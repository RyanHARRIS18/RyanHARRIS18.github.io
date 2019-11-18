/*
||  Name:          apply_lab_10.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 10 lab.
*/

-- Open log file.
SPOOL base_t_ots.txt

SET ECHO OFF
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.1: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

-- step 1.1
/* Unconditional drops of objects. */
DROP TYPE base_t FORCE;

-- Create or replace a generic object type: given to us
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( ONAME  VARCHAR2(30)
  , NAME   VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t
    RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION base_t
    ( ONAME  VARCHAR2
    , NAME   VARCHAR2 )
    RETURN SELF AS RESULT
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (ONAME VARCHAR2)
  , MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

--verify 1.1
desc base_t

DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.1: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

-- step 1.2
/* Unconditional drops of objects. */

DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.2: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

DROP SEQUENCE logger_s;
DROP TABLE logger;

/* Create logger table. */
CREATE TABLE logger
( logger_id  NUMBER
, log_text    base_t );

/* Create logger_s sequence. */
CREATE SEQUENCE logger_s;

/* Verify 1.2 */
DESC logger


DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.2: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 
 
--step 1.3

DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.3: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

/* Create base_t object body. Given to US*/
CREATE OR REPLACE
  TYPE BODY base_t IS
CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN 
    self.ONAME := 'BASE_T';
    RETURN;
END;
  
  CONSTRUCTOR FUNCTION base_t
  ( ONAME  VARCHAR2
  , NAME   VARCHAR2 ) RETURN SELF AS RESULT IS
  BEGIN
     self.ONAME := ONAME;
      /* Assign a designated value or assign a null value. */
      IF NAME IS NOT NULL AND NAME IN ('NEW','OLD') THEN
        self.NAME := NAME;
      END IF;
    RETURN;
  END;
  
  MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN self.NAME;
  END get_name;
  
  MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
  BEGIN
    RETURN self.ONAME;
  END get_oname;
  
  MEMBER PROCEDURE set_oname (ONAME VARCHAR2) IS
  BEGIN
    self.ONAME := ONAME;
  END set_oname;
  
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN 'Object is ['||self.ONAME||']';
  END to_string;
END;
/
-- verify 1.3 : Given to Us------------------------------------------------------------------------------------------------------
DECLARE
  /* Create a default instance of the object type. */
  lv_instance  BASE_T := base_t();
BEGIN
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');
 
  /* Set the oname value to a new value. */
  lv_instance.set_oname('SUBSTITUTE');
 
  /* Print the default value of the oname attribute. */
  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/



/*
You can insert a base_t object instance with the default no parameter constructor, like*/
INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

-- You can insert a base_t object instance with the a parameter-driven constructor, like
DECLARE
  /* Declare a variable of the UDT type. */
  lv_base  BASE_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_base := base_t(
      ONAME => 'BASE_T'
    , NAME => 'NEW' );
 
    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);
 
    /* Commit the record. */
    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';


DECLARE 
   message  varchar2(100):= '*************************  SECTION 1.3: END  ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

-------- step 2.1 ----------------------------------------------------------------------------------------------------------------
-- create the item_t subtype by modeling its columns on the item table in the video store code and extending the base_t object type. You exclude any BFILE, BLOB, CLOB, and NCLOB columns from the item_t type definition. You should include overriding methods for the get_name and to_string functions.

/*
SQL> desc item
 Name                                      Null?    Type
 ITEM_ID                                   NOT NULL NUMBER
 ITEM_BARCODE                              NOT NULL VARCHAR2(20)
 ITEM_TYPE                                 NOT NULL NUMBER
 ITEM_TITLE                                NOT NULL VARCHAR2(60)
 ITEM_SUBTITLE                                      VARCHAR2(60)
 ITEM_DESC                                 NOT NULL CLOB
 ITEM_PHOTO                                         BINARY FILE LOB
 ITEM_RATING                               NOT NULL VARCHAR2(8)
 ITEM_RATING_AGENCY                        NOT NULL VARCHAR2(4)
 ITEM_RELEASE_DATE                         NOT NULL DATE
 CREATED_BY                                NOT NULL NUMBER
 CREATION_DATE                             NOT NULL DATE
 LAST_UPDATED_BY                           NOT NULL NUMBER
 LAST_UPDATE_DATE                          NOT NULL DATE
 TEXT_FILE_NAME                                     VARCHAR2(45)  
 Contents of Item Table*/
 
 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.1: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

 DROP TYPE item_t FORCE;
 CREATE OR REPLACE TYPE item_t UNDER base_t
    ( ITEM_ID             NUMBER
    , ITEM_BARCODE        VARCHAR2(20)
    , ITEM_TYPE           NUMBER
    , ITEM_TITLE          VARCHAR2(60)
    , ITEM_SUBTITLE       VARCHAR2(60)
    , ITEM_RATING         VARCHAR2(8)
    , ITEM_RATING_AGENCY  VARCHAR2(4)
    , ITEM_RELEASE_DATE   DATE
    , CREATED_BY          NUMBER
    , CREATION_DATE       DATE
    , LAST_UPDATED_BY     NUMBER
    , LAST_UPDATE_DATE    DATE
  , CONSTRUCTOR FUNCTION item_t
    ( ONAME               VARCHAR2
    , NAME                VARCHAR2
    , ITEM_ID             NUMBER
    , ITEM_BARCODE         VARCHAR2
    , ITEM_TYPE            NUMBER
    , ITEM_TITLE           VARCHAR2
    , ITEM_SUBTITLE        VARCHAR2
    , ITEM_RATING          VARCHAR2
    , ITEM_RATING_AGENCY   VARCHAR2
    , ITEM_RELEASE_DATE    DATE
    , CREATED_BY           NUMBER
    , CREATION_DATE        DATE
    , LAST_UPDATED_BY      NUMBER
    , LAST_UPDATE_DATE     DATE) RETURN SELF AS RESULT
    , CONSTRUCTOR FUNCTION item_t
    ( oname              VARCHAR2
    , name               VARCHAR2 ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

----verify step 2.1----
 desc item_t
 
  DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.1: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 
 ----step 2.2----
/*--------------------------------------------------------------
You need to implement a item_t object body. Every instance of the item_t class should do the following:
Return the entire record structure of any instance of the item_t object type.
Return the name result for any instance of the object type when you call the get_name function
Return the oname value enclosed in square brackets when you call the to_string function for any instance of the item_t object subtype. You implement this by leveraging generalized invocation of the to_string function in the parent class. You should append the name variable’s contents inside square brackets when you override the behavior of the to_string function in the item_t subtype.
Return a NEW or OLD value as the name value when you call the get_name function of any item_t object instance.

The instructions of set to create item_t object-----------------------*/

 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.2: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

CREATE OR REPLACE TYPE BODY item_t IS
 CONSTRUCTOR FUNCTION item_t
    ( ONAME              VARCHAR2
    , NAME               VARCHAR2
    , ITEM_ID            NUMBER
    , ITEM_BARCODE       VARCHAR2
    , ITEM_TYPE          NUMBER
    , ITEM_TITLE         VARCHAR2
    , ITEM_SUBTITLE      VARCHAR2
    , ITEM_RATING        VARCHAR2
    , ITEM_RATING_AGENCY VARCHAR2
    , ITEM_RELEASE_DATE  DATE
    , CREATED_BY         NUMBER
    , CREATION_DATE      DATE
    , LAST_UPDATED_BY    NUMBER
    , LAST_UPDATE_DATE   DATE) RETURN SELF AS RESULT IS
    
  BEGIN
      /* Assign inputs to instance variables. */    
      self.ONAME := ONAME;

      /* Assign a designated value or assign a null value. */
      IF NAME IS NOT NULL AND NAME IN ('NEW','OLD') THEN
        self.NAME := NAME;
      END IF;

      /* Assign inputs to instance variables. */  
      self.ITEM_ID   := ITEM_ID  ;
      self.ITEM_BARCODE := ITEM_BARCODE;
      self.ITEM_TYPE := ITEM_TYPE;
      self.ITEM_TITLE := ITEM_TITLE;
      self.ITEM_SUBTITLE := ITEM_SUBTITLE;
      self.ITEM_RATING := ITEM_RATING;
      self.ITEM_RATING_AGENCY := ITEM_RATING_AGENCY;
      self.ITEM_RELEASE_DATE := ITEM_RELEASE_DATE;
      self.CREATED_BY := CREATED_BY;
      self.CREATION_DATE := CREATION_DATE;
      self.LAST_UPDATED_BY := LAST_UPDATED_BY;
      self.LAST_UPDATE_DATE := LAST_UPDATE_DATE;
      /* Return an instance of self. */
      RETURN;
    END;

    
    CONSTRUCTOR FUNCTION item_t
    ( ONAME       VARCHAR2
    , NAME        VARCHAR2) RETURN self AS RESULT IS
    BEGIN
      /* Assign inputs to instance variables. */    
      self.ONAME := ONAME;

      /* Assign a designated value or assign a null value. */
      IF NAME IS NOT NULL AND NAME IN ('NEW','OLD') THEN
        self.NAME := NAME;
      END IF;

      /* Return an instance of self. */
      RETURN;
    END;
      
 /* An overriding function for the generalized class. */
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (SELF AS base_t).get_name();
    END get_name;

    /* An overriding function for the generalized class. */
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (SELF AS base_t).to_string()||'.['||SELF.NAME||']';
    END to_string;
  END;
/
 SHOW ERRORS
DESC item_t
 
 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.2: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/  
 
--2.3---------
/*--------------------------------------------------------------
You create the contact_t subtype by modeling its columns on the contact table in the video store code. You exclude any BFILE, BLOB, CLOB, and NCLOB columns from the item_t type definition. You should include overriding methods for the get_name and to_string functions.
instructions for step 2.3-----------------------*/

/*--------------------------------------------------------------------
SQL> desc contact
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CONTACT_ID                                NOT NULL NUMBER
 MEMBER_ID                                 NOT NULL NUMBER
 CONTACT_TYPE                              NOT NULL NUMBER
 LAST_NAME                                 NOT NULL VARCHAR2(20)
 FIRST_NAME                                NOT NULL VARCHAR2(20)
 MIDDLE_NAME                                        VARCHAR2(20)
 CREATED_BY                                NOT NULL NUMBER
 CREATION_DATE                             NOT NULL DATE
 LAST_UPDATED_BY                           NOT NULL NUMBER
 LAST_UPDATE_DATE                          NOT NULL DATE
*Contact Table results ------------------------------------------------- */
 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.3: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

DROP TYPE CONTACT_T FORCE;

CREATE OR REPLACE TYPE CONTACT_T UNDER base_t
 ( CONTACT_ID         NUMBER
 , MEMBER_ID          NUMBER
 , CONTACT_TYPE       NUMBER
 , LAST_NAME          VARCHAR2(20)
 , FIRST_NAME         VARCHAR2(20)
 , MIDDLE_NAME        VARCHAR2(20)
 , CREATED_BY         NUMBER
 , CREATION_DATE      DATE
 , LAST_UPDATED_BY    NUMBER
 , LAST_UPDATE_DATE   DATE
  , CONSTRUCTOR FUNCTION contact_t
(  ONAME              VARCHAR2
 , NAME               VARCHAR2
 , CONTACT_ID         NUMBER
 , MEMBER_ID          NUMBER
 , CONTACT_TYPE       NUMBER
 , LAST_NAME          VARCHAR2
 , FIRST_NAME         VARCHAR2
 , MIDDLE_NAME        VARCHAR2
 , CREATED_BY         NUMBER
 , CREATION_DATE      DATE
 , LAST_UPDATED_BY    NUMBER
 , LAST_UPDATE_DATE   DATE) RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION contact_t
    ( ONAME              VARCHAR2
    , NAME               VARCHAR2 ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.3: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.4: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 
--- step 2.4-------
CREATE OR REPLACE 
TYPE BODY CONTACT_T IS CONSTRUCTOR FUNCTION CONTACT_T 
( ONAME               VARCHAR2
 , NAME               VARCHAR2 
 , CONTACT_ID         NUMBER
 , MEMBER_ID          NUMBER
 , CONTACT_TYPE       NUMBER
 , LAST_NAME          VARCHAR2
 , FIRST_NAME         VARCHAR2
 , MIDDLE_NAME        VARCHAR2
 , CREATED_BY         NUMBER
 , CREATION_DATE      DATE
 , LAST_UPDATED_BY    NUMBER
 , LAST_UPDATE_DATE   DATE) RETURN SELF AS RESULT is
  BEGIN
      /* Assign inputs to instance variables. */    
      self.ONAME := ONAME;

      /* Assign a designated value or assign a null value. */
      IF NAME IS NOT NULL AND NAME IN ('NEW','OLD') THEN
        self.NAME := NAME;
      END IF;

      /* Assign inputs to instance variables. */  
      self.CONTACT_ID       := CONTACT_ID;
      self.MEMBER_ID        := MEMBER_ID;
      self.CONTACT_TYPE     := CONTACT_TYPE;
      self.LAST_NAME        := LAST_NAME;
      self.FIRST_NAME       := FIRST_NAME;
      self.MIDDLE_NAME      := MIDDLE_NAME;
      self.CREATED_BY       := CREATED_BY;
      self.CREATION_DATE    := CREATION_DATE;
      self.CREATED_BY       := CREATED_BY;
      self.CREATION_DATE    := CREATION_DATE;
      self.LAST_UPDATED_BY  := LAST_UPDATED_BY;
      self.LAST_UPDATE_DATE := LAST_UPDATE_DATE;
      /* Return an instance of self. */
      RETURN;
    END;
    
    
     CONSTRUCTOR FUNCTION CONTACT_T
    ( ONAME       VARCHAR2
    , NAME        VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
      /* Assign inputs to instance variables. */
      SELF.ONAME := ONAME;

      /* Assign a designated value or assign a null value. */
--   Return a NEW or OLD value as the name value when you call the              
--        get_name function of any item_t object instance.
      IF NAME IS NOT NULL AND NAME IN ('NEW','OLD') THEN
        SELF.NAME := NAME;
      END IF;

      /* Return an instance of self. */
      RETURN;
    END;
    
    
 /* An overriding function for the generalized class. */
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).get_name();
    END get_name;

    /* An overriding function for the generalized class. */
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string()||'.['||self.NAME||']';
    END to_string;
  END;
/
 SHOW ERRORS
DESC item_t

 DECLARE 
   message  varchar2(100):= '*************************  SECTION 2.4: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

----------------------------step 3 -----------------------------------
-- You can insert a base_t object instance with the a parameter-driven constructor, like


 DECLARE 
   message  varchar2(100):= '*************************  SECTION 3.1: START   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 

DECLARE
  /* Declare a variable of the UDT type. */
  lv_item  ITEM_T;
  lv_contact CONTACT_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_item := item_t(
      ONAME => 'ITEM_T'
    , NAME => 'NEW' );
    
     lv_contact := contact_t(
      ONAME => 'CONTACT_T'
    , NAME => 'NEW' );
 
    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_item);
    
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_contact);
 
    /* Commit the record. */
    COMMIT;
END;
/

-- Verify Step 2 --
COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');




 DECLARE 
   message  varchar2(100):= '*************************  SECTION 3.1: END   ******************************'; 
BEGIN 
   dbms_output.put_line(message); 
END; 
/ 









-- Close log file.
SPOOL OFF
