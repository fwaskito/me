--
-- File			: table.sql
-- Author		: F. Waskito
-- Created on 		: 2024-06-28
-- Database		: PostgreSQL
-- Database version	: 16.3 (Ubuntu 16.3-1.pgdg22.04+1)
-- Last modified	: 2024-07-31
--


/*=============================================================
Department Table
--------------------------------------------------------------*/
CREATE TABLE department (
    id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);


/*=============================================================
Employee Table
--------------------------------------------------------------*/
CREATE TABLE employee (
    id VARCHAR(10) NOT NULL,
    attrition VARCHAR(5),
    age INT NOT NULL,
    department_id VARCHAR(10) NOT NULL,
    dist_from_home INT NOT NULL,
    education INT NOT NULL,
    education_field VARCHAR(50) NOT NULL,
    env_satisfaction INT NOT NULL,
    job_satisfaction INT NOT NULL,
    marital_status VARCHAR(10) NOT NULL,
    num_comp_worked INT NOT NULL,
    monthly_income INT NOT NULL,
    work_life_balance INT NOT NULL,
    years_at_company INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_employee_department_id
        FOREIGN KEY (department_id)
	    REFERENCES department(id)
	    ON UPDATE CASCADE
            ON DELETE CASCADE
);


-- Insert Data
COPY employee
FROM '/absolute/path/to/ibm-attrition-dataset-ready.csv'
DELIMITER ','
CSV HEADER;


/*=============================================================
Employee History Table
--------------------------------------------------------------*/
CREATE TABLE employee_history (
    employee_id VARCHAR(10) NOT NULL,
    modif_action VARCHAR(8) NOT NULL DEFAULT 'update',
    modif_date DATE NOT NULL,
    attrition VARCHAR(5) NOT NULL,
    age INT NOT NULL,
    department_id VARCHAR(10) NOT NULL,
    dist_from_home INT NOT NULL,
    education INT NOT NULL,
    education_field VARCHAR(50) NOT NULL,
    env_satisfaction INT NOT NULL,
    job_satisfaction INT NOT NULL,
    marital_status VARCHAR(10) NOT NULL,
    num_comp_worked INT NOT NULL,
    monthly_income INT NOT NULL,
    work_life_balance INT NOT NULL,
    years_at_company INT NOT NULL,
    PRIMARY KEY (employee_id, modif_action),
    CONSTRAINT fk_employee_history_department_id
        FOREIGN KEY (department_id)
	    REFERENCES department(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

-- Insert Data
-- Make sure the employee_bd trigger was applied
DELETE FROM employee
WHERE attrition = 'Yes';


/*=============================================================
System User Table
--------------------------------------------------------------*/
CREATE TABLE "system_user" (
    id VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    role VARCHAR(10) NOT NULL,
    username VARCHAR(15) NOT NULL,
    password VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert Data
INSERT INTO "system_user"
VALUES ('US1', 'Fajar Waskito', 'admin', 'fwaskito', 'fwaskito123');

