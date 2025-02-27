
-- Check for Nulls or Duplicates in Primary Key.
-- Expected Result: No Result
SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT
	prd_id,
	COUNT(*)
	FROM bronze.crm_prd_info
	GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in string values

SELECT 
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);
 	
SELECT 
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);	

-- Distinct Standardization & Consistency
SELECT 
DISTINCT cst_gender
FROM bronze.crm_cust_info;

SELECT
	DISTINCT prd_line
FROM bronze.crm_prd_info


-- Checking for Nulls or Negative numbers
SELECT 
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Checking for Invalid Dates

SELECT
	*
	FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt ; 
 -- End date must not be earlier than the start date.


