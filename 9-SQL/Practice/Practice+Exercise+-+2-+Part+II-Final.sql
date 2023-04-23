-- Use “world” database for the following questions

-- Q1	Write a query in SQL to display the code, name, continent and GNP for all the countries whose country name last second word is 'd’, using “country” table. (22 rows)

use world;

select code,name,Continent,GNP 
FROM country where 
     name like '%d_';

-- Q2	Write a query in SQL to display the code, name, continent and GNP of the 2nd and 3rd highest GNP from “country” table. (Japan & Germany)

SELECT code,name,Continent,GNP 
FROM country 
order by GNP desc limit 1,2;
