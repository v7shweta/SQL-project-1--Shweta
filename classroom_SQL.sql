-- SQL Retail Sales Analaysis-P1
create database sql_project_p1;
use sql_project_p1;
--- create table
drop table if exists retail_sales;
create table retail_sales (
transactions_id	INT primary key ,
sale_date Date 	,
sale_time	Time,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15) ,
quantity	INT,
price_per_unit FLOAT,
cogs	Float,
total_sale Float);

select count(*) from retail_sales; 

-- Data Checking and cleaning
select * from retail_sales
where 
     age is null
     or 
     cogs is null;
     
-- Delete from this table but before set SQL_safe updates as it is a safety mfeature designed to prevent accidentally deleting
SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR age IS NULL
   OR cogs IS NULL;
   
-- Data exploration
-- How many sales we have?
select count(*) as Total_sales from retail_sales;

-- How many uniques customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- How many uniques categories we have?
SELECT COUNT(DISTINCT category) AS total_category FROM retail_sales;

-- Data Analaysis/Business Problems
-- Q1: Retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date="2022-11-05";

-- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select *
from retail_sales
where 
category= "Clothing"
AND 
date_format(sale_date, '%Y-%m') = '2022-11'
and quantity>=4;

-- Q3: To calculate the total sales for each category
select category, sum(total_sale) as Total_Sales, count(transactions_id) as total_orders
from retail_sales
group by category;

-- Q4: To find a average age of customers who purchased items from the 'Beauty' category.
select Avg(age) as Average_Age, category
from retail_sales
where 
category= "Beauty";

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000
select *
from retail_sales
where 
total_sale> 1000;

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select 
count(transactions_id), 
gender, 
category
from retail_sales
group by 
gender, category
order by category;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year????????

select avg(total_sale) as avg_sale, date_format(sale_date, '%m') as month, date_format(sale_date, '%Y') as Year,
rank() over(partition by date_format(sale_date, '%Y') ORDER BY AVG(total_sale) DESC) AS sales_rank
from retail_sales 
group by 
date_format(sale_date, '%m'), date_format(sale_date, '%Y');



-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales
select sum(total_sale), customer_id
from retail_sales
group by 2
order by 1 desc
limit 5;

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct(customer_id)), category
from retail_sales
group by category;

-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)????????

SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift;
 
     









