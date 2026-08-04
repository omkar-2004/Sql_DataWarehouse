/*
===============================================================
DQL Script: EDA Report
===============================================================

Scrip Purpose:
	This Script stores procedure that perform EDA on dimensions and
	Measures then generate the quick summary report.

Actions Performed:
	- CTEs
	- Merges Data
	- Calculates Descriptive Statistics (Aggregations)

Usage Example:
	EXEC gold.EDA_Report;
*/

CREATE or Alter PROCEDURE gold.EDA_Report AS
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
		)
		SELECT	'Total Customers' AS 'Matrix Name', COUNT(Distinct customer_key)  AS 'Matrix Value' FROM Report_data
		Union ALL
		SELECT 'Total Countries', COUNT(DISTINCT country) FROM Report_data
		UNION ALL
		SELECT 'Registered Products', COUNT(DISTINCT product_key) FROM gold.dim_products
		UNION ALL
		SELECT 'Total Products Sold atleast once', COUNT(DISTINCT product_key) FROM Report_data
		UNION ALL
		SELECT 'Total Products Never Sold', (SELECT COUNT(DISTINCT product_key) FROM gold.dim_products) - COUNT(DISTINCT product_key) FROM Report_data
		UNION ALL
		SELECT 'Registered Categories', COUNT(DISTINCT category) FROM gold.dim_products
		UNION ALL
		SELECT 'Total Categories Sold atleast once', COUNT(DISTINCT category) FROM Report_data
		UNION ALL
		SELECT 'Total Categories never sold' ,(SELECT count(DISTINCT category) FROM gold.dim_products) - COUNT(DISTINCT category)  FROM Report_data
		UNION ALL
		SELECT 'Registered Subcategories', COUNT(DISTINCT subcategory) FROM gold.dim_products
		UNION ALL
		SELECT 'Total Subcategories Sold atleast once', COUNT(DISTINCT subcategory) FROM Report_data
		UNION ALL
		SELECT 'Total subategories never sold' ,(SELECT count(DISTINCT subcategory) FROM gold.dim_products) - COUNT(DISTINCT subcategory)  FROM Report_data
		UNION ALL
		SELECT 'Registered Prpduct Line', COUNT(DISTINCT product_line) FROM gold.dim_products
		UNION ALL
		SELECT 'Total Product Line Sold atleast once', COUNT(DISTINCT product_line) FROM Report_data
		UNION ALL
		SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM Report_data
		UNION ALL
		SELECT 'Total Product Cost', SUM(product_cost) FROM Report_data
		UNION ALL
		SELECT 'Minimum Product Cost', MIN(product_cost) FROM Report_data
		UNION ALL
		SELECT 'Maximum Product Cost', MAX(product_cost) FROM Report_data
		UNION ALL
		SELECT 'Avg Product Cost', AVG(product_cost) FROM Report_data
		UNION ALL
		SELECT 'Total Price', SUM(price) FROM Report_data
		UNION ALL
		SELECT 'Minimum Price', MIN(price) FROM Report_data
		UNION ALL
		SELECT 'Maximum Price', MAX(price) FROM Report_data
		UNION ALL
		SELECT 'Avg Price', AVG(price) FROM Report_data
		UNION ALL
		SELECT 'Total Quantity', SUM(quantity) FROM Report_data
		UNION ALL
		SELECT 'Minimum Quantity', MIN(quantity) FROM Report_data
		UNION ALL
		SELECT 'Maximum Quantity', MAX(quantity) FROM Report_data
		UNION ALL
		SELECT 'Avg Quantity', AVG(quantity) FROM Report_data
		UNION ALL
		SELECT 'Total Sales', SUM(sales_amount) FROM Report_data
		UNION ALL
		SELECT 'Minimum Sales', MIN(sales_amount) FROM Report_data
		UNION ALL
		SELECT 'Maximum Sales', MAX(sales_amount) FROM Report_data
		UNION ALL
		SELECT 'Avg Sales', AVG(sales_amount) FROM Report_data
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
