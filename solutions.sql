-- Practice joins
-- 1
SELECT *
FROM invoice i
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
WHERE il.unit_price > 0.99;

-- 2
SELECT invoice_date, first_name, last_name, total
FROM invoice i
JOIN customer c
    ON i.customer_id = c.customer_id;


-- 3
SELECT c.first_name AS customer_first_name , c.last_name AS customer_last_name, e.first_name AS support_rep_first_name , e.last_name AS support_rep_last_name
FROM customer c
JOIN employee e
    ON c.support_rep_id = e.employee_id;
-- Needed to specify here since unlike #2, there are shared property names between the tables

-- 4
SELECT al.title, ar.name
FROM album al
JOIN artist ar
    ON al.artist_id = ar.artist_id;

-- 5
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p 
    ON pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';

-- 6
SELECT t.name
FROM track t
JOIN playlist_track pt
    ON t.track_id = pt.track_id
WHERE pt.playlist_id = 5;

-- 7
SELECT t.name AS track_name, p.name AS playlist_name
FROM track t
JOIN playlist_track pt
	ON t.track_id = pt.track_id
JOIN playlist p 
	ON pt.playlist_id = p.playlist_id;

-- 8
SELECT t.name, al.title
FROM track t
JOIN album al
	ON t.album_id = al.album_id
JOIN genre g
	ON t.genre_id = g.genre_id
    WHERE g.name = 'Alternative & Punk';


-- Black Diamond
SELECT t.name AS track, g.name AS genre, al.title AS album, ar.name AS artist
FROM playlist p
JOIN playlist_track pt 
	ON p.playlist_id = pt.playlist_id
JOIN track t
	ON pt.track_id = t.track_id
JOIN genre g
	ON t.genre_id = g.genre_id
JOIN album al
	ON t.album_id = al.album_id
JOIN artist ar
	ON al.artist_id = ar.artist_id
		WHERE p.name = 'Music';
 

-- Pracice Nested Queries
-- 1
SELECT *
FROM invoice 
WHERE invoice_id IN (
  SELECT invoice_id
  FROM invoice_line
  WHERE unit_price > 0.99
);  

-- 2
SELECT *
FROM playlist_track 
WHERE playlist_id IN (
  SELECT playlist_id
  FROM playlist
  WHERE name = 'Music'
);  

-- 3
SELECT name
FROM track 
WHERE track_id IN (
  SELECT track_id
  FROM playlist_track
  WHERE playlist_id = 5
);  

-- 4
SELECT *
FROM track 
WHERE genre_id IN (
  SELECT genre_id
  FROM genre
  WHERE name = 'Comedy'
);  

-- 5
SELECT *
FROM track 
WHERE album_id IN (
  SELECT album_id
  FROM album
  WHERE title = 'Fireball'
);  

-- 6
SELECT *
FROM track 
WHERE album_id IN (
  SELECT album_id
  FROM album
  WHERE artist_id IN (
  	SELECT artist_id
    FROM artist
    WHERE name = 'Queen'
  )
);  

-- Practice Updating Rows
-- 1
UPDATE customer
SET fax = null
WHERE fax IS NOT null
RETURNING *;

-- 2
UPDATE customer
SET company = 'Self'
WHERE company IS null
RETURNING *;

-- 3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett'
RETURNING *;

-- 4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'
RETURNING *;

-- 5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id IN (
	SELECT genre_id
  FROM genre
  WHERE name = 'Metal'
)
RETURNING *;

-- Group By
-- 1
SELECT g.name, COUNT(*)
FROM track t
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY g.name;

-- 2
SELECT g.name, COUNT(*)
FROM track t
JOIN genre g 
	ON t.genre_id = g.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- 3
SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar 
	ON al.artist_id = ar.artist_id
GROUP BY ar.name;

-- Use Distinct
-- 1
SELECT DISTINCT composer
FROM track;

-- 2
SELECT DISTINCT billing_postal_code
FROM invoice;

-- 3
SELECT DISTINCT company
FROM customer;

-- Delete Rows
-- 1
-- Copied, pasted and ran the given SQL code

-- 2
DELETE 
FROM practice_delete
WHERE type = 'bronze';

-- 3
DELETE 
FROM practice_delete
WHERE type = 'silver';

-- 4
DELETE 
FROM practice_delete
WHERE value = 150;

-- eCommerce Simulation

-- Create Tables
CREATE TABLE users
(
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(250),
    email VARCHAR(250)
);

CREATE TABLE products
(
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(250),
    price NUMERIC
);

CREATE TABLE orders
(
    order_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    quantity INT
);

-- Add data
INSERT INTO users
  (name, email)
VALUES
  ('Bob', 'bob@thiswebsite.com'),
  ('Donovan', 'theguy@aol.com'),
  ('Kevin', 'kevin@gmail.com');
  
 INSERT INTO products
 		(name, price)
  VALUES
  	('Extra Gum', 0.99),
    ('Bubble Wrap Roll', 27.00),
    ('24 pack of bottled water', 3.69);
    
 INSERT INTO orders
 	(product_id, quantity)
  VALUES
  	(1, 5),
    (2, 1),
    (3, 2),
    (3, 1);

-- Running queries
-- 1
SELECT * 
FROM products p
JOIN orders o 
	ON p.product_id = o.product_id
WHERE order_id = 1;

-- 2
SELECT * 
FROM orders;

-- 3
SELECT SUM(p.price * o.quantity)
FROM products p
JOIN orders o 
	ON p.product_id = o.product_id
  WHERE o.order_id = 1;

-- Adding foreign key
ALTER TABLE ORDERS
ADD COLUMN user_id INT references users(user_id);

-- Updating orders table
UPDATE orders
SET user_id = 1
WHERE order_id = 1
RETURNING *;

UPDATE orders
SET user_id = 2
WHERE order_id = 2
RETURNING *;

UPDATE orders
SET user_id = 3
WHERE order_id = 3
RETURNING *;

UPDATE orders
SET user_id = 1
WHERE order_id = 4
RETURNING *;

-- Running Queries, Part 2
-- 1
SELECT * 
FROM orders o
JOIN users u 
	ON u.user_id = o.user_id
    WHERE o.user_id = 1;

-- 2
SELECT u.name, COUNT(*)
FROM users u
JOIN orders o 
	ON o.user_id = u.user_id
GROUP BY u.user_id 
ORDER BY u.name;

-- Black Diamond
SELECT u.name, SUM(p.price * o.quantity)
FROM users u 
JOIN orders o
	ON u.user_id = o.user_id
JOIN products p
	ON o.product_id = p.product_id
 GROUP BY u.name
 ORDER BY u.name ASC;