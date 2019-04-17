/*  
	Create Fuel Tank Type
	Nov 2018
	
	This script will create Fuel Tank Types using a de-normalized import table.
	
*/

IF OBJECT_ID('tempdb..#fuel_tank_type') IS NOT NULL
	DROP TABLE #fuel_tank_type

CREATE TABLE #fuel_tank_type (
	fuel_tank_type_id	int IDENTITY(1,1) NOT NULL,
	manufacturer		nvarchar(30) NOT NULL,
	maximum_volume		int NOT NULL,
	name				nvarchar(30) NOT NULL,
	fill_volume			int NOT NULL,
)  ON [PRIMARY]
GO

DECLARE	@ClientId INT
DECLARE	@TicketCount BIGINT
DECLARE	@TableId INT 
DECLARE	@NextId INT

SELECT	@ClientId = MAX(client_id) FROM Rad_Sys_Client

INSERT	#fuel_tank_type (manufacturer,maximum_volume,name,fill_volume) 
SELECT	manufacturer, maximum_volume, name, fill_volume
FROM	bc_extract_fuel_tank_type
WHERE	client_id > 0

SET		@TicketCount = @@RowCount

/* Table ID should be returned 366 */
SELECT	@TableId = table_id
FROM	Rad_Sys_Table
WHERE	name = 'Fuel_Tank_Type'
AND		db_id = 1

-- Return the starting value of the next ticket and allocated an addition amount based upon the number of fuel tank types
EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

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
		@NextId - fuel_tank_type_id + 1,
		manufacturer,
		maximum_volume,
		name,
		fill_volume,
		42,
		GETDATE(),
		NULL,
		@ClientId
FROM	#fuel_tank_type


IF OBJECT_ID('tempdb..#fuel_tank_type') IS NOT NULL
	DROP TABLE #fuel_tank_type

