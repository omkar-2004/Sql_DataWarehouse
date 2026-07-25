/*
=============================================================
Stored Procedure: Load Bronze Layer(Source -> Bronze)
=============================================================
Script Purpose:
	This script load the data into the 'bronze' schema from external CSV files.
	It performs the following actions:
	- Truncates the bronze tables before loading data.
	- Uses the 'BULK INSERT' command to load data from csv to bronze tables.
	- Calculates to total and individual duration to load data.
	
Usage example:
	EXEC bronze.load_bronze

Note:
	Change the file locations to csv locations.
*/
CREATE or Alter PROCEDURE bronze.load_bronze AS
BEGIN
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
	BEGIN TRY
		set @Batch_Start_Time = GETDATE();
		print '=======================================================================';
		print 'Loading Bronze Layer';
		print '=======================================================================';
	
		print '-----------------------------------------------------------------------';
		print 'Loading CRM tables';
		print '-----------------------------------------------------------------------';
	
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info
	
		print '>>>Inserting data into Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_crm\cust_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
	
		print '>>>Inserting data into Table: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_crm\prd_info.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details
		print '>>>Inserting data into Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_crm\sales_details.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '-----------------------------------------------------------------------';
		print 'Loading ERP Table';
		print '-----------------------------------------------------------------------';
		
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12
		print '>>>Inserting data into Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_erp\CUST_AZ12.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
		print '>>>Inserting data into Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_erp\LOC_A101.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';


		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		print '>>>Inserting data into Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Omkar\source\repos\NewRepo\Datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		SET @Batch_End_Time = GETDATE();
		print '============================================================';
		print 'Loading Bronze layer is completed.';
		print '>>>Total Load Duration: ' + cast(DATEDIFF(second,@Batch_Start_Time,@Batch_End_Time) as NVARCHAR) + ' Seconds';
		print '============================================================';

	END TRY
	BEGIN CATCH
		print '============================================================';
		print 'Error while loading bronze layer.';
		print 'Error Message' + error_message();
		print 'Error Number' + cast(ERROR_NUMBER() AS NVARCHAR);
		print 'Error state' + cast(ERROR_STATE() AS NVARCHAR);
		print '============================================================';

	END CATCH
END
