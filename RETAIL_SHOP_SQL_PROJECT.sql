CREATE TABLE retail(
transactions_id	INT PRIMARY KEY,
sale_date	DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(10),
age	INT,
category VARCHAR(25),	
quantiy	INT,
price_per_unit FLOAT,	
cogs	FLOAT,
total_sale FLOAT

);
SELECT * FROM retail
LIMIT 15

SELECT COUNT(*) FROM retail

SELECT 
customer_id,
COUNT(*) as tot_cust
FROM retail
GROUP BY 1

SELECT * FROM retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


DELETE FROM retail
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

SELECT COUNT(*) AS TOT_SALES FROM retail

SELECT COUNT(DISTINCT customer_id) AS TOT_CUST_ID FROM retail

SELECT DISTINCT category FROM retail

SELECT * FROM retail

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail
WHERE sale_date = '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail
WHERE category = 'Clothing' AND quantiy >=3 AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
category,
SUM(total_sale) as tot_sale,
COUNT (*) as tot_orders
FROM retail
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
category,
ROUND(AVG(age),3) as avg_age
FROM retail
WHERE category ='Beauty'
GROUP BY 1
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail WHERE total_sale >=1000 ORDER BY total_sale DESC

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
gender,
category,
COUNT(transactions_id) as tot_transact
FROM retail
GROUP BY 1,2
ORDER BY category
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
year_s,
month_s,
avg_tot_sale,
Best_month
FROM(
SELECT 
EXTRACT(YEAR FROM sale_date) as year_s,
EXTRACT(MONTH FROM sale_date) as month_s,
AVG(total_sale) as avg_tot_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as Best_month
FROM retail
GROUP BY 1,2
) as t1
WHERE Best_month =1

 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
customer_id,
SUM(total_sale) as tot_sale
FROM retail 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
category,
COUNT(DISTINCT customer_id) as unq_cust
FROM retail
GROUP BY 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
CASE
WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift
FROM retail
)
SELECT
shift,
COUNT(*)
FROM hourly_sale
GROUP BY shift

