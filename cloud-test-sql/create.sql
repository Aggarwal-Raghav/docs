-- Table Schemas for a fictional company database

-- 1. Employees Table
-- This table stores information about employees.
CREATE TABLE employees (
    employee_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    phone_number STRING,
    hire_date DATE,
    job_id STRING,
    salary DECIMAL(10, 2),
    is_manager BOOLEAN,
    department_id INT,
    last_login TIMESTAMP
);

-- 2. Departments Table
-- This table stores information about the different departments in the company.
CREATE TABLE departments (
    department_id INT,
    department_name STRING,
    manager_id INT,
    location_id INT,
    budget DECIMAL(15, 2),
    creation_date DATE,
    has_vacancies BOOLEAN,
    building_name STRING,
    floor_number INT,
    contact_email STRING
);

-- 3. Salaries Table
-- This table tracks salary history for employees.
CREATE TABLE salaries (
    salary_id BIGINT,
    employee_id INT,
    salary_amount DECIMAL(10, 2),
    bonus_amount DECIMAL(10, 2),
    pay_date DATE,
    payment_type STRING, -- e.g., 'Monthly', 'Bonus', 'Commission'
    is_approved BOOLEAN,
    approved_by INT,
    comments STRING,
    transaction_time TIMESTAMP
);

-- 4. Projects Table
-- This table stores information about company projects.
CREATE TABLE projects (
    project_id STRING,
    project_name STRING,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(20, 2),
    project_lead_id INT,
    status STRING, -- e.g., 'Planning', 'In Progress', 'Completed'
    priority INT, -- 1-5 scale
    last_updated TIMESTAMP,
    is_internal BOOLEAN
);

