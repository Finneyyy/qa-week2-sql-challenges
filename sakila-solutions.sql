use sakila;

/*
	Questions:
    1  List all actors.
	2  Find the surname of the actor with the forename 'John'.	
	3  Find all actors with surname 'Neeson'.
	4  Find all actors with ID numbers divisible by 10.
	5  What is the description of the movie with an ID of 100?
	6  Find every R-rated movie.
	7  Find every non-R-rated movie.
	8  Find the ten shortest movies.
	9  Find the movies with the longest runtime, without using LIMIT.
	10 Find all movies that have deleted scenes.
	11 Using HAVING, reverse-alphabetically list the last names that are not repeated.
	12 Using HAVING, list the last names that appear more than once, from highest to lowest frequency.
	13 Which actor has appeared in the most films?
	14 When is 'Academy Dinosaur' due?
	15 What is the average runtime of all films?
	16 List the average runtime for every film category.
	17 List all movies featuring a robot.
	18 How many movies were released in 2010?
	19 Find the titles of all the horror movies.
	20 List the full name of the staff member with the ID of 2.
	21 List all the movies that Fred Costner has appeared in.
	22 How many distinct countries are there?
	23 List the name of every language in reverse-alphabetical order.
	24 List the full names of every actor whose surname ends with '-son' in alphabetical order by their forename.
	25 Which category contains the most films?
*/
-- 1 List all actors.
select * from actor;

-- 2 Find the surname of the actor with the forename 'John'.
select * from actor where first_name like "%John";

-- 3 Find all actors with surname 'Neeson'.
select * from actor where last_name like "%Neeson";

-- 4 Find all actors with ID numbers divisible by 10.
select * from actor where actor_id % 10 = 0;

-- 5 What is the description of the movie with an ID of 100?
select description from film where film_id = 100;

-- 6 Find every R-rated movie.
select title from film where rating = "R";

-- 7 Find every non-R-rated movie.
select title from film where rating != "R";

-- 8 Find the ten shortest movies.
select title from film order by length asc limit 10;

-- 9 Find the movies with the longest runtime, without using LIMIT.
select title from film where length = (select max(length) from film);

-- 10 Find all movies that have deleted scenes.
select title from film where special_features like "%Deleted Scenes%";

-- 11 Using HAVING, reverse-alphabetically list the last names that are not repeated.
select last_name from actor group by last_name having count(last_name) = 1 order by last_name desc;

-- 12 Using HAVING, list the last names that appear more than once, from highest to lowest frequency.
select last_name from actor group by last_name having count(last_name) != 1 order by count(last_name) desc;

-- 13 Which actor has appeared in the most films?
create view film_actor_names as select actor.actor_id, actor.first_name, actor.last_name, film_actor.film_id from actor join film_actor on actor.actor_id = film_actor.actor_id;
select first_name, last_name from film_actor_names group by actor_id order by count(film_id) desc limit 1;

-- 14 When is 'Academy Dinosaur' due?
select film.title, rental.rental_date, film.rental_duration, date_add(rental.rental_date, interval film.rental_duration day) as due_date from (rental join inventory on rental.inventory_id = inventory.inventory_id) join film on film.film_id = inventory.film_id where film.title = "Academy Dinosaur" and rental.return_date is null;

-- 15 What is the average runtime of all films?
select avg(length) from film;

-- 16 List the average runtime for every film category.
create view film_category_name as select film_category.film_id, category.name from film_category join category on film_category.category_id = category.category_id;
create view film_name_category_name as select film.title, film.length, film_category_name.name from film join film_category_name on film.film_id = film_category_name.film_id;
select avg(length), name as category_name from film_name_category_name group by name;

-- 17 List all movies featuring a robot.
select title from film where description like "%robot%";

-- 18 How many movies were released in 2010?
select count(film_id) from film where release_year = 2010;

-- 19 Find the titles of all the horror movies.
select title from film_name_category_name where name = "Horror";

-- 20 List the full name of the staff member with the ID of 2.
select first_name, last_name from staff where staff_id = 2;

-- 21 List all the movies that Fred Costner has appeared in.
select title from film where film_id in (select film_id from film_actor_names where first_name = "Fred" and last_name = "Costner");

-- 22 How many distinct countries are there?
select distinct country.country from country;

-- 23 List the name of every language in reverse-alphabetical order.
select name from language order by name desc;

-- 24 List the full names of every actor whose surname ends with '-son' in alphabetical order by their forename.
select first_name, last_name from actor where last_name like "%son" order by first_name asc;

-- 25 Which category contains the most films?
select category, count(title) from film_list group by category order by count(title) desc limit 1;




