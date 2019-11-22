
-- This is a sample file, and you should display a multiple-line comment
-- identifying the file, author, and date. Here's the format:
/*
   Author: Ryan Harris
   Date:   21-SEP-2019
*/

-- Put code that you call from other scripts here because they may create
-- their own log files. For example, you call other program scripts by
-- putting an "@" symbol before the name of a relative file name or a
-- fully qualified file name.


-- Open your log file and make sure the extension is ".txt".


-- Add an environment command to allow PL/SQL to print to console.
SET SERVEROUTPUT ON SIZE UNLIMITED


-- Put your code here, like this "Hello World!" program.PL/SQL procedure successfully completed.

DECLARE
lv_raw_input VARCHAR2(32767);
lv_input VARCHAR2(32767);

BEGIN
    lv_input := '&1';
    lv_raw_input := '&1';
IF (LENGTH(lv_input) <= 10) THEN
    dbms_output.put_line('Hello '||lv_input||'!'); 
ELSIF  (LENGTH(lv_input) > 10) THEN
    dbms_output.put_line (SUBSTR(lv_raw_input,0,10));
ELSE
    dbms_output.put_line('Hello World!');
    END IF;
-- EXCEPTION
--     dbms_output.put_line(SQLERRM);
END;
/

-- Close your log file.


-- Instruct the program to exit SQL*Plus, which you need when you call a
-- a program from the command line. Please make sure you comment the
-- following command when you want to remain inside the interactive
-- SQL*Plus connection.
QUIT;
