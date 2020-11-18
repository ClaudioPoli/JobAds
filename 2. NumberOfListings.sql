--Lista delle aree e del numero degli annunci per ognuna
SELECT m.Area,
       m.Countries,
       count(*)                                                                                                   as numListings,
       cast(
               cast(st_area(m.loc, 'true') as decimal(20, 3)) / 1000000 as decimal(15, 3))                        as areaSize,
       cast(count(*) / (cast(
               cast(st_area(m.loc, 'true') as decimal(20, 3)) / 1000000 as decimal(15, 3))) as decimal(10, 3))    as ListingDensity
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
group by m.Area, m.Countries, m.loc
order by numListings desc;

--Dimostrazione delle località nell'area specificata
select (s.map).location, m.Area, m.Countries
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
where m.Area = 'Europa Occidentale';

--Area con il più alto numero di annunci
select m.Area, (s.map).location, s.position
from section as s
         join mapAreas as m
              on st_within(s.position, m.loc)
where m.Area = (
    SELECT m.Area
    from section as s
             join mapAreas as m
                  on st_within(s.position, m.loc)
    group by m.Area, m.Countries, m.loc
    ORDER BY count(*) DESC
    limit 1);

--Variazione dislocazione annunci nel corso degli anni e in base all'impiego
select to_date(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace((s.header).posted,
    'Jan', '01'), 'Feb', '02'),'Mar', '03'),'Apr', '04'), 'May','05'), 'Jun', '06'), 'Jul','07'), 'Aug', '08'), 'Sep', '09'), 'Oct', '10'),'Nov', '11'), 'Dec', '12'), 'MM DD,YYYY'),s.position, (s.header).jobtitle from section s
where extract(YEAR FROM (to_date(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace((s.header).posted,
    'Jan', '01'), 'Feb', '02'),'Mar', '03'),'Apr', '04'), 'May','05'), 'Jun', '06'), 'Jul','07'), 'Aug', '08'), 'Sep', '09'), 'Oct', '10'),'Nov', '11'), 'Dec', '12'), 'MM DD,YYYY')))  = 2019
AND (s.header).jobtitle LIKE '%Project Manager%';

--Definizione di un centroide per ogni area che rappresenti le zone più dense di annunci
SELECT m.Area,
       st_astext(st_centroid(st_union(st_makepoint((s.map).longitude, (s.map).latitude)))) as coordinates
from section s
         join mapareas as m
              on st_within(s.position, m.loc)
group by m.Area;

--Visualizzazione posizione degli annunci all'interno di un raggio dal centroide
select s.position
from section s
         join mapareas m
              on st_dwithin(s.position, (SELECT st_centroid(
                                                        st_union(st_makepoint((s.map).longitude, (s.map).latitude))) as coordinates
                                         from section s
                                                  join mapareas as m
                                                       on st_within(s.position, m.loc)
                                         where m.area = (SELECT m.Area
                                                         from section s
                                                                  join mapareas as m
                                                                       on st_within(s.position, m.loc)
                                                         group by m.Area
                                                         offset 10 limit 1)
                                         group by m.Area)
                  , 100000, 'true')
where m.Area = (SELECT m.Area
                from section s
                         join mapareas as m
                              on st_within(s.position, m.loc)
                group by m.Area
                offset 10 limit 1)
group by m.Area, s.position;


