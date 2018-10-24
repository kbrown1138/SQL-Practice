USE sakila;

-- Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor; 

-- Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) AS "Actor Name" FROM actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
     FROM actor
     WHERE first_name="Joe";

-- Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name
	FROM actor
    WHERE last_name LIKE "%GEN%";

-- Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
	FROM actor
    WHERE last_name LIKE "%LI%";

-- Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country
	FROM country
    WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- You want to keep a description of each actor. You don't think you will be performing queries 
-- on a description, so create a column in the table "actor" named "description" and use the data type BLOB.
ALTER TABLE actor
	ADD description BLOB;

-- Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor
	DROP description;

-- List the last names of actors, as well as how many actors have that last name.
SELECT DISTINCT last_name, COUNT(last_name) AS "Number of Actors"
  FROM actor
  GROUP BY last_name;

-- List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT DISTINCT last_name, COUNT(last_name) AS "Number of Actors"
  FROM actor
  GROUP BY last_name
  HAVING COUNT(last_name) >= 2;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor
	SET first_name="HARPO"
	WHERE actor_id = 172;

-- Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
	SET first_name="GROUCHO"
	WHERE actor_id = 172;

-- You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
CREATE TABLE `address` (`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
	`address` varchar(50) NOT NULL,  `address2` varchar(50) DEFAULT NULL,  `district` varchar(20) NOT NULL,  
	`city_id` smallint(5) unsigned NOT NULL,  `postal_code` varchar(10) DEFAULT NULL,  
	`phone` varchar(20) NOT NULL,  `location` geometry NOT NULL,  
	`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
	PRIMARY KEY (`address_id`),  KEY `idx_fk_city_id` (`city_id`),  SPATIAL KEY `idx_location` (`location`),  
	CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) 
    ON UPDATE CASCADE) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT staff.first_name, staff.last_name, address.address
	FROM staff
	JOIN address ON
    staff.address_id = address.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT SUM(payment.amount) AS "Total Amount"
	FROM payment
	JOIN staff ON
    payment.staff_id = staff.staff_id
	WHERE payment_date BETWEEN "2005-08-01" AND "2005-08-31"
    GROUP BY payment.staff_id;

-- List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner join.
SELECT COUNT(film_actor.actor_id) AS "Number of Actors", film.title
	FROM film_actor
    INNER JOIN film ON
    film_actor.film_id = film.film_id
    GROUP BY film.title;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title, COUNT(inventory.inventory_id) AS "Number of Copies"
	FROM film
    INNER JOIN inventory ON
    film.film_id = inventory.film_id
    WHERE film.title = "Hunchback Impossible";

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS "Total Amount"
	FROM customer
    JOIN payment ON
    customer.customer_id = payment.customer_id
    GROUP BY customer.first_name, customer.last_name
    ORDER BY customer.last_name ASC;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE (title LIKE "K%" OR title LIKE "Q%") AND
language_id IN
	(SELECT language_id
		FROM language
		WHERE name = "English");

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
		FROM film_actor
        WHERE film_id IN
			(SELECT film_id
				FROM film
                WHERE title = "Alone Trip"));

-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email
	FROM customer
    JOIN address ON
    customer.address_id = address.address_id
    JOIN city ON
    address.city_id = city.city_id
    JOIN country ON
    city.country_id = country.country_id
    WHERE country.country = "Canada";