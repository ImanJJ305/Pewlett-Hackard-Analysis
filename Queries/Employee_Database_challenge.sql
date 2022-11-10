-- Creating tables for Employye Database Challenge
-- Create departments table
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
-- Create employees table
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
-- Create department manager table
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
-- Create salaries table
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, from_date)
);
-- Create department employees table
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);
--Create titles table
CREATE TABLE titles (
	emp_no INT NOT NULL, 
	title VARCHAR NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

--Number of retiring employees by title
--retrieve emp_no, first_name, last_name from Employees Table and title, from_date, and to_date from Titles Table
SELECT em.emp_no,
	   em.first_name,
	   em.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO retirement_titles
FROM employees as em
INNER JOIN titles as ti
ON em.emp_no = ti.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');

-- Remove duplicates from query above
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no)
					rt.first_name,
					rt.last_name,
					rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

--Number of retiring employees by most recent job title
SELECT COUNT(title), title
--INTO retiring_titles
FROM unique_titles
GROUP BY unique_titles.title

--Mentorship program eligibility
SELECT DISTINCT ON (em.emp_no)
		           em.first_name,
				   em.last_name,
				   em.birth_date,
				   de.from_date,
				   de.to_date,
				   ti.title
INTO mentoriship_eligibility
FROM employees as em
INNER JOIN dept_emp as de
ON em.emp_no = de.emp_no
INNER JOIN titles as ti
ON em.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01')
AND (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY em.emp_no;