/*
||  Nme:          apply_plsql_lab7.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 8 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

@@/home/student/Data/cit325/lib/cleanup_oracle.sql
@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
-- Open log file.
SPOOL apply_plsql_lab7.log
-- ... insert your solution here ...
-- step 0
/* Show all 4 DBAs if they have the same name*/
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';
 
/* Change all 4 DBAs back to DBA if they are different*/

UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

/* Change DBAs to DBA1-4 to be different*/
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER :=2 ;
  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;
  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);
BEGIN

  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

/* Show new different DBAs */
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

/* Drop existing objects */
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

-- part 1
-- LIST VARIABLES
create or replace PROCEDURE INSERT_CONTACT
(PV_FIRST_NAME           varchar2
,PV_MIDDLE_NAME          varchar2 := ''
,PV_LAST_NAME            varchar2
,PV_CONTACT_TYPE         varchar2
,PV_ACCOUNT_NUMBER       varchar2
,PV_MEMBER_TYPE          varchar2
,PV_CREDIT_CARD_NUMBER   varchar2
,PV_CREDIT_CARD_TYPE     varchar2
,PV_CITY                 varchar2
,PV_STATE_PROVINCE       varchar2
,PV_POSTAL_CODE          varchar2
,PV_ADDRESS_TYPE         varchar2
,PV_COUNTRY_CODE         varchar2
,PV_AREA_CODE            varchar2
,PV_TELEPHONE_NUMBER     varchar2
,PV_TELEPHONE_TYPE       varchar2
,PV_USER_NAME            varchar2) is
LV_ADDRESS_TYPE         varchar2(30);
LV_CONTACT_TYPE         varchar2(30);
LV_CREDIT_CARD_TYPE     varchar2(30);
LV_MEMBER_TYPE          varchar2(30);
LV_TELEPHONE_TYPE       varchar2(30);
LV_MEMBER_ID            number;
LV_SYSTEM_USER_ID       number;

CURSOR get_type(cv_table_name  VARCHAR2
               ,cv_column_name VARCHAR2
               ,cv_lookup_type VARCHAR2) IS
               SELECT common_lookup_id
               FROM common_lookup
               WHERE common_lookup_table  = cv_table_name
               AND   common_lookup_column = cv_column_name
               AND   common_lookup_type   = cv_lookup_type;
        BEGIN

    FOR i IN get_type('MEMBER', 'MEMBER_TYPE', PV_MEMBER_TYPE) LOOP
    lv_member_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('CONTACT', 'CONTACT_TYPE', PV_CONTACT_TYPE) LOOP
    lv_contact_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('ADDRESS', 'ADDRESS_TYPE', PV_ADDRESS_TYPE) LOOP
    lv_address_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('TELEPHONE', 'TELEPHONE_TYPE', PV_TELEPHONE_TYPE) LOOP
    lv_telephone_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('MEMBER', 'CREDIT_CARD_TYPE', PV_CREDIT_CARD_TYPE) LOOP
    lv_credit_card_type := i.common_lookup_id;
    END LOOP;

select system_user_id
into LV_SYSTEM_USER_ID
from system_user
where system_user_name = pv_user_name;

SAVEPOINT starting_point;
    INSERT INTO member
    VALUES
    ( member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_system_user_id
    , SYSDATE
    , lv_system_user_id
    , SYSDATE );
    
    lv_member_id := member_s1.CURRVAL;

  INSERT INTO contact
    VALUES
  ( contact_s1.NEXTVAL
  , lv_member_id
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE);

INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE );

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                        -- TELEPHONE_ID
  , contact_s1.CURRVAL                          -- CONTACT_ID
  , address_s1.CURRVAL                          -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                             -- COUNTRY_CODE
  , pv_area_code                                -- AREA_CODE
  , pv_telephone_number                         -- TELEPHONE_NUMBER
  , lv_system_user_id                           -- CREATED_BY
 , SYSDATE                                      -- CREATION_DATE
  , lv_system_user_id                           -- LAST_UPDATED_BY
  , SYSDATE);                                    -- LAST_UPDATE_DATE
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END INSERT_CONTACT;
/

BEGIN
insert_contact
(PV_FIRST_NAME => 'Charles'
,PV_MIDDLE_NAME => 'Francis'
, PV_LAST_NAME => 'Xavier'
, PV_CONTACT_TYPE => 'CUSTOMER'
, PV_ACCOUNT_NUMBER =>'SLC-000008'
, PV_MEMBER_TYPE =>'INDIVIDUAL'
, PV_CREDIT_CARD_NUMBER =>'7777-6666-5555-4444'
, PV_CREDIT_CARD_TYPE =>'DISCOVER_CARD'
, PV_CITY =>'Milbridge'
, PV_STATE_PROVINCE =>'Maine'
, PV_POSTAL_CODE =>'04658'
, PV_ADDRESS_TYPE =>'HOME'
, PV_COUNTRY_CODE =>'001'
, PV_AREA_CODE =>'207'
, PV_TELEPHONE_NUMBER =>'111-1234'
, PV_TELEPHONE_TYPE =>'HOME'
, PV_USER_NAME =>'DBA 2');
END;
/
-- step 1 query
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

-- step 2 insert
create or replace PROCEDURE INSERT_CONTACT
(PV_FIRST_NAME           varchar2
,PV_MIDDLE_NAME          varchar2 := ''
,PV_LAST_NAME            varchar2
,PV_CONTACT_TYPE         varchar2
,PV_ACCOUNT_NUMBER       varchar2
,PV_MEMBER_TYPE          varchar2
,PV_CREDIT_CARD_NUMBER   varchar2
,PV_CREDIT_CARD_TYPE     varchar2
,PV_CITY                 varchar2
,PV_STATE_PROVINCE       varchar2
,PV_POSTAL_CODE          varchar2
,PV_ADDRESS_TYPE         varchar2
,PV_COUNTRY_CODE         varchar2
,PV_AREA_CODE            varchar2
,PV_TELEPHONE_NUMBER     varchar2
,PV_TELEPHONE_TYPE       varchar2
,PV_USER_NAME            varchar2) is
LV_ADDRESS_TYPE         varchar2(30);
LV_CONTACT_TYPE         varchar2(30);
LV_CREDIT_CARD_TYPE     varchar2(30);
LV_MEMBER_TYPE          varchar2(30);
LV_TELEPHONE_TYPE       varchar2(30);
LV_MEMBER_ID            number;
LV_SYSTEM_USER_ID       number;

CURSOR get_type(cv_table_name  VARCHAR2
               ,cv_column_name VARCHAR2
               ,cv_lookup_type VARCHAR2) IS
               SELECT common_lookup_id
               FROM common_lookup
               WHERE common_lookup_table  = cv_table_name
               AND   common_lookup_column = cv_column_name
               AND   common_lookup_type   = cv_lookup_type;
        PRAGMA AUTONOMOUS_TRANSACTION;

        BEGIN
    FOR i IN get_type('MEMBER', 'MEMBER_TYPE', PV_MEMBER_TYPE) LOOP
    lv_member_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('CONTACT', 'CONTACT_TYPE', PV_CONTACT_TYPE) LOOP
    lv_contact_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('ADDRESS', 'ADDRESS_TYPE', PV_ADDRESS_TYPE) LOOP
    lv_address_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('TELEPHONE', 'TELEPHONE_TYPE', PV_TELEPHONE_TYPE) LOOP
    lv_telephone_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('MEMBER', 'CREDIT_CARD_TYPE', PV_CREDIT_CARD_TYPE) LOOP
    lv_credit_card_type := i.common_lookup_id;
    END LOOP;

select system_user_id
into LV_SYSTEM_USER_ID
from system_user
where system_user_name = pv_user_name;

SAVEPOINT starting_point;

    INSERT INTO member
    VALUES
    ( member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_system_user_id
    , SYSDATE
    , lv_system_user_id
    , SYSDATE );
    lv_member_id := member_s1.CURRVAL;

  INSERT INTO contact
    VALUES
  ( contact_s1.NEXTVAL
  , lv_member_id
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE);

INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE );

 
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL             -- TELEPHONE_ID
  , contact_s1.CURRVAL               -- CONTACT_ID
  , address_s1.CURRVAL               -- ADDRESS_ID
  , lv_telephone_type           
  , pv_country_code                  -- COUNTRY_CODE
  , pv_area_code                     -- AREA_CODE
  , pv_telephone_number              -- TELEPHONE_NUMBER
  , lv_system_user_id                -- CREATED_BY
  , SYSDATE                          -- CREATION_DATE
  , lv_system_user_id                -- LAST_UPDATED_BY
  , SYSDATE);                        -- LAST_UPDATE_DATE
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
    END INSERT_CONTACT;
/

BEGIN
insert_contact
(PV_FIRST_NAME => 'Maura'
,PV_MIDDLE_NAME => 'Jane'
, PV_LAST_NAME => 'Haggerty'
, PV_CONTACT_TYPE => 'CUSTOMER'
, PV_ACCOUNT_NUMBER =>'SLC-000009'
, PV_MEMBER_TYPE =>'INDIVIDUAL'
, PV_CREDIT_CARD_NUMBER =>'8888-7777-6666-5555'
, PV_CREDIT_CARD_TYPE =>'MASTER_CARD'
, PV_CITY =>'Bangor'
, PV_STATE_PROVINCE =>'Maine'
, PV_POSTAL_CODE =>'04401'
, PV_ADDRESS_TYPE =>'HOME'
, PV_COUNTRY_CODE =>'001'
, PV_AREA_CODE =>'207'
, PV_TELEPHONE_NUMBER =>'111-1234'
, PV_TELEPHONE_TYPE =>'HOME'
, PV_USER_NAME =>'DBA 2');
END;
/

-- step 2 test
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';

-- step 3 insert
DROP PROCEDURE INSERT_CONTACT;
create or replace FUNCTION INSERT_CONTACT
(PV_FIRST_NAME           varchar2
,PV_MIDDLE_NAME          varchar2 := ''
,PV_LAST_NAME            varchar2
,PV_CONTACT_TYPE         varchar2
,PV_ACCOUNT_NUMBER       varchar2
,PV_MEMBER_TYPE          varchar2
,PV_CREDIT_CARD_NUMBER   varchar2
,PV_CREDIT_CARD_TYPE     varchar2
,PV_CITY                 varchar2
,PV_STATE_PROVINCE       varchar2
,PV_POSTAL_CODE          varchar2
,PV_ADDRESS_TYPE         varchar2
,PV_COUNTRY_CODE         varchar2
,PV_AREA_CODE            varchar2
,PV_TELEPHONE_NUMBER     varchar2
,PV_TELEPHONE_TYPE       varchar2
,PV_USER_NAME            varchar2) RETURN NUMBER is
LV_ADDRESS_TYPE         varchar2(30);
LV_CONTACT_TYPE         varchar2(30);
LV_CREDIT_CARD_TYPE     varchar2(30);
LV_MEMBER_TYPE          varchar2(30);
LV_TELEPHONE_TYPE       varchar2(30);
LV_MEMBER_ID            number;
LV_SYSTEM_USER_ID       number;

CURSOR get_type(cv_table_name  VARCHAR2
               ,cv_column_name VARCHAR2
               ,cv_lookup_type VARCHAR2) IS
               SELECT common_lookup_id
               FROM common_lookup
               WHERE common_lookup_table  = cv_table_name
               AND   common_lookup_column = cv_column_name
               AND   common_lookup_type   = cv_lookup_type;
        BEGIN
        FOR i IN get_type('MEMBER', 'MEMBER_TYPE', PV_MEMBER_TYPE) LOOP
    lv_member_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('CONTACT', 'CONTACT_TYPE', PV_CONTACT_TYPE) LOOP
    lv_contact_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('ADDRESS', 'ADDRESS_TYPE', PV_ADDRESS_TYPE) LOOP
    lv_address_type := i.common_lookup_id;
    end loop;

    FOR i IN get_type('TELEPHONE', 'TELEPHONE_TYPE', PV_TELEPHONE_TYPE) LOOP
    lv_telephone_type := i.common_lookup_id;
    END LOOP;

    FOR i IN get_type('MEMBER', 'CREDIT_CARD_TYPE', PV_CREDIT_CARD_TYPE) LOOP
    lv_credit_card_type := i.common_lookup_id;
    END LOOP;

select system_user_id
into LV_SYSTEM_USER_ID
from system_user
where system_user_name = pv_user_name;

SAVEPOINT starting_point;

    INSERT INTO member
    VALUES
    ( member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_system_user_id
    , SYSDATE
    , lv_system_user_id
    , SYSDATE );
    lv_member_id := member_s1.CURRVAL;

 
  INSERT INTO contact
    VALUES
  (contact_s1.NEXTVAL
  , lv_member_id
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE);

INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE );


  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_system_user_id                                     -- CREATED_BY
  , SYSDATE                                  -- CREATION_DATE
  , lv_system_user_id                                -- LAST_UPDATED_BY
  , SYSDATE);                             -- LAST_UPDATE_DATE
  return 0;

  COMMIT;

EXCEPTION

  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN 1;
END INSERT_CONTACT;
/

BEGIN
IF insert_contact
(PV_FIRST_NAME => 'Harriet'
,PV_MIDDLE_NAME => 'Mary'
, PV_LAST_NAME => 'McDonnell'
, PV_CONTACT_TYPE => 'CUSTOMER'
, PV_ACCOUNT_NUMBER =>'SLC-000010'
, PV_MEMBER_TYPE =>'INDIVIDUAL'
, PV_CREDIT_CARD_NUMBER =>'9999-8888-7777-6666'
, PV_CREDIT_CARD_TYPE =>'VISA_CARD'
, PV_CITY =>'Orono'
, PV_STATE_PROVINCE =>'Maine'
, PV_POSTAL_CODE =>'04469'
, PV_ADDRESS_TYPE =>'HOME'
, PV_COUNTRY_CODE =>'001'
, PV_AREA_CODE =>'207'
, PV_TELEPHONE_NUMBER =>'111-1234'
, PV_TELEPHONE_TYPE =>'HOME'
, PV_USER_NAME =>'DBA 2') = 0 THEN dbms_output.put_line('Hello');
ELSE dbms_output.put_line('failure');
END IF;
END;
/

-- step 3 test
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';

-- Step 4 create object
CREATE or REPLACE type contact_obj is OBJECT
(first_name varchar2(20)
,middle_name varchar2(20)
,last_name   varchar2(20));
/

create or replace type contact_tab is table of contact_obj;
/

create or replace FUNCTION get_contact return contact_tab is
lv_contact_tab contact_tab := contact_tab();
  cursor contacts is
  select * from contact;
begin
for i in contacts loop
    lv_contact_tab.EXTEND;
    lv_contact_tab(lv_contact_tab.last) := contact_obj(i.first_name, i.middle_name, i.last_name);
    end loop;
    RETURN lv_contact_tab;
    end get_contact;
/

SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);

 

-- Close log file.

SPOOL OFF

show errors