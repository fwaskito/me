--
-- File			: trigger.sql
-- Author		: F. Waskito
-- Created on 		: 2024-06-28
-- Database		: PostgreSQL
-- Database version	: 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Last modified	: 2024-07-31
--


DROP TRIGGER IF EXISTS employee_bu;
DROP TRIGGER IF EXISTS employee_bd;
DROP FUNCTION IF EXISTS act_employee_bu;
DROP FUNCTION IF EXISTS act_employee_bd;


/*==========================================================
Before Update Employee Trigger (Target: Employee History)
-----------------------------------------------------------*/
-- Trigger function
CREATE OR REPLACE FUNCTION act_employee_bu(
)
RETURNS trigger
AS $$
BEGIN
    	DELETE FROM employee_history
	WHERE employee_id = old.id
	  AND modif_action='update'
	  AND EXISTS (SELECT r_count
		      FROM (SELECT count(*) r_count
			    FROM employee_history
			    WHERE employee_id = old.id
			      AND modif_action='update') AS t);

    	INSERT INTO employee_history
	    SELECT e.id, 'update',
		   current_date, 'No',
		   e.age, e.department_id,
		   e.dist_from_home, e.education,
		   e.education_field, e.env_satisfaction,
		   e.job_satisfaction, e.marital_status,
		   e.num_comp_worked, e.monthly_income,
		   e.work_life_balance, e.years_at_company
	    FROM employee AS e
            WHERE e.id = old.id;

	RETURN new;
END;
$$
LANGUAGE plpgsql;

-- Trigger
CREATE OR REPLACE TRIGGER employee_bu
    BEFORE UPDATE ON employee
    FOR each ROW
    EXECUTE FUNCTION act_employee_bu();


/*==========================================================
Before Delete Employee Trigger (Target: Employee History)
-----------------------------------------------------------*/
--- Trigger Function
CREATE OR REPLACE FUNCTION act_employee_bd(
)
RETURNS trigger
AS $$
BEGIN
    	INSERT INTO employee_history
	    SELECT e.id, 'delete',
	           current_date, 'Yes',
		   e.age, e.department_id,
		   e.dist_from_home, e.education,
		   e.education_field, e.env_satisfaction,
		   e.job_satisfaction, e.marital_status,
		   e.num_comp_worked, e.monthly_income,
		   e.work_life_balance, e.years_at_company
	    FROM employee AS e
            WHERE e.id = old.id;

	RETURN old;
END;
$$
LANGUAGE plpgsql;

-- Trigger
CREATE OR REPLACE TRIGGER employee_bd
    BEFORE DELETE ON employee
    FOR each ROW
    EXECUTE FUNCTION act_employee_bd();

