-- Drop tables if they exist to start with a clean slate
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS employee_projects;
DROP TABLE IF EXISTS sales;

-- =================================================================
-- Table Creation
-- =================================================================

-- Table 1: employees
-- This table stores employee information, including complex data types
-- like array for skills, map for contact info, and struct for address.
CREATE TABLE employees (
    employee_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    department_id INT,
    salary DECIMAL(10, 2),
    hire_date STRING,
    skills ARRAY<STRING>,
    contact_info MAP<STRING, STRING>,
    address STRUCT<street:STRING, city:STRING, state:STRING, zip:STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|'
MAP KEYS TERMINATED BY ':'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Table 2: departments
-- A simple dimension table for department information.
CREATE TABLE departments (
    department_id INT,
    department_name STRING,
    location STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Table 3: projects
-- This table stores project details.
CREATE TABLE projects (
    project_id INT,
    project_name STRING,
    start_date STRING,
    end_date STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Table 4: employee_projects
-- A linking table to represent the many-to-many relationship
-- between employees and projects.
CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- Table 5: sales
-- Table to store sales data with timestamps for conversion tests.
CREATE TABLE sales (
    sale_id INT,
    employee_id INT,
    sale_amount DECIMAL(10, 2),
    sale_timestamp_str STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

-- =================================================================
-- Data Insertion
-- =================================================================

-- Inserting data into 'employees'
INSERT INTO employees VALUES
(101, 'John', 'Doe', 'john.doe@example.com', 1, 90000.00, '2022-01-15', array('Java', 'Python', 'SQL'), map('work', '123-456-7890', 'personal', '111-222-3333'), named_struct('street', '123 Main St', 'city', 'Anytown', 'state', 'CA', 'zip', '12345')),
(102, 'Jane', 'Smith', 'jane.smith@example.com', 1, 95000.00, '2021-03-20', array('Python', 'R', 'Machine Learning'), map('work', '123-456-7891'), named_struct('street', '456 Oak Ave', 'city', 'Somecity', 'state', 'NY', 'zip', '54321')),
(103, 'Peter', 'Jones', 'peter.jones@example.com', 2, 80000.00, '2022-06-01', array('HTML', 'CSS', 'JavaScript'), map('work', '123-456-7892', 'personal', '444-555-6666'), named_struct('street', '789 Pine Ln', 'city', 'Otherville', 'state', 'TX', 'zip', '67890')),
(104, 'Mary', 'Johnson', 'mary.j@example.com', 2, 82000.00, '2023-02-10', array('JavaScript', 'React'), map('work', '123-456-7893'), named_struct('street', '101 Maple Dr', 'city', 'Anytown', 'state', 'CA', 'zip', '12346')),
(105, 'Chris', 'Lee', 'chris.lee@example.com', 3, 120000.00, '2020-11-05', array('SQL', 'Tableau', 'PowerBI'), map('work', '123-456-7894', 'personal', '777-888-9999'), named_struct('street', '212 Birch Rd', 'city', 'Dataville', 'state', 'WA', 'zip', '13579'));

-- Inserting data into 'departments'
INSERT INTO departments VALUES
(1, 'Engineering', 'New York'),
(2, 'Marketing', 'San Francisco'),
(3, 'Data Science', 'Chicago');

-- Inserting data into 'projects'
INSERT INTO projects VALUES
(1001, 'Project Alpha', '2023-01-01', '2023-06-30'),
(1002, 'Project Beta', '2023-03-15', '2023-09-15'),
(1003, 'Project Gamma', '2023-07-01', '2023-12-31');

-- Inserting data into 'employee_projects'
INSERT INTO employee_projects VALUES
(101, 1001),
(101, 1002),
(102, 1001),
(103, 1002),
(104, 1003),
(105, 1003);

-- Inserting data into 'sales'
INSERT INTO sales VALUES
(1, 101, 1500.00, '2023-04-10 10:30:00'),
(2, 103, 2500.50, '2023-04-11 14:00:00'),
(3, 101, 750.25, '2023-05-02 09:15:00'),
(4, 104, 3200.00, '2023-05-20 11:45:00'),
(5, 102, 1800.75, '2023-06-05 16:20:00');

