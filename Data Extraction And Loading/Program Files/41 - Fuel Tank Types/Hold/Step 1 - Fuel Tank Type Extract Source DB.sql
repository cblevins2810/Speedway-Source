/* After completing this script, extract the data from the table using SQL Server Management Studio */

IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type
GO	

SELECT	*
INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type
FROM	Fuel_Tank_Type

GO
