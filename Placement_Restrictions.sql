--------------------------------------------------------
--  File created - Tuesday-February-27-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger PLACEMENT_RESTRICTIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "C3444086"."PLACEMENT_RESTRICTIONS" BEFORE
  INSERT ON LDS_PLACEMENT 
  DECLARE 
  daily_insert_amount NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO daily_insert_amount
    FROM S_AUDIT_TRAIL
    WHERE ACTION           = 'I'
    AND DATESTAMP          = TO_CHAR(SYSDATE, 'MM/DD/YYYY')
    AND USER               = USERNAME;
    IF daily_insert_amount >= 5 THEN
      RAISE_APPLICATION_ERROR(-20000, 'You have reached your daily limit to insert new placements.(No more than 5)');
    ELSE
      DBMS_OUTPUT.put_line('Success!');
    END IF;
  END;
/
ALTER TRIGGER "C3444086"."PLACEMENT_RESTRICTIONS" ENABLE;
