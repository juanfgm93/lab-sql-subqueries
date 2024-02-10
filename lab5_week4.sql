# 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS number_copies
FROM inventory 
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');

# 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

# 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT CONCAT(first_name, ' ', last_name) AS actor_names
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip');

# 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

# 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country = 'Canada';

# 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT actor_id, COUNT(*) AS count_films
FROM film_actor
GROUP BY actor_id
ORDER BY count_films DESC
LIMIT 1;

SELECT title
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
WHERE film_actor.actor_id = (
							SELECT actor_id
							FROM film_actor
							GROUP BY actor_id
							ORDER BY COUNT(*) DESC
							LIMIT 1);

# 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT customer_id, SUM(amount) AS total_money
FROM payment
GROUP BY customer_id
ORDER BY total_money DESC
LIMIT 1;

SELECT title
FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN customer ON customer.customer_id = rental.customer_id
WHERE customer.customer_id = (
								SELECT customer_id
								FROM payment
								GROUP BY customer_id
								ORDER BY SUM(amount) DESC
								LIMIT 1);

# 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, total_amount
FROM (
    SELECT customer_id,
		   SUM(amount) AS total_amount
    FROM payment
    GROUP BY customer_id) AS customer_payments
WHERE total_amount > (
	SELECT AVG(total_amount)
	FROM (SELECT 
			customer_id,
					SUM(amount) AS total_amount
		  FROM payment
		  GROUP BY customer_id) AS avg_payments);






