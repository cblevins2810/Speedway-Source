/* After completing this script, extract the data from the table using SQL Server Management Studio */

IF OBJECT_ID('bcssa_custom_integration database..bcssa_custom_integration..bc_extract_Manufacturer') IS NOT NULL
	DROP TABLE bcssa_custom_integration..bcssa_custom_integration..bc_extract_Manufacturer
GO	

SELECT * INTO bcssa_custom_integration..bcssa_custom_integration..bc_extract_Manufacturer FROM Manufacturer
GO
