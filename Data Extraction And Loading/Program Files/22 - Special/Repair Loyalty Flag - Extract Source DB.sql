-- This is a one time only script to repair an error where the loyalty flag where the requires loyalty flag was incorrectly set to false

IF OBJECT_ID('bcssa_custom_integration..bc_extract_special_loyalty_flag') IS NOT NULL
   DROP TABLE bcssa_custom_integration..bc_extract_special_loyalty_flag
GO   
   
SELECT COALESCE(CONVERT(NVARCHAR(15), rac.retail_auto_combo_id) + '-' + rac.xref_code, CONVERT(NVARCHAR(15), rac.retail_auto_combo_id)) AS specialXRefID,
rac.loyalty_flag AS requiresLoyalty
INTO bcssa_custom_integration..bc_extract_special_loyalty_flag
FROM retail_auto_combo AS rac
WHERE loyalty_flag = 'y'

