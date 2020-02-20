/*
||  Name:          Ryan Harris
                apply_plsql_lab7.sql
*/

SET SERVEROUTPUT ON SIZE UNLIMITED
 
/* Run the library files. */
@@/home/student/Data/cit325/lib/cleanup_oracle.sql
@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
-- Open your log file and make sure the extension is ".log".
SPOOL apply_plsql_lab7.log

-- Enter your solution here.
-- 0) Step 0 validating it’s state with this query:
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

--UPDATE statement should be inserted to ensure your iterative 
--test cases all start at the same point, or common data state
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

 --A small anonymous block PL/SQL program lets you fix this mistake:
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;
 
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

 --It should update four rows, and you can verify the update with the following query:
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

 --You need this at the beginning to create the initial procedure during iterative testing.
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

/*
- 1) create an insert_contact definer rights procedure and test case in the first step.*/
CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2) IS
  -- Local variables, to leverage subquery assignments in INSERT statements.
  
  /* Include all common_lookup_type values. The contact_type, member_type, credit_card_type, 
  address_type, and telephone_type columns store foreign key values found as primary key values 
  in the common_lookup_id column of the common_lookup table. */
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  lv_member_id NUMBER;
  lv_system_user_id NUMBER;

  CURSOR c_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;


  --You should write a dynamic SQL cursor that 
--takes three parameters to return the common_lookup_id values into the program scope:
-- cv_table_name
-- cv_column_name
-- cv_lookup_type


-- CURSOR c      
-- ( cv_low_id NUMBER   
--     , cv_high_id NUMBER) IS   
--       SELECT   common_lookup_id AS id   
--       ,        item_title AS title   
--       FROM     common_lookup_table  
--       WHERE    common_lookup_id BETWEEN cv_low_id AND cv_high_id;  
--     item_record c%ROWTYPE;  
--   BEGIN  
--     OPEN c (lv_lowend, lv_highend);  
--     LOOP  
--       FETCH c INTO item_record;  
--       EXIT WHEN c%NOTFOUND;  
--       dbms_output.put_line('Title ['||item_record.title||']');  
--     END LOOP;  
--   END;  
-- /

BEGIN

  -- Assign parameter values to local variables for nested assignments to DML subqueries.

  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;
  lv_system_user_id := 0;
  lv_member_id := 0;


  -- Create a SAVEPOINT as a starting point.

  SAVEPOINT starting_point;

  -- Find User
  FOR i IN c_user LOOP
      lv_system_user_id := i.system_user_id;
  END LOOP;

  -- Quit if no user found
  IF lv_system_user_id = 0 THEN
    dbms_output.put_line('No User Found');
    RETURN;
  END IF;

  -- Find member
  FOR i IN c_member LOOP
      lv_member_id := i.member_id;
  END LOOP;

  -- Add new member if no member found
  IF lv_member_id = 0 THEN

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
    ,( SELECT   common_lookup_id
       FROM     common_lookup
       WHERE    common_lookup_table = 'MEMBER'
       AND      common_lookup_column = 'MEMBER_TYPE'
       AND      common_lookup_type = lv_member_type)
    , pv_account_number
    , pv_credit_card_number
    ,( SELECT   common_lookup_id
       FROM     common_lookup
       WHERE    common_lookup_table = 'MEMBER'
       AND      common_lookup_column = 'CREDIT_CARD_TYPE'
       AND      common_lookup_type = lv_credit_card_type)
    , lv_system_user_id
    , SYSDATE
    , lv_system_user_id
    , SYSDATE );
    lv_member_id := member_s1.CURRVAL;



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
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE );  



  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
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
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_system_user_id                                     -- CREATED_BY
  , SYSDATE                                  -- CREATION_DATE
  , lv_system_user_id                                -- LAST_UPDATED_BY
  , SYSDATE);                             -- LAST_UPDATE_DATE
  END IF;

  COMMIT;

EXCEPTION 

  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;

END insert_contact;
/
DESC insert_contact

BEGIN
insert_contact
( 'Charles'
, 'Francis'
, 'Xavier'
, 'CUSTOMER'
, 'SLC-000008'
, 'INDIVIDUAL'
, '7777-6666-5555-4444'
, 'DISCOVER_CARD'
, 'Milbridge'
, 'Maine'
, '04658'
, 'HOME'
, '001'
, '207'
, '111-1234'
, 'HOME'
, 'DBA 2');
END;
/

-------------verify step 1 -------------
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


---------------- step 2
--2) Modify the insert_contact definer rights procedure into an autonomous insert_contact invoker rights procedure. 

-- use a SELECT-INTO statement to access the system_user_id column of the system_user table. The WHERE clause uses pv_user_name value to find the correct row in the system_user table, and it should select only one row because the system_user_name values should be unique values. 
-- the values should be SYSADMIN, DBA 1, DBA 2, DBA 3, or DBA 4)

BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

/*
- 1) create an insert_contact definer rights procedure and test case in the first step.*/
CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2) IS
  -- Local variables, to leverage subquery assignments in INSERT statements.
  
  /* Include all common_lookup_type values. The contact_type, member_type, credit_card_type, 
  address_type, and telephone_type columns store foreign key values found as primary key values 
  in the common_lookup_id column of the common_lookup table. */
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  lv_member_id NUMBER;
  lv_system_user_id NUMBER;

  CURSOR c_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;


  --You should write a dynamic SQL cursor that 
--takes three parameters to return the common_lookup_id values into the program scope:
-- cv_table_name
-- cv_column_name
-- cv_lookup_type


-- CURSOR c      
-- ( cv_low_id NUMBER   
--     , cv_high_id NUMBER) IS   
--       SELECT   common_lookup_id AS id   
--       ,        item_title AS title   
--       FROM     common_lookup_table  
--       WHERE    common_lookup_id BETWEEN cv_low_id AND cv_high_id;  
--     item_record c%ROWTYPE;  
--   BEGIN  
--     OPEN c (lv_lowend, lv_highend);  
--     LOOP  
--       FETCH c INTO item_record;  
--       EXIT WHEN c%NOTFOUND;  
--       dbms_output.put_line('Title ['||item_record.title||']');  
--     END LOOP;  
--   END;  
-- /
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN

  -- Assign parameter values to local variables for nested assignments to DML subqueries.

  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;
  lv_system_user_id := 0;
  lv_member_id := 0;


  -- Create a SAVEPOINT as a starting point.

  SAVEPOINT starting_point;

  -- Find User
  FOR i IN c_user LOOP
      lv_system_user_id := i.system_user_id;
  END LOOP;

  -- Quit if no user found
  IF lv_system_user_id = 0 THEN
    dbms_output.put_line('No User Found');
    RETURN;
  END IF;

  -- Find member
  FOR i IN c_member LOOP
      lv_member_id := i.member_id;
  END LOOP;

  -- Add new member if no member found
  IF lv_member_id = 0 THEN

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
    ,( SELECT   common_lookup_id
       FROM     common_lookup
       WHERE    common_lookup_table = 'MEMBER'
       AND      common_lookup_column = 'MEMBER_TYPE'
       AND      common_lookup_type = lv_member_type)
    , pv_account_number
    , pv_credit_card_number
    ,( SELECT   common_lookup_id
       FROM     common_lookup
       WHERE    common_lookup_table = 'MEMBER'
       AND      common_lookup_column = 'CREDIT_CARD_TYPE'
       AND      common_lookup_type = lv_credit_card_type)
    , lv_system_user_id
    , SYSDATE
    , lv_system_user_id
    , SYSDATE );
    lv_member_id := member_s1.CURRVAL;




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
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_id
  , SYSDATE
  , lv_system_user_id
  , SYSDATE );  



  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
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
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_system_user_id                                     -- CREATED_BY
  , SYSDATE                                  -- CREATION_DATE
  , lv_system_user_id                                -- LAST_UPDATED_BY
  , SYSDATE);                             -- LAST_UPDATE_DATE

  COMMIT;
  END IF;

EXCEPTION 

  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;

END insert_contact;
/

DESC insert_contact


BEGIN
insert_contact
( 'Maura'
, 'Jane'
, 'Haggerty'
, 'CUSTOMER'
, 'SLC-000009'
, 'INDIVIDUAL'
, '8888-7777-6666-5555'
, 'MASTER_CARD'
, 'Bangor'
, 'Maine'
, '04401'
, 'HOME'
, '001'
, '207'
, '111-1234'
, 'HOME'
, 'DBA 2');
END;
/
-- verify step 2 -- 
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

-- 3)  create an autonomous definer rights insert_contact function by 
--modifying the insert_contact procedure. 
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

CREATE OR REPLACE FUNCTION insert_contact
	( pv_first_name         VARCHAR2
	, pv_middle_name        VARCHAR2
	, pv_last_name          VARCHAR2
	, pv_contact_type       VARCHAR2
	, pv_account_number     VARCHAR2
	, pv_member_type        VARCHAR2
	, pv_credit_card_number VARCHAR2
	, pv_credit_card_type   VARCHAR2
	, pv_city               VARCHAR2
	, pv_state_province     VARCHAR2
	, pv_postal_code        VARCHAR2
	, pv_address_type       VARCHAR2
	, pv_country_code       VARCHAR2
	, pv_area_code          VARCHAR2
	, pv_telephone_number   VARCHAR2
	, pv_telephone_type     VARCHAR2
	, pv_user_name          VARCHAR2) 
	RETURN NUMBER --Return type for function
	AUTHID CURRENT_USER IS --Sets to invoker rights
	

	PRAGMA AUTONOMOUS_TRANSACTION; --Sets autonomous behavior
	

	-- -------------------------------------------------
	-- Declaration section for procedure
	-- -------------------------------------------------

	-- Local variable for the timestamp
	lv_date DATE := SYSDATE;
	--dbms_output.put_line('The SYSDATE is: ' || lv_date);
	

	-- Local variable for system user id
	lv_system_user NUMBER;
	

	-- Local variables for _TYPES
	lv_member_type       INT(10);
	lv_contact_type      INT(10);
	lv_address_type      INT(10);
	lv_telephone_type    INT(10);
	lv_credit_card_type  INT(10);
	

	

	-- Dynamic cursor to call to retrieve the common_lookup_id
	-- where common_lookup_type = 'INDIVIDUAL' and common_lookup_table = 'MEMBER' and common_lookup_column = 
	-- 'MEMBER_TYPE'
	CURSOR c ( cv_table_name        VARCHAR2
	         , cv_column_name       VARCHAR2
	         , cv_lookup_type       VARCHAR2 ) IS
	         SELECT common_lookup_id AS id
	         FROM common_lookup
	         WHERE common_lookup_table = cv_table_name AND
	               common_lookup_column = cv_column_name AND
	               common_lookup_type = cv_lookup_type;
	

	BEGIN
	-- Select into to retrieve the correct system user id
	  SELECT system_user_id
	    INTO lv_system_user
	    FROM system_user
	    WHERE system_user_name = pv_user_name;
	--dbms_output.put_line('System User is: ' || lv_system_user);
	

	-- For Loops:
	/*  FOR i IN 1..lv_cursor_data.COUNT LOOP
	    FOR x IN c(lv_cursor_data(i).table_name
	              , lv_cursor_data(i).column_name
	              , lv_cursor_data(i).lookup_type) LOOP
	      lv_common_lookup_id.EXTEND;
	      lv_common_lookup_id(lv_common_lookup_id.COUNT) := x;
	    END LOOP;
	  END LOOP;
	*/
	

	--member_type
	FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
	  lv_member_type := i.id;
	END LOOP;
	

	--contact_type
	FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
	  lv_contact_type := i.id;
	END LOOP;
	

	--address_type
	FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
	  lv_address_type := i.id;
	END LOOP;
	

	--telephone_type
	FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
	  lv_telephone_type := i.id;
	END LOOP;
	

	--credit_card_type
	FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
	  lv_credit_card_type := i.id;
	END LOOP;
	

	SAVEPOINT all_or_none;
	

	-- Insert Statements: Start with least dependent
	-- Insert into member
	INSERT INTO member
	VALUES
	( member_s1.NEXTVAL
	, lv_member_type
	, pv_account_number
	, pv_credit_card_number
	, lv_credit_card_type
	, lv_system_user
	, lv_date
	, lv_system_user
	, lv_date);
	

	-- Insert into contact
	INSERT INTO contact
	VALUES
	( contact_s1.NEXTVAL
	, member_s1.CURRVAL
	, lv_contact_type
	, pv_last_name
	, pv_first_name
	, pv_middle_name
	, lv_system_user
	, lv_date
	, lv_system_user
	, lv_date);
	

	-- Insert into address
	INSERT INTO address
	VALUES
	( address_s1.NEXTVAL
	, contact_s1.CURRVAL
	, lv_address_type
	, pv_city
	, pv_state_province
	, pv_postal_code
	, lv_system_user
	, lv_date
	, lv_system_user
	, lv_date);
	

	-- Insert into telephone
	INSERT INTO telephone
	VALUES
	( telephone_s1.NEXTVAL
	, contact_s1.CURRVAL
	, address_s1.CURRVAL
	, lv_telephone_type
	, pv_country_code
	, pv_area_code
	, pv_telephone_number
	, lv_system_user
	, lv_date
	, lv_system_user
	, lv_date);
	

	COMMIT;
	

	RETURN 0;
	

	EXCEPTION
	  WHEN OTHERS THEN
	   RETURN 1;
	   dbms_output.put_line('***THERE WAS AN ERROR.  ROLLING BACK.***');
	    ROLLBACK TO all_or_none;
	END insert_contact;
	/

DECLARE 
answer NUMBER := 0;
BEGIN
answer := insert_contact
( 'Harriet'
, 'Mary'
, 'McDonnell'
, 'CUSTOMER'
, 'SLC-000010'
, 'INDIVIDUAL'
, '9999-8888-7777-6666'
, 'VISA_CARD'
, 'Orono'
, 'Maine'
, '04469'
, 'HOME'
, '001'
, '207'
, '111-1234'
, 'HOME'
, 'DBA 2');
END;
/
-- test  step 3 --


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

-- 4) Three key steps in accomplishing an object table function. 

    -- identify whether or not it should be parameterized, and when parameterized that you have the correct parameters????
    
    --your object table function isn’t parameterized, and should return a complete list of persons from the contact table. It should return the names in a first, middle, and last name format with a single white space between each element of the contact’s full name.--
   
                --SQL OBJECT TYPE
    --have three elements. They are the first_name, middle_name, and last_name elements, ize and data types should mirror the equivalent column names in the contact table.
/
          --COLLECTION TYPE
    -- type should a list of the contact_obj SQL object types
  
    -- declare a counter variable, a collection variable (of the contact_tab list), and a non-parameterized cursor against the contact table.
 
 --Second, you need to write the appropriate cursor inside the object table function.
        --The execution block should use a for-loop to read the values from the cursor and translate them into elements of the list before returning the populated list from the function.

 --Third, you need to create a SQL object type and collection type that your object table function returns.

CREATE OR REPLACE TYPE contact_obj IS OBJECT
  ( first_name   VARCHAR2(20)
  , middle_name  VARCHAR2(20)
  , last_name    VARCHAR2(20));
/

  CREATE OR REPLACE TYPE contact_table IS TABLE OF contact_obj;
/

CREATE OR REPLACE FUNCTION get_contact RETURN CONTACT_TABLE IS
  lv_contact_table CONTACT_TABLE := contact_table();
  CURSOR contacts IS
    SELECT * FROM contact;

BEGIN

  FOR i IN contacts LOOP
      lv_contact_table.EXTEND;
      lv_contact_table(lv_contact_table.LAST) := contact_obj(i.first_name, i.middle_name, i.last_name);
  END LOOP;

  RETURN lv_contact_table;
END get_contact;
/
--verify STEP 4 
SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);


-- Close your log file.
SPOOL OFF
--QUIT;

/*
DROP TABLE message;
CREATE TABLE message
(msg_id  NUMBER
, msg_text  VARCHAR2(10));

DROP SEQUENCE message_s;
CREATE SEQUENCE message_s START WITH 1001;

CREATE or REPLACE
    PROCEDURE auditing 
    (pv_message VARCHAR2 ) IS
    delcare as an anonymous unit
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO message
    (msg_id, msg_text )
    VALUES
    ( message_s.NEXTVAL, pv_message );
    COMMIT;
END;
/*/
