--------------------------------------------------------
--  File created - Thursday-March-01-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger TRIG_AUDIT_TRAIL_LOGGER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "C3444086"."TRIG_AUDIT_TRAIL_LOGGER" FOR INSERT OR
  UPDATE ON LDS_PLACEMENT COMPOUND TRIGGER 
  
  action_type CHAR(1);
  event   VARCHAR2(255) := 'Standard Event';
  max_sal NUMBER;
  
  --Set the variables up.  
  BEFORE STATEMENT
  IS
  BEGIN
    IF INSERTING THEN
      action_type := 'I';
    ELSIF UPDATING THEN
      action_type := 'U';
      SELECT MAX(actual_salary) INTO max_sal FROM lds_placement;
    END IF;
  END BEFORE STATEMENT;
  
  --Check whether the salary update is greater than the current highest salary in the table.
  BEFORE EACH ROW 
  IS
  BEGIN
    IF max_sal < :NEW.actual_salary AND UPDATING THEN
      event   := 'New Highest Salary: ' || :NEW.actual_salary;
    END IF;
  END BEFORE EACH ROW;

  --Audit the trigger state.
  AFTER STATEMENT
  IS
  BEGIN
    INSERT
    INTO S_AUDIT_TRAIL
      (
        id,
        datestamp,
        action,
        username,
        event
      )
      VALUES
      (
        audit_trail.NEXTVAL,
        TO_CHAR(SYSDATE, 'MM/DD/YYYY'),
        action_type,
        USER,
        event
      );
  END AFTER STATEMENT;
END;
/
ALTER TRIGGER "C3444086"."TRIG_AUDIT_TRAIL_LOGGER" ENABLE;
