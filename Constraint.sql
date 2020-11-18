--Setting PK-FK
ALTER TABLE employee
    ADD CONSTRAINT PK_employee PRIMARY KEY (job, company, location);

ALTER TABLE opinion
    ADD CONSTRAINT PK_opinion PRIMARY KEY (opinionid);

ALTER TABLE benefitshighlights
    ADD CONSTRAINT PK_benefitshighlights PRIMARY KEY (opinionid, index);

ALTER TABLE benefitscommets
    ADD CONSTRAINT PK_benefitscomments PRIMARY KEY (opinionid, index);

ALTER TABLE review
    ADD CONSTRAINT PK_review PRIMARY KEY (opinionid, reviewid, index);

ALTER TABLE revreply
    ADD CONSTRAINT PK_revreply PRIMARY KEY (reviewid, index);

ALTER TABLE reply
    ADD constraint reply_reviewid_reviewindex_reviewlisting_fkey
        foreign key (reviewid, reviewindex, reviewlisting) references review (reviewid, index, opinionid),
    ADD constraint reply_replyid_replyindex_fkey
        foreign key (replyid, replyindex) references revreply;

ALTER TABLE listing
    ADD CONSTRAINT PK_listing PRIMARY KEY (listingid, opinionid);

alter table listing
    add constraint listing_opinion_opinionid_fk
        foreign key (opinionid) references opinion (opinionid);

ALTER TABLE section
    ADD CONSTRAINT PK_section PRIMARY KEY (listingid);

alter table listing
    add constraint listing_section_listingid_fk
        foreign key (listingid) references section (listingid);

ALTER TABLE currencyexchange
    ADD CONSTRAINT PK_currencyexchange PRIMARY KEY (code3digits);

ALTER TABLE country2digit
    ADD CONSTRAINT PK_country2digit PRIMARY KEY (countrycode);

ALTER TABLE company
    ADD CONSTRAINT PK_company PRIMARY KEY (empid);

ALTER TABLE salarieslist
    ADD CONSTRAINT PK_salarieslist PRIMARY KEY (listingid, index);
