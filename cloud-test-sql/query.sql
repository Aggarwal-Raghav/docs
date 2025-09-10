-- HQL Queries demonstrating different types of joins and casting.

-- 1. INNER JOIN
-- Objective: Get a list of all employees along with their department names.
-- This will only return employees who are assigned to a valid department.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees e
INNER JOIN
    departments d ON e.department_id = d.department_id;


-- 2. LEFT JOIN (or LEFT OUTER JOIN)
-- Objective: List all employees and their department name.
-- Include employees even if they are not currently assigned to a department.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees e
LEFT JOIN
    departments d ON e.department_id = d.department_id;


-- 3. RIGHT JOIN (or RIGHT OUTER JOIN)
-- Objective: List all departments and the names of employees in them.
-- Include departments that may not have any employees assigned.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees e
RIGHT JOIN
    departments d ON e.department_id = d.department_id;


-- 4. FULL OUTER JOIN
-- Objective: List all employees and all departments.
-- Match them where possible, but include employees without departments and departments without employees.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    employees e
FULL OUTER JOIN
    departments d ON e.department_id = d.department_id;


-- 5. Multiple JOINS
-- Objective: Get employee names, their job IDs, department names, and the projects they are leading.
SELECT
    e.first_name,
    e.last_name,
    e.job_id,
    d.department_name,
    p.project_name
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
JOIN
    projects p ON e.employee_id = p.project_lead_id;


-- 6. JOIN with a WHERE clause
-- Objective: Find the total salary payments (salary + bonus) made to employees in the 'Information Technology' department.
SELECT
    e.first_name,
    e.last_name,
    s.salary_amount,
    s.bonus_amount,
    s.pay_date
FROM
    salaries s
JOIN
    employees e ON s.employee_id = e.employee_id
JOIN
    departments d ON e.department_id = d.department_id
WHERE
    d.department_name = 'Information Technology';


-- 7. CASTING: STRING to DATE
-- Objective: Find all projects that started after '2025-03-01'.
-- This demonstrates casting a string literal to a DATE type for comparison.
SELECT
    project_name,
    start_date
FROM
    projects
WHERE
    start_date > CAST('2025-03-01' AS DATE);


-- 8. CASTING: INT to STRING
-- Objective: Concatenate the employee ID with their first name.
-- We need to cast the integer employee_id to a string to use it with CONCAT.
SELECT
    CONCAT(CAST(employee_id AS STRING), ': ', first_name, ' ', last_name) AS employee_identifier
FROM
    employees;


-- 9. CASTING: TIMESTAMP to DATE
-- Objective: Get the date part from the last_login timestamp for all employees.
SELECT
    employee_id,
    first_name,
    last_login,
    CAST(last_login AS DATE) AS last_login_date
FROM
    employees;


-- 10. CASTING in a JOIN condition
-- Objective: Join employees and projects on a derived year value.
-- This is a more complex example where we cast dates to strings, get the year, and join on that.
-- It could be used to find which employees were hired in the same year a project started.
SELECT
    e.first_name,
    e.hire_date,
    p.project_name,
    p.start_date
FROM
    employees e
JOIN
    projects p ON SUBSTR(CAST(e.hire_date AS STRING), 1, 4) = SUBSTR(CAST(p.start_date AS STRING), 1, 4);

