SELECT *
FROM actor;

SELECT *
FROM film;

SELECT *
FROM film_actor;

-- Join the actor table to the film actor table

SELECT *
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id;

-- Join the film table to the film actor table
SELECT *
FROM film_actor fa 
JOIN film f
ON fa.film_id = f.film_id
ORDER BY f.film_id;


-- Multi Join
SELECT a.first_name, a.last_name, a.actor_id, fa.actor_id, fa.film_id, f.film_id, f.title, f.description
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id 
JOIN film f
ON f.film_id = fa.film_id;


-- Display Customer name and film that they rented -- customer -> rental -> inventory -> film
SELECT c.first_name, c.last_name, c.customer_id, r.customer_id, r.inventory_id, i.inventory_id, i.film_id, f.film_id, f.title
FROM customer c 
JOIN rental r 
ON c.customer_id = r.customer_id 
JOIN inventory i 
ON r.inventory_id = i.inventory_id 
JOIN film f
ON i.film_id = f.film_id;


-- We can still do all of the other fun DQL clauses!!!
SELECT c.first_name, c.last_name, c.customer_id, r.customer_id, r.inventory_id, i.inventory_id, i.film_id, f.film_id, f.title
FROM customer c 
JOIN rental r 
ON c.customer_id = r.customer_id 
JOIN inventory i 
ON r.inventory_id = i.inventory_id 
JOIN film f
ON i.film_id = f.film_id
WHERE c.first_name LIKE 'R%'
ORDER BY f.title DESC 
OFFSET 10
LIMIT 20;


-- SUBQUERIES!!
-- Subqueries are queries within queries

-- Example: Which films have exactly 12 actors in the film?

-- Step 1. Find the actor IDs that have been in 12 films
SELECT film_id, COUNT(*)
FROM film_actor
GROUP BY film_id
HAVING COUNT(*) = 12;


--film_id|
---------+
--    529|
--    802|
--     34|
--    892|
--    414|
--    517|

-- Step 2. Query the film from the film table that match those film IDs
SELECT *
FROM film 
WHERE film_id IN (
	529,
	802,
	34,
	892,
	414,
	517
);

-- Put the two steps together into a one query using a subquery!
-- The query that we want to execute FIRST is the subquery.
-- ** Subquery must return only ONE column **        *unless used in a FROM clause

SELECT *
FROM film 
WHERE film_id IN (
	SELECT film_id
	FROM film_actor
	GROUP BY film_id
	HAVING COUNT(*) = 12
);


SELECT film_id
FROM inventory 
GROUP BY film_id
HAVING COUNT(*) = 7;

SELECT *
FROM film 
WHERE film_id IN (
	SELECT film_id
	FROM inventory 
	GROUP BY film_id
	HAVING COUNT(*) = 7
);


-- Subquery vs Join

-- Which employee has sold the most rentals (use the rental table)?

SELECT *
FROM staff 
WHERE staff_id = (
	SELECT staff_id
	FROM rental
	GROUP BY staff_id 
	ORDER BY COUNT(*) DESC
	LIMIT 1
);

-- Show the employee who had the most rentals with the number of rentals sold
SELECT rental.staff_id, first_name, last_name, COUNT(*)
FROM rental
JOIN staff
ON rental.staff_id = staff.staff_id 
GROUP BY rental.staff_id, first_name, last_name
ORDER BY COUNT(*) DESC;


-- Use subqueries for calculations
-- List out all of the payments that are more than the average payment amount

SELECT *
FROM payment
WHERE amount > (
	SELECT AVG(amount)
	FROM payment
);

-- Subqueries with the FROM clause
-- *Subquery in a FROM must have an alias*


-- Ex. Find the average number of rentals per customer

-- Step 1. Get the count of rentals per customer

SELECT customer_id, COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id;

-- Step 2. Use the temporary table from step 1 as a subquery in a FROM
SELECT AVG(num_rentals)
FROM (
	SELECT customer_id, COUNT(*) AS num_rentals
	FROM rental
	GROUP BY customer_id
) AS customer_rental_totals;


-- Can do other DQL clauses
SELECT *
FROM (
	SELECT customer_id, COUNT(*) AS num_rentals
	FROM rental
	GROUP BY customer_id
) AS customer_rental_totals
WHERE num_rentals > 40;


-- Use subqueries in DML Statements


-- Setup example -> Add loyalty member boolean to customer table and set all values to False
ALTER TABLE customer
ADD COLUMN loyalty_member BOOLEAN;

UPDATE customer 
SET loyalty_member = FALSE;

SELECT *
FROM customer;


-- Update the customer table to make every customer who has rented at least 25 films a loyalty member

-- Step 1. Find all customer IDs that have rented at least 25 films
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 25;

-- Step 2. Update the customer table to set loyalty to TRUE if the customer_id is in the subquery
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	GROUP BY customer_id
	HAVING COUNT(*) >= 25
);

SELECT *
FROM customer
WHERE loyalty_member = FALSE;



-- Multiple subqueries are allowed and pretty cool!

-- Get the customer info on the customer who has rented more than the average customer

SELECT *
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	GROUP BY customer_id
	HAVING COUNT(*) > (
		SELECT AVG(num_rentals)
		FROM (
			SELECT customer_id, COUNT(*) AS num_rentals
			FROM rental
			GROUP BY customer_id
		) AS customer_rental_totals
	)
);

-- Joins and Subqueries are friendly
SELECT r.customer_id, c.first_name, c.last_name, COUNT(*)
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id 
GROUP BY r.customer_id, c.first_name, c.last_name
HAVING COUNT(*) > (
	SELECT AVG(num_rentals)
	FROM (
		SELECT customer_id, COUNT(*) AS num_rentals
		FROM rental
		GROUP BY customer_id
	) AS customer_rental_totals
);

