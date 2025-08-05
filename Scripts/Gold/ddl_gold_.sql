
/*
====================================================================================================
DDL Scripts: Create Gold Views
====================================================================================================
Script Purpose:
	This script creates views for the Gold layer in the data warehouse.
	The gold layer represents the final dimention and fact tables (Star Schema)

	Each view performs transformations and combines data from the silver layer to produce a clean, 
	enriched and business-ready dataset.

Usage:
	- Thsee views can be queried directly for analytics and reporting.
=======================================================================================================
*/


-- ====================================================================================================
-- CREATE Dimension: gold.dim_customers
-- ====================================================================================================
IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
DROP VIEW gold.dim_customers;

GO

CREATE VIEW gold.dim_customers AS 

SELECT
	ROW_NUMBER() OVER(ORDER BY cus.cst_id) AS customer_number,
	cus.cst_id AS customer_id,
	cus.cst_key AS customer_key,
	cus.cst_firstname AS first_name,
	cus.cst_last AS last_name,
	lo.CNTRY AS country,
	cus.cst_marital_status AS marital_status,
	CASE WHEN cus.cst_gndr IS NOT NULL THEN cus.cst_gndr
		 ELSE COALESCE(cat.GEN, 'n/a')
	END AS gender,
	cat.BDATE AS birthdate,
	cus.cst_create_date AS create_date
FROM silver.crm_cus_info AS cus
LEFT JOIN silver.erp_CUST_AZ12 AS cat
ON cus.cst_key = cat.CID
LEFT JOIN silver.erp_LOC_A101 AS lo
ON cus.cst_key = lo.CID
;

-- ====================================================================================================
-- CREATE Dimension: gold.dim_products
-- ====================================================================================================

IF OBJECT_ID ('gold.dim_products', 'V') IS NOT NULL
DROP VIEW gold.dim_products;

GO

CREATE VIEW gold.dim_products AS 
SELECT 
	ROW_NUMBER() OVER(ORDER BY prd_start_date, prd_key_new) AS product_key,
	pd.prd_id AS product_id,
	pd.prd_key_new AS product_number,
	pd.prd_nm AS product_name,
	cat.ID AS category_id,
	cat.CAT AS category,
	cat.MAINTENACE AS maintenance,
	cat.SUBCAT AS subcategory,
	REPLACE(pd.prd_cost, 0, 500) AS cost,
	pd.prd_line AS product_line,
	pd.prd_start_date AS start_date
	
FROM silver.crm_prd_info AS pd
LEFT JOIN silver.erp_PX_CAT_G1V2 AS cat
ON pd.cat_key = cat.ID
WHERE prd_end_dt IS NULL;


-- ====================================================================================================
-- CREATE Dimension: gold.fact_sale
-- ====================================================================================================

IF OBJECT_ID ('gold.fact_sale', 'V') IS NOT NULL
DROP VIEW gold.fact_sale;

GO

CREATE VIEW gold.fact_sale AS
SELECT 
	sal.sls_ord_num AS order_number,
	pd.product_key,
	cus.customer_number AS customer_key,
	sal.sls_order_dt AS order_date,
	sal.sls_ship_dt AS shipping_date,
	sal.sls_due_dt AS due_date,
	sal.sls_quantity AS quantity,
	sal.sls_price AS price,
	sal.sls_sales AS sales_amount
FROM silver.crm_sales_details AS sal
LEFT JOIN gold.dim_products AS pd
ON sal.sls_prd_key = pd.product_number
LEFT JOIN gold.dim_customers AS cus
ON sal.sls_cus_id = cus.customer_id;





