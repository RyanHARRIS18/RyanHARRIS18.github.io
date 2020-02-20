/* Set environment variables. */
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED
 
/* Run the library files. */
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
@/home/student/Data/cit325/lab8/apply_plsql_lab8.sql


-- Open your log file and make sure the extension is ".log".
SPOOL apply_plsql_lab8.txt

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 6
, 'BONDSB'
, 1
, 1001
, 'Barry'
, 'L'
, 'Bonds'
, 1
, TRUNC(SYSDATE)
, 1
, TRUNC(SYSDATE));

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 7
, 'OWENSR'
, 1
, 1001
, 'Wardell'
, 'S'
, 'Curry'
, 1
, TRUNC(SYSDATE)
, 1
, TRUNC(SYSDATE));

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( -1
, 'ANONYMOUS'
, 1
, 1001
, ''
, ''
, ''
, 1
, TRUNC(SYSDATE)
, 1
, TRUNC(SYSDATE));

CREATE OR REPLACE PACKAGE contact_package IS

  /* Insert contact with user name */
  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_name           VARCHAR2         -- User_Name
  );

  /* Insert contact with user ID */
  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_id             NUMBER := -1     -- User_Name
  );

END contact_package;
/

---------------CHANGE BODY OF CONTACT PACKAGE----------------------------------
CREATE OR REPLACE PACKAGE BODY contact_package IS
 
---------------INSERT CONTACT WITH USER NAME-----------------------------------
  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_name           VARCHAR2         -- User_Name
  ) IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    /* Declare Local Variables */
    lv_address_type        NUMBER;
    lv_contact_type        NUMBER;
    lv_credit_card_type    NUMBER;
    lv_member_type         NUMBER;
    lv_telephone_type      NUMBER;

    lv_system_user_id      NUMBER;
    lv_member_id           NUMBER;
    lv_time                DATE := TRUNC(SYSDATE);

    /* Cursor to get common_lookup_id */
    CURSOR c
    ( cv_table_name  VARCHAR2
    , cv_column_name VARCHAR2
    , cv_lookup_type VARCHAR2) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_lookup_type;

    /* Cursor to get member_id if it is a group membership */
    CURSOR get_member
    ( cv_account_number VARCHAR2) IS
      SELECT member_id
      FROM   member
      WHERE  account_number = cv_account_number;

    BEGIN
      SAVEPOINT all_or_nothing;

      dbms_output.put_line('Inserting with user name....');

         --Get Lookup Ids for Member Table
      FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := i.common_lookup_id;
      END LOOP;

      FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup Id For Address Table
      FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup ID for Contact Table
      FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup DI for telephone table
      FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
      END LOOP;

    -- Local Variable for Username
      SELECT system_user_id
      INTO   lv_system_user_id
      FROM   system_user
      WHERE  system_user_name = pv_user_name;

      --Get Member ID
      FOR i in get_member(pv_account_number) LOOP
        lv_member_id := i.member_id;
      END LOOP;

      dbms_output.put_line('Member ID ['||lv_member_id||']');

      /* If there is no group id, create a new one */
      IF lv_member_id IS NULL THEN
        dbms_output.put_line('The member ID was not found!');
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

        /* set current sequence number to the local variable for next inserts */
        lv_member_id := member_s1.CURRVAL;
        dbms_output.put_line('Member Insert Done!');
      END IF;

      /* Insert into contact table next */
      INSERT INTO contact
      ( contact_id
      , member_id
      , contact_type
      , last_name
      , first_name
      , middle_name
      , created_by
      , creation_date
      , last_updated_by
      , last_update_date)
      VALUES
      ( contact_s1.NEXTVAL
      , lv_member_id
      , lv_contact_type
      , pv_last_name
      , pv_first_name
      , pv_middle_name
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Contact Insert Done!');

      /* Insert into address table */
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
      ( address_s1.NEXTVAL
      , contact_s1.CURRVAL
      , lv_address_type
      , pv_city
      , pv_state_province
      , pv_postal_code
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Address Insert Done!');

      /* Finally insert into telephone */
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
      ( telephone_s1.NEXTVAL
      , contact_s1.CURRVAL
      , address_s1.CURRVAL
      , lv_telephone_type
      , pv_country_code
      , pv_area_code
      , pv_telephone_number
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Telephone Insert Done!');

      COMMIT;
      dbms_output.put_line('Commit Done!');

      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);
          ROLLBACK to all_or_nothing;

   END insert_contact;

 


-----------FIRST INSERT------------------------------------------------



BEGIN
  contact_package.insert_contact(
      pv_first_name => 'Charlie'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3');
END;
/

BEGIN
  contact_package.insert_contact(
      pv_first_name => 'Peppermint'
    , pv_middle_name => NULL
    , pv_last_name => 'Patty'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME');

END;
/

BEGIN
  contact_package.insert_contact(
      pv_first_name => 'Sally'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => 6);
END;
/


/* First Insert Verification */
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
WHERE  c.last_name IN ('Brown','Patty');


---------------CREATE CONTACT PACKAGE------------------------------------------
CREATE OR REPLACE PACKAGE contact_package IS

  /* Insert contact with user name */
  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_name           VARCHAR2         -- User_Name
  ) RETURN NUMBER;

  /* Insert contact with user ID */
  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_id             NUMBER := -1     -- User_Name
  ) RETURN NUMBER;

END contact_package;
/


---------------CHANGE BODY OF CONTACT PACKAGE----------------------------------


CREATE OR REPLACE PACKAGE BODY contact_package IS

 
---------------INSERT CONTACT WITH USER NAME-----------------------------------
 

  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_name           VARCHAR2         -- User_Name
  ) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;

    /* Declare Local Variables */
    lv_address_type        NUMBER;
    lv_contact_type        NUMBER;
    lv_credit_card_type    NUMBER;
    lv_member_type         NUMBER;
    lv_telephone_type      NUMBER;

    lv_system_user_id      NUMBER;
    lv_member_id           NUMBER;
    lv_time                DATE := TRUNC(SYSDATE);

    /* Cursor to get common_lookup_id */
    CURSOR c
    ( cv_table_name  VARCHAR2
    , cv_column_name VARCHAR2
    , cv_lookup_type VARCHAR2) IS
      SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = cv_table_name
      AND    common_lookup_column = cv_column_name
      AND    common_lookup_type = cv_lookup_type;

    /* Cursor to get member_id if it is a group membership */
    CURSOR get_member
    ( cv_account_number VARCHAR2) IS
      SELECT member_id
      FROM   member
      WHERE  account_number = cv_account_number;

    BEGIN
      dbms_output.put_line('Inserting with user name....');

         --Get Lookup Ids for Member Table
      FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := i.common_lookup_id;
      END LOOP;

      FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup Id For Address Table
      FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup ID for Contact Table
      FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup DI for telephone table
      FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
      END LOOP;

    -- Local Variable for Username
      SELECT system_user_id
      INTO   lv_system_user_id
      FROM   system_user
      WHERE  system_user_name = pv_user_name;

      --Get Member ID
      FOR i in get_member(pv_account_number) LOOP
        lv_member_id := i.member_id;
      END LOOP;

      dbms_output.put_line('Member ID ['||lv_member_id||']');

      /* If there is no group id, create a new one */
      IF lv_member_id IS NULL THEN
        dbms_output.put_line('The member ID was not found!');
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

        /* set current sequence number to the local variable for next inserts */
        lv_member_id := member_s1.CURRVAL;
        dbms_output.put_line('Member Insert Done!');
      END IF;

      /* Insert into contact table next */
      INSERT INTO contact
      ( contact_id
      , member_id
      , contact_type
      , last_name
      , first_name
      , middle_name
      , created_by
      , creation_date
      , last_updated_by
      , last_update_date)
      VALUES
      ( contact_s1.NEXTVAL
      , lv_member_id
      , lv_contact_type
      , pv_last_name
      , pv_first_name
      , pv_middle_name
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Contact Insert Done!');

      /* Insert into address table */
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
      ( address_s1.NEXTVAL
      , contact_s1.CURRVAL
      , lv_address_type
      , pv_city
      , pv_state_province
      , pv_postal_code
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Address Insert Done!');

      /* Finally insert into telephone */
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
      ( telephone_s1.NEXTVAL
      , contact_s1.CURRVAL
      , address_s1.CURRVAL
      , lv_telephone_type
      , pv_country_code
      , pv_area_code
      , pv_telephone_number
      , lv_system_user_id
      , lv_time
      , lv_system_user_id
      , lv_time );

      dbms_output.put_line('Telephone Insert Done!');

      COMMIT;
      dbms_output.put_line('Commit Done!');

      /* If it is successful return 0; */
      RETURN 0;

      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);

          /* If unsuccessful, return 1 */
          RETURN 1;
   END insert_contact;

 
---------------INSERT CONTACT WITH USER ID-------------------------------------
 
  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2         -- First_Name
  , pv_middle_name         VARCHAR2         -- Middle_Name
  , pv_last_name           VARCHAR2         -- Last_Name
  , pv_contact_type        VARCHAR2         -- Contact_Type
  , pv_account_number      VARCHAR2         -- Account_Number
  , pv_member_type         VARCHAR2         -- Member_Type
  , pv_credit_card_number  VARCHAR2         -- Credit_Card_Number
  , pv_credit_card_type    VARCHAR2         -- Credit_Card_Type
  , pv_city                VARCHAR2         -- City
  , pv_state_province      VARCHAR2         -- State_Province
  , pv_postal_code         VARCHAR2         -- Postal_Code
  , pv_address_type        VARCHAR2         -- Address_type
  , pv_country_code        VARCHAR2         -- Country_Code
  , pv_area_code           VARCHAR2         -- Area_Code
  , pv_telephone_number    VARCHAR2         -- Telephone_Number
  , pv_telephone_type      VARCHAR2         -- Telephone_Type
  , pv_user_id             NUMBER           -- User_Name
  ) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;

  /* Declare Local Variables */
  lv_address_type        NUMBER;
  lv_contact_type        NUMBER;
  lv_credit_card_type    NUMBER;
  lv_member_type         NUMBER;
  lv_telephone_type      NUMBER;
  lv_member_id           NUMBER;
  lv_time                DATE := TRUNC(SYSDATE);

  /* Cursor to get common_lookup_id */
  CURSOR c
  ( cv_table_name  VARCHAR2
  , cv_column_name VARCHAR2
  , cv_lookup_type VARCHAR2) IS
  SELECT common_lookup_id
  FROM   common_lookup
  WHERE  common_lookup_table = cv_table_name
  AND    common_lookup_column = cv_column_name
  AND    common_lookup_type = cv_lookup_type;

  /* Cursor to get member_id if it is a group membership */
  CURSOR get_member
  ( cv_account_number VARCHAR2) IS
  SELECT member_id
  FROM   member
  WHERE  account_number = cv_account_number;

  BEGIN
    dbms_output.put_line('Inserting with user ID....');

       --Get Lookup Ids for Member Table
      FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
        lv_member_type := i.common_lookup_id;
      END LOOP;

      FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup Id For Address Table
      FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup ID for Contact Table
      FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
      END LOOP;

      --Get Lookup DI for telephone table
      FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
      END LOOP;

      --Get Member ID
      FOR i in get_member(pv_account_number) LOOP
        lv_member_id := i.member_id;
      END LOOP;

    dbms_output.put_line('Member ID ['||lv_member_id||']');

     /* If there is no group id, create a new one */
      IF lv_member_id IS NULL THEN
        dbms_output.put_line('The member ID was not found!');
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , pv_user_id
        , lv_time
        , pv_user_id
        , lv_time );

        /* set current sequence number to the local variable for next inserts */
        lv_member_id := member_s1.CURRVAL;
        dbms_output.put_line('Member Insert Done!');
      END IF;

    /* Insert into contact table next */
      INSERT INTO contact
      ( contact_id
      , member_id
      , contact_type
      , last_name
      , first_name
      , middle_name
      , created_by
      , creation_date
      , last_updated_by
      , last_update_date)
      VALUES
      ( contact_s1.NEXTVAL
      , lv_member_id
      , lv_contact_type
      , pv_last_name
      , pv_first_name
      , pv_middle_name
      , pv_user_id
      , lv_time
      , pv_user_id
      , lv_time );

      dbms_output.put_line('Contact Insert Done!');

      /* Insert into address table */
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
      ( address_s1.NEXTVAL
      , contact_s1.CURRVAL
      , lv_address_type
      , pv_city
      , pv_state_province
      , pv_postal_code
      , pv_user_id
      , lv_time
      , pv_user_id
      , lv_time );

      dbms_output.put_line('Address Insert Done!');

       /* Finally insert into telephone */
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
      ( telephone_s1.NEXTVAL
      , contact_s1.CURRVAL
      , address_s1.CURRVAL
      , lv_telephone_type
      , pv_country_code
      , pv_area_code
      , pv_telephone_number
      , pv_user_id
      , lv_time
      , pv_user_id
      , lv_time );

      dbms_output.put_line('Telephone Insert Done!');

      COMMIT;
      dbms_output.put_line('Commit Done!');

      /* If it is successful return 0; */
      RETURN 0;

      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(SQLERRM);

          /* If unsuccessful, return 1 */
          RETURN 1;
  END insert_contact;

END contact_package;
/

SHOW ERRORS;


-----------FIRST INSERT------------------------------------------------

BEGIN
  IF(
  contact_package.insert_contact(
        pv_first_name => 'Charlie'
      , pv_middle_name => NULL
      , pv_last_name => 'Brown'
      , pv_contact_type => 'CUSTOMER'
      , pv_account_number => 'SLC-000011'
      , pv_member_type => 'GROUP'
      , pv_credit_card_number => '8888-6666-8888-4444'
      , pv_credit_card_type => 'VISA_CARD'
      , pv_city => 'Lehi'
      , pv_state_province => 'Utah'
      , pv_postal_code => '84043'
      , pv_address_type => 'HOME'
      , pv_country_code => '001'
      , pv_area_code => '207'
      , pv_telephone_number => '877-4321'
      , pv_telephone_type => 'HOME'
      , pv_user_name => 'DBA 3')) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
END IF;
END;
/

BEGIN
  IF(
  contact_package.insert_contact(
      pv_first_name => 'Peppermint'
    , pv_middle_name => NULL
    , pv_last_name => 'Patty'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME')) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
  END IF;
END;
/
SHOW ERRORS;

BEGIN
  IF(
  contact_package.insert_contact(
      pv_first_name => 'Sally'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => 6)) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
END IF;
END;
/


-----------SECOND INSERT-----------------------------------------------



BEGIN
  IF(
  contact_package.insert_contact(
      pv_first_name => 'Shirley'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3')) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
END IF;
END;
/

BEGIN
  IF(
  contact_package.insert_contact(
      pv_first_name => 'Keith'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => 6)) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
END IF;
END;
/

BEGIN
  IF(
  contact_package.insert_contact(
      pv_first_name => 'Laurie'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME')) = 0 THEN
  dbms_output.put_line('Success!');
  ELSE
    dbms_output.put_line('Failure!');
END IF;
END;
/

/* Second Insert verification */
//* System User ID verification */
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

SPOOL OFF


