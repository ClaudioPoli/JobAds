--Lista del salario medio per ogni area per la professione più richiesta
CREATE VIEW avgSalaries as
SELECT m.Area,
       cast(AVG(sl.payperc90 + sl.payperc10 / 2) as decimal(10, 3)) as SalaryAverage,
       mode() within group (order by (s.header).jobtitle)           as job
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
         join salarieslist sl on (s.salaries).salary = sl.listingid
group by m.Area
order by SalaryAverage desc;

SELECT Area, SalaryAverage, job as bestJob
FROM avgSalaries;

--Lista del salario medio per ogni area rispetto ad una professione specifica
--Professioni: Data Engineer,Project Manager,Data Scientist,Business Analyst
SELECT m.Area, cast(AVG(sl.payperc90 + sl.payperc10 / 2) as decimal(10, 3)) as SalaryAnnualAverage
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
         join salarieslist sl on (s.salaries).salary = sl.listingid
where (s.header).jobtitle LIKE '%Data Scientist%'
group by m.Area
order by SalaryAnnualAverage desc;

--Aree confinanti che condividono la ricerca di una posizione lavorativa
CREATE VIEW relJobAreas AS
(
SELECT row_number() over (order by m.Area)                as id,
       m.Area                                             as Area1,
       mm.Area                                            as Area2,
       mode() within group (order by (s.header).jobtitle) as job
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
         join mapAreas as mm
              on st_within(s.position, mm.loc)
where m.Area <> mm.Area
  and st_intersects(m.loc, mm.loc) = true
group by m.Area, mm.Area);

select a.Area1,a.Area2,a.job
from relJobAreas a,
     reljobareas b
WHERE a.id < b.id
  AND a.job = b.job;

--Trasformazione delle jobDescriptions testuali
select (s.header).jobtitle,(s.job).jobdescription,
       regexp_replace(regexp_replace((s.job).jobdescription, '\<.*?\>', '', 'g'), '\n', '', 'g')
from section s
         join mapAreas as m
              on st_within(s.position, m.loc)
         join avgsalaries a on m.area = a.Area
where (s.header).jobtitle = (select a.job from avgSalaries a limit 1)
  and m.area = (select a.Area from avgSalaries a limit 1);

CREATE FUNCTION descr_to_txt(n integer, job text, area text) RETURNS VOID
AS
$$
DECLARE
    count int := 0;
BEGIN
    WHILE count <> n
        LOOP
            EXECUTE format(
                    'COPY (select regexp_replace(regexp_replace((s.job).jobdescription,''\<.*?\>'','' '',''g''),''\n'','' '',''g'') from section s join mapAreas as m on st_within(s.position,m.loc) join avgsalaries a on m.area=a.Area where (s.header).jobtitle=%L and m.area=%L offset %L limit 1) to %L',
                    job, area, count, 'C:\Users\Public\JobDesctiption\JobDescr' || count || '.txt');
            count := count + 1;
        END LOOP;
    RETURN;
END
$$
    LANGUAGE plpgsql;


SELECT descr_to_txt((select cast(count(*) as int)
                     from section s
                              join mapAreas as m
                                   on st_within(s.position, m.loc)
                              join avgsalaries a on m.area = a.Area
                     where (s.header).jobtitle = (select a.job from avgSalaries a limit 1)
                       and m.area = (select a.Area from avgSalaries a limit 1)),
                    (select a.job from avgSalaries a limit 1), (select a.Area from avgSalaries a limit 1));


--Load dei dati dai csv esportati da GATE
COPY TfIdftable (term, typology, lang, tfidf, tfidfraw, tf, locdocfr, refdocfr) FROM 'C:\Users\Public\JobDesctiption\TfIdf.csv' DELIMITER ',' CSV HEADER;
COPY Annotationtable (term, typology, lang, tfidfaug, tfidfaugra, tf, locdocfr) FROM 'C:\Users\Public\JobDesctiption\Annotation.csv' DELIMITER ',' CSV HEADER;
COPY Hyponymytable (term, typology, lang, kdomRel, kdomRelra, tf, hypCount, locdocfr) FROM 'C:\Users\Public\JobDesctiption\Hyponymy.csv' DELIMITER ',' CSV HEADER;

INSERT INTO jobdescription(tfidf, annotation, hyponymy)
SELECT cast((t.term, t.lang, t.typology, t.tfidf, t.tfidfraw, t.tf, t.locdocfr, t.refdocfr) as TfIdf),
       cast((a.term, a.lang, a.typology, a.tfidfaug, a.tfidfaugra, a.tf, a.locdocfr) as Annotation),
       cast((h.term, h.lang, h.typology, h.kdomRel, h.kdomRelra, h.tf, h.hypCount, h.locdocfr) as Hyponymy)
FROM tfidftable t
         join annotationtable a on a.term = t.term
         join hyponymytable h on h.term = t.term;

--Termine e score associati
select (j.tfidf).term,(j.tfidf).tfidf,(j.annotation).tfidfaug,(j.tfidf).tf
from jobdescription j
where (j.tfidf).typology='MultiWord'
order by tfidfaug desc;

truncate table tfidftable;
truncate table annotationtable;
truncate table hyponymytable;



