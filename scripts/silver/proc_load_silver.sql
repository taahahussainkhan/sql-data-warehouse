
-- Data Tranformation

-- Removing duplicate Primary Keys(cst_id)
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gender,
	cst_create_date)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
	 WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
	 ELSE 'N/A'
END cst_gender,
CASE WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
	 WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
	 ELSE 'N/A'
END cst_gender,
cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) t
WHERE flag_last =1;


--- crm_prd_info


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
	REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,		-- Extracting categoryID
	SUBSTRING(prd_key, 7 , LEN(prd_key)) AS prd_key,		--Extracting product key
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'T' THEN 'Touring'
		 ELSE 'N/A'
	END AS prd_line,										-- Map product line codes to descriptive values.
	CAST (prd_start_dt AS DATE) AS prd_start_dt,
	CAST(
		LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
		AS DATE)
	AS prd_end_dt											-- Calculate end date as one day before the next start date.
FROM bronze.crm_prd_info;