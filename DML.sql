--Importazione dati da CSV in tabelle temporanee
COPY glassdoor_country2digit (countryname, countrycode) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\country_names_2_digit_codes.csv' DELIMITER ',' CSV HEADER;
COPY glassdoor_currency_exchange (code, country, currency, number, exchange_rate) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\currency_exchange.csv' DELIMITER ',' CSV HEADER;
COPY glassdoor_benefits_comments (id, index, city, comment, date, jobrelated, jobtitle, benefitsrating,
                                  state) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor_benefits_comments.csv' DELIMITER ';' CSV HEADER;
COPY glassdoor_benefits_highlights (id, phrase, icon, benefitname, index, countreviews) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor_benefits_highlights.csv' DELIMITER ',' CSV HEADER;
COPY glassdoor_reviews (id, index, cons, revdate, featured, helpful, revid, pros, pubdate, publisher, careerrating,
                        companybenefits, culturerating, overallrating, seniormanagrating, worklifebalancerating,
                        timeworked, currrel, jobtitle, location, employeetype, ceoapproval, unknown, companyrecommend,
                        revtitle, advicetomangm, compreply,
                        idresp) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor_reviews.txt' DELIMITER ',' CSV HEADER; --usato txt perchè file usa il newLine come row separator (newLine presente anche nei text field ed il parametro non è gestibile tramite copy)
COPY glassdoor_revresponses (id, index, date, helpful, jobtitle, nothelpnum, text, textlenght, helpnum,
                             updatedate) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor_reviews_val_reviewResponses.csv' DELIMITER ',' CSV HEADER;
COPY glassdoor_salaries (id, index, numsalaryreport, jobtitle, payperiod, payperc10, payperc90, payperc50,
                         whoreported) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor_salary_salaries.csv' DELIMITER ',' CSV HEADER;
COPY glassdoor (benrating, bencomments, benhighlights, bennumratings, benemployersummary, breadcrumbs, category, empid,
                empname, empsize, expired, industry, industryid, jobid, jobidint, jobtitle, location, locationid,
                locationtype, guid, guidvalid, guidpart1, guidpart2, sector, sectorid, trackingcat, trackingsrc,
                trackingxsp, viewdisplaymillis, requirestracking, trackingurl, headadorderid, headadvertisertype,
                headapplicationid, headapplybuttondisabled, headapplyurl, headblur, headcoverphoto, headeasyapply,
                heademployerid, heademployername, headexpired, headgocid, headhideceo, headjobtitle, headlocid,
                headlocation, headlocationtype, headlogo, headlogox2, headorganic, headoverviewurl, headposted,
                headrating, headsaved, headsavedjobid, headsgocid, headsponsored, headuseradmin, headuxapplytype,
                headfeaturedvideo, headnormalizedjob, headurgencylabel, headurgencylabelformessage, headurgencymessage,
                headneedscommission, headpayhigh, headpaylow, headpaymed, headpayperiod, headsalaryhigh, headsalarylow,
                headsalarysource, jobdescription, jobdiscoverdate, jobeolhashcode, jobimportconfid, jobreqid,
                jobreqidint, jobsource, jobtitleid, joblistingid, joblistingidint, mapcountry, mapemployername, maplat,
                maplong, maplocation, mapaddress, mappostalcode, ovallbenefitslink, ovallphotoslink, ovallrevlink,
                ovallsalarieslink, ovfoundedyear, ovhq, ovindustry, ovindustryid, ovrevenue, ovsector, ovsectorid,
                ovsize, ovstock, ovtype, ovdescription, ovmission, ovwebsite, ovallvideoslink, ovcompetitors,
                ovcompanyvideo, photos, ratceoname, ratceophoto, ratceophoto2, ratceoratcount, ratceoapproval,
                ratrecomtofriend, ratstarrating, reviews, salcountry3let, salcountryiso, salcountrycontcode,
                salcountrycontname, salcountrycontid, salcountrycontnew, salcountryfips, salcountrycurrcode,
                salcountrycurrencydefdig, salcountrycurrname, salcountrycurrid, salcountrycurrname2,
                salcountrycurrnegtempl, salountrycurrnew, salcountrycurrpostempl, salcountrycurrsymbol,
                salcountrycurrcode2, salcountrydeflocal, salcountrydefname, salcountrydefshortname,
                salcountryemplsolcount, salcountryid, salcountrylongname, salcountrymajor, salcountryname,
                salcountrynew, salcountrypop, salcountryshortname, salcountrytld, salcountrytype, salcountryuniname,
                salcountrycentrname, salcurrcode, salcurrdefdig, salcurrdispname, salcurrid, salcurrname,
                salcurrnegtempl, salcurrnew, salcurrpostempl, salcurrsymbol, sallassalarydate, salsalaries,
                wwfu) FROM 'C:\Users\Public\data-jobs-listings-glassdoor\glassdoor.csv' DELIMITER ',' CSV HEADER;

--Popolamento delle tabelle effettive
INSERT INTO section(LISTINGID, JOB, HEADER, BENEFITS, SALARIES, RATINGS, MAP)
SELECT coalesce(joblistingid, joblistingidint),
       cast((jobDescription, jobSource, jobTitleId, jobDiscoverDate) as job_item),
       cast((headAdOrderId, headAdvertiserType, headEmployerID, headEmployerName, headExpired, headHideCEO,
             headSavedJobID, headJobTitle, headLocation, headLocID, headPosted, headRating, headSponsored, headPayHigh,
             headPayLow, headPayMed, headPayPeriod) as header_item),
       cast((benNumRatings, benEmployerSummary, benRating) as benefits_item),
       cast((salcurrcode, salLasSalaryDate, salSalaries) as salaries_item),
       cast((ratCEOName, ratCEOApproval, ratRecomToFriend, ratStarRating, reviews, ratCEOratCount) as ratings_item),
       cast((mapCountry, mapLat, mapLong, mapLocation, mapAddress, mapPostalCode) as map_item)
FROM glassdoor;

INSERT INTO currencyexchange (code3digits, countryname, currencyname, currencynumber, exchangerate)
SELECT code, country, currency, number, exchange_rate
FROM glassdoor_currency_exchange;

INSERT INTO country2digit(countrycode, countryname)
SELECT countrycode, countryname
FROM glassdoor_country2digit;

INSERT INTO company(empid, empname, companyfoundationyear, companyheadquarters, industry, sector, companyrevenue,
                    companysize, companydescription, companymission, companytype)
SELECT empId,
       empName,
       ovFoundedYear,
       ovHq,
       cast((industryId, industry) as industry_sector_item),
       cast((sectorId, sector) as industry_sector_item),
       ovRevenue,
       empSize,
       ovDescription,
       ovMission,
       ovType
FROM glassdoor;

INSERT INTO listing(listingid, opinionid)
SELECT coalesce(joblistingid, joblistingidint), benComments
FROM glassdoor;

INSERT INTO opinion (opinionid)
SELECT id
FROM glassdoor_benefits_highlights;

INSERT INTO benefitshighlights(opinionid, index, highlights, benefitsname, countbenefitsreviews)
SELECT id, index, phrase, benefitname, countreviews
FROM glassdoor_benefits_highlights;

INSERT INTO benefitscommets(opinionid, index, city, employeecomment, commentdate, currentjobrelated, employeejob,
                            benefitsrating, state)
SELECT id,
       index,
       city,
       comment,
       date,
       jobrelated,
       jobtitle,
       benefitsrating,
       state
FROM glassdoor_benefits_comments;

INSERT INTO review(opinionid, reviewid, index, reviewtitle, cons, reviewdate, featured, pros, publicationdate,
                   careerrating, benefitsrating, culturevaluesrating, overallrating, senmanagrating, workliferating,
                   timeworked, currrel, revjobtitle, revlocation, ceoapproval, recommendedcompany, revmanadv, revrespid)
SELECT id,
       revID,
       index,
       revTitle,
       cons,
       Revdate,
       featured,
       pros,
       pubDate,
       careerRating,
       companybenefits,
       culturerating,
       overallrating,
       seniorManagRating,
       worklifeBalanceRating,
       timeWorked,
       currRel,
       jobTitle,
       location,
       CEOapproval,
       companyrecommend,
       adviceToMangm,
       IDresp
FROM glassdoor_reviews;

INSERT INTO revreply(reviewid, index, revjobtitle, revtext, revtextlenght, revupdatedate)
SELECT id, index, jobTitle, text, textLenght, updateDate
FROM glassdoor_revResponses;

INSERT INTO reply(replyDate, replyID, replyIndex, reviewID, reviewIndex, reviewListing)
SELECT p.date, p.id, p.index, r.revid, r.index, r.id
FROM glassdoor_revResponses p
         INNER JOIN glassdoor_reviews r on p.id = r.revid;

INSERT INTO salarieslist(listingid, index, countsalaryrep, jobtitle, payperiod, payperc10, payperc90, payperc50,
                         whoreport)
SELECT id,
       index,
       numsalaryreport,
       jobtitle,
       payperiod,
       payperc10,
       payperc90,
       payperc50,
       whoreported
FROM glassdoor_salaries;

INSERT INTO exemployee(job, location, company, relation)
SELECT (s.header).jobtitle, (s.map).location, (s.header).empname, r.currrel
FROM section s
         JOIN listing l on s.listingid = l.listingid
         JOIN review r on r.opinionid = l.opinionid
WHERE r.currrel LIKE 'Former%';

INSERT INTO curremployee(job, location, company, relation)
SELECT (s.header).jobtitle, (s.map).location, (s.header).empname, r.currrel
FROM section s
         JOIN listing l on s.listingid = l.listingid
         JOIN review r on r.opinionid = l.opinionid
WHERE r.currrel LIKE 'Current%';

--Eliminazione tabelle temporanee
CREATE OR REPLACE FUNCTION dropprefix(IN _schema TEXT, IN _parttionbase TEXT)
    RETURNS void
    LANGUAGE plpgsql
AS
$$
DECLARE
    row record;
BEGIN
    FOR row IN
        SELECT table_schema,
               table_name
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE'
          AND table_schema = _schema
          AND table_name ILIKE (_parttionbase || '%')
        LOOP
            EXECUTE 'DROP TABLE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name);
            RAISE INFO 'Dropped table: %', quote_ident(row.table_schema) || '.' || quote_ident(row.table_name);
        END LOOP;
END;
$$;

--Eliminazione duplicati
CREATE FUNCTION drop_duplicates(tab regclass, attr text) RETURNS VOID
AS
$$
BEGIN
    EXECUTE 'ALTER TABLE ' || tab || ' ADD id serial;' ||
            'DELETE FROM ' || tab || ' a USING ' || tab || ' b ' ||
            'WHERE a.id < b.id AND a.' || attr || ' = b.' || attr || ';' ||
            'ALTER TABLE ' || tab || ' DROP id;';
    RETURN;
END
$$
    LANGUAGE plpgsql;

--Eliminazione righe con attributo nullo
CREATE FUNCTION drop_if_null(tab regclass, attr text) RETURNS VOID
AS
$$
BEGIN
    EXECUTE 'DELETE FROM ' || tab || ' WHERE ' || attr || ' is null';
    RETURN;
END
$$
    LANGUAGE plpgsql;


SELECT dropprefix('public', 'glassdoor');

--Post-processing per la definizione dei constraint
--EMPLOYEE
DELETE
FROM employee
WHERE company IS NULL
   OR location IS NULL;

--OPINION
select drop_duplicates('opinion', 'opinionid');

--BENEFITSHIGHLIGHTS
select drop_if_null('benefitshighlights','index');

--BENEFITSCOMMENTS
select drop_if_null('benefitscommets','index');

--REVIEW
select drop_if_null('review','index');

--LISTING
ALTER TABLE listing
    ADD id serial;
DELETE
FROM listing a
    USING listing b
WHERE a.id < b.id
  AND a.listingid = b.listingid
  AND a.opinionid = b.opinionid;
ALTER TABLE listing
    DROP id;

select drop_if_null('listing', 'opinionid');

--SECTION
select drop_duplicates('section', 'listingid');

--CURRENCYEXCHANGE
select drop_duplicates('currencyexchange', 'code3digits');
select drop_if_null('currencyexchange', 'code3digits');

--COMPANY
--Rimozione righe con id=0
DELETE
FROM company
where empid = '0';

select drop_duplicates('company', 'empid');

--TABLE SALARIESLIST
select drop_if_null('salarieslist', 'index');


--Inserimento colonna spaziale
create extension postgis;
SELECT AddGeometryColumn('section', 'position', '-1', 'POINT', '2');
--Creazione di punti per ogni coppia di valori lat long
UPDATE section
set position = st_setsrid(st_makepoint((section.map).longitude, (section.map).latitude), -1);

--Prevenzione errori (diversi valori hanno lat e long = 0 causando la generazione di punti geografici errati)
UPDATE section
SET position = NULL
where (section.map).latitude = 0
  and (section.map).longitude = 0;

--Inserimento colonna spaziale
SELECT AddGeometryColumn('mapareas', 'loc', '-1', 'POLYGON', '2');

--Inserimento dei valori nella tabella
INSERT INTO mapAreas(Area, loc, Countries)
VALUES ('Europa Occidentale',
        'POLYGON((-1.4062500 43.4622554,3.1640625 42.2383789,7.9101563 43.6532806,6.5478516 45.0446779,6.8994141 45.9836038,10.5029297 46.8167521,13.5351563 46.4850194,16.2377930 46.8468088,16.8750000 48.6194977,13.9746094 48.7210437,12.2167969 50.1916219,14.9194336 50.9173346,14.2822266 53.8910229,8.7670898 54.8633403,4.9658203 53.3701453,2.3510742 51.3307093,-4.6582031 48.5177470,-1.4062500 43.4622554))',
        'Austria-Beglio-Francia-Germania-Liechtenstein-Lussemburgo-Monaco-Paesi Bassi-Svizzera'),
       ('Europa Settentrionale',
        'POLYGON((-26.0156250 67.0661874,-11.0742188 47.8723052,0.9667969 50.3457826,4.3945313 54.5209838,17.3144531 55.3311685,23.5546875 53.6472173,27.3339844 55.3791924,27.6855469 57.6584438,31.6406250 62.7545388,28.8281250 68.8777289,29.8828125 71.8266802,-26.0156250 67.0661874))',
        'Danimarca-Estonia-Finlandia-Islanda-Norvegia-Svezia-Lettonia-Lituania-Regno Unito-Irlanda'),
       ('Europa Orientale',
        'POLYGON((28.1250000 59.4000470,28.2568359 55.9744305,25.8398438 54.3934992,23.5986328 53.8796947,21.4453125 55.0541046,14.3261719 53.6719976,15.0732422 51.1263252,12.3486328 50.2636437,13.8867188 48.6067907,16.7871094 48.7228558,16.2158203 46.8035977,13.7109375 46.5020331,13.7988281 44.6885420,19.9951172 39.6117541,22.9833984 41.2502494,27.9492188 41.8420938,34.6289063 42.2934041,41.3085938 41.5468488,43.1542969 41.1785273,43.8574219 39.8819878,46.1206055 38.8910983,48.0322266 39.5715674,48.8452148 38.3793618,50.7128906 40.3805595,48.9550781 46.2008997,47.9882813 50.4569836,54.4921875 50.7961958,60.7324219 51.0694397,63.8964844 54.3671703,73.6523438 53.5434790,87.2753906 49.1527810,102.4804688 51.2331128,116.4550781 49.2672712,125.4199219 53.0130765,134.5605469 48.3415982,131.5722656 43.3321381,147.6562500 46.5021820,191.0742188 65.5837921,153.1054688 76.5569828,93.8671875 81.5956497,31.2890625 69.4086382,31.6406250 63.2339522,28.1250000 59.4000470))',
        'Albania-Armenia-Azerbaigian-Bielorussia-Bosnia-Bulgaria-Rep.Ceca-Croazia-Georgia-Ungheria-Macedonia-Moldavia-Montenegro-Polonia-Romania-Russia-Serbia-Slovacchia-Slovenia-Ucraina'),
       ('Europa Meridionale',
        'POLYGON((26.1035156 40.7149399,26.5209961 41.5741994,25.2026367 41.2612011,22.5219727 41.1453117,21.0498047 40.7638057,19.9951172 39.6745824,15.8422852 42.4073190,13.1396484 45.3054686,13.6450195 45.7517111,13.6230469 46.4371942,12.1728516 47.0094142,10.7885742 46.8300802,10.1074219 46.2704184,9.4482422 46.3468488,8.9648438 45.8589015,8.4155273 46.3766073,7.0751953 45.8287532,6.7895508 44.9334326,7.7563477 43.7075066,6.8994141 41.8374906,1.6040039 42.7146130,0.2197266 42.7149132,-10.1953125 44.9023907,-10.8544922 35.2098690,2.6367188 37.1602303,10.5908203 37.8246350,13.8427734 34.9246815,27.2021484 34.2737465,26.1035156 40.7149399))',
        'Italia-Grecia-Malta-Andorra-Spagna-Portogallo-Cipro'),
       ('Asia Centrale',
        'POLYGON((49.3945313 46.1342783,54.1406250 37.2680268,57.6123047 37.9264504,61.3916016 35.4997248,66.5771484 37.1280465,70.7519531 38.2033436,74.8828125 36.9878069,73.7402344 39.5399607,80.4638672 42.1971977,81.8701172 45.6447514,87.4511719 48.9507192,84.2871094 50.4573510,80.3759766 50.8186943,76.6845703 54.2903905,71.3671875 54.1090332,70.5322266 55.1283604,61.4794922 54.0316942,61.6552734 50.8464421,52.5146484 51.6450031,47.8125000 50.3164103,46.4941406 48.5165247,49.3945313 46.1342783))',
        'Kazakistan-Kirghizistan-Tagikistan-Turkmenistan-Uzbekistan'),
       ('Asia Orientale',
        'POLYGON((87.7148438 49.0371981,81.6943359 45.8898910,79.8046875 41.8701964,74.0478516 39.2342736,78.7939453 34.6332277,78.9697266 31.5413255,82.0458984 30.1500023,89.0771484 28.2660847,96.5917969 29.2723920,98.4814453 27.2545868,98.0859375 24.9328679,100.6347656 21.2082432,102.7001953 22.7152459,105.2929688 23.1273173,108.2812500 21.5425286,108.4130859 19.1036483,109.7753906 16.6454633,133.3740234 28.6573893,148.8427734 43.9301906,141.3281250 45.6756334,130.9130859 42.3921006,134.6484375 48.2827209,130.9570313 47.8434886,123.5742188 53.3035005,116.7626953 49.7236321,109.4677734 49.2957347,98.9648438 51.9699387,97.1191406 49.8948048,92.4169922 50.7639096,87.7148438 49.0371981))',
        'Mongolia-Cina-Corea del Nord-Corea del Sud-Giappone-Taiwan'),
       ('Asia Meridionale',
        'POLYGON((92.2412109 20.8847901,94.9658203 26.6272165,97.2070313 27.9155876,95.7128906 29.2285229,88.9013672 27.8025918,81.0351563 30.2607285,78.9257813 31.9894826,79.0136719 34.0523208,76.9921875 35.3534318,74.5312500 37.1601920,71.5869141 36.8446628,71.1035156 38.0303217,66.6650391 37.2648125,61.4355469 35.4608560,60.7324219 32.3979576,62.8417969 26.8246179,61.7431641 25.2080952,71.0156250 0.7574582,82.0019531 5.3112863,92.2412109 20.8847901))',
        'Bangladesh-Afghanistan-Bhutan-India-Maldive-Nepal-Pakistan-Sri Lanka'),
       ('Sud-Est Asiatico',
        'POLYGON((107.8857422 21.4164595,105.4687500 22.9581055,102.7441406 22.3947151,101.2500000 21.5761661,97.9541016 24.0468043,97.8662109 28.1905110,95.3613281 26.5884519,94.3945313 24.4471934,92.1533203 21.0068925,91.8457031 4.2149911,99.2285156 -12.1867650,141.1523438 -10.2284609,140.8886719 6.9214388,120.7617188 19.7405042,108.1933594 17.7703907,107.8857422 21.4164595))',
        'Brunei-Cambogia-Indonesia-Laos-Malaysia-Birmania-Filippine-Singapore-Thailandia-Timor Est-Vietnam'),
       ('Medio Oriente',
        'POLYGON((61.7871094 24.7716089,63.1933594 26.6280331,61.0400391 30.0312011,60.9082031 36.3164424,57.4804688 38.1341784,53.9208984 37.1613895,48.5595703 38.4449564,47.8125000 39.5044488,46.0107422 38.7885328,44.7363281 39.4026809,43.4619141 40.9465593,41.5722656 41.3767003,28.0371094 41.8693281,26.5429688 41.8039348,26.1035156 40.7140287,27.5097656 35.3548142,34.0576172 35.6751377,34.8925781 29.4621014,34.3652344 27.2918839,43.9892578 11.5750821,60.6005859 17.0570949,61.7871094 24.7716089))',
        'Arabia Saudita-Bahrein-Emirati Arabi Uniti-Giordania-Iraq-Iran-Israele-Kuwait-Libano-Oman-Qatar-Siria-Turchia-Yemen'),
       ('Africa Settentrionale',
        'POLYGON((1.9335938 37.5041760,-33.6621094 30.3612383,-26.0156250 8.8434091,4.8779297 -0.0456763,8.3935547 4.4399765,9.7119141 6.2715583,11.1621094 6.6650493,14.3701172 12.1244063,13.4033203 13.4998157,15.8642578 23.2815094,23.9941406 19.3128223,23.5107422 9.4535677,27.2021484 5.4412736,30.8056641 3.2564733,34.8486328 4.7397410,38.0126953 3.5999906,41.7480469 3.8625036,47.8125000 7.8817895,42.8466797 10.9143063,41.9677734 11.6522364,43.0224609 12.3760245,34.5190430 27.7597396,34.2553711 31.2210611,18.8964844 34.0823711,12.5683594 35.3533730,10.9423828 37.7880719,1.9335938 37.5041760))',
        'Etiopia-Sudan-Eritrea-Gibuti-Egitto-Libia-Niger-Algeria-Marocco-Tunisia-Mali-Nigeria-Benin-Togo-Ghana-Burkina Faso-Costa d Avorio-Liberia-Sierra Leone-Guinea-Guinea-Gambia-Senegal-Mauritania'),
       ('Africa Centrale',
        'POLYGON((23.2470703 -17.7578326,24.1259766 -11.2973699,29.7509766 -13.2390679,30.4101563 -8.7348108,29.3115234 -4.4694915,29.7509766 -0.6152226,30.8056641 3.2564733,27.2021484 5.4412736,23.5107422 9.4535677,23.9941406 19.3128223,15.8642578 23.2815094,13.4033203 13.4998157,14.3701172 12.1244063,11.1621094 6.6650493,9.7119141 6.2715583,8.3935547 4.4399765,4.8779297 -0.0456763,11.5576172 -17.1787710,23.2470703 -17.7578326))',
        'Angola-Camerun-Ciad-Guinea Equatoriale-Gabon-Rep.Centrafricana-RD del Congo-Rep. del Congo-Sao Tomè e Principe'),
       ('Africa Meridionale',
        'POLYGON((42.9345703 12.4318464,41.9238281 10.8397759,47.7685547 7.7619101,41.8798828 4.0042345,38.5839844 3.5136370,34.9365234 4.6090384,30.8496094 3.4343070,29.7949219 -1.2978611,29.1796875 -4.5217622,30.6298828 -8.4827980,29.5312500 -13.4100001,24.0820313 -11.0371222,22.1484375 -14.6472986,23.2031250 -17.7143960,11.9531250 -17.4212065,16.0839844 -38.5206709,60.1171875 -36.7112129,56.6015625 14.0279400,42.9345703 12.4318464))',
        'Somalia-Kenya-Uganda-Ruanda-Burundi-Tanzania-Zambia-Malawi-Mozambico-Zimbabwe-Botswana-Namibia-Sudafrica-Lesotho-Madagascar'),
       ('America Settentrionale',
        'POLYGON((-166.9921875 74.9189134,-168.2226563 61.2702328,-172.9687500 47.6605964,-93.7792969 13.1659875,-91.8017578 15.9191660,-90.9667969 17.6021391,-86.1328125 19.3207405,-85.9570313 23.6124237,-80.9912109 23.9660221,-74.9267578 23.2092581,-46.6699219 50.6300296,-69.0820313 74.0191462,-166.9921875 74.9189134))',
        'Stati Uniti-Canada-Messico'),
       ('America Centrale',
        'POLYGON((-93.8232422 12.2588382,-81.6503906 3.3013668,-77.2558594 8.3695320,-74.4873047 13.0252047,-63.5009766 12.8114145,-61.1279297 9.7531402,-55.6347656 12.0870564,-67.6318359 22.8385855,-81.1230469 23.8454300,-84.4628906 23.2024966,-85.9130859 18.8963475,-88.9013672 17.8981800,-91.0546875 17.1827216,-90.4394531 16.0071924,-91.6259766 15.9649581,-93.8232422 12.2588382))',
        'Guatemala-Honduras-Belize-El Salvador-Nicaragua-Costa Rica-Panama-Cuba-Repubblica Dominicana-'),
       ('America Meridionale',
        'POLYGON((-77.0361328 7.9794118,-93.2958984 0.2291382,-71.8945313 -57.4143550,-40.6933594 -47.8074227,-30.1464844 5.7829557,-60.2050781 11.3449863,-72.5537109 12.6342037,-75.9814453 10.6173354,-77.0361328 7.9794118))',
        'Colombia-Venezuela-Guyana-Suriname-Ecuador-Perù-Brasile-Bolivia-Paraguay-Cile-Uruguay-Argentina'),
       ('Oceania',
        'POLYGON((-218.8476563 -10.2219782,-229.3945313 -10.8336366,-246.9726563 -13.9093557,-257.1679688 -34.4351675,-187.3828125 -52.8921669,-151.6992188 -16.9580700,-170.6835938 1.2297492,-197.4902344 14.8595018,-212.0800781 6.5776136,-218.7597656 0.5309424,-218.8476563 -10.2219782))',
        'Australia-Polinesia-Melanesia-Micronesia-Nuova Zelanda');

create index "IDX_areas" on mapareas
    using gist (loc);


--Conversione campo reviewDate da stringa in formato data
update review
set reviewdate=NULL
where reviewdate like '%week%'
   or reviewdate like 'yesterday'
   or reviewdate like '%da%'
   or reviewdate like '%ho%'
   or reviewdate like '%mi%';

update review
set reviewdate=to_date(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace
    (reviewdate, 'Jan', '01'), 'Feb', '02'),'Mar', '03'),'Apr', '04'), 'May','05'), 'Jun', '06'), 'Jul','07'), 'Aug', '08'), 'Sep', '09'), 'Oct', '10'),'Nov', '11'), 'Dec', '12'), 'MM DD,YYYY');

alter table review
    alter column reviewdate type date using reviewdate::date;

