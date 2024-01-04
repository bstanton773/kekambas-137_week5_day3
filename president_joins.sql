-- DDL Statements to create the tables in the database

-- Create customer table
CREATE TABLE IF NOT EXISTS customer (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(2)
);

SELECT *
FROM customer;

-- Create receipt table
CREATE TABLE IF NOT EXISTS receipt (
	receipt_id SERIAL PRIMARY KEY,
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	amount NUMERIC(5,2), -- Max OF 5 total digits, 2 digits TO the RIGHT OF the decimal (XXX.XX)
	customer_id INTEGER, -- can be NULL
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);


SELECT *
FROM receipt;

-- DML Statements to add data to our tables

-- Inserting customers into the customer table
INSERT INTO customer(first_name, last_name, email, address, city, state)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL');

SELECT *
FROM customer;

-- Add some receipt data (one at a time so we have different order dates)
INSERT INTO receipt(amount, customer_id)
VALUES (55.55, 1);

INSERT INTO receipt(amount, customer_id)
VALUES (79.26, 3);

INSERT INTO receipt(amount, customer_id)
VALUES (420.32, 1);

INSERT INTO receipt(amount, customer_id)
VALUES (93.85, 2);

INSERT INTO receipt(amount, customer_id)
VALUES (99.99, null);

INSERT INTO receipt(amount, customer_id)
VALUES (876.54, null);

SELECT *
FROM receipt;


-- Get Info about Customer ID 1
SELECT *
FROM customer
WHERE customer_id = 1;

SELECT *
FROM receipt
WHERE customer_id = 1;

-- Using JOINs we can combine these tables together on a common field
-- Syntax:
-- SELECT col_1, col_2, etc. (can be from either table)
-- FROM table_name_1 (will be considered the LEFT table)
-- JOIN table_name_2 (will be considered the RIGHT table)
-- ON table_name_1.col_name = table_name_2.col_name (where col_name is FK to other col_name PK)

-- Inner Join
SELECT *
FROM customer 
JOIN receipt
ON customer.customer_id = receipt.customer_id;


SELECT first_name, last_name, email, c.customer_id AS cust_cust_id, r.customer_id AS rec_cust_id, receipt_id, order_date, amount
FROM customer c
JOIN receipt r
ON c.customer_id = r.customer_id;


-- Each Join 

-- JOIN or INNER JOIN - returns records that have matching values in both tables
SELECT *
FROM customer 
JOIN receipt
ON customer.customer_id = receipt.customer_id;

-- FULL JOIN - Return all records from both tables, will match if possible
SELECT *
FROM customer 
FULL JOIN receipt
ON customer.customer_id = receipt.customer_id;

-- LEFT JOIN - Returns all records from the left table, and only matched records from the right
SELECT *
FROM customer  -- LEFT table
LEFT JOIN receipt -- RIGHT table
ON customer.customer_id = receipt.customer_id;

-- RIGHT JOIN - Returns all records from the right table, and only matched records from the left
SELECT *
FROM customer  -- LEFT table
RIGHT JOIN receipt -- RIGHT table
ON customer.customer_id = receipt.customer_id;

-- RIGHT JOIN again *flip-flop right and left table*
SELECT *
FROM receipt  -- LEFT table
RIGHT JOIN customer -- RIGHT table
ON customer.customer_id = receipt.customer_id;


-- JOIN...ON comes after the SELECT...FROM and before WHERE

-- SELECT
-- FROM
-- JOIN
-- ON
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
-- LIMIT
-- OFFSET

SELECT *
FROM customer
JOIN receipt 
ON customer.customer_id = receipt.customer_id
WHERE last_name = 'Washington';

SELECT customer.customer_id, first_name, last_name, SUM(amount)
FROM receipt
JOIN customer
ON receipt.customer_id = customer.customer_id 
GROUP BY customer.customer_id, first_name, last_name
ORDER BY SUM(amount) DESC;


-- Aliasing table names and unambiguous column names

-- Two new tables - Teacher, Student
CREATE TABLE IF NOT EXISTS teacher (
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR
);

CREATE TABLE student (
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR,
	teacher_id INTEGER NOT NULL,
	FOREIGN KEY(teacher_id) REFERENCES teacher(teacher_id)
);

INSERT INTO teacher (first_name, last_name) VALUES ('Brian', 'Stanton'), ('Ryan', 'Rhodes');

SELECT *
FROM teacher;

INSERT INTO student (first_name, last_name, teacher_id)
VALUES ('Sarah', 'Stodder', 1), ('Alex', 'Swiggum', 2), ('Dylan', 'Katina', 1), ('Dylan', 'Smith', 2);

SELECT *
FROM student;

SELECT teacher.first_name, teacher.last_name, student.first_name, student.last_name, student_id
FROM teacher
JOIN student
ON teacher.teacher_id = student.teacher_id;


-- Alias the table names - we then MUST refer to the tables by their alias
SELECT t.first_name, t.last_name, s.first_name, s.last_name
FROM teacher t 
JOIN student s
ON t.teacher_id = s.teacher_id;

