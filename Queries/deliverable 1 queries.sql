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

--Create a Unique Titles table using the INTO clause.
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO Unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;
--create a Retiring Titles table to hold the required information.

SELECT COUNT(title), title
FROM Unique_titles 
GROUP BY title
ORDER BY count desc


