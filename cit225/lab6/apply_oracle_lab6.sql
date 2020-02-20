-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab6.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab6.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

-- Open log file.
SPOOL apply_oracle_lab6.txt

-- ... insert lab 6 commands here ...

--part 1--
ALTER TABLE rental_item
    ADD(Rental_item_price NUMBER)
    ADD(rental_item_type NUMBER);
    
    SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;
    
--------------------------------------------------------------------------
-----------------------------------------------------------------------------
----------------------------------------------------------------------------


--part 2--
CREATE TABLE PRICE
( PRICE_ID                   NUMBER   
, ITEM_ID                    NUMBER    CONSTRAINT nn_price_1 NOT NULL
, PRICE_TYPE                 NUMBER    
, ACTIVE_FLAG            VARCHAR2(19) CONSTRAINT nn_price_2 NOT NULL
, START_DATE             VARCHAR2(20) CONSTRAINT nn_price_3 NOT NULL 
, END_DATE                   VARCHAR2(20)
, AMOUNT                     NUMBER  CONSTRAINT nn_price_4 NOT NULL
, CREATED_BY                 NUMBER  CONSTRAINT nn_price_5 NOT NULL   
, CREATION_DATE              varchar2(20) CONSTRAINT nn_price_6 NOT NULL
, LAST_UPDATED_BY            NUMBER CONSTRAINT nn_price_7 NOT NULL
, LAST_UPDATE_DATE          VARCHAR2(20) CONSTRAINT nn_price_8 NOT NULL
, CONSTRAINT pk_price_1     PRIMARY KEY(PRICE_ID)
, CONSTRAINT fk_price_1    FOREIGN KEY (ITEM_ID) REFERENCES item(item_id)
, CONSTRAINT fk_price_2   FOREIGN KEY (PRICE_TYPE) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3  FOREIGN KEY (CREATED_BY) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_price_4  FOREIGN KEY (LAST_UPDATED_BY) REFERENCES system_user(system_user_id) 
, CONSTRAINT  YN_PRICE CHECK (ACTIVE_FLAG IN('Y', 'N')));

SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE'
ORDER BY 2;

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';
--------------------------------------------------------------------------
-----------------------------------------------------------------------------
----------------------------------------------------------------------------


--part 3--

-- part3.a--

ALTER TABLE Item
RENAME COLUMN item_release_date to release_date;
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

--part3.b--
INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'9886-05840-5'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tron'
,'Special Collector''s Edition'
,'R'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'9546-05888-6'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Enders Game'
,'Special Collector''s Edition'
,'R'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_s1.nextval
,'1258-68748-4'
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'ITEM'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Elysium'
,'Special Collector''s Edition'
,'PG-13'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);


SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

--------------------------------------------------------------------------
-----------------------------------------------------------------------------
----------------------------------------------------------------------------

--part 3.c--
-- ------------------------------------------------------------------
--  Insert first contact in a group account user.
-- ----------------------------------------------------------------
INSERT INTO MEMBER
VALUES
(member_s1.nextval			       -- member_id
, 1004					       -- member_type
,'US00011'				       -- account_number
,'6011-0000-0000-0078'			       -- credit_card_number
,(SELECT	common_lookup_id
  FROM	common_lookup
  WHERE	common_lookup_context = 'MEMBER'
  AND	common_lookup_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT	system_user_id
    FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
, SYSDATE					       -- creation_date
,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
, SYSDATE					       -- last_update_date
   );

   INSERT INTO contact
   ( contact_id
  , member_id
  , contact_type
  , first_name
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( contact_s1.nextval			       -- contact_id
  , member_s1.currval			       -- member_id
  ,(SELECT	common_lookup_id
     FROM	common_lookup
    WHERE	common_lookup_context = 'CONTACT'
    AND	common_lookup_type = 'CUSTOMER')       -- contact_type
  ,'Harry'					       -- first_name
  ,'Potter'					       -- last_name
    ,(SELECT	system_user_id
     FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
  ,(SELECT	system_user_id
    FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
    , SYSDATE					       -- last_update_date
  );
  
   INSERT INTO address
    ( address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
   , last_updated_by
   , last_update_date )
   VALUES
   ( address_s1.nextval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_type = 'HOME')	       -- address_type
   ,'Provo'				       -- city
   ,'Utah'					       -- state_province
   ,'84604'					       -- postal_code
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );

    INSERT INTO street_address
   ( street_address_id
   , address_id
   , street_address
   , created_by
  , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( street_address_s1.nextval		       -- street_address_id
   , address_s1.currval			       -- address_id
   ,'900, E 300 N'			       -- street_address
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
   
   INSERT INTO telephone
   ( telephone_id
   , contact_id
   , address_id
   , telephone_type
   , country_code
   , area_code
  , telephone_number
   , created_by
   , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( telephone_s1.nextval			       -- telephone_id
   , address_s1.currval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_context = 'MULTIPLE'
     AND	common_lookup_type = 'HOME')	       -- telephone_type
   ,'001'					       -- country_code
  ,'801'					       -- area_code
   ,'333-3333'				       -- telephone_number
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
   ------------------------------------------------------------------
--  Insert second contact in a group account user.
-- ------------------------------------------------------------------
     
    INSERT INTO contact
   ( contact_id
  , member_id
  , contact_type
  , first_name
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( contact_s1.nextval			       -- contact_id
  , member_s1.currval			       -- member_id
  ,(SELECT	common_lookup_id
     FROM	common_lookup
    WHERE	common_lookup_context = 'CONTACT'
    AND	common_lookup_type = 'CUSTOMER')       -- contact_type
  ,'Ginny'					       -- first_name
  ,'Potter'					       -- last_name
    ,(SELECT	system_user_id
     FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
  ,(SELECT	system_user_id
    FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
    , SYSDATE					       -- last_update_date
  );
  
   INSERT INTO address
    ( address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
   , last_updated_by
   , last_update_date )
   VALUES
   ( address_s1.nextval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_type = 'HOME')	       -- address_type
   ,'Provo'				       -- city
   ,'Utah'					       -- state_province
   ,'84604'					       -- postal_code
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );

    INSERT INTO street_address
   ( street_address_id
   , address_id
   , street_address
   , created_by
  , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( street_address_s1.nextval		       -- street_address_id
   , address_s1.currval			       -- address_id
   ,'900, E 300 N'			       -- street_address
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
    INSERT INTO telephone
   ( telephone_id
   , contact_id
   , address_id
   , telephone_type
   , country_code
   , area_code
  , telephone_number
   , created_by
   , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( telephone_s1.nextval			       -- telephone_id
   , address_s1.currval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_context = 'MULTIPLE'
     AND	common_lookup_type = 'HOME')	       -- telephone_type
   ,'001'					       -- country_code
  ,'801'					       -- area_code
   ,'333-3333'				       -- telephone_number
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
     ------------------------------------------------------------------
--  Insert third contact in a group account user.
-- ------------------------------------------------------------------
   
       INSERT INTO contact
   ( contact_id
  , member_id
  , contact_type
  , first_name
  , middle_name
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( contact_s1.nextval			       -- contact_id
  , member_s1.currval			       -- member_id
  ,(SELECT	common_lookup_id
     FROM	common_lookup
    WHERE	common_lookup_context = 'CONTACT'
    AND	common_lookup_type = 'CUSTOMER')       -- contact_type
  ,'Lily'                   -- first_name
  , 'Luna'
  ,'Potter'					       -- last_name
    ,(SELECT	system_user_id
     FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
  ,(SELECT	system_user_id
    FROM	system_user
    WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
    , SYSDATE					       -- last_update_date
  );
  
     INSERT INTO address
    ( address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
   , last_updated_by
   , last_update_date )
   VALUES
   ( address_s1.nextval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_type = 'HOME')	       -- address_type
   ,'Provo'				       -- city
   ,'Utah'					       -- state_province
   ,'84604'					       -- postal_code
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );

    INSERT INTO street_address
   ( street_address_id
   , address_id
   , street_address
   , created_by
  , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( street_address_s1.nextval		       -- street_address_id
   , address_s1.currval			       -- address_id
   ,'900, E 300 N'			       -- street_address
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
    INSERT INTO telephone
   ( telephone_id
   , contact_id
   , address_id
   , telephone_type
   , country_code
   , area_code
  , telephone_number
   , created_by
   , creation_date
   , last_updated_by
   , last_update_date )
    VALUES
   ( telephone_s1.nextval			       -- telephone_id
   , address_s1.currval			       -- address_id
   , contact_s1.currval			       -- contact_id
   ,(SELECT	common_lookup_id
     FROM	common_lookup
     WHERE	common_lookup_context = 'MULTIPLE'
     AND	common_lookup_type = 'HOME')	       -- telephone_type
   ,'001'					       -- country_code
   ,'801'					       -- area_code
   ,'333-3333'				       -- telephone_number
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- created_by
   , SYSDATE					       -- creation_date
   ,(SELECT	system_user_id
     FROM	system_user
     WHERE	system_user_name = 'SYSADMIN')	       -- last_updated_by
   , SYSDATE					       -- last_update_date
   );
   
   COLUMN account_number  FORMAT A10  HEADING "Account|Number"
COLUMN full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COLUMN street_address  FORMAT A14  HEADING "Street Address"
COLUMN city            FORMAT A10  HEADING "City"
COLUMN state           FORMAT A10  HEADING "State"
COLUMN postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN
             ' ' || c.middle_name || ' '
         END AS full_name
,        sa.street_address
,        a.city
,        a.state_province AS state
,        a.postal_code
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--PART 3.d--
-- .NEXTVAL pseudo column calls for the primary key values and .CURRVAL pseudo column calls for the foreign key values into RENTAL and RENTAL_ITEM tables respectively. --

    
  
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1001
, SYSDATE
, 1001
, SYSDATE);

  
  ---------last_update_date


   INSERT INTO rental_item
    (rental_item_id
    , rental_id
    , item_id
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date)
  VALUES
   (rental_item_s1.nextval 
   ,  rental_s1.currval        
   , 1022
   , 1001    
   , TRUNC(SYSDATE)  
   , 1001         
   , TRUNC(SYSDATE));                                             
  
    INSERT INTO rental_item
    (rental_item_id
    , rental_id
    , item_id
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    , rental_item_price
    , rental_item_type)
  VALUES
   (rental_item_s1.nextval                       ---rental_item_id
   ,  rental_s1.currval                               --renal_id                
   , (SELECT item_id                                   ---item_id
      FROM   item
      WHERE item_title = 'Star Wars III')
    , 1001                                             ---created_by
   , TRUNC(SYSDATE)                                ----creation_date
   , 1001                                           ---last_updated_by
   , TRUNC(SYSDATE)                                 -----last_update_date
   , 10                                                 ----rental_item_price
   , 1);  
   
     
  
     
  
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1001
, SYSDATE
, 1001
, SYSDATE);
---------last_update_date
  
  
  
        INSERT INTO rental_item
    (rental_item_id
    , rental_id
    , item_id
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    , rental_item_price
    , rental_item_type)
  VALUES
   (rental_item_s1.nextval                           ---rental_item_id
   ,  rental_s1.currval                              --renal_id                
   , (SELECT item_id                                 ---item_id
      FROM   item
      WHERE item_title = 'Enders Game')
    , 1001                                        ---created_by
   , TRUNC(SYSDATE)                               ----creation_date
   , 1001                                         ---last_updated_by
   , TRUNC(SYSDATE)                               -----last_update_date
   , 10                                           ----rental_item_price
   , 1);  
   
   
   
INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);
---------last_update_date
  
  
  
   INSERT INTO rental_item
    (rental_item_id
    , rental_id
    , item_id
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    , rental_item_price
    , rental_item_type)
  VALUES
   (rental_item_s1.nextval                    ---rental_item_id
   ,  rental_s1.currval                      --renal_id                
   , (SELECT item_id                         ---item_id
      FROM   item
      WHERE item_title = 'Elysium')
    , 1001                                  ---created_by
   , TRUNC(SYSDATE)                         ----creation_date
   , 1001                                   ---last_updated_by
   , TRUNC(SYSDATE)                         -----last_update_date
   , 10                                      ----rental_item_price
   , 1);  
   
   
  COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

--------------------------------
 -------------------------------------------------------------------
 
 --PART 4.A---
 DROP INDEX common_lookup_n1;
 DROP INDEX common_lookup_u2;
 
 COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';
 
  ------------------------------------------------------------------
 -------------------------------------------------------------------
 -- PART 4.B---
 ALTER TABLE common_lookup
 ADD (common_lookup_table VARCHAR2 (30));
 
 ALTER TABLE common_lookup
 ADD (common_lookup_column VARCHAR2 (30));
 
 ALTER TABLE common_lookup
 ADD (common_lookup_code VARCHAR2 (30));
 
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;
 ------------------------------------------------------------------
 
 
 -- part 4 c1 --
 --Migrate data and populate (or seed) new columns with existing data.
-- Migrate COMMON_LOOKUP_CONTEXT column values. It is possible to make these changes one at a time, as the instructions explain. It is also possible to make multiple changes in a single query. The detail verification scripts verify the detailed steps. You may ignore them if you write a more complex UPDATE statement.
--The state of the COMMON_LOOKUP table before any data changes:

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;
 
 
 
 
 -- part 4 c2--
--Update the COMMON_LOOKUP_TABLE column with the value of the COMMON_LOOKUP_CONTEXT column when the COMMON_LOOKUP_CONTEXT column’s value isn’t equal to a value of 'MULTIPLE'..--

  UPDATE   common_lookup
SET      common_lookup_table = common_lookup_context
WHERE common_lookup_context <> 'MULTIPLE';

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;


-- part 4 c 3---
--Update the COMMON_LOOKUP_TABLE column with the value of of 'ADDRESS' when the COMMON_LOOKUP_CONTEXT column value is equal to 'MULTIPLE'..

UPDATE common_lookup
SET common_lookup_table = 'ADDRESS'
WHERE common_lookup_context = 'MULTIPLE';

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;




-- part 4 c 4---
--Update the COMMON_LOOKUP_COLUMN column with the value of the COMMON_LOOKUP_CONTEXT column and a '_TYPE' string where the COMMON_LOOKUP_CONTEXT column contains a valid table name.

UPDATE common_lookup
SET common_lookup_column = common_lookup_context || '_TYPE'
WHERE common_lookup_context <> 'MULTIPLE';

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;


--Update the COMMON_LOOKUP_COLUMN column with the value of 'ADDRESS_TYPE' string where the COMMON_LOOKUP_CONTEXT column contains a MULTIPLE string.
--The table will look like the following after migrating COMMON_LOOKUP_CONTEXT values to the COMMON_LOOKUP_TABLE and COMMON_LOOKUP_COLUMN column values:--


-- part 4 c 5---
--Update the COMMON_LOOKUP_COLUMN column with the value of 'ADDRESS_TYPE' string where the COMMON_LOOKUP_CONTEXT column contains a MULTIPLE string.
--The table will look like the following after migrating COMMON_LOOKUP_CONTEXT values to the COMMON_LOOKUP_TABLE and COMMON_LOOKUP_COLUMN column values:--
 UPDATE common_lookup
 SET common_lookup_column = 'ADDRESS_TYPE'
 WHERE common_lookup_context = 'MULTIPLE';

COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;


 
 
 
 
/* -------------------------------------------------------------------
 --part 4 d Add two new rows to the COMMON_LOOKUP table to support the 'HOME' and 'WORK' possibilities for the TELEPHONE_TYPE column. The following shows you what to insert into the COMMON_LOOKUP table:
Table Name: COMMON_LOOKUP
Table	Column	Code	Type	Meaning
TEELEPHONE	
TELEPHONE_TYPE	 	
HOME	
Home


TELEPHONE	
TELEPHONE_TYPE	 	
WORK	
Work;
You should insert the required two rows by using the following named notation signature for the INSERT statement:
 ---------------------------------------------------------------------*/
 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'TELEPHONE'
 ,      'HOME'
 ,      'HOME'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'TELEPHONE'
 ,      'TELEPHONE_TYPE'
 ,      '');
 
 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'TELEPHONE'
 ,      'WORK'
 ,      'WORK'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'TELEPHONE'
 ,      'TELEPHONE_TYPE'
 ,      '');
 
 COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;
 
 
 -------------------------------------------------------------------
 --part 4 e
 ---------------------------------------------------------------------
 ---4.e.1
 --You must get rid of old and now obsolete COMMON_LOOKUP_CONTEXT column.-- 
  ALTER TABLE common_lookup
  DROP COLUMN COMMON_LOOKUP_CONTEXT;
  
  SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;
          
  ---4.e.2 & 3---   
  --Add a NOT NULL constraint to the COMMON_LOOKUP_TABLE column.--
ALTER TABLE common_lookup
MODIFY (common_lookup_table  VARCHAR2(30) CONSTRAINT NN_CLOOKUP_8 NOT NULL);

ALTER TABLE common_lookup
MODIFY (common_lookup_column VARCHAR2(30) CONSTRAINT NN_CLOOKUP_9 NOT NULL);
   
   COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;
   
 ---4.e.4--  
  -- Add a unique index using the following three columns:
CREATE INDEX clookup_u1
ON common_lookup(COMMON_LOOKUP_TABLE, COMMON_LOOKUP_COLUMN, COMMON_LOOKUP_TYPE);

COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   UI.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes UI INNER JOIN user_ind_columns uic
ON       UI.index_name = uic.index_name
AND      UI.table_name = uic.table_name
WHERE    UI.table_name = UPPER('common_lookup')
ORDER BY UI.index_name
,        uic.column_position;



         -------------------------------------------------------------------
 --part 4 f
 ---------------------------------------------------------------------
 
 -- The last step requires that you update incorrect foreign key values in the telephone table. They are invalid because the rows in the COMMON_LOOKUP table that once supported both the ADDRESS and TELEPHONE tables now only supports the ADDRESS table. You need to copy the values of the correct COMMON_LOOKUP_ID column values (the surrogate primary key column) into the TELEPHONE_TYPE column of the TELEPHONE table.
 
--You should structure and UPDATE statement that sets the TELEPHONE_TYPE column values equal to the correct values where they are currently the obsolete values. --
 UPDATE telephone
 SET telephone_type = (SELECT common_lookup_id
                    FROM common_lookup WHERE common_lookup_table = 'TELEPHONE' 
                    AND common_lookup_meaning = 'HOME');

 COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

SPOOL OFF
