# Pewlett-Hackard-Analysis

## Overview of the Analysis
The purpose of this analysis is to determine the number of retiring employees per title and identify employees who will be eligible to participate in a mentorship program.
We will do this by using Postgre SQL and pgAdmin.

## Results

### SQL
Using this program we identify data relationships between datasets and common colums. To identify the relationship we use database keys ( primary, foreign, and uinque).

    Primary: is a column or a set of columns that uniquely identifies each row in the table.
    Foreign: is a column or group of columns in a table that links to a column or group of columns in another table.
    Unique: is used to uniquely identify one or more fields in a table.

### Data Modeling
Inspect the CSVs and sketch out an ERD of the tables using QuickDBD
![ERD](https://github.com/alainacox/Pewlett-Hackard-Analysis/blob/main/EmployeeDB.png)

As you can see each table is linked to to another table and each has a primary key.

### Data Engineering
* Use the information to create a table schema for each of the six CSV files. Remember to specify data types, primary keys, foreign keys, and other constraints.
* Import each CSV file into the corresponding SQL table.

```  
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
Create table dept_emp (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	dept_no VARCHAR(30) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	from_date Date NOT NULL,
	to_date Date NOT NULL
);
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(25) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL, 
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no,title,from_date)
);
```
### Data Analysis
Once I completed the database, I then was able to preformed queries to do the following:
    * Filter the data by birth dates
    * Joined tables
    * Filter using the WHERE clause
    * Using the ORDER BY clause
    * Using the COUNT function
    * To create new tables using the INTO

## Summary
In conclusion I created three new queries to give a little more insight on the "silver tsunami" on how many current employees reach retirement age.

The first query was to use to filter the table on employees that were born between January 01, 1952 to December 31, 1955 using the following code 
```
--Filter the data on the birth_date column to retrieve the employees who were born between 1952 and 1955. Then, order by the employee number.
SELECT e.emp_no,
    e.first_name,
e.last_name,
    ti.title,
    ti.from_date,
    ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
```
The second query was create to highlight which employees are close to retiring and what their titles are. I used the following the code.
```
--Create a Unique Titles table using the INTO clause.
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO Unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;
```
 I used the above query to create a table that would show how many people are retiring from each title.
 ![table](https://github.com/alainacox/Pewlett-Hackard-Analysis/blob/main/retiring_titles_table.png)
 
 The three query was created to show how which employees my be eligible for the mentorship program. I used the following functions
  * Distinct On
  * Inner Joins
  * Into
  * Order by
  * Where
Using all of the above function give you the following code 
```
SELECT
    DISTINCT ON(emp_no) e.emp_no,
    e.first_name,
    e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
Order By emp_no;
```
Which creates a table with all the employees that are  eligibile to participate in the mentorship program.
