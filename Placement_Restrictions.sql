--------------------------------------------------------
--  File created - Wednesday-February-28-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger PLACEMENT_RESTRICTIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "C3444086"."PLACEMENT_RESTRICTIONS" FOR INSERT OR
  UPDATE ON LDS_PLACEMENT COMPOUND TRIGGER 
  username VARCHAR2(255);
  daily_insert_amount NUMBER;
  --Set the variables up.
  BEFORE STATEMENT
IS
BEGIN
  SELECT cst_name INTO username FROM lds_consultant WHERE cst_name = USER;
  SELECT COUNT(*)
  INTO daily_insert_amount
  FROM S_AUDIT_TRAIL
  WHERE ACTION  = 'I'
  AND DATESTAMP = TO_CHAR(SYSDATE, 'MM/DD/YYYY')
  AND USER      = USERNAME;
END BEFORE STATEMENT;
--Make sure that all parameters are met so that a user may modify the table.
BEFORE EACH ROW
IS
BEGIN
  --Check user is a consultant else throw error.
  IF USER != username THEN
    RAISE_APPLICATION_ERROR(-20001, 'YOU SHALL NOT MODIFY! *strikes ground with keyboard*');
  END IF;
  IF INSERTING THEN
    --Before Execution check the user has not inserted over 5 times today.
    IF daily_insert_amount <= 5 THEN
      DBMS_OUTPUT.put_line(username || ': Success!');
    ELSE
      RAISE_APPLICATION_ERROR(-20002, 'You have reached your daily limit to insert new placements.(No more than 5)');
    END IF;
  END IF;
  
  IF UPDATING AND :OLD.ptl_actual_start_date IS NULL THEN
    DBMS_OUTPUT.put_line(username || ': Success!');
  ELSE
    RAISE_APPLICATION_ERROR(-20003, 'Not an open placement, modification denied.');
  END IF;
END BEFORE EACH ROW;
END;
/
ALTER TRIGGER "C3444086"."PLACEMENT_RESTRICTIONS" ENABLE;
