-- Use “Sakila” database for the following questions

Use sakila;

-- Q1	Display all tables available in the databse “sakila”

show tables;

-- Q2	Display structure of table “actor”. (4 row)

describe actor;

-- Q3	Display the schema which was used to create table “actor” and view the complete schema using the viewer. (1 row)

Show create table actor;

-- Q4	Display the first and last names of all actors from the table actor. (200 rows)

select first_name, last_name 
from actor;

-- Q5	Which actors have the last name ‘Johansson’. (3 rows)

select * from actor where last_name like 'Johansson';

-- Q6	Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. (200 rows)

select upper(concat(first_name, ' ', last_name))   'Actor Name'
from actor;

-- Q7	You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? (1 row)

select actor_id, first_name, last_name 
from actor where lower(first_name) = lower("Joe");

-- Q8	Which last names are not repeated? (66 rows)

select last_name from actor 
group by last_name 
having count(*) = 1;

-- Q9	List the last names of actors, as well as how many actors have that last name. (121 rows)
select last_name, count(*) actor_count 
from actor 
group by last_name
order by actor_count desc, last_name;

-- Q10	Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables “staff” and “address”. (2 rows)

select stf.first_name, stf.last_name, adr.address, adr.district, adr.postal_code, adr.city_id 
from staff stf
left join address adr
on stf.address_id = adr.address_id;
