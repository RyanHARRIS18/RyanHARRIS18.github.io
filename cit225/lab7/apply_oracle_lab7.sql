/*-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab7.sql
--  Lab Assignment: Lab #7
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
--   sql> @apply_oracle_lab7.sql
--
-- ------------------------------------------------------------------*/

-- Call library files.
@@/home/student/Data/cit225/oracle/lab6/apply_oracle_lab6.sql

-- Open log file.
SPOOL apply_oracle_lab7.txt

-- ... insert lab 7 commands here ...


-- ------------------------------------------------------------------
-- Call the prior lab.
-- ------------------------------------------------------------------

@@/home/student/Data/cit225/oracle/lab6/apply_oracle_lab6.sql

-- Open log file.
SPOOL apply_oracle_lab7.txt

---- ---------------------------------------------Step #1----------------------------------------------------------
/*-- Step #1 instructions ----------------------
--  -------You write two INSERT statements to the COMMON_LOOKUP table.--

--   insert two new ROWS into the COMMON_LOOKUP table to support the ACTIVE_FLAG column in the PRICE table that you created in Lab #6: --
--  Insert two ACTIVE_FLAG records in the COMMON_LOOKUP table.*/

/* follow this table while creating 

Table Name: COMMON_LOOKUP

Table	Column	      Code	Type	Meaning
PRICE	ACTIVE_FLAG	   Y	YES	       Yes
PRICE	ACTIVE_FLAG	   N	NO	        No */

                    -- *****Insert step #1 statements here*****--
 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'YES'
 ,      'Yes'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'PRICE'
 ,      'ACTIVE_FLAG'
 ,      'Y');
 
 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      'NO'
 ,      'No'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'PRICE'
 ,      'ACTIVE_FLAG'
 ,      'N');

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

/* 1 should display:
COMMON_LOOKUP_TABLE  COMMON_LOOKUP_COLUMN COMMON_LOOKUP_TYPE
-------------------- -------------------- --------------------
PRICE                ACTIVE_FLAG          YES
PRICE                ACTIVE_FLAG          NO
2 rows selected.
-- --------------------------------------------------------*/





---- ---------------------------------------------Step #2----------------------------------------------------------
/*-- Step #2-------------------------------------
-- Insert three new rows into the COMMON_LOOKUP table to support the PRICE_TYPE column in the PRICE table, and three new rows into the COMMON_LOOKUP table to support the RENTAL_ITEM_TYPE column in the RENTAL_ITEM table.
--  -------
--  Insert three PRICE_TYPE and three RENTAL_ITEM_TYPE
--  records in the COMMON_LOOKUP table.
-- --------------------------------------------------------
--You write six INSERT statements to the COMMON_LOOKUP table.-- */
/* follow this table while creating 

Table Name: COMMON_LOOKUP
Table	       Column	        Code	Type	        Meaning
PRICE	       PRICE_TYPE	     1	   1-DAY RENTAL	  1-Day Rental
PRICE	       PRICE_TYPE	     3	   3-DAY RENTAL	  3-Day Rental
PRICE	       PRICE_TYPE	     5	   5-DAY RENTAL	  5-Day Rental
RENTAL_ITEM	   RENTAL_ITEM_TYPE	 1	   1-DAY RENTAL	  1-Day Rental
RENTAL_ITEM	   RENTAL_ITEM_TYPE	 3	   3-DAY RENTAL	  3-Day Rental
RENTAL_ITEM	   RENTAL_ITEM_TYPE	 5	   5-DAY RENTAL	  5-Day Rental   */

            -- *****Insert step #2 statements here*****--

INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '1-DAY RENTAL'
 ,      '1-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'PRICE'
 ,      'PRICE_TYPE'
 ,      '1');

 
INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '3-DAY RENTAL'
 ,      '3-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'PRICE'
 ,      'PRICE_TYPE'
 ,      '3');

 
INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '5-DAY RENTAL'
 ,      '5-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'PRICE'
 ,      'PRICE_TYPE'
 ,      '5');

INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '1-DAY RENTAL'
 ,      '1-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'RENTAL_ITEM'
 ,      'RENTAL_ITEM_TYPE'
 ,      '1');
 
 INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '3-DAY RENTAL'
 ,      '3-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'RENTAL_ITEM'
 ,      'RENTAL_ITEM_TYPE'
 ,      '3');
 
  INSERT INTO common_lookup
 VALUES
 (common_lookup_s1.nextval
 ,      '5-DAY RENTAL'
 ,      '5-DAY RENTAL'
 ,      1
 ,      SYSDATE
 ,      1
 ,      SYSDATE
 ,      'RENTAL_ITEM'
 ,      'RENTAL_ITEM_TYPE'
 ,      '5');


COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 3;

/* 2 should display

COMMON_LOOKUP_TABLE  COMMON_LOOKUP_COLUMN COMMON_LOOKUP_TYPE
-------------------- -------------------- --------------------
PRICE		     PRICE_TYPE 	  1-DAY RENTAL
PRICE		     PRICE_TYPE 	  3-DAY RENTAL
PRICE		     PRICE_TYPE 	  5-DAY RENTAL
RENTAL_ITEM	     RENTAL_ITEM_TYPE	  1-DAY RENTAL
RENTAL_ITEM	     RENTAL_ITEM_TYPE	  3-DAY RENTAL
RENTAL_ITEM	     RENTAL_ITEM_TYPE	  5-DAY RENTAL

6 rows selected. */



/*-- ---------------------------------------------Step #3--------------------------------------------------------
--  6 points] You added a RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns in the previous (Lab #6). Here you update the RENTAL_ITEM_TYPE column with values for all pre-existing rows. After you have updated the pre-existing rows, you add a NOT NULL constraint on the RENTAL_ITEM_TYPE column.

You update the null values in RENTAL_ITEM_TYPE column of the RENTAL_ITEM table with a correlated UPDATE   
    statement; and then you enable a NOT NULL constraint not the RENTAL_ITEM_TYPE column.
--  -------
--  Update the RENTAL_ITEM_TYPE column values and add a
--  foreign key constraint on the RENTAL_ITEM_TYPE column.
-- --------------------------------------------------------*/
--OVERRAL WHAT YOU DO IN 3 [6 points] You added a RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns in the previous (Lab #6). Here you update the RENTAL_ITEM_TYPE column with values for all pre-existing rows. After you have updated the pre-existing rows, you add a NOT NULL constraint on the RENTAL_ITEM_TYPE column. --



/* Instructions for 3.A.1.........................
You update the null values in RENTAL_ITEM_TYPE column of the RENTAL_ITEM table with a correlated UPDATE   
statement; and then you enable a NOT NULL constraint not the RENTAL_ITEM_TYPE column.

Update the rental_item_type column with values for all pre-existing rows, 
so you can add a FOREIGN KEY and NOT NULL constraint on the rental_item_type column in steps b and c respectively.
You can not populate the rental_item_price until you get to Lab #8. */

/* follow this table while creating 

Table Name: RENTAL_ITEM

Column Name	       Constraint	      
                    ___________________________________________________    Data        Physical
                     Type	    Refrence Table     Refrence Column         Type        Size
                   
                   
                   
                 
 RENTAL_ITEM_TYPE	 FOREIGN KEY
                    ___________________________________________________    Data        Physical
                     NOT NULL	   COMMON_LOOKUP   COMMON_LOOKUP_ID        INTEGER      MAX     
                     
                     
                     
                     
   RENTAL_ITEM_TYPE	
                    ___________________________________________________    Data        Physical
                     NOT NULL	                                           INTEGER      MAX    */

                       -- Insert step #3.a.1 statements here.     
                /*       
 UPDATE telephone
 SET telephone_type = (SELECT common_lookup_id
                    FROM common_lookup WHERE common_lookup_table = 'TELEPHONE' 
                    AND common_lookup_meaning = 'HOME'); */
                       
UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');
                  
                
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

/* 3.A.1 should display
TABLE_NAME     COLUMN_ID COLUMN_NAME            NULLABLE DATA_TYPE
-------------- --------- ---------------------- -------- ------------
RENTAL_ITEM            1 RENTAL_ITEM_ID         NOT NULL NUMBER(22)
RENTAL_ITEM            2 RENTAL_ID              NOT NULL NUMBER(22)
RENTAL_ITEM            3 ITEM_ID                NOT NULL NUMBER(22)
RENTAL_ITEM            4 CREATED_BY             NOT NULL NUMBER(22)
RENTAL_ITEM            5 CREATION_DATE          NOT NULL DATE
RENTAL_ITEM            6 LAST_UPDATED_BY        NOT NULL NUMBER(22)
RENTAL_ITEM            7 LAST_UPDATE_DATE       NOT NULL DATE
RENTAL_ITEM            8 RENTAL_ITEM_TYPE                NUMBER(22)
RENTAL_ITEM            9 RENTAL_ITEM_PRICE               NUMBER(22)

9 rows selected. */
                    

        UPDATE   rental_item ri
        SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');
     
     
  --You should use the following to verify that the UPDATE statement worked successfully in this step:--          
    SELECT   ROW_COUNT
    ,        col_count
    FROM    (SELECT   COUNT(*) AS ROW_COUNT
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;
            
/* 3a2 should display
ROW_COUNT  COL_COUNT
---------- ----------
        13         13

1 row selected.*/


  -- START OF #3B --.          
/*---instructions 3b
        Add the FK_RENTAL_ITEM_7 foreign key to the RENTAL_ITEM table. 
        The FK_RENTAL_ITEM_7 foreign key belongs on the RENTAL_ITEM_TYPE column 
        of the RENTAL_ITEM table and references the COMMON_LOOKUP_ID column of the COMMON_LOOKUP table. */

                                -- Insert step #3.b statements here.
                                
  ALTER TABLE RENTAL_ITEM
ADD CONSTRAINT FK_RENTAL_ITEM_7 FOREIGN KEY (rental_item_type) REFERENCES COMMON_LOOKUP(COMMON_LOOKUP_ID);
    
                                
     --The following query, lets you verify that you’ve set the foreign key constraint for the RENTAL_ITEM_TYPE column:--   
        COLUMN table_name      FORMAT A12 HEADING "TABLE NAME"
COLUMN constraint_name FORMAT A18 HEADING "CONSTRAINT NAME"
COLUMN constraint_type FORMAT A12 HEADING "CONSTRAINT|TYPE"
COLUMN column_name     FORMAT A18 HEADING "COLUMN NAME"
SELECT   uc.table_name
,        uc.constraint_name
,        CASE
           WHEN uc.constraint_type = 'R' THEN
            'FOREIGN KEY'
         END AS constraint_type
,        ucc.column_name
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = 'RENTAL_ITEM'
AND      ucc.column_name = 'RENTAL_ITEM_TYPE';

/*--3B should return
CONSTRAINT
TABLE NAME   CONSTRAINT NAME    TYPE         COLUMN NAME
------------ ------------------ ------------ ------------------
RENTAL_ITEM  FK_RENTAL_ITEM_7   FOREIGN KEY  RENTAL_ITEM_TYPE

1 row selected. */




  -- START OF #3c --.
/* instruction 3c 
Change the RENTAL_ITEM_TYPE column of the RENTAL_ITEM table from a null allowed column to a not null constrained column. */


-- Insert step #3.c statements here.

ALTER TABLE RENTAL_ITEM
MODIFY (RENTAL_ITEM_TYPE NUMBER CONSTRAINT NN_rental_item_7 NOT NULL);

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_TYPE';


/*--3c should display
TABLE_NAME     COLUMN_NAME            CONSTRAINT
-------------- ---------------------- ----------
RENTAL_ITEM    RENTAL_ITEM_TYPE       NOT NULL

1 row selected.*/

- ---------------------------------------------Step #4--------------------------------------------------------
/*--Step #4 Instructions --------------------------------------------------------
--  
You write the logic for the SELECT-list, which includes the use 
of CASE operators; and the negation logic to filter out the 
fabricated rows that do not apply to the data set.

The SELECT-list (or query) draws data from the current ITEM table and
adds values that let you calculate different value sets for the 
ACTIVE_FLAG and AMOUNT column. Specifically, you must add the following values:

                        ACTIVE_FLAG values: 'Y' and 'N'
                        AMOUNT values: '1', '3', '5', '10', and '15'

You can fabricate the data set with a query like the example below. The sample query returns 24 (the number of) rows from the ITEM table times 2 rows from the fabrication of 'Y' and 'N' values times 3 rows from the fabrication of the '1', '3', and '5' rental day values. */

--  -------
--  Create a query to fabricate pricing data that you
--  will insert into a PRICE table in lab 8.
-- --------------------------------------------------------

-- Insert step #4 statements here.--


SELECT   i.item_id
,        af.active_flag
,        cl.common_lookup_id AS price_type
,        cl.common_lookup_type AS price_desc
,        CASE  
           WHEN  (TRUNC(SYSDATE) - i.release_date) <= 30 OR 
           (TRUNC(SYSDATE) - i.release_date > 30) AND af.active_flag = 'N' THEN i.release_date
           ELSE  i.release_date + 31
         END AS start_date
         ,CASE 
         WHEN (TRUNC(SYSDATE) - i.release_date > 30)  AND af.active_flag = 'N' THEN i.release_date + 30
         END AS end_date
,        CASE   
           WHEN (TRUNC(SYSDATE) - i.release_date <= 30)  THEN
           CASE
                WHEN dr.rental_days = 1 THEN 3
                WHEN  dr.rental_days = 3 THEN 10
                WHEN  dr.rental_days = 5 THEN 15
            END
        WHEN (TRUNC(SYSDATE) - i.release_date > 30)  AND af.active_flag = 'N' THEN 
        CASE
           WHEN  dr.rental_days = 1 THEN 3
           WHEN  dr.rental_days = 3 THEN 10
           WHEN  dr.rental_days = 5 THEN 15
           END
        ELSE  
           CASE
            WHEN dr.rental_days = 1 THEN 1
            WHEN dr.rental_days = 3 THEN 3
            WHEN dr.rental_days = 5 THEN 5
          END
         END AS amount
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
AND NOT (af.active_flag = 'N' AND (TRUNC(SYSDATE) - 30) < i.release_date)  --Logic of A
ORDER BY 1, 2, 3;


/* following instrucitons 
--When you have written the correct logic for the preceding query, you should see the following results: --

You should note that the result set displays the price_type value. The price_type value is a foreign key and a copy of the common_lookup_id value in the common_lookup table.

You find the common_lookup_id value by using the natural key. Three columns define the natural key. They are the uppercase strings:

common_lookup_table column
common_lookup_column column
common_lookup_type column
String literals of PRICE and PRICE_TYPE match the common_lookup_table and common_lookup_column column values and the Cartesian join resolves the common_lookup_type column by comparing it against the first character of the rental_days column. The rental_days column is fabricated into the data set via a CROSS JOIN.*/

--You can use the following SQL*Plus formatting commands to display the information from your query for step 4 --
COLUMN item_id     FORMAT 9999 HEADING "ITEM|ID"
COLUMN active_flag FORMAT A6   HEADING "ACTIVE|FLAG"
COLUMN price_type  FORMAT 9999 HEADING "PRICE|TYPE"
COLUMN price_desc  FORMAT A12  HEADING "PRICE DESC"
COLUMN start_date  FORMAT A10  HEADING "START|DATE"
COLUMN end_date    FORMAT A10  HEADING "END|DATE"
COLUMN amount      FORMAT 9999 HEADING "AMOUNT"

/* it should display 
ITEM ACTIVE PRICE
   ID FLAG    TYPE PRICE DESC   START DATE         END DATE           AMOUNT
----- ------ ----- ------------ ------------------ ------------------ ------
 1001 N       1020 1-DAY RENTAL 02-MAR-90 00:00:00 01-APR-90 00:00:00      3
 1001 N       1021 3-DAY RENTAL 02-MAR-90 00:00:00 01-APR-90 00:00:00     10
 1001 N       1022 5-DAY RENTAL 02-MAR-90 00:00:00 01-APR-90 00:00:00     15
 1001 Y       1020 1-DAY RENTAL 02-APR-90 00:00:00                         1
 1001 Y       1021 3-DAY RENTAL 02-APR-90 00:00:00                         3
 1001 Y       1022 5-DAY RENTAL 02-APR-90 00:00:00                         5
 1002 N       1020 1-DAY RENTAL 04-MAY-99 00:00:00 03-JUN-99 00:00:00      3
 1002 N       1021 3-DAY RENTAL 04-MAY-99 00:00:00 03-JUN-99 00:00:00     10
 1002 N       1022 5-DAY RENTAL 04-MAY-99 00:00:00 03-JUN-99 00:00:00     15
 1002 Y       1020 1-DAY RENTAL 04-JUN-99 00:00:00                         1
 1002 Y       1021 3-DAY RENTAL 04-JUN-99 00:00:00                         3
 1002 Y       1022 5-DAY RENTAL 04-JUN-99 00:00:00                         5
 1003 N       1020 1-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00      3
 1003 N       1021 3-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     10
 1003 N       1022 5-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     15
 1003 Y       1020 1-DAY RENTAL 16-JUN-02 00:00:00                         1
 1003 Y       1021 3-DAY RENTAL 16-JUN-02 00:00:00                         3
 1003 Y       1022 5-DAY RENTAL 16-JUN-02 00:00:00                         5
 1004 N       1020 1-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00      3
 1004 N       1021 3-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     10
 1004 N       1022 5-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     15
 1004 Y       1020 1-DAY RENTAL 16-JUN-02 00:00:00                         1
 1004 Y       1021 3-DAY RENTAL 16-JUN-02 00:00:00                         3
 1004 Y       1022 5-DAY RENTAL 16-JUN-02 00:00:00                         5
 1005 N       1020 1-DAY RENTAL 19-MAY-05 00:00:00 18-JUN-05 00:00:00      3
 1005 N       1021 3-DAY RENTAL 19-MAY-05 00:00:00 18-JUN-05 00:00:00     10
 1005 N       1022 5-DAY RENTAL 19-MAY-05 00:00:00 18-JUN-05 00:00:00     15
 1005 Y       1020 1-DAY RENTAL 19-JUN-05 00:00:00                         1
 1005 Y       1021 3-DAY RENTAL 19-JUN-05 00:00:00                         3
 1005 Y       1022 5-DAY RENTAL 19-JUN-05 00:00:00                         5
 1006 N       1020 1-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00      3
 1006 N       1021 3-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     10
 1006 N       1022 5-DAY RENTAL 16-MAY-02 00:00:00 15-JUN-02 00:00:00     15
 1006 Y       1020 1-DAY RENTAL 16-JUN-02 00:00:00                         1
 1006 Y       1021 3-DAY RENTAL 16-JUN-02 00:00:00                         3
 1006 Y       1022 5-DAY RENTAL 16-JUN-02 00:00:00                         5
 1007 N       1020 1-DAY RENTAL 24-JUL-03 00:00:00 23-AUG-03 00:00:00      3
 1007 N       1021 3-DAY RENTAL 24-JUL-03 00:00:00 23-AUG-03 00:00:00     10
 1007 N       1022 5-DAY RENTAL 24-JUL-03 00:00:00 23-AUG-03 00:00:00     15
 1007 Y       1020 1-DAY RENTAL 24-AUG-03 00:00:00                         1
 1007 Y       1021 3-DAY RENTAL 24-AUG-03 00:00:00                         3
 1007 Y       1022 5-DAY RENTAL 24-AUG-03 00:00:00                         5
 1008 N       1020 1-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00      3
 1008 N       1021 3-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00     10
 1008 N       1022 5-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00     15
 1008 Y       1020 1-DAY RENTAL 31-JUL-03 00:00:00                         1
 1008 Y       1021 3-DAY RENTAL 31-JUL-03 00:00:00                         3
 1008 Y       1022 5-DAY RENTAL 31-JUL-03 00:00:00                         5
 1009 N       1020 1-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00      3
 1009 N       1021 3-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00     10
 1009 N       1022 5-DAY RENTAL 30-JUN-03 00:00:00 30-JUL-03 00:00:00     15
 1009 Y       1020 1-DAY RENTAL 31-JUL-03 00:00:00                         1
 1009 Y       1021 3-DAY RENTAL 31-JUL-03 00:00:00                         3
 1009 Y       1022 5-DAY RENTAL 31-JUL-03 00:00:00                         5
 1010 N       1020 1-DAY RENTAL 17-NOV-03 00:00:00 17-DEC-03 00:00:00      3
 1010 N       1021 3-DAY RENTAL 17-NOV-03 00:00:00 17-DEC-03 00:00:00     10
 1010 N       1022 5-DAY RENTAL 17-NOV-03 00:00:00 17-DEC-03 00:00:00     15
 1010 Y       1020 1-DAY RENTAL 18-DEC-03 00:00:00                         1
 1010 Y       1021 3-DAY RENTAL 18-DEC-03 00:00:00                         3
 1010 Y       1022 5-DAY RENTAL 18-DEC-03 00:00:00                         5
 1011 N       1020 1-DAY RENTAL 08-APR-03 00:00:00 08-MAY-03 00:00:00      3
 1011 N       1021 3-DAY RENTAL 08-APR-03 00:00:00 08-MAY-03 00:00:00     10
 1011 N       1022 5-DAY RENTAL 08-APR-03 00:00:00 08-MAY-03 00:00:00     15
 1011 Y       1020 1-DAY RENTAL 09-MAY-03 00:00:00                         1
 1011 Y       1021 3-DAY RENTAL 09-MAY-03 00:00:00                         3
 1011 Y       1022 5-DAY RENTAL 09-MAY-03 00:00:00                         5
 1012 N       1020 1-DAY RENTAL 15-NOV-04 00:00:00 15-DEC-04 00:00:00      3
 1012 N       1021 3-DAY RENTAL 15-NOV-04 00:00:00 15-DEC-04 00:00:00     10
 1012 N       1022 5-DAY RENTAL 15-NOV-04 00:00:00 15-DEC-04 00:00:00     15
 1012 Y       1020 1-DAY RENTAL 16-DEC-04 00:00:00                         1
 1012 Y       1021 3-DAY RENTAL 16-DEC-04 00:00:00                         3
 1012 Y       1022 5-DAY RENTAL 16-DEC-04 00:00:00                         5
 1013 N       1020 1-DAY RENTAL 19-MAY-06 00:00:00 18-JUN-06 00:00:00      3
 1013 N       1021 3-DAY RENTAL 19-MAY-06 00:00:00 18-JUN-06 00:00:00     10
 1013 N       1022 5-DAY RENTAL 19-MAY-06 00:00:00 18-JUN-06 00:00:00     15
 1013 Y       1020 1-DAY RENTAL 19-JUN-06 00:00:00                         1
 1013 Y       1021 3-DAY RENTAL 19-JUN-06 00:00:00                         3
 1013 Y       1022 5-DAY RENTAL 19-JUN-06 00:00:00                         5
 1014 N       1020 1-DAY RENTAL 28-APR-06 00:00:00 28-MAY-06 00:00:00      3
 1014 N       1021 3-DAY RENTAL 28-APR-06 00:00:00 28-MAY-06 00:00:00     10
 1014 N       1022 5-DAY RENTAL 28-APR-06 00:00:00 28-MAY-06 00:00:00     15
 1014 Y       1020 1-DAY RENTAL 29-MAY-06 00:00:00                         1
 1014 Y       1021 3-DAY RENTAL 29-MAY-06 00:00:00                         3
 1014 Y       1022 5-DAY RENTAL 29-MAY-06 00:00:00                         5
 1015 N       1020 1-DAY RENTAL 01-MAR-92 00:00:00 31-MAR-92 00:00:00      3
 1015 N       1021 3-DAY RENTAL 01-MAR-92 00:00:00 31-MAR-92 00:00:00     10
 1015 N       1022 5-DAY RENTAL 01-MAR-92 00:00:00 31-MAR-92 00:00:00     15
 1015 Y       1020 1-DAY RENTAL 01-APR-92 00:00:00                         1
 1015 Y       1021 3-DAY RENTAL 01-APR-92 00:00:00                         3
 1015 Y       1022 5-DAY RENTAL 01-APR-92 00:00:00                         5
 1016 N       1020 1-DAY RENTAL 05-JAN-98 00:00:00 04-FEB-98 00:00:00      3
 1016 N       1021 3-DAY RENTAL 05-JAN-98 00:00:00 04-FEB-98 00:00:00     10
 1016 N       1022 5-DAY RENTAL 05-JAN-98 00:00:00 04-FEB-98 00:00:00     15
 1016 Y       1020 1-DAY RENTAL 05-FEB-98 00:00:00                         1
 1016 Y       1021 3-DAY RENTAL 05-FEB-98 00:00:00                         3
 1016 Y       1022 5-DAY RENTAL 05-FEB-98 00:00:00                         5
 1017 N       1020 1-DAY RENTAL 02-NOV-99 00:00:00 02-DEC-99 00:00:00      3
 1017 N       1021 3-DAY RENTAL 02-NOV-99 00:00:00 02-DEC-99 00:00:00     10
 1017 N       1022 5-DAY RENTAL 02-NOV-99 00:00:00 02-DEC-99 00:00:00     15
 1017 Y       1020 1-DAY RENTAL 03-DEC-99 00:00:00                         1
 1017 Y       1021 3-DAY RENTAL 03-DEC-99 00:00:00                         3
 1017 Y       1022 5-DAY RENTAL 03-DEC-99 00:00:00                         5
 1018 N       1020 1-DAY RENTAL 28-JUN-94 00:00:00 28-JUL-94 00:00:00      3
 1018 N       1021 3-DAY RENTAL 28-JUN-94 00:00:00 28-JUL-94 00:00:00     10
 1018 N       1022 5-DAY RENTAL 28-JUN-94 00:00:00 28-JUL-94 00:00:00     15
 1018 Y       1020 1-DAY RENTAL 29-JUL-94 00:00:00                         1
 1018 Y       1021 3-DAY RENTAL 29-JUL-94 00:00:00                         3
 1018 Y       1022 5-DAY RENTAL 29-JUL-94 00:00:00                         5
 1019 N       1020 1-DAY RENTAL 11-DEC-91 00:00:00 10-JAN-92 00:00:00      3
 1019 N       1021 3-DAY RENTAL 11-DEC-91 00:00:00 10-JAN-92 00:00:00     10
 1019 N       1022 5-DAY RENTAL 11-DEC-91 00:00:00 10-JAN-92 00:00:00     15
 1019 Y       1020 1-DAY RENTAL 11-JAN-92 00:00:00                         1
 1019 Y       1021 3-DAY RENTAL 11-JAN-92 00:00:00                         3
 1019 Y       1022 5-DAY RENTAL 11-JAN-92 00:00:00                         5
 1020 N       1020 1-DAY RENTAL 04-DEC-92 00:00:00 03-JAN-93 00:00:00      3
 1020 N       1021 3-DAY RENTAL 04-DEC-92 00:00:00 03-JAN-93 00:00:00     10
 1020 N       1022 5-DAY RENTAL 04-DEC-92 00:00:00 03-JAN-93 00:00:00     15
 1020 Y       1020 1-DAY RENTAL 04-JAN-93 00:00:00                         1
 1020 Y       1021 3-DAY RENTAL 04-JAN-93 00:00:00                         3
 1020 Y       1022 5-DAY RENTAL 04-JAN-93 00:00:00                         5
 1021 N       1020 1-DAY RENTAL 15-MAY-98 00:00:00 14-JUN-98 00:00:00      3
 1021 N       1021 3-DAY RENTAL 15-MAY-98 00:00:00 14-JUN-98 00:00:00     10
 1021 N       1022 5-DAY RENTAL 15-MAY-98 00:00:00 14-JUN-98 00:00:00     15
 1021 Y       1020 1-DAY RENTAL 15-JUN-98 00:00:00                         1
 1021 Y       1021 3-DAY RENTAL 15-JUN-98 00:00:00                         3
 1021 Y       1022 5-DAY RENTAL 15-JUN-98 00:00:00                         5
 1022 Y       1020 1-DAY RENTAL 28-MAY-14 00:00:00                         3
 1022 Y       1021 3-DAY RENTAL 28-MAY-14 00:00:00                        10
 1022 Y       1022 5-DAY RENTAL 28-MAY-14 00:00:00                        15
 1023 Y       1020 1-DAY RENTAL 28-MAY-14 00:00:00                         3
 1023 Y       1021 3-DAY RENTAL 28-MAY-14 00:00:00                        10
 1023 Y       1022 5-DAY RENTAL 28-MAY-14 00:00:00                        15
 1024 Y       1020 1-DAY RENTAL 28-MAY-14 00:00:00                         3
 1024 Y       1021 3-DAY RENTAL 28-MAY-14 00:00:00                        10
 1024 Y       1022 5-DAY RENTAL 28-MAY-14 00:00:00                        15

135 rows selected. */

-- Close log file.
SPOOL OFF


