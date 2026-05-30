CREATE DATABASE sales;
USE sales;

CREATE TABLE sales_data (
    id INT,
    employee VARCHAR(50),
    department VARCHAR(40),
    sales_amount INT,
    sale_date DATE
);

INSERT INTO sales_data VALUES
(1, 'Alice', 'A', 1000, '2024-01-01'),
(2, 'Bob', 'B', 1500, '2024-01-02'),
(3, 'Alice', 'A', 2000, '2024-01-03'),
(4, 'Bob', 'B', 1800, '2024-01-04'),
(5, 'Alice', 'A', 1200, '2024-01-05'),
(6, 'Bob', 'B', 1600, '2024-01-06');

-- 1. Total sales per employee (Running Total)
SELECT id, employee, department, sales_amount, sale_date,
       SUM(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS running_total_sales
FROM sales_data;

-- 2. Row number per employee
SELECT id, employee, department, sales_amount, sale_date,
       ROW_NUMBER() OVER (PARTITION BY employee ORDER BY sale_date, id) AS row_num
FROM sales_data;

-- 3. Rank of sales per department
SELECT id, employee, department, sales_amount, sale_date,
       RANK() OVER (PARTITION BY department ORDER BY sales_amount DESC) AS sales_rank_dept
FROM sales_data;

-- 4. Lead (next sale) per employee
SELECT id, employee, department, sales_amount, sale_date,
       LEAD(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS next_sale_amount
FROM sales_data;

-- 5. Lag (previous sale) per employee
SELECT id, employee, department, sales_amount, sale_date,
       LAG(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS prev_sale_amount
FROM sales_data;

-- 6. Average sales per employee
SELECT id, employee, department, sales_amount, sale_date,
       AVG(sales_amount) OVER (PARTITION BY employee) AS avg_sales_employee
FROM sales_data;

-- 7. First and last sales per employee
SELECT id, employee, department, sales_amount, sale_date,
       FIRST_VALUE(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS first_sale_amount,
       LAST_VALUE(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id 
                                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_sale_amount
FROM sales_data;


-- 8. Dense rank (no gaps)
SELECT id, employee, department, sales_amount, sale_date,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY sales_amount DESC) AS sales_dense_rank_dept
FROM sales_data;


-- 9. Cumulative average per employee
SELECT id, employee, department, sales_amount, sale_date,
       AVG(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS cumulative_avg_sales
FROM sales_data;

-- 10. Find highest sale per employee
SELECT id, employee, department, sales_amount, sale_date,
       MAX(sales_amount) OVER(
           PARTITION BY employee
       ) AS highest_sale
FROM sales_data;

-- 11. Sales difference from previous record
SELECT id, employee, department, sales_amount, sale_date,
       sales_amount - LAG(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS sales_diff_from_prev
FROM sales_data;

-- 12. Cumulative count of sales per employee
SELECT id, employee, department, sales_amount, sale_date,
       COUNT(sales_amount) OVER (PARTITION BY employee ORDER BY sale_date, id) AS cumulative_sales_count
FROM sales_data;

-- 13. Show if sale is above average per employee
SELECT id, employee, department, sales_amount, sale_date,
       AVG(sales_amount) OVER(
           PARTITION BY employee
       ) AS avg_sales,

       CASE
           WHEN sales_amount >
                AVG(sales_amount) OVER(PARTITION BY employee)
           THEN 'Above Average'
           ELSE 'Below Average'
       END AS sales_status
FROM sales_data;

-- 14. Find second highest sale per employee
SELECT id, employee, department, sales_amount, sale_date
FROM (
    SELECT id, employee, department, sales_amount, sale_date,
           DENSE_RANK() OVER(
               PARTITION BY employee
               ORDER BY sales_amount DESC
           ) AS rnk
    FROM sales_data
) temp
WHERE rnk = 2;
