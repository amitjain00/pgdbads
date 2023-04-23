-- Use “world” database for the following questions

use world;

-- Q1	Display all columns and 10 rows from table “city”.(10 rows)

SELECT * FROM city limit 10;

-- Q2	Modify the above query to display from row # 16 to 20 with all columns. (5 rows)

SELECT * FROM city limit 15,5;

-- Q3	How many rows are available in the table city. (1 row)-4079.

SELECT count(ID) FROM city;

-- Q4	Using city table find out which is the most populated city. ('Mumbai (Bombay)', '10500000')

SELECT Name, Population 
FROM city                                            
WHERE Population = (SELECT Max(Population) FROM city);

-- Q5	Using city table find out the least populated city. ('Adamstown', '42')

SELECT Name, Population 
FROM city                                            
WHERE Population = (SELECT Min(Population) FROM city);

-- Q6	Display name of all cities where population is between 670000 to 700000. (13 rows)

SELECT Name, Population FROM city
    WHERE Population BETWEEN 670000 AND 700000;

-- Q7	Find out 10 most populated cities and display them in a decreasing order i.e. most populated city to appear first.

SELECT Name, Population FROM city
ORDER BY Population DESC LIMIT 10;

-- Q8	Order the data by city name and get first 10 cities from city table.

SELECT Name, Population FROM city ORDER By Name LIMIT 10;

-- Q9	Display all the districts of USA where population is greater than 3000000, from city table. (6 rows)

SELECT District, SUM(Population) FROM city
WHERE CountryCode = 'USA' GROUP BY District
HAVING SUM(Population) > 3000000;

-- Q10	What is the value of name and population in the rows with ID =5, 23, 432 and 2021. Pl. write a single query to display the same. (4 rows).

SELECT Name, Population FROM city WHERE ID IN (5, 23, 432, 2021)

