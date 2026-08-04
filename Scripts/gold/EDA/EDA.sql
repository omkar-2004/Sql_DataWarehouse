/*
===============================================================
Exploratory Data Analysis
===============================================================

Scrip Purpose:
	This Script stores procedure that perform EDA.

Actions Performed:
	- Database Exploration
	- Dimension Exploration
	- Date Exploration
	- Measure Exploration
	- Geographical Analysis (By Country)
	- Product Hierarchy Analysis (By Category & Subcategory)
	- Product Line Analysis (By Product Line)
	- Demographic Analysis (By Gender)
	- Ranking by Sales Performance
	- Ranking by Volume & Demand
	- Ranking by Costs
	- Ranking by Pricing Structure
	- Ranking by Frequency & Customer Base
*/

-- ===============================================================
-- Database Exploration
-- ===============================================================

SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
Where TABLE_SCHEMA = 'gold';

-- ===============================================================
-- Dimension Exploration: Formula = COUNT(DISTINCT[Dimension]) & DISTINCT[Dimension] & count([Dimension)
-- ===============================================================

-- Customers Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Count Total Customers.

SELECT 
	COUNT(*) AS Total_customers
FROM gold.dim_customers;

-- ---------------------------------------------------------------

-- Count and list distinct countries.

SELECT 
	COUNT(DISTINCT country) AS Total_country
FROM gold.dim_customers;

SELECT 
	DISTINCT country 
FROM gold.dim_customers;

-- ---------------------------------------------------------------

-- List Distinct marital_status.

SELECT 
	DISTINCT marital_status 
FROM gold.dim_customers;

-- ---------------------------------------------------------------

-- List Distinct gender.

SELECT	
	DISTINCT gender
FROM gold.dim_customers;

-- ===============================================================

-- Products Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Count Total Products.

SELECT 
	COUNT(*) AS Total_products
FROM gold.dim_products;

-- ---------------------------------------------------------------

-- Count and list Distinct category.

SELECT
	count(DISTINCT category) AS Total_category
FROM gold.dim_products;

SELECT
	DISTINCT category
FROM gold.dim_products;

-- ===============================================================

-- Count and List Distinct subcategory.

SELECT
	count(DISTINCT subcategory) AS Total_subcategory
FROM gold.dim_products;

SELECT 
	DISTINCT subcategory
FROM gold.dim_products;

-- ===============================================================

-- Count Distinct maintenance.

SELECT 
	DISTINCT maintenance
FROM gold.dim_products;

-- ===============================================================

-- Count and list Distinct product_line.

SELECT 
	COUNT(DISTINCT product_line) AS Total_product_line
FROM gold.dim_products;

SELECT 
	DISTINCT product_line
FROM gold.dim_products;

-- ===============================================================

-- Sales Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Count Total orders.

SELECT 
	COUNT(*) AS Total_orders
FROM gold.fact_sales;

-- ===============================================================
-- Date Exploration: Formula = MIN/MAX [Date], DATEDIFF[MIN/MAX [Date]]
-- ===============================================================

-- Customers Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Find oldest birthdate, youngest birthdate, oldest age, youngest age and year differance.

SELECT
	min(birthdate) AS oldest_birthdate,
	DATEDIFF(year,min(birthdate),GETDATE()) AS oldest_age,
	max(birthdate) AS youngest_date,
	DATEDIFF(year,max(birthdate),GETDATE()) AS youngest_age,
	DATEDIFF(year,min(birthdate),max(birthdate)) AS year_diff
FROM gold.dim_customers

-- ===============================================================

-- Find first customer creation date, leatest creation date and creation date range in months.

SELECT
	min(create_date) AS first_creation_date,
	max(create_date) AS leatest_creation_date,
	DATEDIFF(month,min(create_date),max(create_date)) AS create_date_range_month
FROM gold.dim_customers

-- ===============================================================

-- Products Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Find first start date, leatest start date and start date range in years.

SELECT
	min(start_date) AS first_start_date,
	max(start_date) AS leatest_start_date,
	DATEDIFF(year,min(start_date),max(start_date)) AS start_date_range_year
FROM gold.dim_products

-- ===============================================================

-- Sales Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Find first order date, leatest order date and order date range in years.
SELECT
	min(order_date) AS first_order,
	max(order_date) AS leatest_order,
	DATEDIFF(year,min(order_date),max(order_date)) AS order_range_year
FROM gold.fact_sales

-- ===============================================================

-- Find first shipping date, leatest shipping date and shipping date range in years.

SELECT
	min(shipping_date) AS first_shipping,
	max(shipping_date) AS leatest_shipping,
	DATEDIFF(year,min(shipping_date),max(shipping_date)) AS shipping_range_year
FROM gold.fact_sales

-- ===============================================================

-- Find first due date, leatest due date and  due date range in years.

SELECT
	min(due_date) AS first_due,
	max(due_date) AS leatest_due,
	DATEDIFF(year,min(due_date),max(due_date)) AS due_range_year
FROM gold.fact_sales

-- ===============================================================
-- Measure Exploration: Formula = [Aggrigate function]([Measure])
-- ===============================================================

-- Products Table

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Find Total, minimum, maximum and average product cost.

SELECT 
	SUM(product_cost) AS Total_product_cost,
	MIN(product_cost) AS Min_product_cost,
	MAX(product_cost) AS Max_product_cost,
	AVG(product_cost) AS Avg_product_cost
FROM gold.dim_products

-- ===============================================================

-- Sales Table

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=

-- Find Total, minimum, maximum and average price.

SELECT 
	SUM(price) AS Total_price,
	MIN(price) AS Min_price,
	MAX(price) AS Max_price,
	AVG(price) AS Avg_price
FROM gold.fact_sales;

-- ===============================================================

-- Find Total, minimum, maximum and average quantity.

SELECT 
	SUM(quantity) AS Total_quantity,
	MIN(quantity) AS Min_quantity,
	MAX(quantity) AS Max_quantity,
	AVG(quantity) AS Avg_quantity
FROM gold.fact_sales;

-- ===============================================================

-- Find Total, minimum, maximum and average Sales Amount.

SELECT 
	SUM(sales_amount) AS Total_sales_amount,
	MIN(sales_amount) AS Min_sales_amount,
	MAX(sales_amount) AS Max_sales_amount,
	AVG(sales_amount) AS Avg_sales_amount
FROM gold.fact_sales;

-- ===============================================================
-- Magnitude: Formula = ([Aggrigate function][ Measure] By [ Dimension ] )
-- ===============================================================

-- ***************************************************************
-- Geographical Analysis (By Country)
-- ***************************************************************

-- Find Total Customers by country.
-- Find Total orders by country.
-- Find Total_product_cost, Min_product_cost, Max_product_cost and Avg_product_cost by country.
-- Find Total_price, Min_price, Max_price and Avg_price by country.
-- Find Total_quantity, Min_quantity, Max_quantity and Avg_quantity by country.
-- Find Total_sales_amount, Min_sales_amount, Max_sales_amount and Avg_sales_amount by country.

SELECT
	c.country,
	COUNT(DISTINCT c.customer_id) AS Total_customers,
	COUNT(s.order_number) AS Total_orders,
	SUM(p.product_cost) AS Total_product_cost,
	MIN(p.product_cost) AS Min_product_cost,
	MAX(p.product_cost) AS Max_product_cost,
	AVG(p.product_cost) AS Avg_product_cost,
	SUM(s.price) AS Total_price,
	MIN(s.price) AS Min_price,
	MAX(s.price) AS Max_price,
	AVG(s.price) AS Avg_price,
	SUM(s.quantity) AS Total_quantity,
	MIN(s.quantity) AS Min_quantity,
	MAX(s.quantity) AS Max_quantity,
	AVG(s.quantity) AS Avg_quantity,
	SUM(s.sales_amount) AS Total_sales_amount,
	MIN(s.sales_amount) AS Min_sales_amount,
	MAX(s.sales_amount) AS Max_sales_amount,
	AVG(s.sales_amount) AS Avg_sales_amount
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products as p
ON s.product_key = p.product_key
WHERE c.country != 'n/a'
GROUP BY c.country
ORDER BY SUM(s.sales_amount) DESC;
 


-- ***************************************************************
-- Product Hierarchy Analysis (By Category & Subcategory)
-- ***************************************************************

-- Find Total Customers by category and subcategory.
-- Find Total orders by category and subcategory.
-- Find Total products by category and subcategory.
-- Find Total_product_cost, Min_product_cost, Max_product_cost and Avg_product_cost by category and subcategory.
-- Find Total_price, Min_price, Max_price and Avg_price by category and subcategory.
-- Find Total_quantity, Min_quantity, Max_quantity and Avg_quantity by category and subcategory.
-- Find Total_sales_amount, Min_sales_amount, Max_sales_amount and Avg_sales_amount by category and subcategory.

SELECT
	p.category,
	p.subcategory,
	COUNT(DISTINCT c.customer_key) AS Total_customers,
	COUNT(s.order_number) AS Total_orders,
	COUNT(DISTINCT p.product_number) AS Total_products ,
	SUM(p.product_cost) AS Total_product_cost,
	MIN(p.product_cost) AS Min_product_cost,
	MAX(p.product_cost) AS Max_product_cost,
	AVG(p.product_cost) AS Avg_product_cost,
	SUM(s.price) AS Total_price,
	MIN(s.price) AS Min_price,
	MAX(s.price) AS Max_price,
	AVG(s.price) AS Avg_price,
	SUM(s.quantity) AS Total_quantity,
	MIN(s.quantity) AS Min_quantity,
	MAX(s.quantity) AS Max_quantity,
	AVG(s.quantity) AS Avg_quantity,
	SUM(s.sales_amount) AS Total_sales_amount,
	MIN(s.sales_amount) AS Min_sales_amount,
	MAX(s.sales_amount) AS Max_sales_amount,
	AVG(s.sales_amount) AS Avg_sales_amount
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category,p.subcategory
ORDER BY SUM(s.sales_amount) DESC;

-- ***************************************************************
-- Product Line Analysis (By Product Line)
-- ***************************************************************

-- Find Total Customers by product_line.
-- Find Total orders by product_line.
-- Find Total_product_cost, Min_product_cost, Max_product_cost and Avg_product_cost by product_line.
-- Find Total_price, Min_price, Max_price and Avg_price by product_line.
-- Find Total_quantity, Min_quantity, Max_quantity and Avg_quantity by product_line.
-- Find Total_sales_amount, Min_sales_amount, Max_sales_amount and Avg_sales_amount by product_line.

SELECT
	p.product_line,
	COUNT(DISTINCT c.customer_key) AS Total_customers,
	COUNT(s.order_number) AS Total_orders,
	SUM(p.product_cost) AS Total_product_cost,
	MIN(p.product_cost) AS Min_product_cost,
	MAX(p.product_cost) AS Max_product_cost,
	AVG(p.product_cost) AS Avg_product_cost,
	SUM(s.price) AS Total_price,
	MIN(s.price) AS Min_price,
	MAX(s.price) AS Max_price,
	AVG(s.price) AS Avg_price,
	SUM(s.quantity) AS Total_quantity,
	MIN(s.quantity) AS Min_quantity,
	MAX(s.quantity) AS Max_quantity,
	AVG(s.quantity) AS Avg_quantity,
	SUM(s.sales_amount) AS Total_sales_amount,
	MIN(s.sales_amount) AS Min_sales_amount,
	MAX(s.sales_amount) AS Max_sales_amount,
	AVG(s.sales_amount) AS Avg_sales_amount
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_line
ORDER BY SUM(s.sales_amount) DESC;

-- ***************************************************************
-- Demographic Analysis (By Gender)
-- ***************************************************************

-- Find Total Customers by gender.
-- Find Total orders by gender.
-- Find Total_product_cost, Min_product_cost, Max_product_cost and Avg_product_cost by gender.
-- Find Total_price, Min_price, Max_price and Avg_price by gender.
-- Find Total_quantity, Min_quantity, Max_quantity and Avg_quantity by gender.
-- Find Total_sales_amount, Min_sales_amount, Max_sales_amount and Avg_sales_amount by gender.

SELECT
	c.gender,
	COUNT(DISTINCT c.customer_key) AS Total_customers,
	COUNT(s.order_number) AS Total_orders,
	SUM(p.product_cost) AS Total_product_cost,
	MIN(p.product_cost) AS Min_product_cost,
	MAX(p.product_cost) AS Max_product_cost,
	AVG(p.product_cost) AS Avg_product_cost,
	SUM(s.price) AS Total_price,
	MIN(s.price) AS Min_price,
	MAX(s.price) AS Max_price,
	AVG(s.price) AS Avg_price,
	SUM(s.quantity) AS Total_quantity,
	MIN(s.quantity) AS Min_quantity,
	MAX(s.quantity) AS Max_quantity,
	AVG(s.quantity) AS Avg_quantity,
	SUM(s.sales_amount) AS Total_sales_amount,
	MIN(s.sales_amount) AS Min_sales_amount,
	MAX(s.sales_amount) AS Max_sales_amount,
	AVG(s.sales_amount) AS Avg_sales_amount
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE gender != 'n/a'
GROUP BY c.gender
ORDER BY SUM(s.sales_amount) DESC;

-- ===============================================================
-- Ranking Formula : ( Rank [ Dimension ] By Agg [ Measure ] )
-- ===============================================================

-- ***************************************************************
-- Ranking by Sales Performance
-- ***************************************************************

-- Top and bottom Country By Total_sales_amount

SELECT 
	c.country,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Country_Sales_Rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country;

-- Top and bottom, category,subcategory,productnsme By Total_sales_amount

-- Query 1

SELECT TOP 1 
	'Top Tier' AS Performance_tier,
	p.category,
	p.subcategory,
	p.product_name,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS category_Sales_Rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category,p.subcategory,p.product_name

UNION ALL

SELECT TOP 1 
	'Bottom Tier' AS Performance_tier,
	p.category,
	p.subcategory,
	p.product_name,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount)) AS category_Sales_Rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category,p.subcategory,p.product_name;

-- Query 2

WITH Categorical_Ranking AS (
SELECT 
	p.category,
	p.subcategory,
	p.product_name,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Top_Rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) ASC) AS Bottom_Rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category,p.subcategory,p.product_name)
SELECT 
	CASE 
		WHEN Top_Rank = 1 THEN 'Top Tier'
		Else 'Bottom Tier' 
	END performance_tier,
	category,
	subcategory,
	product_name,
	Total_sales_amount
FROM Categorical_Ranking
WHERE Top_Rank = 1 OR Bottom_Rank = 1
ORDER BY Total_sales_amount DESC
;

-- Top and bottom product_line By Total_sales_amount
WITH product_line_By_Total_sales_amount AS (
SELECT 
	P.product_line,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_line)
SELECT
	CASE 
		WHEN Top_Rank = 1 THEN 'Top Tier'
		Else 'Bottom Tier' 
	END performance_tier,
	product_line,
	Total_sales_amount
FROM product_line_By_Total_sales_amount
WHERE Top_rank = 1 or Bottom_rank = 1
ORDER BY Total_sales_amount DESC;

-- Rank gender by Total_sales_amount

SELECT
	c.gender,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS Gender_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.gender != 'n/a'
GROUP BY c.gender;

-- Rank  marital_status by Total_sales_amount

SELECT 
	c.marital_status,
	SUM(s.sales_amount) AS Total_sales_amount,
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount)  DESC) AS ms_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.marital_status;

-- Top and bottom Country By Avg_sales_amount
WITH Ranking_AVG AS(
SELECT 
	c.country,
	AVG(s.sales_amount) AS Avg_sales_amount,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.country)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		Else 'Bottom Tier'
	END performance_tier,
	country,
	Avg_sales_amount
FROM Ranking_AVG
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Avg_sales_amount DESC;

-- Top and bottom category By Avg_sales_amount
WITH Ranking_AVG_by_category AS(
SELECT 
	p.category,
	AVG(s.sales_amount) AS Avg_sales_amount,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	category,
	Avg_sales_amount
FROM Ranking_AVG_by_category
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Avg_sales_amount DESC;

-- Top and bottom subcategory By Avg_sales_amount

WITH Ranking_AVG_by_subcategory AS(
SELECT 
	p.subcategory,
	AVG(s.sales_amount) AS Avg_sales_amount,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.subcategory)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	subcategory,
	Avg_sales_amount
FROM Ranking_AVG_by_subcategory
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Avg_sales_amount DESC;

-- Top and bottom product_line By Avg_sales_amount

WITH Ranking_AVG_by_product_line AS(
SELECT 
	p.product_line,
	AVG(s.sales_amount) AS Avg_sales_amount,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_line)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	product_line,
	Avg_sales_amount
FROM Ranking_AVG_by_product_line
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Avg_sales_amount DESC;

-- Rank gender by Avg_sales_amount

WITH Ranking_AVG_by_gender AS(
SELECT 
	c.gender,
	AVG(s.sales_amount) AS Avg_sales_amount,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.sales_amount)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE gender != 'n/a'
GROUP BY c.gender)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	gender,
	Avg_sales_amount
FROM Ranking_AVG_by_gender
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Avg_sales_amount DESC;

-- ***************************************************************
-- Ranking by Volume & Demand
-- ***************************************************************

-- Top and bottom country By Total_quantity

WITH Ranking_quantity_by_country AS(
SELECT 
	c.country,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	country,
	Total_quantity
FROM Ranking_quantity_by_country
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_quantity DESC;

-- Top and bottom category By Total_quantity

WITH Ranking_quantity_by_Category AS(
SELECT 
	p.category,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.category != 'n/a'
GROUP BY p.category)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	category,
	Total_quantity
FROM Ranking_quantity_by_category
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_quantity DESC;


-- Top and bottom subcategory By Total_quantity

WITH Ranking_quantity_by_subCategory AS(
SELECT 
	p.subcategory,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.subcategory != 'n/a'
GROUP BY p.subcategory)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	subcategory,
	Total_quantity
FROM Ranking_quantity_by_subCategory
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_quantity DESC;

-- Top and bottom product_line By Total_quantity

WITH Ranking_quantity_by_product_line AS(
SELECT 
	p.product_line,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity)) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.product_line != 'n/a'
GROUP BY p.product_line)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELse 'Bottom Tier'
	END performance_tier,
	product_line,
	Total_quantity
FROM Ranking_quantity_by_product_line
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_quantity DESC;

-- Top and bottom maintenance By Total_quantity

WITH RANKING_Maintanance AS (
SELECT 
	p.maintenance,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC) AS Top_tier,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) ASC) AS  Bottom_tier
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE p.maintenance != 'n/a'
GROUP BY p.maintenance)
SELECT
	CASE
		WHEN Top_tier = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_tier,
	maintenance,
	Total_quantity
FROM RANKING_Maintanance
WHERE Top_tier = 1 OR Bottom_tier = 1
ORDER BY Total_quantity DESC;

-- Top and bottom gender By Total_quantity

WITH Ranking_Total_quantity_by_gender AS(
SELECT 
	c.gender,
	SUM(s.quantity) AS Total_quantity,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) DESC ) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(s.quantity) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.gender != 'n/a'
GROUP BY c.gender)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_tier,
	gender,
	Total_quantity
FROM Ranking_Total_quantity_by_gender
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_quantity DESC;

-- ***************************************************************
-- Ranking by Costs
-- ***************************************************************

-- Top and bottom country By Total_product_cost
WITH Ranking_country_by_product_cost AS (
SELECT
	c.country,
	SUM(p.product_cost) AS Total_product_cost,
	ROW_NUMBER() OVER(ORDER BY SUM(p.product_cost) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY SUM(p.product_cost) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE country != 'n/a'
GROUP BY c.country)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_tier,
	country,
	Total_product_cost
FROM Ranking_country_by_product_cost
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_product_cost DESC;

-- Top and bottom category By Avg_product_cost

WITH Ranking_category_by_avg_product_cost AS (
SELECT
	p.category,
	AVG(p.product_cost) AS AVG_product_cost,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) ASC) AS Bottom_rank
FROM gold.dim_products AS p
WHERE p.category IS NOT NULL
GROUP BY p.category)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END AS performance_Tier,
	category,
	AVG_product_cost
FROM Ranking_category_by_avg_product_cost
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY AVG_product_cost DESC;

-- Top and bottom subcategory By Avg_product_cost

WITH Ranking_subcategory_by_avg_product_cost AS (
SELECT
	p.subcategory,
	AVG(p.product_cost) AS AVG_product_cost,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) ASC) AS Bottom_rank
FROM gold.dim_products AS p
WHERE p.subcategory IS NOT NULL
GROUP BY p.subcategory)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END AS performance_Tier,
	subcategory,
	AVG_product_cost
FROM Ranking_subcategory_by_avg_product_cost
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY AVG_product_cost DESC;

-- Top and bottom product_line By Avg_product_cost

WITH Ranking_ProductLine_by_avg_product_cost AS (
SELECT
	p.product_line,
	AVG(p.product_cost) AS AVG_product_cost,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(p.product_cost) ASC) AS Bottom_rank
FROM gold.dim_products AS p
WHERE p.product_line IS NOT NULL
GROUP BY p.product_line)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END AS performance_Tier,
	product_line,
	AVG_product_cost
FROM Ranking_ProductLine_by_avg_product_cost
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY AVG_product_cost DESC;

-- ***************************************************************
-- Ranking by Pricing Structure
-- ***************************************************************

-- Top and bottom category By Avg_price

WITH Ranking_category_by_Avg_Price AS(
SELECT 
	p.category,
	AVG(s.price) AS Avg_price,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category)
SELECT 
	CASE 
		WHEN Top_rank = 1 THEN 'Top Rank'
		ELSE 'Bottom Rank'
	END performance_tier,
	category,
	Avg_price
FROM Ranking_category_by_Avg_Price
WHERE Top_rank = 1 OR Bottom_rank =1
ORDER BY Avg_price DESC;

-- Top and bottom subcategory By Avg_price

WITH Ranking_subcategory_by_Avg_Price AS(
SELECT 
	p.subcategory,
	AVG(s.price) AS Avg_price,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.subcategory)
SELECT 
	CASE 
		WHEN Top_rank = 1 THEN 'Top Rank'
		ELSE 'Bottom Rank'
	END performance_tier,
	subcategory,
	Avg_price
FROM Ranking_subcategory_by_Avg_Price
WHERE Top_rank = 1 OR Bottom_rank =1
ORDER BY Avg_price DESC;

-- Top and bottom product_line By Avg_price

WITH Ranking_product_line_by_Avg_Price AS(
SELECT 
	p.product_line,
	AVG(s.price) AS Avg_price,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_line)
SELECT 
	CASE 
		WHEN Top_rank = 1 THEN 'Top Rank'
		ELSE 'Bottom Rank'
	END performance_tier,
	product_line,
	Avg_price
FROM Ranking_product_line_by_Avg_Price
WHERE Top_rank = 1 OR Bottom_rank =1
ORDER BY Avg_price DESC;

-- Top and bottom maintenance By Avg_price

WITH Ranking_maintenance_by_Avg_Price AS(
SELECT 
	p.maintenance,
	AVG(s.price) AS Avg_price,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY AVG(s.price) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.maintenance)
SELECT 
	CASE 
		WHEN Top_rank = 1 THEN 'Top Rank'
		ELSE 'Bottom Rank'
	END performance_tier,
	maintenance,
	Avg_price
FROM Ranking_maintenance_by_Avg_Price
WHERE Top_rank = 1 OR Bottom_rank =1
ORDER BY Avg_price DESC;

-- Top and bottom category By Max_price

WITH Ranking_category_by_Max_Price AS(
SELECT 
	p.category,
	MAX(s.price) AS Max_price,
	ROW_NUMBER() OVER(ORDER BY MAX(s.price) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY MAX(s.price) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.category)
SELECT 
	CASE 
		WHEN Top_rank = 1 THEN 'Top Rank'
		ELSE 'Bottom Rank'
	END performance_tier,
	category,
	Max_price
FROM Ranking_category_by_Max_Price
WHERE Top_rank = 1 OR Bottom_rank =1
ORDER BY Max_price DESC;


-- ***************************************************************
-- Ranking by Frequency & Customer Base
-- ***************************************************************

-- Rank country by total_orders

WITH Ranking_country_by_total_orders As (
SELECT
	c.country,
	COUNT(s.order_number) AS Total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(s.order_number) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY COUNT(s.order_number) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_Tier,
	country,
	Total_orders
FROM Ranking_country_by_total_orders
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_orders DESC;

-- Rank gender by total_orders

WITH Ranking_gender_by_total_orders As (
SELECT
	c.gender,
	COUNT(s.order_number) AS Total_orders,
	ROW_NUMBER() OVER(ORDER BY COUNT(s.order_number) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY COUNT(s.order_number) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.gender != 'n/a'
GROUP BY c.gender)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_Tier,
	gender,
	Total_orders
FROM Ranking_gender_by_total_orders
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_orders DESC;

-- Rank country by total_customers
WITH Ranking_country_by_total_customers AS (
SELECT 
	c.country,
	COUNT(c.customer_number) as Total_customers,
	ROW_NUMBER() OVER(ORDER BY COUNT(c.customer_number) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY COUNT(c.customer_number) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_Tier,
	country,
	Total_customers
FROM Ranking_country_by_total_customers
WHERE Top_rank =1 OR Bottom_rank = 1
ORDER BY Total_customers DESC;

-- Rank marital_status by total_customers

With Marital_status_BY_Total_customers AS(
SELECT 
	c.marital_status,
	COUNT(c.customer_number) as Total_customers,
	ROW_NUMBER() OVER(ORDER BY COUNT(c.customer_number) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY COUNT(c.customer_number) ASC) AS Bottom_rank
FROM gold.dim_customers AS c
GROUP BY c.marital_status)
SELECT
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_Tier,
	marital_status,
	Total_customers
FROM Marital_status_BY_Total_customers
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_customers DESC;

-- Rank country by total_products
WITH Ranking_country_by_total_products AS(
SELECT
	 c.country,
	 COUNT(p.product_key) AS Total_products,
	ROW_NUMBER() OVER(ORDER BY COUNT(p.product_key) DESC) AS Top_rank,
	ROW_NUMBER() OVER(ORDER BY COUNT(p.product_key) ASC) AS Bottom_rank
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
WHERE c.country != 'n/a'
GROUP BY c.country)
SELECT 
	CASE
		WHEN Top_rank = 1 THEN 'Top Tier'
		ELSE 'Bottom Tier'
	END performance_Tier,
	country,
	Total_products
FROM Ranking_country_by_total_products
WHERE Top_rank = 1 OR Bottom_rank = 1
ORDER BY Total_products DESC;