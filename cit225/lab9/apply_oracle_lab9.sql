-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab9.sql
--  Lab Assignment: Lab #9
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
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
--   sql> @apply_oracle_lab9.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql
 
-- Open log file.  
SPOOL apply_oracle_lab9.txt
 
-- --------------------------------------------------------
--  Step #1
--  -------
--  Create the TRANSACTION table per the web page spec.
/*
 Create the following transaction table as per the specification, 
 but do so understanding the business logic of the model. After
 creating the transaction table, create a unique index on the 
 columns that make up the natural key and call it the natural_key index.*/
-- --------------------------------------------------------
 
-- Insert step #1 statements here.
 
-- --------------------------------------------------------
CREATE TABLE TRANSACTION
( TRANSACTION_ID                   NUMBER   
, TRANSACTION_ACCOUT               VARCHAR2(15) CONSTRAINT nn_transaction_1 NOT NULL
, TRANSACTION_TYPE                 NUMBER CONSTRAINT nn_transaction_2 NOT NULL  
, TRANSACTION_DATE                 DATE CONSTRAINT nn_transaction_3  NOT NULL 
, TRANSACTION_AMOUNT               NUMBER CONSTRAINT nn_transaction_4  NOT NULL 
, RENTAL_ID                        NUMBER CONSTRAINT nn_transaction_5  NOT NULL 
, PAYMENT_METHOD_TYPE              NUMBER CONSTRAINT nn_transaction_6  NOT NULL
, PAYMENT_ACCOUNT_NUMBER           VARCHAR2(19) CONSTRAINT nn_transaction_7  NOT NULL
, CREATED_BY                       NUMBER  CONSTRAINT nn_transaction_8  NOT NULL    
, CREATION_DATE                    DATE CONSTRAINT nn_transaction_9  NOT NULL 
, LAST_UPDATED_BY                  NUMBER CONSTRAINT nn_transaction_10  NOT NULL 
, LAST_UPDATE_DATE                 DATE CONSTRAINT nn_transaction_11  NOT NULL 
, CONSTRAINT pk_transaction_1     PRIMARY KEY(TRANSACTION_ID)
, CONSTRAINT fk_transaction_1    FOREIGN KEY (TRANSACTION_TYPE) REFERENCES COMMON_LOOKUP(common_lookup_id)
, CONSTRAINT fk_transaction_2   FOREIGN KEY (RENTAL_ID) REFERENCES RENTAL(RENTAL_ID)
, CONSTRAINT fk_transaction_3  FOREIGN KEY (PAYMENT_METHOD_TYPE) REFERENCES COMMON_LOOKUP(common_lookup_id)
, CONSTRAINT fk_transaction_4  FOREIGN KEY (CREATED_BY) REFERENCES system_user(system_user_id) 
, CONSTRAINT fk_transaction_5  FOREIGN KEY (LAST_UPDATED_BY) REFERENCES system_user(system_user_id)); 

drop sequence transaction_s1;
CREATE SEQUENCE transaction_s1 START WITH 1001;

COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
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
WHERE    table_name = 'TRANSACTION'
ORDER BY 2;

/* IT should display 
Table Name     Column ID Column Name            Nullable Data Type
-------------- --------- ---------------------- -------- ------------
TRANSACTION            1 TRANSACTION_ID         NOT NULL NUMBER(22)
TRANSACTION            2 TRANSACTION_ACCOUNT    NOT NULL VARCHAR2(15)
TRANSACTION            3 TRANSACTION_TYPE       NOT NULL NUMBER(22)
TRANSACTION            4 TRANSACTION_DATE       NOT NULL DATE
TRANSACTION            5 TRANSACTION_AMOUNT     NOT NULL NUMBER(22)
TRANSACTION            6 RENTAL_ID              NOT NULL NUMBER(22)
TRANSACTION            7 PAYMENT_METHOD_TYPE    NOT NULL NUMBER(22)
TRANSACTION            8 PAYMENT_ACCOUNT_NUMBER NOT NULL VARCHAR2(19)
TRANSACTION            9 CREATED_BY             NOT NULL NUMBER(22)
TRANSACTION           10 CREATION_DATE          NOT NULL DATE
TRANSACTION           11 LAST_UPDATED_BY        NOT NULL NUMBER(22)
TRANSACTION           12 LAST_UPDATE_DATE       NOT NULL DATE
 
 12 rows selected.
 
 After you create the table, you need to add a UNIQUE INDEX on the following columns to the TRANSACTION table. This is necessary to improve the run-time performance of the merge operations later in this lab
RENTAL_ID
TRANSACTION_TYPE
TRANSACTION_DATE
PAYMENT_METHOD_TYPE
PAYMENT_ACCOUNT_NUMBER
TRANSACTION_ACCOUNT
.*/
 
CREATE UNIQUE INDEX NATURAL_KEY ON TRANSACTION(RENTAL_ID
, TRANSACTION_TYPE
, TRANSACTION_DATE
, PAYMENT_METHOD_TYPE
, PAYMENT_ACCOUNT_NUMBER
, TRANSACTION_ACCOUT);


COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'TRANSACTION'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NATURAL_KEY';

/* It should display
Table Name   Index Name       Unique   Column Position Column Name
------------ ---------------- -------- --------------- ------------------------
TRANSACTION  NATURAL_KEY      UNIQUE                 1 RENTAL_ID
TRANSACTION  NATURAL_KEY      UNIQUE                 2 TRANSACTION_TYPE
TRANSACTION  NATURAL_KEY      UNIQUE                 3 TRANSACTION_DATE
TRANSACTION  NATURAL_KEY      UNIQUE                 4 PAYMENT_METHOD_TYPE
TRANSACTION  NATURAL_KEY      UNIQUE                 5 PAYMENT_ACCOUNT_NUMBER
TRANSACTION  NATURAL_KEY      UNIQUE                 6 TRANSACTION_ACCOUNT
 
6 rows selected. */

 
--  Step #2
--  -------
--  Insert two rows for the TRANSACTION_TYPE column and
--  four rows for the PAYMENT_METHOD_TYPE column of the
--  TRANSACTION table into the COMMON_LOOKUP table.
-- --------------------------------------------------------
 
-- Insert step #2 statements here.
 
-- --------------------------------------------------------
/* using this table Insett 6 rows

Table Name: COMMON_LOOKUP
Lookup Table	Lookup Column	Lookup Type	Lookup Meaning	Lookup Code
TRANSACTION	TRANSACTION_TYPE	CREDIT	Credit	CR
TRANSACTION	TRANSACTION_TYPE	DEBIT	Debit	DR
TRANSACTION	PAYMENT_METHOD_TYPE	DISCOVER_CARD	Discover Card	
TRANSACTION	PAYMENT_METHOD_TYPE	VISA_CARD	Visa Card	
TRANSACTION	PAYMENT_METHOD_TYPE	MASTER_CARD	Master Card	
TRANSACTION	PAYMENT_METHOD_TYPE	CASH	Cash	
*/

INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'CREDIT'
 ,      'credit'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'TRANSACTION_TYPE'
 ,      'CR');

INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'DEBIT'
 ,      'Debit'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'TRANSACTION_TYPE'
 ,      'CR');

INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'DISCOVER_CARD'
 ,      'Discover Card'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'PAYMENT_METHOD_TYPE'
 ,      NULL);

 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'VISA_CARD'
 ,      'Visa Card'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'PAYMENT_METHOD_TYPE'
 ,      NULL);
 
  INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'MASTER_CARD'
 ,      'Master Card'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'PAYMENT_METHOD_TYPE'
 ,      NULL);
 
  INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'CASH'
 ,      'Cash'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE)
 ,      'TRANSACTION'
 ,      'PAYMENT_METHOD_TYPE'
 ,      NULL);
 
 COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'TRANSACTION'
AND      common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;

/* it should display
COMMON_LOOKUP_TABLE  COMMON_LOOKUP_COLUMN COMMON_LOOKUP_TYPE
-------------------- -------------------- --------------------
TRANSACTION          PAYMENT_METHOD_TYPE  VISA_CARD
TRANSACTION          PAYMENT_METHOD_TYPE  MASTER_CARD
TRANSACTION          PAYMENT_METHOD_TYPE  DISCOVER_CARD
TRANSACTION          PAYMENT_METHOD_TYPE  CASH
TRANSACTION          TRANSACTION_TYPE     DEBIT
TRANSACTION          TRANSACTION_TYPE     CREDIT
 
6 rows selected.
*/

--  Step #3
--  -------
--  Create the AIRPORT and ACCOUNT_LIST tables; and 
--  insert rows into both tables.
-- --------------------------------------------------------
 
-- Insert step #3 statements here.
 
-- --------------------------------------------------------

/* follow this table
Table Name: AIRPORT
Column Name	Constraint	Data
Type	Physical
Size
Type	Reference Table	Reference Column
AIRPORT_ID	PRIMARY KEY			Integer	Maximum
AIRPORT_CODE	NOT NULL			String	3
AIRPORT_CITY	NOT NULL			String	30
CITY	NOT NULL			String	30
STATE_PROVINCE	NOT NULL			String	30
CREATED_BY	FOREIGN KEY	SYSTEM_USER	SYSTEM_USER_ID	Integer	Maximum
NOT NULL
CREATION_DATE	NOT NULL			Date	Date
LAST_UPDATED_BY	FOREIGN KEY	SYSTEM_USER	SYSTEM_USER_ID	Integer	Maximum
NOT NULL
LAST_UPDATE_DATE	NOT NULL			Date	Date
*/
-- a--
CREATE TABLE AIRPORT
( AIRPORT_ID                   NUMBER   
, AIRPORT_CODE                 VARCHAR2(3) CONSTRAINT nn_airport_1 NOT NULL
, AIRPORT_CITY                 VARCHAR2(30)  CONSTRAINT nn_airport_2 NOT NULL  
, CITY                         VARCHAR2(30)  CONSTRAINT nn_airport_3  NOT NULL 
, STATE_PROVINCE               VARCHAR2(30)  CONSTRAINT nn_airport_4  NOT NULL
, CREATED_BY                       NUMBER  CONSTRAINT nn_airport_5  NOT NULL    
, CREATION_DATE                    DATE CONSTRAINT nn_airport_6  NOT NULL 
, LAST_UPDATED_BY                  NUMBER CONSTRAINT nn_airport_7  NOT NULL 
, LAST_UPDATE_DATE                 DATE CONSTRAINT nn_airport_8  NOT NULL 
, CONSTRAINT pk_airport_1     PRIMARY KEY(AIRPORT_ID)
, CONSTRAINT fk_airport_1    FOREIGN KEY (CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
, CONSTRAINT fk_airport_2   FOREIGN KEY (LAST_UPDATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)); 

drop sequence airport_s1;
CREATE SEQUENCE airport_s1 START WITH 1001;

COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
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
WHERE    table_name = 'AIRPORT'
ORDER BY 2;

/* It should display the following results:
9 rows selected. */

--b--

CREATE UNIQUE INDEX NK_AIRPORT ON AIRPORT(AIRPORT_CODE
, AIRPORT_CITY
, CITY
, STATE_PROVINCE);

COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'AIRPORT'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NK_AIRPORT';

/* It should display the following results:
4 rows selected.*/


--c--
  INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'LAX'
 ,      'Los Angeles'
 ,      'Los Angeles'
 ,      'California'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));
 
   INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'SLC'
 ,      'Salt Lake City'
 ,      'Provo'
 ,      'Utah'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));

  INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'SLC'
 ,      'Salt Lake City'
 ,      'Spanish Fork'
 ,      'Utah'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));

  INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'SFO'
 ,      'San Francisco'
 ,      'San Francisco'
 ,      'California'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));

 INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'SJC'
 ,      'San Jose'
 ,      'San Jose'
 ,      'California'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));

INSERT INTO AIRPORT
 VALUES
 (AIRPORT_s1.nextval
 ,      'SJC'
 ,      'San Jose'
 ,      'San Carlos'
 ,      'California'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,       TRUNC(SYSDATE));


COLUMN code           FORMAT A4  HEADING "Code"
COLUMN airport_city   FORMAT A14 HEADING "Airport City"
COLUMN city           FORMAT A14 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
SELECT   airport_code AS code
,        airport_city
,        city
,        state_province
FROM     airport;


--d--

CREATE TABLE ACCOUNT_LIST
( ACCOUNT_LIST_ID                  NUMBER   
, ACCOUNT_NUMBER                   VARCHAR2(10) CONSTRAINT nn_account_list_1 NOT NULL
, CONSUMED_DATE                    DATE  
, CONSUMED_BY                      NUMBER 
, CREATED_BY                       NUMBER  CONSTRAINT nn_account_list_4  NOT NULL    
, CREATION_DATE                    DATE CONSTRAINT nn_account_list_5  NOT NULL 
, LAST_UPDATED_BY                  NUMBER CONSTRAINT nn_account_list_6  NOT NULL 
, LAST_UPDATE_DATE                 DATE CONSTRAINT nn_account_list_7  NOT NULL 
, CONSTRAINT pk_account_list_1     PRIMARY KEY(ACCOUNT_LIST_ID)
, CONSTRAINT fk_account_list_1    FOREIGN KEY (CONSUMED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
, CONSTRAINT fk_account_list_2    FOREIGN KEY (CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)
, CONSTRAINT fk_account_list_3   FOREIGN KEY (LAST_UPDATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_ID)); 

drop sequence account_list_s1;
CREATE SEQUENCE account_list_s1 START WITH 1001;

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
WHERE    table_name = 'ACCOUNT_LIST'
ORDER BY 2;


--e

CREATE OR REPLACE PROCEDURE seed_account_list IS
  /* Declare variable to capture table, and column. */
  lv_table_name   VARCHAR2(90);
  lv_column_name  VARCHAR2(30);
 
  /* Declare an exception variable and PRAGMA map. */
  not_null_column  EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_null_column,-1400);
 
BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;
 
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
 
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , NULL
      , NULL
      , 1002
      , SYSDATE
      , 1002
      , SYSDATE);
    END LOOP;
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN not_null_column THEN
    lv_table_name := (TRIM(BOTH '"' FROM RTRIM(REGEXP_SUBSTR(SQLERRM,'".*\."',REGEXP_INSTR(SQLERRM,'\.',1,1)),'."')));
    lv_column_name := (TRIM(BOTH '"' FROM REGEXP_SUBSTR(SQLERRM,'".*"',REGEXP_INSTR(SQLERRM,'\.',1,2))));
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
    RAISE_APPLICATION_ERROR(
       -20001
      ,'Remove the NOT NULL contraint from the '||lv_column_name||' column in'||CHR(10)||' the '||lv_table_name||' table.');
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/

EXECUTE seed_account_list();

COLUMN object_name FORMAT A18
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'SEED_ACCOUNT_LIST';


/*It should display the following results:

OBJECT_NAME        OBJECT_TYPE
------------------ ------------
SEED_ACCOUNT_LIST  PROCEDURE
 
1 row selected. 
*/

COLUMN airport FORMAT A7
SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY SUBSTR(account_number,1,3)
ORDER BY 1;

/* It should display the following:

Airport # Accounts
------- ----------
LAX             50
SFO             50
SJC             50
SLC             50
 
4 rows selected. */


-- f--
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';


--g--
CREATE OR REPLACE PROCEDURE update_member_account IS

  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);

  /* Declare a SQL cursor fabricated from local variables. */
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;

BEGIN

  /* Set savepoint. */
  SAVEPOINT all_or_none;

  /* Open a local cursor. */
  FOR i IN member_cursor LOOP

      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;

      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;

      /* Mark consumed the last used account number. */
      UPDATE account_list
      SET    consumed_by = 1002
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;

  END LOOP;

  /* Commit the writes as a group. */
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');

    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/
EXECUTE update_member_account();

COLUMN object_name FORMAT A22
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'UPDATE_MEMBER_ACCOUNT';


/* It should display 
OBJECT_NAME            OBJECT_TYPE
---------------------- ------------
UPDATE_MEMBER_ACCOUNT  PROCEDURE
 
1 row selected.*/

COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A12    HEADING "Address City"
COLUMN apstate        FORMAT A10    HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A5     HEADING "Airport|Account|Code"
 
-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.state_province AS apstate
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province INNER JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;

/* it should display
					Address    Airport  
 Member Last	Account 		State or   Account
   ID # Name	Number	   Address City Province   Code
------- ------- ---------- ------------ ---------- --------
   1001 Winn	SJC-000001 San Jose	California SJC
   1002 Vizquel SJC-000002 San Jose	California SJC
   1003 Sweeney SJC-000003 San Jose	California SJC
   1004 Clinton SLC-000001 Provo	Utah	   SLC
   1005 Moss	SLC-000002 Provo	Utah	   SLC
   1006 Gretelz SLC-000003 Provo	Utah	   SLC
   1007 Royal	SLC-000004 Provo	Utah	   SLC
   1008 Smith	SLC-000005 Spanish Fork Utah	   SLC
   1009 Potter	SLC-000006 Provo	Utah	   SLC */

--  Step #4
--  -------
--  Create an external table TRANSACTION_UPLOAD that uses
--  a pre-seeded source file.
-- --------------------------------------------------------
 
-- Insert step #4 statements here.

/* use this table 
Table Name: TRANSACTION_UPLOAD
Column Name	        Constraint	                          DataType	PhysicalSize
            Type	Reference Table	   Reference Column
ACCOUNT_NUMBER				                              String	10
FIRST_NAME				                                  String	20
MIDDLE_NAME				                                  String	20
LAST_NAME				                                  String	20
CHECK_OUT_DATE				                              Date	    Date
RETURN_DATE				                                  Date   	Date
RENTAL_ITEM_TYPE				                          String	12
TRANSACTION_TYPE				                          String	14
TRANSACTION_AMOUNT				                          Number	Decimal
TRANSACTION_DATE				                          Date	    Date
ITEM_ID				                                      Integer	Maximum
PAYMENT_METHOD_TYPE				                          String	14
PAYMENT_ACCOUNT_NUMBER				                      String	19
*/


 CREATE TABLE "STUDENT"."TRANSACTION_UPLOAD"
   (    "ACCOUNT_NUMBER" VARCHAR2(10),
        "FIRST_NAME" VARCHAR2(20),
        "MIDDLE_NAME" VARCHAR2(20),
        "LAST_NAME" VARCHAR2(20),
        "CHECK_OUT_DATE" DATE,
        "RETURN_DATE" DATE,
        "RENTAL_ITEM_TYPE" VARCHAR2(12),
        "TRANSACTION_TYPE" VARCHAR2(14),
        "TRANSACTION_AMOUNT" NUMBER,
        "TRANSACTION_DATE" DATE,
        "ITEM_ID" NUMBER,
        "PAYMENT_METHOD_TYPE" VARCHAR2(14),
        "PAYMENT_ACCOUNT_NUMBER" VARCHAR2(19)
   )
   ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL     )
      LOCATION
       ( 'transaction_upload.csv'
       )
    )
   REJECT LIMIT UNLIMITED;
   
   
SET LONG 200000 
SELECT   dbms_metadata.get_ddl('TABLE','TRANSACTION_UPLOAD') AS "Table Description"
FROM     dual;

   SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;
 

/*It should display
1 row selected.*/

-- Close log file.
SPOOL OFF
 
 /* should display
 External Rows
-------------
        11520
        
        */
        
-- Make all changes permanent.
COMMIT;
