/*
=============================================================
Stored Procedure: Load Silver Layer(Bronze -> Silver)
=============================================================

Script Purpose:
	This stores procedure performs the ETL(Extract, Transform, Load)
	process to populated the 'silver' schema tables from the 'bronze'
	schema.

Actions Performed:
	- Truncate the silver tables.
	- Insert transformed and cleaned data from Bronze to silver tables

Usage Example:
	EXEC silver.load_silver;
*/

CREATE or Alter PROCEDURE silver.load_silver AS
BEGIN
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
	BEGIN TRY
		set @Batch_Start_Time = GETDATE();
		print '=======================================================================';
		print 'Loading Silver Layer';
		print '=======================================================================';

		print '***********************************************************************';
		print 'CRM Tables';
		print '***********************************************************************';

		print '-----------------------------------------------------------------------';
		print 'Loading Customer information table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info

		print '>>>Inserting data into Table: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname, -- Triming the first name column.
			TRIM(cst_lastname) AS cst_last_lastname,-- Triming the last name column.
				CASE 
					WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
					WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
					ELSE 'n/a'
				END AS cst_marital_status, -- mapping (S,M) to (Single, Married) and null to n/a in marital status.
 				CASE 
					WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
					WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
					ELSE 'n/a'
				END AS cst_gndr, -- mapping (F,M) to (Female,Male) and null to n/a in gender.
			cst_create_date
		FROM (
			SELECT 
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date desc) as flag_last
			FROM bronze.crm_cust_info
			where cst_id is not null)t
		WHERE flag_last = 1; -- Retriving leatest customer information.
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		print '-----------------------------------------------------------------------';
		print 'Loading Product information table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info

		print '>>>Inserting data into Table: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- Extracting Category Id from product key
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, -- Extracting only product key
			TRIM(prd_nm) AS prd_nm,
			ISNULL(prd_cost,0) AS prd_cost,
			CASE
				WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
				WHEN UPPER(prd_line) = 'R' THEN 'Road'
				WHEN UPPER(prd_line) = 'S' THEN 'Standard'
				WHEN UPPER(prd_line) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line, -- Mapping product line codes to descriptive values.
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) 
				OVER(
					PARTITION BY prd_key 
					ORDER BY prd_start_dt
					) - 1 AS DATE) as prd_end_dt -- Calculating end date as one day before the next date
		FROM bronze.crm_prd_info
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		print '-----------------------------------------------------------------------';
		print 'Loading Sales Details table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details

		print '>>>Inserting data into Table: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price

		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL
				ELSE cast(cast(sls_order_dt AS VARCHAR) AS DATE)
			END sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
				ELSE cast(cast(sls_ship_dt AS VARCHAR) AS DATE)
			END sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL
				ELSE cast(cast(sls_due_dt AS VARCHAR) AS DATE)
			END sls_due_dt,
			CASE
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
				ELSE sls_price
			END as sls_price

		FROM bronze.crm_sales_details;
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '***********************************************************************';
		print 'ERP Tables';
		print '***********************************************************************';
		print '-----------------------------------------------------------------------';
		print 'Loading Customer Birthdate Information Table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12

		print '>>>Inserting data into Table: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)
		SELECT 
			CASE
				WHEN cid like 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
				ELSE cid
			END cid,
			CASE 
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate,
			CASE 
				WHEN UPPER(gen) = 'F' OR UPPER(gen) = 'FEMALE' THEN 'Female'
				When UPPER(gen) = 'M' OR UPPER(gen) = 'MALE' THEN 'Male'
				ELSE 'n/a'
			END AS gen
		FROM bronze.erp_cust_az12
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		print '-----------------------------------------------------------------------';
		print 'Loading Customer Location/Country Information Table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101

		print '>>>Inserting data into Table: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101(
			cid,
			cntry
			)
		SELECT
			REPLACE(cid,'-','') AS cid,
			CASE 
				WHEN UPPER(TRIM(cntry)) in ('DE','GERMANY') THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) in ('USA','UNITED STATES','US') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) = ' ' OR cntry is null THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry
		FROM bronze.erp_loc_a101;
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		print '-----------------------------------------------------------------------';
		print 'Loading Product Category Information Table';
		print '-----------------------------------------------------------------------';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2

		print '>>>Inserting data into Table: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
			)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		SET @Batch_End_Time = GETDATE();
		print '============================================================';
		print 'Loading Silver layer is completed.';
		print '>>>Total Load Duration: ' + cast(DATEDIFF(second,@Batch_Start_Time,@Batch_End_Time) as NVARCHAR) + ' Seconds';
		print '============================================================';


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