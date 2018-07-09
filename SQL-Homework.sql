use sakila;
show tables;
select count(*) from film;
select count(*) from film_text;

-- 1a. Display the first and last names of all actors from the table actor.

SELECT FIRST_NAME , LAST_NAME FROM ACTOR;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT_WS(" ", first_name, last_name) AS `whole_name` FROM ACTOR;

SELECT  CONCAT_WS(" " , FIRST_NAME ,LAST_NAME) AS ACTOR_NAME FROM ACTOR;

SELECT concat( first_name," ", last_name) AS ACTOR_NAME FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT ACTOR_ID,FIRST_NAME,LAST_NAME, A.* FROM ACTOR A WHERE FIRST_NAME='ED';

-- 
-- 2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM ACTOR WHERE LAST_NAME  LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM ACTOR WHERE LAST_NAME LIKE '%LI%'
ORDER BY LAST_NAME,FIRST_NAME;


-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT * FROM COUNTRY WHERE COUNTRY IN ('Afghanistan', 'Bangladesh', 'China');


-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

ALTER TABLE ACTOR ADD MIDDLE_NAME VARCHAR(20) AFTER FIRST_NAME;

SELECT * FROM ACTOR;


-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

ALTER TABLE ACTOR MODIFY MIDDLE_NAME BLOB ;
DESCRIBE ACTOR;
-- 
-- 3c. Now delete the middle_name column.

ALTER TABLE ACTOR DROP MIDDLE_NAME;

DESCRIBE ACTOR;
-- 
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME,COUNT(LAST_NAME) AS COUNT_OF_LASTNAME FROM ACTOR  GROUP BY LAST_NAME;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(last_name) as 'Count of Last Name'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) <=2;


-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

SELECT * FROM ACTOR WHERE LAST_NAME  LIKE '%WILLIAMS%';

UPDATE ACTOR SET FIRST_NAME ='HARPO'
WHERE FIRST_NAME='GROUCHO'
AND LAST_NAME='WILLIAMS';


-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
-- If the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, 
-- as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, 
-- HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE ACTOR SET FIRST_NAME =
CASE 
WHEN FIRST_NAME = 'HARPO'
THEN 'GROUCHO'
ELSE 'MUCHO GROUCHO'
END
WHERE ACTOR_ID=172;


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- 
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

SHOW CREATE TABLE SAKILA.ADDRESS;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT  FIRST_NAME, LAST_NAME, ADDRESS FROM STAFF S 
INNER JOIN ADDRESS A 
ON S.ADDRESS_ID = A.ADDRESS_ID;

-- 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
DESCRIBE payment;
DESCRIBE STAFF;

SELECT FIRST_NAME,LAST_NAME,SUM(AMOUNT) AS  TOTAL_RUNGUP FROM STAFF S
INNER JOIN PAYMENT P
ON S.STAFF_ID = P.STAFF_ID
GROUP BY P.STAFF_ID
ORDER BY LAST_NAME ASC;
-- HAVING P.PAYMENT_DATE BETWEEN '01-AUG-2005'  AND '31-AUG-2005' ;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT TITLE,COUNT(ACTOR_ID) FROM FILM_ACTOR FA
INNER JOIN FILM F
ON FA.FILM_ID = F.FILM_ID
GROUP BY TITLE;

SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;

SELECT * FROM inventory;
-- 
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT TITLE, COUNT(inventory_id) from FILM F
INNER JOIN inventory I
ON F.FILM_ID = I.FILM_ID
WHERE TITLE = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT FIRST_NAME,LAST_NAME,SUM(AMOUNT) FROM payment P
INNER JOIN CUSTOMER C
ON P.customer_id = C.customer_id
GROUP BY P.customer_id
ORDER BY LAST_NAME ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT * FROM FILM F 
WHERE LANGUAGE_ID IN (SELECT LANGUAGE_ID FROM LANGUAGE  
                                                              WHERE NAME ='ENGLISH')
AND (TITLE LIKE 'K%' ) OR (TITLE LIKE 'Q%' );

SELECT * FROM film_actor;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT FIRST_NAME,LAST_NAME FROM actor A
WHERE ACTOR_ID IN (SELECT ACTOR_ID FROM FILM_ACTOR FA WHERE  FILM_ID IN (SELECT FILM_ID FROM FILM WHERE TITLE ="Alone Trip"));


SELECT LAST_NAME,FIRST_NAME 
FROM ACTOR 
WHERE ACTOR_ID IN 
	(SELECT ACTOR_ID FROM FILM_ACTOR
    WHERE FILM_ID IN
    (SELECT FILM_ID FROM film
    WHERE TITLE ="Alone Trip"));


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT COUNTRY,FIRST_NAME,LAST_NAME,EMAIL FROM COUNTRY C
LEFT JOIN customer CU
ON C.COUNTRY_ID = CU.customer_id
WHERE COUNTRY ='CANADA';
-- 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT TITLE,CATEGORY  FROM FILM_LIST
WHERE CATEGORY ='FAMILY';

USE SAKILA;
-- 7e. Display the most frequently rented movies in descending order.
SELECT I.FILM_ID,F.TITLE,COUNT(R.INVENTORY_ID)  FROM INVENTORY I
INNER JOIN RENTAL R 
ON i.inventory_id = r.inventory_id
INNER JOIN FILM_TEXT  F
ON I.FILM_ID=F.FILM_ID
GROUP BY R.INVENTORY_ID
ORDER BY COUNT(R.INVENTORY_ID) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT  S.STORE_ID,SUM(AMOUNT)  FROM STORE S
INNER JOIN staff ST
ON S.STORE_ID=ST.STORE_ID
INNER JOIN PAYMENT P
ON P.STAFF_ID=ST.STAFF_ID
GROUP BY S.STORE_ID
ORDER BY SUM(AMOUNT);



-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT  S.store_id, C.city, con.country FROM STORE S 
inner join address a
on a.address_id=s.address_id
inner join city  c
on c.city_id = a.city_id
inner join country con
on con.country_id=c.country_id
group by store_id
order by city;

-- order by store_id;
select * from store;
select * from customer;
select * from staff;
select * from address;
select * from city;
select * from country;



-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select * from category;
select * from film_category;
select * from inventory;
select * from payment;
select * from rental;

select sum(p.amount) as amt, c.name as  name from payment p
inner join 
rental r 
on p.rental_id = r.rental_id 
inner join inventory i
on  r.inventory_id = i.inventory_id 
inner join film_category f
on i.film_id = f.film_id 
inner join category c
on f.category_id = c.Category_id
group by c.name
order by amt desc limit 5
;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view  top_5 as (select sum(p.amount) as amt, c.name as  name from payment p
inner join 
rental r 
on p.rental_id = r.rental_id 
inner join inventory i
on  r.inventory_id = i.inventory_id 
inner join film_category f
on i.film_id = f.film_id 
inner join category c
on f.category_id = c.Category_id
group by c.name
order by amt desc limit 5);

-- 8b. How would you display the view that you created in 8a?
select name as business_catogery,amt as collections from top_5;
-- 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view top_5;


