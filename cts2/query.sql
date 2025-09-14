-- =================================================================
-- HIVE TEST QUERIES
-- =================================================================

-- Query 1: Simple SELECT with WHERE clause
-- Test basic data retrieval and filtering.
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 90000;

-- Query 2: INNER JOIN
-- Test joining two tables on a common key.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Query 3: LEFT OUTER JOIN
-- Test retrieving all records from the left table, even if there's no match in the right table.
SELECT
    d.department_name,
    e.first_name
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id;

-- Query 4: AGGREGATION with GROUP BY
-- Test aggregation functions like COUNT and AVG.
SELECT
    d.department_name,
    COUNT(e.employee_id) AS num_employees,
    AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Query 5: MANY-TO-MANY JOIN
-- Test joining through a linking table.
SELECT
    e.first_name,
    p.project_name
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id;

-- Query 6: Testing Complex Type - ARRAY
-- Use the `explode` UDF to flatten an array. Find employees with 'Python' skill.
SELECT
    first_name,
    last_name,
    skill
FROM employees
LATERAL VIEW explode(skills) exploded_skills AS skill
WHERE skill = 'Python';

-- Query 7: Testing Complex Type - MAP
-- Accessing map key-value pairs. Get personal contact info.
SELECT
    first_name,
    contact_info['personal'] AS personal_contact
FROM employees
WHERE contact_info['personal'] IS NOT NULL;

-- Query 8: Testing Complex Type - STRUCT
-- Accessing elements within a struct.
SELECT
    first_name,
    address.city,
    address.state
FROM employees
WHERE address.state = 'CA';

-- Query 9: Timestamp Conversion and Functions
-- Convert string to timestamp and extract the month.
SELECT
    sale_id,
    sale_amount,
    from_unixtime(unix_timestamp(sale_timestamp_str, 'yyyy-MM-dd HH:mm:ss')) AS sale_time,
    month(from_unixtime(unix_timestamp(sale_timestamp_str, 'yyyy-MM-dd HH:mm:ss'))) AS sale_month
FROM sales;

-- Query 10: Date Functions and Filtering
-- Find employees hired in 2022.
SELECT
    first_name,
    hire_date
FROM employees
WHERE year(hire_date) = 2022;

-- Query 11: String Manipulation UDFs
-- Concatenate names and find the length of the email.
SELECT
    concat(first_name, ' ', last_name) AS full_name,
    email,
    length(email) AS email_length
FROM employees;

-- Query 12: CASE statement
-- Categorize employees based on salary.
SELECT
    first_name,
    salary,
    CASE
        WHEN salary > 100000 THEN 'High Earner'
        WHEN salary BETWEEN 85000 AND 100000 THEN 'Mid Earner'
        ELSE 'Standard Earner'
    END AS salary_category
FROM employees;

-- Query 13: Subquery in WHERE clause
-- Find employees who work in the 'Engineering' department using a subquery.
SELECT first_name, salary
FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE department_name = 'Engineering');

-- Query 14: Common Table Expression (CTE) and Window Function
-- Rank employees within each department by salary.
WITH RankedEmployees AS (
    SELECT
        first_name,
        d.department_name,
        salary,
        RANK() OVER (PARTITION BY d.department_name ORDER BY salary DESC) as rank_in_dept
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
)
SELECT * FROM RankedEmployees WHERE rank_in_dept <= 2;

-- Query 15: Self Join (Not applicable with this schema, but here's a conceptual example)
-- Let's find employees in the same city.
SELECT
    e1.first_name AS employee1,
    e2.first_name AS employee2,
    e1.address.city
FROM employees e1
JOIN employees e2 ON e1.address.city = e2.address.city AND e1.employee_id < e2.employee_id;

-- Query 16: Mathematical UDFs
-- Calculate the salary after a hypothetical 10% bonus.
SELECT
    first_name,
    salary,
    round(salary * 1.10, 2) AS salary_with_bonus
FROM employees;

-- Query 17: UNION ALL
-- Combine employees from CA and NY into a single list.
SELECT first_name, address.state FROM employees WHERE address.state = 'CA'
UNION ALL
SELECT first_name, address.state FROM employees WHERE address.state = 'NY';

-- Query 18: Aggregate Window Function
-- Calculate the total sales amount per employee along with each individual sale.
SELECT
    e.first_name,
    s.sale_amount,
    SUM(s.sale_amount) OVER (PARTITION BY s.employee_id) AS total_employee_sales
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id;

-- Query 19: Using `LIKE` for pattern matching
-- Find employees whose first name starts with 'J'.
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'J%';

-- Query 20: Complex filtering with AND/OR
-- Find employees in the Marketing department OR employees with a salary over 92000.
SELECT
    first_name,
    d.department_name,
    salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Marketing' OR e.salary > 92000;

-- =================================================================
-- MATERIALIZED VIEW QUERIES
-- =================================================================

-- Query 21: CREATE MATERIALIZED VIEW
-- Create a materialized view to store aggregated data. This can speed up
-- dashboarding queries. We'll aggregate total sales per department.
CREATE MATERIALIZED VIEW department_sales_summary AS
SELECT
    d.department_name,
    SUM(s.sale_amount) as total_sales,
    COUNT(s.sale_id) as number_of_sales
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Query 22: QUERY a MATERIALIZED VIEW
-- Querying the materialized view is just like querying a regular table, but should be much faster.
SELECT department_name, total_sales
FROM department_sales_summary
ORDER BY total_sales DESC;

-- Query 23: REBUILD MATERIALIZED VIEW
-- If the data in the underlying base tables (sales, employees, departments) changes,
-- the materialized view needs to be rebuilt to reflect those changes.
ALTER MATERIALIZED VIEW department_sales_summary REBUILD;

-- Query 24: DROP MATERIALIZED VIEW
-- Clean up by dropping the materialized view.
DROP MATERIALIZED VIEW IF EXISTS department_sales_summary;


