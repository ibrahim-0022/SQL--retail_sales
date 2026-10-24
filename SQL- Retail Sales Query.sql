--CREATE TABLE
CREATE TABLE retail_sales
	 		(
				  transactions_id INT PRIMARY KEY,
				  sales_date DATE,
				  sales_time TIME,
				  customer_id INT,
				  gender VARCHAR(15),
				  age INT,
				  category VARCHAR(15),
				  quantiy INT,
				  price_per_unit FLOAT,
				  cogs FLOAT,
				  total_sales FLOAT
	 		)

--DATA EXPLORATION

--How many Sales we have?
SELECT COUNT(*) AS "Total_Sales" 
FROM retail_sales

--How many unique Customers we have?
SELECT COUNT(DISTINCT customer_id) AS "Customers"
FROM retail_sales

--How many unique Categoroy we have?
SELECT DISTINCT category AS "Total Category"
FROM retail_sales


--DATA CLEANING

--
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity

--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sales_date IS NULL 
OR sales_time IS NULL 
OR gender IS NULL 
OR category IS NULL
OR quantity IS NULL 
OR cogs IS NULL 
OR total_sales IS NULL

--
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sales_date IS NULL 
OR sales_time IS NULL 
OR gender IS NULL 
OR category IS NULL
OR quantity IS NULL 
OR cogs IS NULL 
OR total_sales IS NULL


--Data Analysis & Business Key Problems & Answers

-- 1. Write a SQL query to retrieve all columns for sales made on 2022-11-05:
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- 3. Write a SQL query to calculate the total sales(total_sale) for each category.:
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
-- 6. Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category.:
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales :
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
-- 10. Write a SQL query to create each shift and number of orders(Example Morning <12, Afternoon Between 12 & 17, Evening >17):

-------------------------------------------------------------------------------------------------------------

-- 1. Write a SQL query to retrieve all columns for sales made on 2022-11-05:
SELECT *
FROM retail_sales
WHERE sales_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than equal to 4 in the month of Nov-2022:
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	sales_date BETWEEN '2022-11-01' AND '2022-11-30'
	AND
	quantity >= 4

-- 3. Write a SQL query to calculate the total sales(total_sale) for each category.:
SELECT 
	category, 
	SUM(total_sales) AS "Net_sales",
	COUNT(*) AS "Total_orders_for_each_category"
FROM retail_sales
GROUP BY category

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
	ROUND(AVG(age), 2) AS "Average_age"
FROM retail_sales
WHERE category = 'Beauty'

-- 5. Write a SQL query to find all transactions where the total_sales is greater than 1000.:
SELECT * 
FROM retail_sales
WHERE total_sales > 1000

-- 6. Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category.:
SELECT 
	category,
	gender, 
	COUNT(transactions_id) AS "Total_Transactions"
FROM retail_sales
GROUP BY category, gender
ORDER BY 1

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
	Year,
	Month,
	Average_Sales
FROM
(
SELECT 
		EXTRACT(YEAR FROM sales_date) AS Year,
		EXTRACT(MONTH FROM sales_date) AS Month,
		AVG(total_sales) AS Average_Sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales) DESC) as RANK
FROM retail_sales
GROUP BY 1, 2
) AS T1
WHERE RANK = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales :
SELECT 
	customer_id, 
	SUM(total_sales) AS Highest_total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
	category, 
	COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail_sales
GROUP BY category

-- 10. Write a SQL query to create each shift and number of orders
-- 		(Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sales AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS Total_orders
FROM hourly_sales
GROUP BY shift

--END OF PROJECT
