/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
SPOOL apply_plsql_lab5.LOG

SET SERVEROUTPUT ON SIZE UNLIMITED;
-- RATING_AGENCY_S sequence that starts with a value of 1001.
CREATE SEQUENCE rating_agency_s START WITH 1001;

--You can create the new RATING_AGENCY table by using the data from the ITEM table,--
CREATE TABLE rating_agency AS
SELECT rating_agency_s.NEXTVAL AS rating_agency_id
,      il.item_rating AS rating
,      il.item_rating_agency AS rating_agency
FROM  (SELECT DISTINCT
              i.item_rating
       ,      i.item_rating_agency
       FROM   item i) il;

SELECT rating_agency_id
,rating
,rating_agency
FROM rating_agency; 

--Add a new RATING_AGENCY_ID column to the ITEM table.
ALTER TABLE ITEM ADD (RATING_AGENCY_ID  NUMBER);

    
--A SQL structure or composite object type, as qualified above--
CREATE OR REPLACE TYPE rating_agency_obj is OBJECT
( rating_agency_id NUMBER
, rating          VARCHAR2(8)
, rating_agency   VARCHAR2(4));
/

--A SQL collection, as a table of the composite object type.
CREATE OR REPLACE TYPE pl_rating_agency IS TABLE OF rating_agency_obj;
/


SET NULL ''
COLUMN table_name   FORMAT A18
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

--Implement your anonymous PL/SQL block to read the RATING_AGENCY reference cursor into a collection--
DECLARE
CURSOR c IS 
SELECT rating_agency_id
,rating
,rating_agency
FROM rating_agency; 

  lv_rating_agency PL_RATING_AGENCY := pl_rating_agency();
 
BEGIN
  /* Implement assignment of variables inside a loop, which mimics
     how you would handle them if they were read from a cursor loop. */
     
     /*reads the cursor contents and assigns them to a local variable of the SQL collection data type.*/
     FOR i IN c LOOP
    lv_rating_agency.EXTEND;
    lv_rating_agency(lv_rating_agency.COUNT) := rating_agency_obj(i.rating_agency_id, i.rating, i.rating_agency);
  END LOOP;
  
  
--updates the RATING_AGENCY_ID column in the item table by checking the ITEM_RATING and ITEM_RATING_AGENCY column values with the members of the collection’s composite object type.--
  FOR i IN 1..lv_rating_agency.COUNT LOOP
    UPDATE item SET rating_agency_id = lv_rating_agency(i).rating_agency_id
    WHERE item_rating = lv_rating_agency(i).rating
    AND item_rating_agency = lv_rating_agency(i).rating_agency;
  END LOOP;
     
END;
/

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

SPOOL OFF
/
