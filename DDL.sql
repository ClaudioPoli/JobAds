--Tabelle temporanee
create table glassdoor_country2digit
(
    countrycode char(2),
    countryname varchar(50)
);

create table glassdoor_currency_exchange
(
    code          char(3),
    country       varchar(100),
    currency      varchar(50),
    number        numeric,
    exchange_rate numeric
);

create table glassdoor_benefits_comments
(
    id             varchar(10),
    index          integer,
    city           varchar(50),
    comment        text,
    date           timestamp,
    jobrelated     varchar(10),
    jobtitle       varchar(100),
    benefitsrating integer,
    state          varchar(20)
);

create table glassdoor_benefits_highlights
(
    id           varchar(10),
    phrase       text,
    icon         varchar(20),
    benefitname  varchar(50),
    index        integer,
    countreviews integer
);

create table glassdoor_reviews
(
    id                    varchar(10),
    index                 integer,
    cons                  text,
    revdate               varchar(30),
    featured              varchar(10),
    helpful               integer,
    revid                 varchar(10),
    pros                  text,
    pubdate               varchar(30),
    publisher             varchar(100),
    careerrating          numeric,
    companybenefits       numeric,
    culturerating         numeric,
    overallrating         numeric,
    seniormanagrating     numeric,
    worklifebalancerating numeric,
    timeworked            varchar(30),
    currrel               text,
    jobtitle              varchar(100),
    location              varchar(100),
    employeetype          varchar(30),
    ceoapproval           numeric,
    unknown               integer,
    companyrecommend      integer,
    revtitle              text,
    advicetomangm         text,
    compreply             text,
    idresp                varchar(10)
);


create table glassdoor_revresponses
(
    id         varchar(10),
    index      integer,
    date       timestamp,
    helpful    integer,
    jobtitle   varchar(100),
    nothelpnum integer,
    text       text,
    textlenght integer,
    helpnum    integer,
    updatedate timestamp
);

create table glassdoor_salaries
(
    id              varchar(10),
    index           integer,
    numsalaryreport integer,
    jobtitle        varchar(150),
    payperiod       varchar(20),
    payperc10       numeric,
    payperc90       numeric,
    payperc50       numeric,
    whoreported     varchar(20)
);

create table glassdoor
(
    benrating                  numeric,
    bencomments                varchar(10),
    benhighlights              varchar(10),
    bennumratings              numeric,
    benemployersummary         text,
    breadcrumbs                integer,
    category                   integer,
    empid                      varchar(10),
    empname                    varchar(100),
    empsize                    varchar(20),
    expired                    varchar(10),
    industry                   varchar(50),
    industryid                 varchar(10),
    jobid                      varchar(20),
    jobidint                   varchar(20),
    jobtitle                   varchar(200),
    location                   varchar(100),
    locationid                 varchar(10),
    locationtype               varchar(10),
    guid                       varchar(50),
    guidvalid                  varchar(10),
    guidpart1                  varchar(50),
    guidpart2                  varchar(50),
    sector                     varchar(100),
    sectorid                   varchar(10),
    trackingcat                varchar(20),
    trackingsrc                varchar(20),
    trackingxsp                varchar(20),
    viewdisplaymillis          integer,
    requirestracking           varchar(10),
    trackingurl                text,
    headadorderid              varchar(10),
    headadvertisertype         varchar(10),
    headapplicationid          varchar(10),
    headapplybuttondisabled    varchar(10),
    headapplyurl               text,
    headblur                   varchar(10),
    headcoverphoto             text,
    headeasyapply              varchar(10),
    heademployerid             varchar(10),
    heademployername           varchar(200),
    headexpired                varchar(50),
    headgocid                  text,
    headhideceo                varchar(10),
    headjobtitle               varchar(200),
    headlocid                  varchar(10),
    headlocation               varchar(100),
    headlocationtype           varchar(3),
    headlogo                   text,
    headlogox2                 text,
    headorganic                varchar(10),
    headoverviewurl            text,
    headposted                 varchar(20),
    headrating                 numeric,
    headsaved                  varchar(10),
    headsavedjobid             integer,
    headsgocid                 varchar(10),
    headsponsored              varchar(10),
    headuseradmin              varchar(10),
    headuxapplytype            varchar(10),
    headfeaturedvideo          text,
    headnormalizedjob          varchar(150),
    headurgencylabel           text,
    headurgencylabelformessage text,
    headurgencymessage         text,
    headneedscommission        varchar(10),
    headpayhigh                numeric,
    headpaylow                 numeric,
    headpaymed                 numeric,
    headpayperiod              varchar(10),
    headsalaryhigh             numeric,
    headsalarylow              numeric,
    headsalarysource           varchar(30),
    jobdescription             text,
    jobdiscoverdate            timestamp,
    jobeolhashcode             numeric,
    jobimportconfid            varchar(10),
    jobreqid                   numeric,
    jobreqidint                numeric,
    jobsource                  text,
    jobtitleid                 varchar(10),
    joblistingid               varchar(15),
    joblistingidint            varchar(15),
    mapcountry                 varchar(30),
    mapemployername            varchar(100),
    maplat                     double precision,
    maplong                    double precision,
    maplocation                varchar(100),
    mapaddress                 varchar(200),
    mappostalcode              varchar(100),
    ovallbenefitslink          text,
    ovallphotoslink            text,
    ovallrevlink               text,
    ovallsalarieslink          text,
    ovfoundedyear              integer,
    ovhq                       varchar(100),
    ovindustry                 varchar(50),
    ovindustryid               varchar(10),
    ovrevenue                  varchar(100),
    ovsector                   varchar(50),
    ovsectorid                 varchar(10),
    ovsize                     varchar(50),
    ovstock                    varchar(50),
    ovtype                     varchar(30),
    ovdescription              text,
    ovmission                  text,
    ovwebsite                  text,
    ovallvideoslink            text,
    ovcompetitors              varchar(10),
    ovcompanyvideo             text,
    photos                     numeric,
    ratceoname                 varchar(200),
    ratceophoto                text,
    ratceophoto2               text,
    ratceoratcount             integer,
    ratceoapproval             numeric,
    ratrecomtofriend           numeric,
    ratstarrating              numeric,
    reviews                    integer,
    salcountry3let             varchar(3),
    salcountryiso              varchar(2),
    salcountrycontcode         varchar(2),
    salcountrycontname         varchar(20),
    salcountrycontid           varchar(5),
    salcountrycontnew          varchar(6),
    salcountryfips             varchar(2),
    salcountrycurrcode         varchar(3),
    salcountrycurrencydefdig   integer,
    salcountrycurrname         varchar(50),
    salcountrycurrid           varchar(3),
    salcountrycurrname2        varchar(50),
    salcountrycurrnegtempl     varchar(5),
    salountrycurrnew           varchar(6),
    salcountrycurrpostempl     varchar(5),
    salcountrycurrsymbol       varchar(10),
    salcountrycurrcode2        varchar(3),
    salcountrydeflocal         varchar(10),
    salcountrydefname          varchar(20),
    salcountrydefshortname     varchar(20),
    salcountryemplsolcount     varchar(6),
    salcountryid               varchar(3),
    salcountrylongname         varchar(20),
    salcountrymajor            varchar(6),
    salcountryname             varchar(20),
    salcountrynew              varchar(6),
    salcountrypop              integer,
    salcountryshortname        varchar(2),
    salcountrytld              varchar(5),
    salcountrytype             varchar(2),
    salcountryuniname          varchar(20),
    salcountrycentrname        varchar(20),
    salcurrcode                varchar(3),
    salcurrdefdig              integer,
    salcurrdispname            varchar(30),
    salcurrid                  varchar(3),
    salcurrname                varchar(30),
    salcurrnegtempl            varchar(5),
    salcurrnew                 varchar(6),
    salcurrpostempl            varchar(5),
    salcurrsymbol              varchar(10),
    sallassalarydate           timestamp,
    salsalaries                integer,
    wwfu                       varchar(10)
);

--Tabelle effettive
CREATE TABLE users
(
    idUser serial
);

create table employee
(
    job      varchar(200),
    location varchar(100),
    company  varchar(150)
) inherits (users);


create table currEmployee
(
    relation varchar(200)
) INHERITS (employee);

create table ExEmployee
(
    relation varchar(200)
) INHERITS (employee);

create table opinion
(
    opinionid varchar(10)
);

create table benefitshighlights
(
    opinionid            varchar(10),
    index                integer,
    highlights           text,
    benefitsname         varchar(100),
    countbenefitsreviews integer
);

create table benefitscommets
(
    opinionid         varchar(10),
    index             integer,
    city              varchar(100),
    employeecomment   text,
    commentdate       date,
    currentjobrelated varchar(10),
    employeejob       varchar(100),
    benefitsrating    integer,
    state             varchar(50)
);

create table review
(
    opinionid           varchar(10),
    reviewid            varchar(10),
    index               integer,
    reviewtitle         text,
    cons                text,
    reviewdate          varchar(50),
    featured            varchar(10),
    pros                text,
    publicationdate     varchar(50),
    careerrating        numeric,
    benefitsrating      numeric,
    culturevaluesrating numeric,
    overallrating       numeric,
    senmanagrating      numeric,
    workliferating      numeric,
    timeworked          varchar(200),
    currrel             varchar(200),
    revjobtitle         varchar(100),
    revlocation         varchar(100),
    ceoapproval         numeric,
    recommendedcompany  integer,
    revmanadv           text,
    revrespid           varchar(30)
);

create table revreply
(
    reviewid      varchar(10),
    index         integer,
    revjobtitle   varchar(100),
    revtext       text,
    revtextlenght integer,
    revupdatedate date
);

create table reply
(
    replydate     date,
    replyid       varchar(10),
    replyindex    integer,
    reviewid      varchar(10),
    reviewindex   integer,
    reviewlisting varchar(10)
);


create table listing
(
    listingid varchar(10),
    OpinionId varchar(10)
);

create type job_item as
(
    jobdescription text,
    jobsource      varchar(50),
    jobtitleid     varchar(10),
    discoverdate   date
);

create type header_item as
(
    adorderid      varchar(10),
    advertisertype varchar(100),
    empid          varchar(10),
    empname        varchar(100),
    expired        varchar(50),
    hideceoinfo    varchar(10),
    jobid          varchar(10),
    jobtitle       varchar(200),
    joblocation    varchar(200),
    joblocationid  varchar(10),
    posted         varchar(50),
    companyrating  numeric,
    sponsored      varchar(10),
    payment90perc  integer,
    payment10perc  integer,
    medianpayment  integer,
    payperiod      varchar(20)
);


create type benefits_item as
(
    numratings      integer,
    benefitssummary text,
    benefitsratings numeric
);

create type salaries_item as
(
    currencycode   varchar(5),
    lastsalarydate date,
    salary         varchar(10)
);

create type ratings_item as
(
    ceoname             varchar(200),
    ceoapproval         numeric,
    recommendedtofriend numeric,
    starrating          numeric,
    reviews             integer,
    ratingscount        integer
);

create type map_item as
(
    country    varchar(50),
    latitude   float,
    longitude  float,
    location   varchar(100),
    address    varchar(200),
    postalcode varchar(50)
);

create table section
(
    listingid varchar(10),
    job       job_item,
    header    header_item,
    benefits  benefits_item,
    salaries  salaries_item,
    ratings   ratings_item,
    map       map_item
);

create table currencyexchange
(
    code3digits    varchar(5),
    countryname    varchar(100),
    currencyname   varchar(50),
    currencynumber numeric,
    exchangerate   numeric
);


create table country2digit
(
    countrycode varchar(5),
    countryname varchar(50)
);

create type industry_sector_item as
(
    id           varchar(10),
    denomination varchar(50)
);

create table company
(
    empid                 varchar(10),
    empname               varchar(100),
    companyfoundationyear integer,
    companyheadquarters   varchar(100),
    industry              industry_sector_item,
    sector                industry_sector_item,
    companyrevenue        varchar(100),
    companysize           varchar(40),
    companydescription    text,
    companymission        text,
    companytype           varchar(50)
) inherits (users);

create table salarieslist
(
    listingid      varchar(10),
    index          integer,
    countsalaryrep integer,
    jobtitle       varchar(150),
    payperiod      varchar(30),
    payperc10      numeric,
    payperc90      numeric,
    payperc50      numeric,
    whoreport      varchar(50)
);

--Tabelle di supporto per le query
--Aree e Nazioni che le compongono
CREATE TABLE mapAreas
(
    Area      varchar(30),
    Countries varchar(500)
);

--Salvataggio dei dati json risultanti dalla pipeline NER
CREATE TABLE highlightsResults
(
    id      serial,
    comment json
);

--Tabella che funge da template per la trasformazione da json
create table Features
(
    indices  text,
    source   text,
    string   text,
    length   int,
    category text,
    chunk    text
);

--Salvataggio dei dati CSV risultati dalla pipeline di PMI
CREATE TABLE mixedBag
(
    term     text,
    lang     text,
    type     text,
    term2    text,
    lang2    text,
    type2    text,
    pmiscore decimal,
    docFreq  int,
    freq     int
);


--Salvataggio dei dati CSV risultanti dalla pipeline di Corpus Analysis
CREATE TABLE TfIdftable
(
    term     text,
    typology varchar(20),
    lang     varchar(10),
    tfidf    decimal,
    tfidfraw decimal,
    tf       decimal,
    locdocfr decimal,
    refdocfr decimal
);

CREATE TABLE Annotationtable
(
    term       text,
    typology   varchar(20),
    lang       varchar(10),
    tfidfaug   decimal,
    tfidfaugra decimal,
    tf         decimal,
    locdocfr   decimal
);

CREATE TABLE Hyponymytable
(
    term      text,
    typology  varchar(20),
    lang      varchar(10),
    kdomRel   decimal,
    kdomRelra decimal,
    tf        decimal,
    hypCount  decimal,
    locdocfr  decimal
);


--Tipi composti per la creazione della tabella dove salvare i risultati della pipelina di Corpus Analysis
CREATE TYPE TfIdf as
(
    term     text,
    typology varchar(20),
    lang     varchar(10),
    tfidf    decimal,
    tfidfraw decimal,
    tf       decimal,
    locdocfr decimal,
    refdocfr decimal
);

CREATE TYPE Annotation as
(
    term       text,
    typology   varchar(20),
    lang       varchar(10),
    tfidfaug   decimal,
    tfidfaugra decimal,
    tf         decimal,
    locdocfr   decimal
);

CREATE TYPE Hyponymy AS
(
    term      text,
    typology  varchar(20),
    lang      varchar(10),
    kdomRel   decimal,
    kdomRelra decimal,
    tf        decimal,
    hypCount  decimal,
    locdocfr  decimal
);

--Tabella per contenere i risultati della pipeline di Corpus Analysis
CREATE TABLE CorpusStats(
    tfidf      TfIdf,
    annotation Annotation,
    hyponymy   Hyponymy
);

CREATE TABLE JobDescription() INHERITS (CorpusStats);
CREATE TABLE Pros() INHERITS (CorpusStats);
CREATE TABLE Cons() INHERITS (CorpusStats);








