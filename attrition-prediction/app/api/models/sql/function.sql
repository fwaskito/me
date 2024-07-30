--
-- File			: function.sql
-- Author		: F. Waskito
-- Created on 		: 2024-06-28
-- Database		: PostgreSQL
-- Database version	: 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Last modified	: 2024-07-31
--


DROP FUNCTION IF EXISTS get_employees;
DROP FUNCTION IF EXISTS update_employee;
DROP FUNCTION IF EXISTS delete_employee;
DROP FUNCTION IF EXISTS add_employee;
DROP FUNCTION IF EXISTS get_employee_histories;
DROP FUNCTION IF EXISTS get_train_class_distribution;
DROP FUNCTION IF EXISTS get_test_data;
DROP FUNCTION IF EXISTS get_train_data;
DROP FUNCTION IF EXISTS set_employee_attrition;
DROP FUNCTION IF EXISTS reset_test_data;
DROP FUNCTION IF EXISTS get_sys_user;


/*==========================================================
Get Employees Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_employees(
)
RETURNS TABLE(
	id character varying(10), attrition character varying(5),
	age integer, department character varying(10),
	dist_from_home integer, education integer,
	education_field character varying(50), env_satisfaction integer,
	job_satisfaction integer, marital_status character varying(10),
	num_comp_worked integer, monthly_income integer,
	work_life_balance integer, years_at_company integer
)
AS $$
	SELECT t1.id, attrition, age, name AS department,
	       dist_from_home, education, education_field, env_satisfaction,
	       job_satisfaction, marital_status, num_comp_worked, monthly_income,
	       work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY t1.id
$$
LANGUAGE sql;


/*==========================================================
Update Employee Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION update_employee(
	IN p_id character varying(10), p_age integer,
	   p_department_id character varying(10), p_dist_from_home integer,
	   p_education integer, p_education_field character varying(50),
	   p_env_satisfaction integer, p_job_satisfaction integer,
	   p_marital_status character varying(10), p_num_comp_worked integer,
	   p_monthly_income integer, p_work_life_balance integer,
	   p_years_at_company integer
)
RETURNS void
AS $$
	UPDATE employee
    	SET attrition = NULL
    	WHERE id = p_id;

	UPDATE employee
	SET age = p_age, department_id = p_department_id,
	    dist_from_home = p_dist_from_home, education = p_education,
	    education_field = p_education_field, env_satisfaction = p_env_satisfaction,
	    job_satisfaction = p_job_satisfaction, marital_status = p_marital_status,
	    num_comp_worked = p_num_comp_worked, monthly_income = p_monthly_income,
	    work_life_balance = p_work_life_balance, years_at_company = p_years_at_company
	WHERE id = p_id;
$$
LANGUAGE sql;


/*==========================================================
Delete Employee Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION delete_employee(
	IN p_id character varying(10)
)
RETURNS void
AS $$
	DELETE FROM employee
	WHERE id = p_id;
$$
LANGUAGE sql;


/*==========================================================
Add Employee Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION add_employee(
	IN p_id character varying(10), p_attrition character varying(5),
	   p_age integer, p_department_id character varying(10),
	   p_dist_from_home integer, p_education integer,
	   p_education_field character varying(50), p_env_satisfaction integer,
	   p_job_satisfaction integer, p_marital_status character varying(10),
	   p_num_comp_worked integer, p_monthly_income integer,
	   p_work_life_balance integer, p_years_at_company integer
)
RETURNS void
AS $$
	INSERT INTO employee
	VALUES (p_id, p_attrition,
		p_age, p_department_id,
		p_dist_from_home, p_education,
		p_education_field, p_env_satisfaction,
		p_job_satisfaction, p_marital_status,
		p_num_comp_worked, p_monthly_income,
		p_work_life_balance, p_years_at_company);
$$
LANGUAGE sql;


/*==========================================================
Get Employee Histories Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_employee_histories(
)
RETURNS TABLE(
	id character varying(10), attrition character varying(5),
	modif_action character varying(8), modif_date date,
	age integer, department character varying(10),
	dist_from_home integer, education integer,
	education_field character varying(50), env_satisfaction integer,
	job_satisfaction integer, marital_status character varying(10),
	num_comp_worked integer, monthly_income integer,
	work_life_balance integer, years_at_company integer
)
AS $$
	SELECT employee_id, attrition, modif_action, modif_date,
	       age, name AS department, dist_from_home, education,
	       education_field, env_satisfaction, job_satisfaction, marital_status,
	       num_comp_worked, monthly_income, work_life_balance, years_at_company
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY employee_id;
$$
LANGUAGE sql;


/*==========================================================
Get Train CLass Distribution Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_train_class_distribution(
)
RETURNS TABLE(
		e_attrition_no integer,
		eh_attrition_no integer,
		eh_attrition_yes integer
)
AS $$
   	WITH
	t1 AS
	(
	    SELECT sum(case when attrition = 'No' then 1 end) AS e_attrition_no
	    FROM employee
	    WHERE attrition IS NOT NULL
	),
	t2 AS
	(
	    SELECT sum(case when attrition = 'No' then 1 end) AS eh_attrition_no,
		   sum(case when attrition = 'Yes' then 1 end) AS eh_attrition_yes
	    FROM employee_history
	)
	SELECT e_attrition_no,
	       eh_attrition_no,
	       eh_attrition_yes
	FROM t1, t2;
$$
LANGUAGE sql;


/*==========================================================
Get Test Data Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_test_data(
)
RETURNS TABLE(
	id character varying(10), attrition character varying(5),
	age integer, department character varying(10),
	dist_from_home integer, education integer,
	education_field character varying(50), env_satisfaction integer,
	job_satisfaction integer, marital_status character varying(10),
	num_comp_worked integer, monthly_income integer,
	work_life_balance integer, years_at_company integer
)
AS $$
	SELECT t1.id, attrition, age, name AS department,
	       dist_from_home, education, education_field, env_satisfaction,
	       job_satisfaction, marital_status, num_comp_worked, monthly_income,
	       work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE attrition IS NULL
	ORDER BY t1.id;
$$
LANGUAGE sql;


/*==========================================================
Get Train Data Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_train_data(
)
RETURNS TABLE(
	id character varying(10), attrition character varying(5),
	age integer, department character varying(10),
	dist_from_home integer, education integer,
	education_field character varying(50), env_satisfaction integer,
	job_satisfaction integer, marital_status character varying(10),
	num_comp_worked integer, monthly_income integer,
	work_life_balance integer, years_at_company integer
)
AS $$
	SELECT 	t1.id, attrition, age, name AS department,
		dist_from_home, education, education_field, env_satisfaction,
		job_satisfaction, marital_status, num_comp_worked, monthly_income,
		work_life_balance, years_at_company
	FROM employee t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	WHERE attrition IS NOT NULL
	UNION
	SELECT employee_id AS id, attrition, age, name AS department,
	       dist_from_home, education, education_field, env_satisfaction,
	       job_satisfaction, marital_status, num_comp_worked, monthly_income,
	       work_life_balance, years_at_company
	FROM employee_history t1
	INNER JOIN department t2
		ON t1.department_id = t2.id
	ORDER BY id;
$$
LANGUAGE sql;


/*==========================================================
Set Employee Attrition Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION set_employee_attrition(
	IN p_id character varying(10), p_attrition character varying(5)
)
RETURNS void
AS $$
	UPDATE employee
	SET attrition = p_attrition
	WHERE id = p_id;
$$
LANGUAGE sql;


/*==========================================================
Reset Test Data Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION reset_test_data(
)
RETURNS void
AS $$
	ALTER TABLE employee
	DISABLE TRIGGER employee_bu;

	UPDATE employee
	SET attrition = 'No'
	WHERE attrition IS NULL;

	ALTER TABLE employee
	ENABLE TRIGGER employee_bu;
$$
LANGUAGE sql;


/*==========================================================
Get Sys User Function
-----------------------------------------------------------*/
CREATE OR REPLACE FUNCTION get_sys_user(
	IN p_username character varying(15)
)
RETURNS TABLE(
	id character varying(10), name character varying(50),
	role character varying(10), username character varying(15),
	password character varying(25)
)
AS $$
	SELECT *
	FROM sys_user
	WHERE username = p_username;
$$
LANGUAGE sql;

