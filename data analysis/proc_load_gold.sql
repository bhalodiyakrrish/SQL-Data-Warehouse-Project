CREATE DATABASE DataWarehouseAnalytics;

USE DataWarehouseAnalytics;
GO

CREATE SCHEMA gold;
GO

CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Gold Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Dimension Tables';
		PRINT '------------------------------------------------';

		-- Loading gold.dim_customers
		SET @start_time = GETDATE();
		PRINT 'DROP Table: gold.dim_customers';
		DROP TABLE gold.dim_customers;
		PRINT '>> Inserting Data Into: gold.dim_customers'
		SELECT
			*
		INTO DataWarehouseAnalytics.gold.dim_customers
		FROM DataWarehouse.gold.dim_customers;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		-- Loading gold.dim_products
		SET @start_time = GETDATE();
		PRINT 'DROP Table: gold.dim_products';
		DROP TABLE gold.dim_products;
		PRINT '>> Inserting Data Into: gold.dim_products'
		SELECT
			*
		INTO DataWarehouseAnalytics.gold.dim_products
		FROM DataWarehouse.gold.dim_products;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading Fact Table';
		PRINT '------------------------------------------------';

		-- Loading gold.fact_sales
		SET @start_time = GETDATE();
		PRINT 'DROP Table: gold.fact_sales';
		DROP TABLE gold.fact_sales;
		PRINT '>> Inserting Data Into: gold.fact_sales'
		SELECT
			*
		INTO DataWarehouseAnalytics.gold.fact_sales
		FROM DataWarehouse.gold.fact_sales;
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Gold Layer is Completed';
        PRINT '- Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING GOLD LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END;

EXEC gold.load_gold;