create database employee;
use employee;

select * from Proj_table;

select * from emp_record_table;

INSERT INTO emp_record_table (
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER,
    ROLE, DEPT, EXP, COUNTRY,
    CONTINENT, SALARY, EMP_RATING,
    MANAGER_ID, PROJ_ID
) VALUES (
    'E260', 'Roy', 'Collins', 'M',
    'SENIOR DATA SCIENTIST', 'RETAIL', 7, 'INDIA',
    'Asia', 7000, 3,
    'E583', null
);

select count(*) from emp_record_table;

SELECT PROJECT_ID FROM proj_table
WHERE START_DATE = '2021-06-04';

select * from data_science_team;


SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM 
    information_schema.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'employee' AND
    REFERENCED_TABLE_NAME IS NOT NULL;


select * from data_science_team;
select * from proj_table;
select * from emp_record_table;

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and
-- DEPARTMENT from the employee record table, and make a list of employees
-- and details of their department.

Select emp_id, first_name, last_name, gender, dept
from emp_record_table;


-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER,
-- DEPARTMENT, and EMP_RATING if the EMP_RATING is:
-- ● less than two
-- ● greater than four
-- ● between two and four

Select emp_id,first_name,last_name,gender,dept,emp_rating,
CASE 
	WHEN EMP_RATING < 2 Then 'less than 2'
    WHEN EMP_RATING > 4 Then 'Greater than 4'
    WHEN EMP_RATING BETWEEN 2 AND 4 Then 'Between 2 and 4'
END AS rating_category
from emp_record_table;

-- Write a query to concatenate the FIRST_NAME and the LAST_NAME of
-- employees in the Finance department from the employee table and then give
-- the resultant column alias as NAME.

Select Concat(First_Name,' ', Last_Name) AS Name
from emp_record_table 
where dept = 'Finance';

select * from emp_record_table;





Select emp_id,first_name,last_name,gender,dept,emp_rating
from emp_record_table
Where EMP_RATING < 2 or EMP_RATING > 4 or emp_rating  between 2 and 4;


-- Write a SQL query to retrieve the employee ID, first name, role, and
-- department of employees who hold leadership positions (Manager,
-- President, or CEO).


SELECT EMP_ID, FIRST_NAME, ROLE, DEPT
FROM emp_record_table
WHERE ROLE IN ('Manager', 'President', 'CEO');

-- Write a query to list all the employees from the healthcare and finance
-- departments using the union. Take data from the employee record table.

Select * from emp_record_table
where dept = 'HEALTHCARE'

UNION 

Select * from emp_record_table
where dept = 'FINANCE';


-- Write a query to list employee details such as EMP_ID, FIRST_NAME,
-- LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also
-- include the respective employee rating along with the max emp rating for the
-- department.


Select e.emp_id, e.first_name, e.last_name, e.role, e.dept, e.emp_rating, m.max_rating 
From emp_record_table as e
JOIN (
	Select dept, MAX(emp_rating) as max_rating
	from emp_record_table
	group by dept
) m ON e.dept = m.dept;



SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT,
    EMP_RATING,
    MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS max_rating
FROM emp_record_table;


-- Write a query to calculate the minimum and the maximum salary of the
-- employees in each role. Take data from the employee record table.

Select role, MIN(Salary) as min_salary, MAX(Salary) as max_salary
from emp_record_table
group by role;


-- Write a query to assign ranks to each employee based on their experience.
-- Take data from the employee record table.

Select *,
	Rank() over (order by EXP DESC) as experience_rank
from emp_record_table;


-- .Write a query to create a view that displays employees in various countries
-- whose salary is more than six thousand. Take data from the employee record
-- table.

USE `employee`;
CREATE  OR REPLACE VIEW emp_sal_country AS 
Select * 
from emp_record_table
where salary > 6000;;

Select * from emp_sal_country; 

-- Write a nested query to find employees with experience of more than ten
-- years. Take data from the employee record table.

Select * 
from emp_record_table 
where emp_id IN 
( 
Select emp_id 
	from emp_record_table
	where EXP > 10
);


Select * from data_science_team;


DELIMITER $$

CREATE FUNCTION get_standard_role (EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE expected_role VARCHAR(50);

  IF exp <= 2 THEN
    SET expected_role = 'JUNIOR DATA SCIENTIST';
  ELSEIF exp > 2 AND exp <= 5 THEN
    SET expected_role = 'ASSOCIATE DATA SCIENTIST';
  ELSEIF exp > 5 AND exp <= 10 THEN
    SET expected_role = 'SENIOR DATA SCIENTIST';
  ELSEIF exp > 10 AND exp <= 12 THEN
    SET expected_role = 'LEAD DATA SCIENTIST';
  ELSEIF exp > 12 AND exp <= 16 THEN
    SET expected_role = 'MANAGER';
  ELSE
    SET expected_role = 'UNKNOWN';
  END IF;

  RETURN expected_role;
END $$

DELIMITER ;

SELECT EMP_ID, FIRST_NAME, ROLE AS actual_role, EXP,
  get_standard_role(EXP) AS expected_role,
  CASE
    WHEN ROLE = get_standard_role(EXP) THEN 'Matching'
    ELSE 'Not Matching'
  END AS match_status
FROM data_science_team;


EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';





Select emp_id, first_name, last_name, salary, emp_rating,
round(0.05 * salary * emp_rating,2) as BONUS
from emp_record_table;


-- Write a query to calculate the average salary distribution based on the
-- continent and country. Take data from the employee record table.

Select Continent, Country, ROUND(AVG(Salary),2) AS AVGERAGE_SALARY
from emp_record_table
group by CONTINENT,COUNTRY
order by CONTINENT,COUNTRY;













