
 --when you get locked out of sqlplus--
[student@localhost lab6]$ sqlplus 
Enter user-name: sys as sysdba
Enter password: 
SQL> startup open
SQL> SQL> conn student/student
SQL> exit
[student@localhost lab6]$ sqlplus student/student


-- INSERT STATEMENT--
--faculty in class stuff--
SELECT student.first_name, student.last_name
 FROM student JOIN faculty
 ON studnet.mentor = faculty.faculty_id 
 
UPDATE item 
SET item_title = 'Star Wars III: On Stanger Tides'
,   item_rating = 'PG'
WHERE item_title like 'Star Wars%';

rollback


INSERT INTO  Faculty
(  Faculty_ID                  
, department                   
, fname                        
, lname                       
, office )
  VALUES
    ('1'				       -- faculty_ID
    ,'cit'					       -- department
    ,'david'					       -- fname
    ,'miller'					       -- lname
    ,'267-B'					       -- office
  
);
--UPDATE STATEMENTS--

UPDATE student
SET mentor = 3
WHERE mentor = 2;



UPDATE student
SET mentor = 
(SELECT facult_id from faculty where first_name = 'Felix')
WHERE mentor = 
(SELECT facult_id from faculty where first_name = 'David');


grep -irn "error"

CREATE TABLE Faculty
( Faculty_ID                   NUMBER       CONSTRAINT nn_Faculty NOT NULL
, department                   VARCHAR2(19)
, fname                        VARCHAR2(10) 
, lname                        VARCHAR2(19) 
, office                        VARCHAR2(10)

, CONSTRAINT pk_Faculty     PRIMARY KEY(Faculty_ID)
);


CREATE TABLE Student
( I_NUMBER                      NUMBER       CONSTRAINT nn_student_1 NOT NULL
, Major                         VARCHAR2(19)
, fname                        VARCHAR2(10) 
, lname                        VARCHAR2(19) 
, MENTOR                        NUMBER  CONSTRAINT nn_student_2 NOT NULL

, CONSTRAINT pk_student_1     PRIMARY KEY( I_NUMBER)
, CONSTRAINT fk_student_2      FOREIGN KEY(MENTOR) REFERENCES Faculty(Faculty_ID)
);

INSERT INTO  Faculty
(  Faculty_ID                  
, department                   
, fname                        
, lname                       
, office )
  VALUES
    ,0222548				       -- faculty_ID
    ,'cit'					       -- department
    ,'david'					       -- fname
    ,'miller'					       -- lname
    ,'267-B'					       -- office
  
);

UPDATE   common_lookup
SET      common_lookup_table = common_lookup_context;
The following shows you how UPDATE an existing row before you ALTER TABLE to DROP the column:

UPDATE   common_lookup
SET      common_lookup_table = 'ITEM'
,        common_lookup_column = 'ITEM_TYPE'
WHERE    common_lookup_context = 'ITEM';



/*
UPDATE   common_lookup
SET      common_lookup_table = common_lookup_context;
 
 COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3; */
