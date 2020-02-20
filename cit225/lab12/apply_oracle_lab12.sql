@@/home/student/Data/cit225/oracle/lab11/apply_oracle_lab11.sql
 
-- Open log file.  
SPOOL apply_oracle_lab12.txt
 
-- --------------------------------------------------------
--  Step #1
--  -------
--  Create the CALENDAR table as per the specifications.
-- --------------------------------------------------------

/*
You should use the following specification to create the calendar table and calendar_s1 sequence.
*/


CREATE TABLE CALENDAR
( CALENDAR_ID                 NUMBER
, CALENDAR_NAME      VARCHAR2(10) CONSTRAINT SYS_C00169405_1 NOT NULL
, CALENDAR_SHORT_NAME  VARCHAR2(3) CONSTRAINT SYS_C00169406_2 NOT NULL
, START_DATE                  DATE CONSTRAINT SYS_C00169407_3 NOT NULL
, END_DATE                    DATE CONSTRAINT SYS_C00169408_4 NOT NULL
, CREATED_BY                  NUMBER CONSTRAINT SYS_C00169409_5 NOT NULL
, creation_date               DATE   CONSTRAINT SYS_C00169410_6 NOT NULL
, last_updated_by             NUMBER CONSTRAINT SYS_C00169411_7 NOT NULL
, last_update_date            DATE   CONSTRAINT SYS_C00169412_8 NOT NULL
, CONSTRAINT pk_calendar_1 PRIMARY KEY(calendar_id)
, CONSTRAINT fk_calendar_1 FOREIGN KEY(CREATED_BY) REFERENCES SYSTEM_USER(SYSTEM_USER_id)
, CONSTRAINT fk_calendar_2 FOREIGN KEY(last_updated_by) REFERENCES SYSTEM_USER(SYSTEM_USER_id));

SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'CALENDAR'
ORDER BY 2;

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A1   HEADING "C|T"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('calendar')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = 'CALENDAR'
ORDER BY ucc1.table_name
,        uc.constraint_name;

CREATE SEQUENCE calendar_s1 START WITH 1001;
 
-- Insert step #1 statements here.
 
-- --------------------------------------------------------
--  Step #2
--  -------
--  Seed the CALENDAR table.
-- --------------------------------------------------------
 INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'January'
 ,      'JAN'
 ,      '01-JAN-2009'
 ,      '31-JAN-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));

 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'February'
 ,      'FEB'
 ,      '01-FEB-2009'
 ,      '28-FEB-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'March'
 ,      'MAR'
 ,      '01-MAR-09'
 ,      '31-MAR-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'April'
 ,      'APR'
 ,      '01-APR-2009'
 ,      '30-APR-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'May'
 ,      'MAY'
 ,      '01-MAY-2009'
 ,      '31-MAY-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'June'
 ,      'JUN'
 ,      '01-JUN-2009'
 ,      '30-JUN-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));

  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'July'
 ,      'JUL'
 ,      '01-JUL-2009'
 ,      '31-JUL-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));

  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'August'
 ,      'AUG'
 ,      '01-AUG-2009'
 ,      '31-AUG-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));

  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'September'
 ,      'SEP'
 ,      '01-SEP-2009'
 ,      '30-SEP-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'October'
 ,      'OCT'
 ,      '01-OCT-2009'
 ,      '31-OCT-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'November'
 ,      'NOV'
 ,      '01-NOV-2009'
 ,      '30-NOV-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));
 
  INSERT INTO CALENDAR
 VALUES
 (calendar_s1.nextval
 ,      'December'
 ,      'DEC'
 ,      '01-DEC-2009'
 ,      '31-DEC-2009'
 ,      1001
 ,      TRUNC(SYSDATE)
 ,      1001
 ,      TRUNC(SYSDATE));

 -- Query the data insert.
COL calendar_name        FORMAT A10  HEADING "Calendar|Name"
COL calendar_short_name  FORMAT A8  HEADING "Calendar|Short|Name"
COL start_date           FORMAT A9   HEADING "Start|Date"
COL end_date             FORMAT A9   HEADING "End|Date"
SELECT   calendar_name
,        calendar_short_name
,        start_date
,        end_date
FROM     calendar;

-- --------------------------------------------------------
 
-- Insert step #3 statements here.
 
-- --------------------------------------------------------
CREATE TABLE TRANSACTION_REVERSAL
( TRANSACTION_ID                   NUMBER   
, TRANSACTION_ACCOUNT               VARCHAR2(15)
, TRANSACTION_TYPE                 NUMBER
, TRANSACTION_DATE                 DATE 
, TRANSACTION_AMOUNT               NUMBER 
, RENTAL_ID                        NUMBER 
, PAYMENT_METHOD_TYPE              NUMBER 
, PAYMENT_ACCOUNT_NUMBER           VARCHAR2(19) 
, CREATED_BY                       NUMBER    
, CREATION_DATE                    DATE 
, LAST_UPDATED_BY                  NUMBER 
, LAST_UPDATE_DATE                 DATE 
, CONSTRAINT pk_transaction_reversal_1 PRIMARY KEY(TRANSACTION_ID)); 

INSERT INTO TRANSACTION
(SELECT TRANSACTION_ID, TRANSACTION_ACCOUNT, TRANSACTION_TYPE, TRANSACTION_DATE, TRANSACTION_AMOUNT, RENTAL_ID, PAYMENT_METHOD_TYPE, PAYMENT_ACCOUNT_NUMBER, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
FROM    transaction_reversal);
COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

--  Step #4
--  -------
--  Create a annual financial report using selective 
--  aggregation.
-- --------------------------------------------------------
 
-- Insert step #4 statements here.
 
-- Close log file.
SPOOL OFF
 
-- Make all changes permanent.
COMMIT;
