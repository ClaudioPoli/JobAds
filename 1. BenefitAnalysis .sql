--Vista per visualizzare i commenti relativi ai benefit degli impiegati (attuali o passati),il loro impiego, la data di pubblicazione, l'azienda di riferimento,
-- il rating medio dei benefit e l'area di appartenenza
create view bestbenefitCompany as
select b.opinionid,
       m.area,
       (s.header).empname,
       cast(avg(b.benefitsrating) as decimal(10, 1)) as average,
       (s.header).jobtitle,
       b.commentdate,
       b.currentjobrelated,
       b.employeecomment
from benefitscommets b
         join listing l on l.opinionid = b.opinionid
         join section s on l.listingid = s.listingid
         join mapAreas as m
              on st_within(s.position, m.loc)
group by m.area, (s.header).empname, (s.header).jobtitle, b.commentdate, b.currentjobrelated, b.employeecomment,
         b.opinionid
order by average desc;


select *
from bestbenefitCompany;

--Classifica commenti e azienda relativa
select distinct c.empname, c.employeecomment, c.average
from bestbenefitCompany c
where c.area = 'Europa Settentrionale'
  and extract(YEAR from c.commentdate) = 2019
  and c.currentjobrelated = 'VERO'
  and c.jobtitle like '%Software Developer%'
  and c.average > 2;


--Benefit offerti dalle aziende in una specifica area
select distinct h.benefitsname, count(h.benefitsname), c.area
from benefitshighlights h
         join bestbenefitCompany c on c.opinionid = h.opinionid
where c.area = 'Europa Settentrionale'
group by h.benefitsname, c.area
order by count(h.benefitsname) desc;

--Highlights per specifico benefit
select distinct q.highlights
from (select distinct h.benefitsname, h.highlights, c.empname
      from benefitshighlights h
               join bestbenefitCompany c on c.opinionid = h.opinionid
      where c.area = (select distinct a.area
                      from (select distinct h.benefitsname, count(h.benefitsname), c.area
                            from benefitshighlights h
                                     join bestbenefitCompany c on c.opinionid = h.opinionid
                            where c.area = 'Europa Settentrionale'
                            group by h.benefitsname, c.area
                            order by count(h.benefitsname) desc) a)
        and h.benefitsname = 'Annual Leave') q;

--Funzioni per estrarre i commenti sui benefit
CREATE FUNCTION comm_to_txt(n integer, area text, year integer, currentjob text, job text, avg decimal) RETURNS VOID
AS
$$
DECLARE
    count int := 0;
BEGIN
    WHILE count <> n
        LOOP
            EXECUTE format('COPY (select q.employeecomment ' ||
                           'from(select distinct c.empname,c.employeecomment,c.average ' ||
                           'from bestbenefitCompany c ' ||
                           'where c.area=%L and extract(YEAR from c.commentdate)=%L and c.currentjobrelated=%L and c.jobtitle like %L and c.average>%L)q ' ||
                           'offset %L limit 1) ' ||
                           'to %L', area, year, currentjob, job, avg, count,
                           'C:\Users\Public\Benefits\Comments\comment' || count || '.txt');
            count := count + 1;
        END LOOP;
    RETURN;
END
$$
    LANGUAGE plpgsql;

CREATE FUNCTION high_to_txt(n integer, area text, benefit text) RETURNS VOID
AS
$$
DECLARE
    count int := 0;
BEGIN
    WHILE count <> n
        LOOP
            EXECUTE format('COPY (select q.highlights ' ||
                           'from (select distinct h.benefitsname,h.highlights,c.empname ' ||
                           'from benefitshighlights h join bestbenefitCompany c on c.opinionid=h.opinionid ' ||
                           'where c.area=%L and h.benefitsname=%L) q ' ||
                           'offset %L limit 1) to %L', area, benefit, count,
                           'C:\Users\Public\Benefits\Highlights\highlight' || count || '.txt');
            count := count + 1;
        END LOOP;
    RETURN;
END
$$
    LANGUAGE plpgsql;

--Commenti
SELECT comm_to_txt((select cast(count(q.employeecomment) as int)
                    from (select distinct c.empname, c.employeecomment, c.average
                          from bestbenefitCompany c
                          where c.area = 'Europa Settentrionale'
                            and extract(YEAR from c.commentdate) = 2019
                            and c.currentjobrelated = 'VERO'
                            and c.jobtitle like '%Software Developer%'
                            and c.average > 0.5) q), 'Europa Settentrionale', 2019, 'VERO', '%Software Developer%',
                   0.5);

COPY mixedbag (term, lang, type, term2, lang2, type2, pmiscore, docfreq, freq) FROM 'C:\Users\Public\Benefits\Comments\MixedBag.csv' DELIMITER ',' csv header;

--PMI - Termini più strettamente associati a "benefit"
select term as BenefitTerm, term2 as AssociatedTerm, type2, cast(pmiscore as decimal(10, 3))
from mixedbag
where term like '%benefit%'
  and type2 <> 'Verb'
  and term2 not like '%benefit%'
order by pmiscore desc;


--HIGHLIGHTS
SELECT high_to_txt((select distinct cast(count(q.highlights) as int)
                    from (select distinct h.benefitsname, h.highlights, c.empname
                          from benefitshighlights h
                                   join bestbenefitCompany c on c.opinionid = h.opinionid
                          where c.area = (select distinct a.area
                                          from (select distinct h.benefitsname, count(h.benefitsname), c.area
                                                from benefitshighlights h
                                                         join bestbenefitCompany c on c.opinionid = h.opinionid
                                                where c.area = 'Europa Settentrionale'
                                                group by h.benefitsname, c.area
                                                order by count(h.benefitsname) desc) a)
                            and h.benefitsname = 'Annual Leave') q), 'Europa Settentrionale', 'Annual Leave');

--Import dei risultati in json
COPY highlightsResults (comment) FROM 'C:\Users\Public\Benefits\Highlights\Highlights' DELIMITER '^' csv quote '''' escape '\';

--Vista per estrazione testo e features
create view highlightsfeatures as
(
select id, comment -> 'text' as text, comment -> 'entities' -> 'Token' as features
from highlightsResults);

--Modellazione dei dati della vista precedente
create view jsonFeaturesView as
(
select a.id,
       cast(a.text as text),
       cast(substring(r.indices, '([0-9]{1,2}),') as decimal(2, 0)) as start_pos,
       cast(substring(r.indices, ',([0-9]{1,2})') as decimal(2, 0)) as end_pos,
       r.*
from highlightsfeatures a,
     lateral json_populate_recordset(null::Features, a.features) r);

--Comprensione classi grammaticali più comuni nelle recensioni
select category, count(category) as catcount
from jsonFeaturesView
WHERE chunk like '%NP%'
group by category
order by catcount desc;

--Estrazione dei token consecutivi appartenenti alle classi grammaticali più comuni e più rilevanti
select a.text,
       a.start_pos,
       a.end_pos,
       a.string,
       a.category,
       b.start_pos,
       b.end_pos,
       b.string,
       b.category
from jsonFeaturesView a,
     jsonfeaturesview b
where a.id = b.id
  and (a.chunk like '%NP%' or b.chunk like '%NP%')
  and b.start_pos = a.end_pos + 1
  and a.category in ('NN', 'JJ', 'NNS', 'NNP', 'CD', 'JJS', 'JJR')
  and b.category in ('NN', 'JJ', 'NNS', 'NNP', 'CD', 'JJS', 'JJR')
ORDER BY a.id;




