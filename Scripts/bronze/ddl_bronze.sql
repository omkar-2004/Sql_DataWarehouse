/*
=============================================================
DDL Script: Create Bronze Table Structure
=============================================================
Script Purpose:
	This script creates tables in the 'bronze' schema.
	Dropping existing tables if they already exists.
	Run this script to redefine the DDL structure of the 'bronze' tables.
	
WARNING:
    Running this script will drop the entire table if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/


use DataWarehouse;
GO


-- Creating Customer information table in bronze schema as bronze.crm_cust_info from crm datasource.
-- if table exists it drop the table and recreate the table
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
	);
GO

-- Creating product information table in bronze schema as bronze.crm_prd_info from crm datasource
-- if table exists it drop the table and recreate the table

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt datetime,
	prd_end_dt datetime
	);
GO

-- Creating sales details table in bronze schema as bronze.crm_sls_details from crm datasource
-- if table exists it drop the table and recreate the table

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);
GO

-- Creating customer birthdate table in bronze schema as bronze.erp_CUST_AZ12 from erp datasource
-- if table exists it drop the table and recreate the table

IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATETIME,
	gen NVARCHAR(50)
);
GO

-- Creating customer country location table in bronze schema as bronze.erp_LOC_A101 from erp datasource
-- if table exists it drop the table and recreate the table

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);
GO

-- Creating product Category table in bronze schema as bronze.erp_PX_CAT_G1V2 from erp datasource
-- if table exists it drop the table and recreate the table

IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);
GO









