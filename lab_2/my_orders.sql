-- ============================================
-- ORDER DATABASE
-- ============================================

CREATE DATABASE order_db;

USE order_db;


-- ============================================
-- TABLE CREATION
-- ============================================

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    commission DECIMAL(10,2)
);


CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(100),
    city VARCHAR(50),
    grade INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id)
        REFERENCES salesman(salesman_id)
);


CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purchase_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    FOREIGN KEY (salesman_id)
        REFERENCES salesman(salesman_id)
);


-- ============================================
-- INSERT DATA
-- ============================================

INSERT INTO salesman
(salesman_id, name, city, commission)
VALUES
(1000, 'John', 'Bangalore', 5000.00),
(1001, 'Ravi', 'Mysore', 4500.00),
(1002, 'Arun', 'Bangalore', 5500.00),
(1003, 'Kiran', 'Chennai', 4000.00),
(1004, 'Rahul', 'Mysore', 4800.00);


INSERT INTO customer
(customer_id, cust_name, city, grade, salesman_id)
VALUES
(101, 'Amit', 'Bangalore', 5, 1000),
(102, 'Priya', 'Bangalore', 7, 1000),
(103, 'Rahul', 'Mysore', 6, 1001),
(104, 'Sneha', 'Mysore', 8, 1001),
(105, 'Kiran', 'Bangalore', 9, 1002),
(106, 'Anil', 'Chennai', 4, 1003),
(107, 'Deepa', 'Delhi', 3, 1004);


INSERT INTO orders
(ord_no, purchase_amt, ord_date, customer_id, salesman_id)
VALUES
(1, 1500.00, '2022-01-10', 101, 1000),
(2, 2500.00, '2022-01-10', 102, 1000),
(3, 3000.00, '2022-01-11', 103, 1001),
(4, 4500.00, '2022-01-11', 104, 1001),
(5, 5000.00, '2022-01-12', 105, 1002),
(6, 2000.00, '2022-01-12', 106, 1003),
(7, 3500.00, '2022-01-13', 107, 1004),
(8, 4000.00, '2022-01-13', 101, 1000);


-- ============================================
-- 1. COUNT CUSTOMERS WITH GRADES ABOVE
--    BANGALORE'S AVERAGE
-- ============================================

SELECT COUNT(*) AS customers_above_bangalore_average
FROM customer
WHERE grade > (
    SELECT AVG(grade)
    FROM customer
    WHERE city = 'Bangalore'
);


-- ============================================
-- 2. SALESMEN WHO HAD MORE THAN ONE CUSTOMER
-- ============================================

SELECT
    s.name,
    COUNT(c.customer_id) AS number_of_customers
FROM salesman s
JOIN customer c
    ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name
HAVING COUNT(c.customer_id) > 1;


-- ============================================
-- 3. ALL SALESMEN AND INDICATE WHETHER THEY
--    HAVE OR DON'T HAVE CUSTOMERS IN THEIR CITY
--    USING UNION
-- ============================================

SELECT DISTINCT
    s.salesman_id,
    s.name,
    s.city,
    'Has customers in city' AS customer_status
FROM salesman s
JOIN customer c
    ON s.salesman_id = c.salesman_id
    AND s.city = c.city

UNION

SELECT
    s.salesman_id,
    s.name,
    s.city,
    'Does not have customers in city' AS customer_status
FROM salesman s
WHERE NOT EXISTS (
    SELECT 1
    FROM customer c
    WHERE c.salesman_id = s.salesman_id
      AND c.city = s.city
);


-- ============================================
-- 4. CREATE A VIEW THAT FINDS THE SALESMAN
--    WHO HAS THE CUSTOMER WITH THE HIGHEST
--    ORDER OF A DAY
-- ============================================

CREATE VIEW highest_daily_order AS
SELECT
    s.salesman_id,
    s.name AS salesman_name,
    c.customer_id,
    c.cust_name,
    o.ord_date,
    o.purchase_amt
FROM salesman s
JOIN customer c
    ON s.salesman_id = c.salesman_id
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.purchase_amt = (
    SELECT MAX(o2.purchase_amt)
    FROM orders o2
    WHERE o2.ord_date = o.ord_date
);


SELECT *
FROM highest_daily_order;


-- ============================================
-- 5. DELETE SALESMAN WITH ID 1000
--    AND DELETE ALL HIS ORDERS
-- ============================================

DELETE FROM orders
WHERE salesman_id = 1000;

DELETE FROM customer
WHERE salesman_id = 1000;

DELETE FROM salesman
WHERE salesman_id = 1000;


-- ============================================
-- 6. CREATE INDEX ON CUSTOMER(ID)
--    AND DEMONSTRATE ITS USAGE
-- ============================================

CREATE INDEX idx_customer_id
ON customer(customer_id);

EXPLAIN
SELECT *
FROM customer
WHERE customer_id = 101;