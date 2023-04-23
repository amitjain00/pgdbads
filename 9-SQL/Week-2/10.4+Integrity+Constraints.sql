USE hr_emp;


drop table course, student;
create table course
(course_id integer primary key,
course_name varchar(20) not null);



create table student
(sid integer primary key ,
sname varchar(20),
course_id integer,
foreign key (course_id) references course(course_id)
);


insert into course values ('One', 'Python'); -- Error


insert into course values( 10,'Python'),(20,'SQL'),(30,'BigData');

insert into course values (30, 'Hive');


insert into student values(1,'Ram',10),(2,'John',20),(3,'Steve',10), (4, 'Rishab',20);

insert into student values ( 5, 'Vishal', 50); -- Error


Update course set course_id = 100 where course_id = 10; -- Error

delete from course where course_id = 20;      -- Error

drop table student;

-- Creating the table with cascade option
create table student
(sid integer primary key ,
sname varchar(20),
course_id integer,
foreign key (course_id) references course(course_id)
on delete cascade
on update cascade
);

insert into student values(1,'Ram',10),(2,'John',20),(3,'Steve',10), (4, 'Rishab',20);


Update course set course_id = 100 where course_id = 10; 

select * from student where course_id = 20;
delete from course where course_id = 20;      


select * from course where course_id = 20;

DESC course;

insert into course values ( 50, NULL);

create table city
(city_id char(3) primary key,
city_name varchar(30) UNIQUE);

desc city;


select * from city;

insert into city values('CHN', 'Chennai'),('BLR','Bangalore');



insert into city values('BAN', 'Bangalore');

select * from employees;

alter table employees add check ( salary>2000);

insert into employees values(104,'Ashok','Patel', 'APATEL', '673.453.1289', '1993-12-19','MK_REP', 1500,NULL, 63,19);


