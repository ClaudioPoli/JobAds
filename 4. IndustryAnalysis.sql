--Creazione vista per ottenere, per ogni area, il settore, l'industria e l'azienda più importanti
CREATE VIEW topCompanies AS
select m.Area,
       mode() within group (order by (c.sector).denomination)   as Sector,
       mode() within group (order by (c.industry).denomination) as Industry,
       mode() within group (order by c.empname)                 as Company
from section s
         join company c on (s.header).empid = c.empid
         join mapAreas as m on st_within(s.position, m.loc)
group by m.Area;

select *
from topCompanies;

--Per ogni top azienda comprendere la posizione degli headquarters
select q.Company, q.companysize, q.companyheadquarters, q.avg, q.position, q.area
from (select distinct tc.company,
                      c.companysize,
                      coalesce(cast(substring(c.companysize from '[0-9]+00+') as decimal(10, 0)), 0) as numEmployee
              ,
                      c.companyheadquarters,
                      cast(avg((s.header).companyrating) as decimal(10, 1))
              ,
                      (select s.position
                       from section s
                       where (s.map).location LIKE
                             '%' || LEFT(c.companyheadquarters, strpos(c.companyheadquarters, ',') - 1) || '%'
                         and s.position is not null
                       limit 1),
                      (select m.Area
                       from section s
                                join mapareas m on st_within(s.position, m.loc)
                       where s.position = (select s.position
                                           from section s
                                           where (s.map).location LIKE '%' ||
                                                                       LEFT(c.companyheadquarters, strpos(c.companyheadquarters, ',') - 1) ||
                                                                       '%'
                                             and s.position is not null
                                           limit 1)
                       limit 1)
      from topCompanies tc
               join company c on c.empname = tc.company
               join section s on c.empid = (s.header).empid
      group by tc.company, c.companysize, c.companysize, c.companyheadquarters
      order by numEmployee desc) q;

--Comprensione dei pro e dei contro data una specifica azienda (e relativa area) tra quelle della vista "TopCompanies" in un determinato anno
select distinct r.opinionid, r.pros, r.cons, (s.header).empname, r.reviewdate, (s.map).location
from review r
         join listing l on r.opinionid = l.opinionid
         join section s on s.listingid = l.listingid
         join topCompanies tc on (s.header).empname = tc.company
         join mapAreas m on st_within(s.position, m.loc)
where (s.header).empname = (select tc.company from topCompanies tc offset 12 limit 1)
  and extract(YEAR FROM reviewdate) = 2018
  and m.area = (select tc.Area from topCompanies tc offset 12 limit 1)
order by r.opinionid;

--Funzioni per estrarre pro e contro da analizzare in GATE
CREATE FUNCTION pros_to_txt(n integer, company text, year integer, area text) RETURNS VOID
AS
$$
DECLARE
    count int := 0;
BEGIN
    WHILE count <> n
        LOOP
            EXECUTE format(
                    'COPY (select r.pros from review r join listing l on r.opinionid=l.opinionid join section s on s.listingid=l.listingid join mapAreas m on st_within(s.position,m.loc) where (s.header).empname=%L and extract(YEAR FROM reviewdate)=%L and m.area=%L order by r.opinionid offset %L limit 1) to %L',
                    company, year, area, count, 'C:\Users\Public\Pros\pro' || count || '.txt');
            count := count + 1;
        END LOOP;
    RETURN;
END
$$
    LANGUAGE plpgsql;

CREATE FUNCTION cons_to_txt(n integer, company text, year integer, area text) RETURNS VOID
AS
$$
DECLARE
    count int := 0;
BEGIN
    WHILE count <> n
        LOOP
            EXECUTE format(
                    'COPY (select r.cons from review r join listing l on r.opinionid=l.opinionid join section s on s.listingid=l.listingid join mapAreas m on st_within(s.position,m.loc) where (s.header).empname=%L and extract(YEAR FROM reviewdate)=%L and m.area=%L order by r.opinionid offset %L limit 1) to %L',
                    company, year, area, count, 'C:\Users\Public\Cons\con' || count || '.txt');
            count := count + 1;
        END LOOP;
    RETURN;
END
$$
    LANGUAGE plpgsql;

--Analisi testuale
SELECT pros_to_txt((select cast(count(*) as int)
                    from review r
                             join listing l on r.opinionid = l.opinionid
                             join section s on s.listingid = l.listingid
                             join mapAreas m on st_within(s.position, m.loc)
                    where (s.header).empname = 'Amazon'
                      and extract(YEAR FROM reviewdate) = 2018
                      and m.area = 'Europa Settentrionale'), 'Amazon', 2018, 'Europa Settentrionale');

SELECT cons_to_txt((select cast(count(*) as int)
                    from review r
                             join listing l on r.opinionid = l.opinionid
                             join section s on s.listingid = l.listingid
                             join mapAreas m on st_within(s.position, m.loc)
                    where (s.header).empname = 'Amazon'
                      and extract(YEAR FROM reviewdate) = 2018
                      and m.area = 'Europa Settentrionale'), 'Amazon', 2018, 'Europa Settentrionale');

--PRO
--Load dei dati dai csv esportati da GATE
COPY TfIdftable (term, typology, lang, tfidf, tfidfraw, tf, locdocfr, refdocfr) FROM 'C:\Users\Public\Pros\TfIdf.csv' DELIMITER ',' CSV HEADER;
COPY Annotationtable (term, typology, lang, tfidfaug, tfidfaugra, tf, locdocfr) FROM 'C:\Users\Public\Pros\Annotation.csv' DELIMITER ',' CSV HEADER;
COPY Hyponymytable (term, typology, lang, kdomRel, kdomRelra, tf, hypCount, locdocfr) FROM 'C:\Users\Public\Pros\Hyponymy.csv' DELIMITER ',' CSV HEADER;

INSERT INTO Pros(tfidf, annotation, hyponymy)
SELECT cast((t.term, t.lang, t.typology, t.tfidf, t.tfidfraw, t.tf, t.locdocfr, t.refdocfr) as TfIdf),
       cast((a.term, a.lang, a.typology, a.tfidfaug, a.tfidfaugra, a.tf, a.locdocfr) as Annotation),
       cast((h.term, h.lang, h.typology, h.kdomRel, h.kdomRelra, h.tf, h.hypCount, h.locdocfr) as Hyponymy)
FROM tfidftable t
         join annotationtable a on a.term = t.term
         join hyponymytable h on h.term = t.term;

select (p.hyponymy).term,(p.hyponymy).kdomrel,(p.hyponymy).tf
from Pros p
where (p.hyponymy).typology = 'MultiWord'
order by (p.hyponymy).kdomrel desc;

truncate table tfidftable;
truncate table annotationtable;
truncate table hyponymytable;

--CONTRO
COPY TfIdftable (term, typology, lang, tfidf, tfidfraw, tf, locdocfr, refdocfr) FROM 'C:\Users\Public\Cons\TfIdf.csv' DELIMITER ',' CSV HEADER;
COPY Annotationtable (term, typology, lang, tfidfaug, tfidfaugra, tf, locdocfr) FROM 'C:\Users\Public\Cons\Annotation.csv' DELIMITER ',' CSV HEADER;
COPY Hyponymytable (term, typology, lang, kdomRel, kdomRelra, tf, hypCount, locdocfr) FROM 'C:\Users\Public\Cons\Hyponymy.csv' DELIMITER ',' CSV HEADER;


INSERT INTO Cons(tfidf, annotation, hyponymy)
SELECT cast((t.term, t.lang, t.typology, t.tfidf, t.tfidfraw, t.tf, t.locdocfr, t.refdocfr) as TfIdf),
       cast((a.term, a.lang, a.typology, a.tfidfaug, a.tfidfaugra, a.tf, a.locdocfr) as Annotation),
       cast((h.term, h.lang, h.typology, h.kdomRel, h.kdomRelra, h.tf, h.hypCount, h.locdocfr) as Hyponymy)
FROM tfidftable t
         join annotationtable a on a.term = t.term
         join hyponymytable h on h.term = t.term;

select (c.hyponymy).term,(c.hyponymy).kdomrel,(c.hyponymy).tf
from Cons c
where (c.hyponymy).typology = 'MultiWord'
order by (c.hyponymy).kdomrel desc;

truncate table tfidftable;
truncate table annotationtable;
truncate table hyponymytable;