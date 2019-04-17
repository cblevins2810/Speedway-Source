/*
After completing this script, extract the data from the table(s) using SQL Server Management Studio
*/

SET NOCOUNT ON

------------------------------------------------------------------------------------------
-- Cleanup extract tables
------------------------------------------------------------------------------------------
IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type

-- Regardless if one or multiple tables were created for calibrations extract,
-- cleanup all tables
IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal

IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_01') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_01

IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_02') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_02

IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_03') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_03

IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_04') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_04
GO	

------------------------------------------------------------------------------------------
-- Declare Variables
------------------------------------------------------------------------------------------
-- Added for check and split up (if needed) of Calibration data in multiple tables 
-- due to size of Calibrations table/data
DECLARE	@numRecsSource		INT
DECLARE	@numRecsPerTable	INT

-- Added for support of incremental extract
DECLARE	@last_max_id		INT
-- Set this to the max Item Id from the last extract
SET		@last_max_id		= 0
-- END for additional changes

SELECT	@numRecsSource		= COUNT(*)
FROM	Fuel_Tank_Type_Calibration
-- Added for support of incremental extract
WHERE	fuel_tank_type_id > @last_max_id
-- END for additional changes

SELECT	@numRecsPerTable	= (@numRecsSource / 4) + 1

------------------------------------------------------------------------------------------
-- Create and get data for Fuel Tank Type Extract Table
------------------------------------------------------------------------------------------
SELECT	*
INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type
FROM	Fuel_Tank_Type
-- Added for support of incremental extract
WHERE fuel_tank_type_id > @last_max_id
-- END for additional changes

------------------------------------------------------------------------------------------
-- Create and get data for Fuel Tank Type Calibration Extract Table
------------------------------------------------------------------------------------------
-- Check for amount of data
IF (@numRecsSource) < 100001
	BEGIN
		-- Just create one table
		SELECT	*
		INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal
		FROM
		(
			SELECT	ROW_NUMBER() OVER (ORDER BY fuel_tank_type_id ASC) AS row_id, *
			FROM	Fuel_Tank_Type_Calibration
			-- Added for support of incremental extract
			WHERE	fuel_tank_type_id > @last_max_id
			-- END for additional changes
		) fttc
		WHERE	fttc.row_id > 0
	END
ELSE
	BEGIN
		-- Evenly distribute data into 4 tables
		-- Table 1
		SELECT	TOP (@numRecsPerTable) *
		INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_01
		FROM
		(
			SELECT	ROW_NUMBER() OVER (ORDER BY fuel_tank_type_id ASC) AS row_id, *
			FROM	Fuel_Tank_Type_Calibration
			-- Added for support of incremental extract
			WHERE	fuel_tank_type_id > @last_max_id
			-- END for additional changes
		) fttc
		WHERE	fttc.row_id > 0
		-- Table 2
		SELECT	TOP (@numRecsPerTable) *
		INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_02
		FROM
		(
			SELECT	ROW_NUMBER() OVER (ORDER BY fuel_tank_type_id ASC) AS row_id, *
			FROM	Fuel_Tank_Type_Calibration
			-- Added for support of incremental extract
			WHERE	fuel_tank_type_id > @last_max_id
			-- END for additional changes
		) fttc
		WHERE	fttc.row_id > (@numRecsPerTable * 1)
		-- Table 3
		SELECT	TOP (@numRecsPerTable) *
		INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_03
		FROM
		(
			SELECT	ROW_NUMBER() OVER (ORDER BY fuel_tank_type_id ASC) AS row_id, *
			FROM	Fuel_Tank_Type_Calibration
			-- Added for support of incremental extract
			WHERE	fuel_tank_type_id > @last_max_id
			-- END for additional changes
		) fttc
		WHERE	fttc.row_id > (@numRecsPerTable * 2)
		-- Table 4
		SELECT	TOP (@numRecsPerTable) *
		INTO	bcssa_custom_integration.dbo.bc_extract_fuel_tank_type_cal_04
		FROM
		(
			SELECT	ROW_NUMBER() OVER (ORDER BY fuel_tank_type_id ASC) AS row_id, *
			FROM	Fuel_Tank_Type_Calibration
			-- Added for support of incremental extract
			WHERE	fuel_tank_type_id > @last_max_id
			-- END for additional changes
		) fttc
		WHERE	fttc.row_id > (@numRecsPerTable * 3)
	END
