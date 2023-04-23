-- DDL Commands

-- Create a Database .
create database company;

show databases;

-- Drop a database
drop database company;


use company;
-- Create a table with the name customers
create table customers
(
customerid int,
first_name varchar(20),
last_name varchar(20),
country  varchar(20));


show tables;

-- View the structure of the table
describe customers;


-- Alter the table
alter table customers change last_name second_name varchar(20);
describe customers;

alter table customers change second_name last_name varchar(25);

alter table customers modify first_name varchar(25);

alter table customers modify first_name varchar(25) NOT NULL;

alter table customers add column total_exp varchar(20);
alter table customers add column salary int;

alter table customers add date_of_birth date after last_name;

describe customers;

alter table customers drop column salary;

-- Rename a table

rename table customers to customers_info;

show tables;
-- truncate the table

truncate table customers_info;
describe customers_info;


-- Drop the table
drop table customers_info;







