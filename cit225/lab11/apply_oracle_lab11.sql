-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab11.sql
--  Lab Assignment: Lab #11
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
--   sql> @apply_oracle_lab11.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

-- Spool log file.
SPOOL apply_oracle_lab11.txt


-- --------------------------------------------------------
--  Step #1
--  -------
--  This step requires that you use the query from Lab #10 that you used 
-- to insert records into the RENTAL table. You need to put it inside the 
-- USING clause of the MERGE statement as the query, resolve which columns 
-- you use in an UPDATE statement, and resolve which columns you use in an 
-- INSERT statement.
-- --------------------------------------------------------
 
-- Insert step #1 statements here.
 
-- --------------------------------------------------------

MERGE INTO rental target
USING (
 SELECT   DISTINCT
             r.rental_id
    ,        c.contact_id
    ,        tu.check_out_date AS check_out_date
    ,        tu.return_date AS return_date
    ,        1 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date
    FROM     member m INNER JOIN contact c
    ON m.member_id = c.member_id INNER JOIN transaction_upload tu
    ON c.first_name = tu.first_name
    AND        NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
    AND        c.last_name = tu.last_name
    AND        tu.account_number = m.account_number LEFT JOIN rental r
    ON         c.contact_id = r.customer_id
    AND        TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
    AND        TRUNC(tu.return_date) = TRUNC(r.return_date)
    ) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
, source.contact_id
, source.check_out_date
, source.return_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental after merge"
FROM     rental;


/*Rental after merge
------------------
	     4,689
 
1 row selected.*/

--  Step #2
--  -------
    /* This step requires that the preceding MERGE statement 
    ran successfully and that you use the query from Lab #10 
    that you used to insert records into the RENTAL_ITEM table.
    You need to put it inside the USING clause of the MERGE 
    statement as the query, resolve which columns you use in 
    an UPDATE statement, and resolve which columns you use 
    in an INSERT statement. */
-- --------------------------------------------------------
 
-- Insert step #2 statements here.
 
-- --------------------------------------------------------


MERGE INTO rental_item target
USING ( 
SELECT    
             ri.rental_item_id
    ,        r.rental_id
    ,        tu.item_id
    ,        1001 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1001 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date
    ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
    ,        cl.common_lookup_id AS rental_item_type
    FROM     member m INNER JOIN contact c
            ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
            ON       c.first_name = tu.first_name
            AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
            AND      c.last_name = tu.last_name
            LEFT JOIN rental r
            ON       c.contact_id = r.customer_id
            AND      TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
            AND      TRUNC(tu.return_date) = TRUNC(r.return_date)
            INNER JOIN common_lookup cl
            ON   cl.common_lookup_table = 'RENTAL_ITEM'
            AND     cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
            AND     cl.common_lookup_type = tu.rental_item_type
            LEFT JOIN rental_item ri
            ON r.rental_id = ri.rental_id) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval
, source.rental_id
, source.item_id
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date
, source.rental_item_price
, source.rental_item_type);

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental Item after merge"
FROM     rental_item;


--  Step #3
--  -------
--  Using the query from Lab 10, Step 3, insert the query
--  in the MERGE statement to the TRANSACTION table.
-- --------------------------------------------------------
 
-- Insert step #3 statements here.
 
-- --------------------------------------------------------

MERGE INTO transaction target
USING ( 
SELECT   t.transaction_id
    ,        tu.payment_account_number AS transaction_account
    ,        cl1.common_lookup_id AS transaction_type
    ,        TRUNC(tu.transaction_date) AS transaction_date
    ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
    ,        r.rental_id
    ,        cl2.common_lookup_id AS payment_method_type
    ,        m.credit_card_number AS payment_account_number
    ,        1001 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1001 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date   
    FROM     member m INNER JOIN contact c
            ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
            ON       c.first_name = tu.first_name
            AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
            AND      c.last_name = tu.last_name
            INNER JOIN rental r
            ON       c.contact_id = r.customer_id
            AND      TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
            AND      TRUNC(tu.return_date) = TRUNC(r.return_date)
            INNER JOIN common_lookup cl1
            ON   cl1.common_lookup_table = 'TRANSACTION'
            AND      cl1.common_lookup_column = 'TRANSACTION_TYPE'
            AND     cl1.common_lookup_type = tu.transaction_type
            INNER JOIN common_lookup cl2
            ON      cl2.common_lookup_table = 'TRANSACTION'
            AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
            AND     cl2.common_lookup_type = tu.payment_method_type
            LEFT JOIN TRANSACTION t
            ON t.transaction_account = tu.payment_account_number
            AND t.rental_id = r.rental_id
            AND t.transaction_type = cl1.common_lookup_id
            AND t.transaction_date = tu.transaction_date
            AND t.payment_method_type = cl2.common_lookup_id
            AND t.payment_account_number = m.credit_card_number
             GROUP BY t.transaction_id
,        tu.payment_account_number
,        cl1.common_lookup_id
,        tu.transaction_date
,        r.rental_id
,        cl2.common_lookup_id
,        m.credit_card_number
,        1
,        TRUNC(SYSDATE)
,        1
,        TRUNC(SYSDATE))
source
ON (target.transaction_id = source.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
, source.TRANSACTION_ACCOUNT                       
, source.TRANSACTION_TYPE                         
, source.TRANSACTION_DATE                         
, source.TRANSACTION_AMOUNT                       
, source.RENTAL_ID                                
, source.PAYMENT_METHOD_TYPE                       
, source.PAYMENT_ACCOUNT_NUMBER                    
, source.CREATED_BY                                
, source.CREATION_DATE                             
, source.LAST_UPDATED_BY                           
, source.LAST_UPDATE_DATE);

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Transaction after merge"
FROM     transaction;

--  Step #4
--  -------
--  Insert the MERGE statements to the RENTAL, RENTAL_ITEM,
--  and TRANSACTION tables into the UPLOAD_TRANSACTION
--  procedure; execute the UPLOAD_TRANSACTION procedure,
--  and query the results from the target tables; and
--  re-execute the UPLOAD_TRANSACTION procedure to
--  verify that the query returns the same set and only
--  inserts new records.
-- --------------------------------------------------------
 
-- Insert step #4 statements here.

-- Create a procedure to wrap the transaction.

-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_transaction IS 
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;
 

  MERGE INTO rental target
USING (
 SELECT   DISTINCT
             r.rental_id
    ,        c.contact_id
    ,        tu.check_out_date AS check_out_date
    ,        tu.return_date AS return_date
    ,        1 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date
    FROM     member m INNER JOIN contact c
    ON m.member_id = c.member_id INNER JOIN transaction_upload tu
    ON c.first_name = tu.first_name
    AND        NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
    AND        c.last_name = tu.last_name
    AND        tu.account_number = m.account_number LEFT JOIN rental r
    ON         c.contact_id = r.customer_id
    AND        TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
    AND        TRUNC(tu.return_date) = TRUNC(r.return_date)
    ) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
, source.contact_id
, source.check_out_date
, source.return_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

 
MERGE INTO rental_item target
USING ( 
SELECT    
             ri.rental_item_id
    ,        r.rental_id
    ,        tu.item_id
    ,        1001 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1001 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date
    ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
    ,        cl.common_lookup_id AS rental_item_type
    FROM     member m INNER JOIN contact c
            ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
            ON       c.first_name = tu.first_name
            AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
            AND      c.last_name = tu.last_name
            LEFT JOIN rental r
            ON       c.contact_id = r.customer_id
            AND      TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
            AND      TRUNC(tu.return_date) = TRUNC(r.return_date)
            INNER JOIN common_lookup cl
            ON   cl.common_lookup_table = 'RENTAL_ITEM'
            AND     cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
            AND     cl.common_lookup_type = tu.rental_item_type
            LEFT JOIN rental_item ri
            ON r.rental_id = ri.rental_id) source
ON (target.rental_item_id = source.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval
, source.rental_id
, source.item_id
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date
, source.rental_item_price
, source.rental_item_type);
 
MERGE INTO transaction target
USING ( 
SELECT   t.transaction_id
    ,        tu.payment_account_number AS transaction_account
    ,        cl1.common_lookup_id AS transaction_type
    ,        TRUNC(tu.transaction_date) AS transaction_date
    ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
    ,        r.rental_id
    ,        cl2.common_lookup_id AS payment_method_type
    ,        m.credit_card_number AS payment_account_number
    ,        1001 AS created_by
    ,        TRUNC(SYSDATE) AS creation_date
    ,        1001 AS last_updated_by
    ,        TRUNC(SYSDATE) AS last_update_date   
    FROM     member m INNER JOIN contact c
            ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
            ON       c.first_name = tu.first_name
            AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
            AND      c.last_name = tu.last_name
            INNER JOIN rental r
            ON       c.contact_id = r.customer_id
            AND      TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
            AND      TRUNC(tu.return_date) = TRUNC(r.return_date)
            INNER JOIN common_lookup cl1
            ON   cl1.common_lookup_table = 'TRANSACTION'
            AND      cl1.common_lookup_column = 'TRANSACTION_TYPE'
            AND     cl1.common_lookup_type = tu.transaction_type
            INNER JOIN common_lookup cl2
            ON      cl2.common_lookup_table = 'TRANSACTION'
            AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
            AND     cl2.common_lookup_type = tu.payment_method_type
            LEFT JOIN TRANSACTION t
            ON t.transaction_account = tu.payment_account_number
            AND t.rental_id = r.rental_id
            AND t.transaction_type = cl1.common_lookup_id
            AND t.transaction_date = tu.transaction_date
            AND t.payment_method_type = cl2.common_lookup_id
            AND t.payment_account_number = m.credit_card_number
             GROUP BY t.transaction_id
,        tu.payment_account_number
,        cl1.common_lookup_id
,        tu.transaction_date
,        r.rental_id
,        cl2.common_lookup_id
,        m.credit_card_number
,        1
,        TRUNC(SYSDATE)
,        1
,        TRUNC(SYSDATE))
source
ON (target.transaction_id = source.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = source.last_updated_by
,          last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
, source.TRANSACTION_ACCOUNT                       
, source.TRANSACTION_TYPE                         
, source.TRANSACTION_DATE                         
, source.TRANSACTION_AMOUNT                       
, source.RENTAL_ID                                
, source.PAYMENT_METHOD_TYPE                       
, source.PAYMENT_ACCOUNT_NUMBER                    
, source.CREATED_BY                                
, source.CREATION_DATE                             
, source.LAST_UPDATED_BY                           
, source.LAST_UPDATE_DATE);
 
  -- Save the changes.
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/
 
 EXECUTE upload_transaction;
 
 COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;

        

-- --------------------------------------------------------
--  Step #5
--  -------
--  Write a query that uses date functions to report
--  aggregated transaction amount values for base revenue,
--  110% of revenue, 120% of revenue, 90% of revenue,
--  80% or revenue.
-- --------------------------------------------------------
 
-- Insert step #5 statements here.
 set linesize 150
select
   il.month AS "Month Year"
,  il.base AS "BASE REVENUE"
,  il.plus10 AS "10 PLUS REVENUE"
,  il.plus20 AS "20 PLUS REVENUE"
,  il.only10 AS "10 PLUS DIFF"
, il.only20 AS "20 PLUS DIFF"
  from
      (select 
 concat(TO_CHAR(t.transaction_date, 'MON'),CONCAT(' ',EXTRACT(YEAR From t.transaction_date))) AS month
 , EXTRACT(MONTH From t.transaction_date) AS sortkey
 , TO_CHAR(SUM(t.transaction_amount), '$9,999,999.00') AS base
 , TO_CHAR(SUM(t.transaction_amount) * 1.1, '$9,999,999.00') AS plus10
 , TO_CHAR(SUM(t.transaction_amount) * 1.2, '$9,999,999.00') AS plus20
 , TO_CHAR(SUM(t.transaction_amount) * 0.1, '$9,999,999.00') AS only10
 , TO_CHAR(SUM(t.transaction_amount) * 0.2, '$9,999,999.00') AS only20
       FROM transaction t
 Where EXTRACT(YEAR FROM t.transaction_date) = 2009
 group by concat(TO_CHAR(t.transaction_date, 'MON'),CONCAT(' ',EXTRACT(YEAR FROM t.transaction_date))), EXTRACT(MONTH FROM
 t.transaction_date)) il
 order by il.sortkey;
-- ... insert lab 11 commands here ...

SELECT   TO_CHAR(9999,'$9,999,999.00') AS "Formatted"
FROM     dual;

SPOOL OFF
