/* After completing this script, extract the data from the table using SQL Server Management Studio */

IF OBJECT_ID('bc_extract_Manufacturer') IS NOT NULL
	DROP TABLE bc_extract_Manufacturer
GO	

SELECT * INTO bc_extract_Manufacturer FROM Manufacturer
GO
