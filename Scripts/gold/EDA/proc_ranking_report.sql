/*
===============================================================
Ranking Analysis
===============================================================

Scrip Purpose:
	This Script stores procedure that perform Ranking by total Salesthen generate the quick summary report.

Actions Performed:
	- Data Extraction & Filtering
	- Aggregation & Ranking
	- Transformation & Standardization

Usage Example:
	EXEC gold.Ranking_report;
*/
CREATE or Alter PROCEDURE gold.Ranking_report AS
BEGIN
	BEGIN TRY
	WITH Report_data AS(
		SELECT 
			c.customer_key,
			c.country,
			c.gender,
			c.marital_status,
			p.product_key,
			p.product_name,
			p.category,
			p.subcategory,
			p.product_line,
			p.product_cost,
			s.order_number,
			s.price,
			s.quantity,
			s.sales_amount
		FROM gold.fact_sales AS s
		LEFT JOIN gold.dim_customers AS c
		ON s.customer_key = c.customer_key
		LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
		WHERE gender != 'n/a' AND country != 'n/a'
	),
	Categorical_Ranking AS(
	SELECT 
		category,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_category,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_category
	FROM Report_data
	GROUP BY category
	),
	Subcategorical_Ranking AS(
	SELECT 
		subcategory,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_subcategory,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_subcategory
	FROM Report_data
	GROUP BY subcategory
	),
	Product_Ranking AS(
	SELECT 
		product_name,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_product_name,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_product_name
	FROM Report_data
	GROUP BY product_name
	),
	Product_Line_Ranking AS(
		SELECT 
		product_line,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_product_line,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_product_line
	FROM Report_data
	GROUP BY product_line
	),
	Gender_Ranking AS(
		SELECT 
		gender,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_gender,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_gender
	FROM Report_data
	GROUP BY gender
	),
	Marital_Status_Ranking AS(
		SELECT 
		marital_status,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_marital_status,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_marital_status
	FROM Report_data
	GROUP BY marital_status
	),
	Country_Ranking AS(
		SELECT 
		country,
		SUM(sales_amount) AS Total_sales_amount,
		RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS top_country,
		RANK() OVER(ORDER BY SUM(sales_amount) ASC) AS bottom_country
	FROM Report_data
	GROUP BY country
	)

	SELECT 
		CASE 
			WHEN top_category = 1 THEN 'top_category'
			Else 'bottom_category' 
		END AS performance_tier,
		CAST(category AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Categorical_Ranking
	WHERE top_category = 1 OR bottom_category = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_subcategory = 1 THEN 'top_subcategory'
			Else 'bottom_subcategory' 
		END AS performance_tier,
		CAST(subcategory AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Subcategorical_Ranking
	WHERE top_subcategory = 1 OR bottom_subcategory = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_product_name = 1 THEN 'top_product_name'
			Else 'bottom_product_name' 
		END AS performance_tier,
		CAST(product_name AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Product_Ranking
	WHERE top_product_name = 1 OR bottom_product_name = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_product_line = 1 THEN 'top_product_line'
			Else 'bottom_product_line' 
		END AS performance_tier,
		CAST(product_line AS nvarchar(255))  AS Metric_Name,
		Total_sales_amount
	FROM Product_Line_Ranking
	WHERE top_product_line = 1 OR bottom_product_line = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_gender = 1 THEN 'top_gender'
			Else 'bottom_gender' 
		END AS performance_tier,
		CAST(gender AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Gender_Ranking
	WHERE top_gender = 1 OR bottom_gender = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_marital_status = 1 THEN 'top_marital_status'
			Else 'bottom_marital_status' 
		END AS performance_tier,
		CAST(marital_status AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Marital_Status_Ranking
	WHERE top_marital_status = 1 OR bottom_marital_status = 1

	UNION ALL

	SELECT 
		CASE 
			WHEN top_country = 1 THEN 'top_country'
			Else 'bottom_country' 
		END AS performance_tier,
		CAST(country AS nvarchar(255) ) AS Metric_Name,
		Total_sales_amount
	FROM Country_Ranking
	WHERE top_country = 1 OR bottom_country = 1
	END TRY
	BEGIN CATCH
		print '============================================================';
		print 'Error while loading silver layer.';
		print 'Error Message' + error_message();
		print 'Error Number' + cast(ERROR_NUMBER() AS NVARCHAR);
		print 'Error state' + cast(ERROR_STATE() AS NVARCHAR);
		print '============================================================';

	END CATCH
END
