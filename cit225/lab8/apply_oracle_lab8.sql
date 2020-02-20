-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab8.sql
--  Lab Assignment: Lab #8
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
--   sql> @apply_oracle_lab8.sql
--
- ------------------------------------------------------------------
-- Call the prior lab.
-- ------------------------------------------------------------------

@@/home/student/Data/cit225/oracle/lab7/apply_oracle_lab7.sql

-- Open log file.
SPOOL apply_oracle_lab8.txt

-- --------------------------------------------------------
--  Step #1
--  -------
--  Using the query from Lab 7, Step 4, insert the 135
--  rows in the PRICE table created in Lab 6.
-- --------------------------------------------------------
--add the necessary columns to insert the values directly into the price table. You will need to add values for the price_id, created_by, creation_date, last_updated_by, and last_update_date columns.

/* Instructions
If you did not create a price_s sequence in Lab #6, you should create the price_id sequence with a starting value of 1001. You modify the query from the last lab by adding the following:
A price_s.nextval call to populate the price_id column of the price table.

A a subquery like the following to populate the created_by and last_updated_by columns.
SELECT su.system_user_id
FROM   system_user su
WHERE  su.system_user_name = 'Some valid string for a system_name value'
A TRUNC(SYSDATE) call for the creation_date and last_update_date columns. */
INSERT INTO price
( price_id
, item_id
, price_type
, active_flag
, start_date
, end_date
, amount
, created_by
, creation_date
, last_updated_by
, last_update_date )
( SELECT price_s1.NEXTVAL
  ,        item_id
  ,        price_type
  ,        active_flag
  ,        start_date
  ,        end_date
  ,        amount
  ,        created_by
  ,        creation_date
  ,        last_updated_by
  ,        last_update_date
  FROM
    (SELECT   i.item_id
     ,        af.active_flag
     ,        cl.common_lookup_id AS price_type
     ,        cl.common_lookup_type AS price_desc
     ,        CASE
                 WHEN  (TRUNC(SYSDATE) - i.release_date) <= 30 OR 
           (TRUNC(SYSDATE) - i.release_date > 30) AND af.active_flag = 'N' THEN i.release_date
           ELSE  i.release_date + 31
              END AS start_date
     ,        CASE
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
     , (SELECT su.system_user_id
     FROM   system_user su
     WHERE  su.system_user_name = 'DBA1') AS created_by
     ,(TRUNC(SYSDATE)) creation_date
     ,(SELECT su.system_user_id
     FROM   system_user su
     WHERE  su.system_user_name = 'DBA1') AS last_updated_by
     ,(TRUNC(SYSDATE)) AS last_update_date
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
     AND NOT (af.active_flag = 'N' AND (TRUNC(SYSDATE) - 30) < i.release_date)));



--Use this Query to verify step 1 --
SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);


/* --it should display--
Type       1-Day      3-Day      5-Day      TOTAL
----- ---------- ---------- ---------- ----------
OLD Y         21         21         21         63
OLD N         21         21         21         63
NEW Y          3          3          3          9
NEW N          0          0          0          0

4 rows selected. */

-- --------------------------------------------------------
--  Step #2
--  -------
--  Add a NOT NULL constraint on the PRICE_TYPE column
--  of the PRICE table.
-- --------------------------------------------------------

-- Insert step #2 statements here.
--You should add the NOT NULL constraint to the PRICE_TYPE column of the PRICE table.--

ALTER TABLE PRICE
MODIFY (PRICE_TYPE NUMBER CONSTRAINT NN_price_9 NOT NULL);

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';

/* It should display the following results for a not null constrained column:

TABLE_NAME     COLUMN_NAME            CONSTRAINT
-------------- ---------------------- ----------
PRICE          PRICE_TYPE             NOT NULL

1 row selected.*/





-- --------------------------------------------------------
--  Step #3
--  -------
--  Update the RENTAL_ITEM_PRICE column with valid price
--  values in the RENTAL_ITEM table.
-- --------------------------------------------------------


-- Insert step #3 statements here.

UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2
           WHERE    p.item_id = ri.item_id
           AND      ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                     BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1));
                      
--You can confirm you’ve updated the correct rows with the following query, which implements the complete logic required of a successful UPDATE statement:--

--query--
-- Widen the display console.
SET LINESIZE 110

-- Set the column display values.
COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL contact_id             FORMAT 9999 HEADING "Contact|--------|Contact|ID #"
COL customer_id            FORMAT 9999 HEADING "Rental|--------|Customer|ID #"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL ri_rental_id           FORMAT 9999 HEADING "Rental|Item|------|Rental|ID #"
COL rental_item_id         FORMAT 9999 HEADING "Rental|Item|------||ID #"
COL price_item_id          FORMAT 9999 HEADING "Price|------|Item|ID #"
COL rental_item_item_id    FORMAT 9999 HEADING "Rental|Item|------|Item|ID #"
COL rental_item_price      FORMAT 9999 HEADING "Rental|Item|------||Price"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        c.contact_id
,        r.customer_id
,        r.rental_id AS r_rental_id
,        ri.rental_id AS ri_rental_id
,        ri.rental_item_id
,        p.item_id AS price_item_id
,        ri.item_id AS rental_item_item_id
,        ri.rental_item_price
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;

-- Reset the column display values to their default value.
SET LINESIZE 80

/* Step 3 should now DISPLAY 
Rental Rental	   Rental Rental	       Rental
		      Contact	Rental Rental	Item   Item  Price   Item   Item  Price  Price	 Item
Contact 	     -------- -------- ------ ------ ------ ------ ------ ------ ------ ------ ------
--------	      Contact Customer Rental Rental	      Item   Item		  Type	 Type
Customer Name		 ID #	  ID #	 ID #	ID #   ID #   ID #   ID #  Price Amount   Code	 Code
-------------------- -------- -------- ------ ------ ------ ------ ------ ------ ------ ------ ------
Winn, Brian		 1002	  1002	 1005	1005   1008   1007   1007      5      5      5	    5
Winn, Brian		 1002	  1002	 1005	1005   1009   1001   1001      5      5      5	    5
Vizquel, Oscar		 1003	  1003	 1001	1001   1003   1005   1005      5      5      5	    5
Vizquel, Oscar		 1003	  1003	 1001	1001   1002   1004   1004      5      5      5	    5
Vizquel, Oscar		 1003	  1003	 1001	1001   1001   1002   1002      5      5      5	    5
Vizquel, Doreen 	 1004	  1004	 1002	1002   1005   1021   1021      5      5      5	    5
Vizquel, Doreen 	 1004	  1004	 1002	1002   1004   1016   1016      5      5      5	    5
Sweeney, Meaghan	 1005	  1005	 1003	1003   1006   1019   1019      5      5      5	    5
Sweeney, Ian M		 1007	  1007	 1004	1004   1007   1014   1014      5      5      5	    5
Potter, Harry		 1013	  1013	 1006	1006   1011   1022   1022      1      1      1	    1
Potter, Harry		 1013	  1013	 1006	1006   1010   1022   1022      3      3      1	    1
Potter, Ginny		 1014	  1014	 1007	1007   1012   1023   1023     10     10      3	    3
Potter, Lily Luna	 1015	  1015	 1008	1008   1013   1024   1024     15     15      5	    5 */

-- --------------------------------------------------------
--  Step #4
--  -------
--  Add a NOT NULL constraint on the RENTAL_ITEM_PRICE
--  column of the RENTAL_ITEM table.
-- --------------------------------------------------------

-- Insert step #4 statements here.
--[4 points] Add a not null constraint to the RENTAL_ITEM_PRICE column of the RENTAL_ITEM table.-- 

ALTER TABLE RENTAL_ITEM
MODIFY (RENTAL_ITEM_PRICE NUMBER CONSTRAINT NN_rental_item_8 NOT NULL);

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';

/* it should display --
TABLE_NAME     COLUMN_NAME            CONSTRAINT
-------------- ---------------------- ----------
RENTAL_ITEM    RENTAL_ITEM_PRICE      NOT NULL

1 row selected.*/

-- Close log file.
SPOOL OFF

-- Make all changes permanent.
COMMIT;
