/*  
	Create Fuel Tank Type and Fuel Tank Type Calibrations
	April 2019
	
	This script will create Fuel Tank Types and Calibrations using a de-normalized import table.
	
*/

-----------------------------------------------
-- Create Table for Fuel Tank Type
-----------------------------------------------
IF OBJECT_ID('tempdb..#fuel_tank_type') IS NOT NULL
	DROP TABLE #fuel_tank_type

CREATE TABLE #fuel_tank_type (
	log_seq						INT IDENTITY(1,1) NOT NULL,
	fuel_tank_type_id			INT NOT NULL,
	manufacturer				NVARCHAR(30) NOT NULL,
	maximum_volume				INT NOT NULL,
	name						NVARCHAR(30) NOT NULL,
	fill_volume					INT NOT NULL,
	fuel_tank_type_id_assigned	INT NOT NULL
)  ON [PRIMARY]
GO

-----------------------------------------------
-- Create Table for Fuel Tank Type Calibration
-----------------------------------------------
IF OBJECT_ID('tempdb..#fuel_tank_type_cal') IS NOT NULL
	DROP TABLE #fuel_tank_type_cal

CREATE TABLE #fuel_tank_type_cal (
	log_seq						INT IDENTITY(1,1) NOT NULL,
	row_id						BIGINT NOT NULL,
	fuel_tank_type_id			INT NOT NULL,
	measure						NUMERIC(12, 4) NOT NULL,
	volume						INT NOT NULL,
	fuel_tank_type_id_assigned	INT NOT NULL
)  ON [PRIMARY]
GO

-- Declare variables
DECLARE	@ClientId		INT
DECLARE	@TicketCount	BIGINT
DECLARE	@NextId			INT

SELECT	@ClientId = MAX(client_id) FROM Rad_Sys_Client


-----------------------------------------------
-- Insert data for Fuel Tank Type
-----------------------------------------------
INSERT	#fuel_tank_type (fuel_tank_type_id, manufacturer, maximum_volume, name, fill_volume, fuel_tank_type_id_assigned) 
SELECT	fuel_tank_type_id, manufacturer, maximum_volume, name, fill_volume, 0
FROM	bc_extract_fuel_tank_type
WHERE	client_id > 0

SET		@TicketCount = @@RowCount


-- Return the starting value of the next ticket and allocate an additional amount based upon the number of fuel tank types
EXEC plt_get_next_named_ticket 'Fuel_Tank_Type','n', @TicketCount, @NextId OUTPUT


-- Add assigned Fuel Tank Type ID (new) to records
UPDATE	#fuel_tank_type
SET		fuel_tank_type_id_assigned = @NextId - @TicketCount + log_seq

-- Add records to table
INSERT	Fuel_Tank_Type
(
		fuel_tank_type_id,
		manufacturer,
		maximum_volume,
		name,
		fill_volume,
		last_modified_user_id,
		last_modified_timestamp,
		data_guid,
		client_id
)
SELECT
		fuel_tank_type_id_assigned,
		manufacturer,
		maximum_volume,
		name,
		fill_volume,
		42,
		GETDATE(),
		NULL,
		@ClientId
FROM	#fuel_tank_type



-----------------------------------------------
-- Insert data for Fuel Tank Type Calibration
-----------------------------------------------
INSERT	#fuel_tank_type_cal (row_id, fuel_tank_type_id, measure, volume, fuel_tank_type_id_assigned) 
SELECT	bcfttc.row_id, bcfttc.fuel_tank_type_id, bcfttc.measure, bcfttc.volume, tftt.fuel_tank_type_id_assigned
FROM	bc_extract_fuel_tank_type_cal AS bcfttc
JOIN	#fuel_tank_type AS tftt
ON		bcfttc.fuel_tank_type_id = tftt.fuel_tank_type_id
WHERE	bcfttc.client_id > 0


-- Add records to table
INSERT	Fuel_Tank_Type_Calibration
(
	fuel_tank_type_id,
	measure,
	volume,
	last_modified_user_id,
	client_id,
	last_modified_timestamp,
	data_guid
)
SELECT
		fuel_tank_type_id_assigned,
		measure,
		volume,
		42,
		@ClientId,
		GETDATE(),
		NULL
FROM	#fuel_tank_type_cal


-----------------------------------------------
-- Cleanup temp tables
-----------------------------------------------
IF OBJECT_ID('tempdb..#fuel_tank_type') IS NOT NULL
	DROP TABLE #fuel_tank_type
	
IF OBJECT_ID('tempdb..#fuel_tank_type_cal') IS NOT NULL
	DROP TABLE #fuel_tank_type_cal

