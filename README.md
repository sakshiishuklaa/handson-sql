
# Hands-on SQL

A collection of SQL problem-solving exercises focused on strengthening query-writing skills, understanding core SQL concepts, and preparing for technical interviews.

This repository contains solutions to SQL problems from LeetCode, along with important SQL concepts, common mistakes, and notes to remember while solving problems.

##  Goals

- Strengthen SQL fundamentals through hands-on practice.
- Improve logical thinking and problem-solving skills.
- Understand joins, aggregation, subqueries, and window functions.
- Learn to handle NULL values, duplicate records, and edge cases.
- Prepare for SQL interviews for Data Engineer and Data Analyst roles.

##  Tech Stack

- **Language:** SQL
- **Database:** MySQL
- **Practice Platform:** LeetCode

##  Important SQL Notes

### 1. SQL Query Execution Order

SQL does not logically execute clauses in the same order in which they are written.

```sql
FROM / JOIN
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT
```

**Remember:** A column alias defined in `SELECT` generally cannot be used in `WHERE` because `WHERE` is logically evaluated earlier.

Incorrect:

```sql
SELECT salary * 12 AS annual_salary
FROM Employee
WHERE annual_salary > 100000;
```

Correct:

```sql
SELECT salary * 12 AS annual_salary
FROM Employee
WHERE salary * 12 > 100000;
```

For filtering a window function result, use a subquery or CTE.

### 2. WHERE vs HAVING

- `WHERE` filters individual rows before grouping.
- `HAVING` filters groups after aggregation.

```sql
SELECT departmentId, COUNT(*) AS employee_count
FROM Employee
WHERE salary > 30000
GROUP BY departmentId
HAVING COUNT(*) >= 5;
```

**Remember:** Use `WHERE` for row-level conditions and `HAVING` for aggregate conditions.

### 3. GROUP BY and Aggregate Functions

Common aggregate functions:

- `COUNT()` — counts values or rows.
- `SUM()` — calculates the total.
- `AVG()` — calculates the average.
- `MIN()` — returns the minimum.
- `MAX()` — returns the maximum.

```sql
SELECT departmentId, MAX(salary) AS highest_salary
FROM Employee
GROUP BY departmentId;
```

**Important differences:**

```sql
COUNT(*)          -- Counts rows
COUNT(column_name) -- Counts non-NULL values
COUNT(DISTINCT column_name) -- Counts distinct non-NULL values
```

Remember to group by every selected non-aggregated column when required by your SQL dialect.

### 4. JOINs

**INNER JOIN:** Returns matching rows from both tables.

**LEFT JOIN:** Returns every row from the left table and matching rows from the right table.

**RIGHT JOIN:** Returns every row from the right table and matching rows from the left table.

**CROSS JOIN:** Returns every possible combination of rows.

Example:

```sql
SELECT e.name, d.department_name
FROM Employee e
LEFT JOIN Department d
    ON e.departmentId = d.id;
```

**Remember:**

- Always verify the join condition.
- A one-to-many join can increase the number of rows.
- Use table aliases to make queries readable.
- Use `COUNT(right_table.id)` when counting matched records after a `LEFT JOIN`, assuming that ID is non-NULL for real rows.

### 5. NULL Values

`NULL` represents a missing or unknown value.

Incorrect:

```sql
WHERE salary = NULL
```

Correct:

```sql
WHERE salary IS NULL
```

To exclude NULL values:

```sql
WHERE salary IS NOT NULL
```

**Remember:**

- `NULL` is not equal to zero or an empty string.
- Most aggregate functions ignore NULL values.
- `COUNT(*)` still counts rows containing NULL values.
- Be careful with `NOT IN` if the subquery can return NULL. `NOT EXISTS` is often safer.

### 6. DISTINCT and Duplicate Records

Use `DISTINCT` to remove duplicate combinations from the selected columns.

```sql
SELECT DISTINCT departmentId
FROM Employee;
```

Find duplicate email addresses:

```sql
SELECT email, COUNT(*) AS total
FROM Person
GROUP BY email
HAVING COUNT(*) > 1;
```

**Remember:** `DISTINCT` applies to the complete set of selected columns, not just one column.

### 7. Subqueries and CTEs

A subquery is a query nested inside another query.

```sql
SELECT name, salary
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
);
```

A Common Table Expression (CTE) improves readability:

```sql
WITH DepartmentSalary AS (
    SELECT departmentId, AVG(salary) AS avg_salary
    FROM Employee
    GROUP BY departmentId
)
SELECT *
FROM DepartmentSalary
WHERE avg_salary > 50000;
```

**Remember:** Use CTEs to break complex problems into smaller, understandable steps.

### 8. Window Functions

Window functions perform calculations across related rows without collapsing them into groups.

```sql
SELECT
    name,
    departmentId,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY departmentId
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employee;
```

**ROW_NUMBER vs RANK vs DENSE_RANK**

| Function | Tie behavior | Example for salaries 100, 100, 90 |
|---|---|---|
| `ROW_NUMBER()` | Unique sequential numbers | 1, 2, 3 |
| `RANK()` | Ties share rank; gaps follow | 1, 1, 3 |
| `DENSE_RANK()` | Ties share rank; no gaps | 1, 1, 2 |

**Remember:**

- `PARTITION BY` divides rows into groups.
- `ORDER BY` inside `OVER()` determines the calculation order.
- Add a unique tie-breaker to `ROW_NUMBER()` when deterministic ordering matters.
- Use `DENSE_RANK()` when the question asks for the Nth distinct value.

### 9. Filtering Window Function Results

You cannot directly filter a window function alias in the same query's `WHERE` clause.

Incorrect:

```sql
SELECT
    name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rk
FROM Employee
WHERE rk <= 3;
```

Correct using a CTE:

```sql
WITH RankedEmployees AS (
    SELECT
        name,
        salary,
        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS rk
    FROM Employee
)
SELECT name, salary
FROM RankedEmployees
WHERE rk <= 3;
```

**Remember:** Calculate the rank first, then filter it in the outer query.

### 10. CASE WHEN

Use `CASE` to implement conditional logic.

```sql
SELECT
    name,
    salary,
    CASE
        WHEN salary >= 80000 THEN 'High'
        WHEN salary >= 40000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM Employee;
```

Conditional aggregation:

```sql
SELECT
    departmentId,
    SUM(CASE WHEN salary >= 50000 THEN 1 ELSE 0 END) AS high_paid
FROM Employee
GROUP BY departmentId;
```

### 11. Date Filtering

Use clear date boundaries to avoid accidentally excluding records containing time components.

```sql
SELECT *
FROM Orders
WHERE order_date >= '2020-01-01'
  AND order_date < '2020-02-01';
```

This includes all timestamps in January when `order_date` is a datetime column.

**Remember:**

- `BETWEEN` includes both endpoints.
- Check whether the column is `DATE` or `DATETIME`.
- Use the date range specified in the question.
- For rolling-window problems, confirm whether the requirement concerns calendar days or rows.

### 12. Rolling Aggregations

For a seven-row moving average:

```sql
SELECT
    visited_on,
    AVG(amount) OVER (
        ORDER BY visited_on
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM Customer;
```

**Remember:** This calculates over the current row and up to six preceding rows, not automatically seven distinct calendar dates.

For a seven-calendar-day analysis, first aggregate to one row per date and ensure missing dates are handled as required.

### 13. UNION vs UNION ALL

- `UNION` combines results and removes duplicate rows.
- `UNION ALL` combines results while retaining duplicates.

```sql
SELECT name AS result
FROM Users

UNION ALL

SELECT title AS result
FROM Movies;
```

**Remember:**

- Both queries must return the same number of columns.
- Corresponding columns should have compatible data types.
- The final `ORDER BY` applies to the combined result.

### 14. Common SQL Mistakes to Avoid

- Using a `SELECT` alias in `WHERE`.
- Using aggregate functions in `WHERE` instead of `HAVING`.
- Forgetting a required `GROUP BY` column.
- Using `= NULL` instead of `IS NULL`.
- Confusing `COUNT(*)` with `COUNT(column)`.
- Filtering a window function in the same query's `WHERE`.
- Using the wrong join condition.
- Accidentally turning a `LEFT JOIN` into an effective `INNER JOIN` with a right-table filter in `WHERE`.
- Ignoring duplicate rows produced by joins.
- Forgetting ties when using ranking functions.
- Using `NOT IN` when the subquery may return NULL.
- Ignoring date and timestamp boundaries.
- Assuming `LIMIT` returns a predictable order without `ORDER BY`.

##  Problem-Solving Checklist

Before submitting a SQL solution, ask yourself:

- [ ] What exactly should the output contain?
- [ ] What is the expected number of rows and the grain of each row?
- [ ] Which tables and joins are required?
- [ ] Could the joins create duplicates?
- [ ] Should filtering happen before or after grouping?
- [ ] Are NULL values handled correctly?
- [ ] Are ties important for ranking?
- [ ] Are date boundaries correct?
- [ ] Does the solution handle edge cases?
- [ ] Have I tested the query against a small example?

## Practice Topics

- [ ] SELECT, WHERE, ORDER BY, LIMIT
- [ ] Aggregate Functions and GROUP BY
- [ ] INNER JOIN, LEFT JOIN, Self JOIN
- [ ] Subqueries and CTEs
- [ ] CASE WHEN and Conditional Aggregation
- [ ] NULL Handling and Duplicate Records
- [ ] String and Date Functions
- [ ] Window Functions and Ranking
- [ ] Running Totals and Moving Averages
- [ ] UNION and UNION ALL
- [ ] Advanced SQL Interview Problems

##  Practice Resources

- [LeetCode SQL 50](https://leetcode.com/studyplan/top-sql-50/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [SQLBolt Interactive Lessons](https://sqlbolt.com/)

---

**Consistency matters more than memorizing queries. Understand the logic, test edge cases, and practice writing SQL every day.**
