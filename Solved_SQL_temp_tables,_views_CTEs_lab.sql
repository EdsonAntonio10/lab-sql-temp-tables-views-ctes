USE sakila;


-- STEP 1: VIEW
DROP VIEW IF EXISTS customer_rental_summary;

CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

SELECT * FROM customer_rental_summary LIMIT 5;

DROP TEMPORARY TABLE IF EXISTS customer_payment_summary;


-- STEP 2: TEMP TABLE

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    crs.customer_id,
    SUM(p.amount) AS total_paid
FROM customer_rental_summary crs
JOIN payment p 
    ON crs.customer_id = p.customer_id
GROUP BY crs.customer_id;

SELECT * FROM customer_payment_summary LIMIT 5;


-- STEP 3: CTE
WITH customer_summary AS (
    SELECT 
        crs.customer_name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        (cps.total_paid / crs.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps
        ON crs.customer_id = cps.customer_id
)

SELECT * 
FROM customer_summary
ORDER BY total_paid DESC;