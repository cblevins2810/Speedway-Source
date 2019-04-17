/*  
	Create Fuel Tank and Fuel Physical Tank
	Nov 2018
	
	This script will import Fuel Tank and Fuel Physical Tank data using a de-normalized import table.
	
*/

/* Drop temporary tables if they already exist */
IF OBJECT_ID('tempdb..#fuel_tank_ini') IS NOT NULL
  DROP TABLE #fuel_tank_ini
GO

IF OBJECT_ID('tempdb..#fuel_tank') IS NOT NULL
  DROP TABLE #fuel_tank
GO

/* Create temporary tables needed for import */
CREATE TABLE #fuel_tank_ini (
	[fuel_tank_ini_id] int IDENTITY(1,1) NOT NULL,
	[business_unit_code] [nvarchar](50) NOT NULL,
	[fuel_item_name] [nvarchar](50) NOT NULL,
	[xref_code] [nvarchar](255) NULL,
	[active_flag_ft] [nchar](1) NOT NULL,
	[bu_id_ft] [int] NOT NULL,
	[fuel_tank_id_ft] [int] NOT NULL,
	[fuel_tank_id_fpt] [int] NULL,
	[bu_id_fpt] [int] NULL,
	[fuel_tank_type_name_fpt] [nvarchar](30) NULL,
	[tank_number_fpt] [smallint] NULL,
	[maximum_water_volume_fpt] [int] NULL,
	[low_tank_threshold_fpt] [numeric](28, 10) NULL,
	[low_tank_status_fpt] [nchar](1) NULL,
	[daily_variance_sales_percent_threshold_fpt] [numeric](28, 10) NULL,
	[daily_variance_volume_threshold_fpt] [numeric](28, 10) NULL,
	[active_flag_fpt] [nchar](1) NULL
) ON [PRIMARY]
GO

CREATE TABLE #fuel_tank (
	[fuel_tank_id] int IDENTITY(1,1) NOT NULL,
	[fuel_tank_id_assigned] [bigint] NOT NULL,
	[business_unit_code] [nvarchar](50) NOT NULL,
	[fuel_item_name] [nvarchar](50) NOT NULL,
	[xref_code] [nvarchar](255) NULL,
	[active_flag_ft] [nchar](1) NOT NULL,
	[bu_id_ft] [int] NOT NULL,
	[fuel_tank_id_ft] [int] NOT NULL,
	[fuel_tank_id_fpt] [int] NULL,
	[bu_id_fpt] [int] NULL,
	[fuel_tank_type_name_fpt] [nvarchar](30) NULL,
	[tank_number_fpt] [smallint] NULL,
	[maximum_water_volume_fpt] [int] NULL,
	[low_tank_threshold_fpt] [numeric](28, 10) NULL,
	[low_tank_status_fpt] [nchar](1) NULL,
	[daily_variance_sales_percent_threshold_fpt] [numeric](28, 10) NULL,
	[daily_variance_volume_threshold_fpt] [numeric](28, 10) NULL,
	[active_flag_fpt] [nchar](1) NULL
) ON [PRIMARY]
GO

/* Declare needed variables */
DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @NextId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

/* Populate the temporary fuel_tank_ini table with data from extract table for row count */
INSERT #fuel_tank_ini (
	business_unit_code,
	fuel_item_name,
	xref_code,
	active_flag_ft,
	bu_id_ft,
	fuel_tank_id_ft,
	fuel_tank_id_fpt,
	bu_id_fpt,
	fuel_tank_type_name_fpt,
	tank_number_fpt,
	maximum_water_volume_fpt,
	low_tank_threshold_fpt,
	low_tank_status_fpt,
	daily_variance_sales_percent_threshold_fpt,
	daily_variance_volume_threshold_fpt,
	active_flag_fpt
)
SELECT
	business_unit_code,
	fuel_item_name,
	xref_code,
	active_flag_ft,
	bu_id_ft,
	fuel_tank_id_ft,
	fuel_tank_id_fpt,
	bu_id_fpt,
	fuel_tank_type_name_fpt,
	tank_number_fpt,
	maximum_water_volume_fpt,
	low_tank_threshold_fpt,
	low_tank_status_fpt,
	daily_variance_sales_percent_threshold_fpt,
	daily_variance_volume_threshold_fpt,
	active_flag_fpt
FROM bc_extract_fuel_tanks

SET @TicketCount = @@RowCount


-- Return the starting value of the next ticket and allocate an additional amount based upon the number of fuel tanks
EXEC plt_get_next_named_ticket 'Fuel_Tank','n', @TicketCount, @NextId OUTPUT


/* Populate the temporary fuel_tank table with data from initial temporary fuel_tank_ini table and provide fuel_tank_id_assigned
used for the insert of data into fuel_tank and fuel_physical_tank tables */
INSERT #fuel_tank (
	fuel_tank_id_assigned,
	business_unit_code,
	fuel_item_name,
	xref_code,
	active_flag_ft,
	bu_id_ft,
	fuel_tank_id_ft,
	fuel_tank_id_fpt,
	bu_id_fpt,
	fuel_tank_type_name_fpt,
	tank_number_fpt,
	maximum_water_volume_fpt,
	low_tank_threshold_fpt,
	low_tank_status_fpt,
	daily_variance_sales_percent_threshold_fpt,
	daily_variance_volume_threshold_fpt,
	active_flag_fpt
)
SELECT
	@NextId - @TicketCount + fuel_tank_ini_id,
	business_unit_code,
	fuel_item_name,
	xref_code,
	active_flag_ft,
	bu_id_ft,
	fuel_tank_id_ft,
	fuel_tank_id_fpt,
	bu_id_fpt,
	fuel_tank_type_name_fpt,
	tank_number_fpt,
	maximum_water_volume_fpt,
	low_tank_threshold_fpt,
	low_tank_status_fpt,
	daily_variance_sales_percent_threshold_fpt,
	daily_variance_volume_threshold_fpt,
	active_flag_fpt
FROM #fuel_tank_ini


/* Populate the Fuel_Tank table */
INSERT Fuel_Tank (
business_unit_id,
fuel_tank_id,
fuel_inventory_item_id,
last_modified_user_id,
last_modified_timestamp,
client_id,
active_flag
)
SELECT 
rsda.data_accessor_id,
ft.fuel_tank_id_assigned,
i.item_id,
42,
GETDATE(),
@ClientId,
ft.active_flag_ft
FROM #fuel_tank AS ft
JOIN Rad_Sys_Data_Accessor AS rsda
ON   ft.business_unit_code = rsda.name
JOIN item AS i
ON   ft.xref_code = i.xref_code


/* Populate the Fuel_Physical_Tank table */
INSERT Fuel_Physical_Tank (
business_unit_id,
physical_fuel_tank_id,
fuel_tank_type_id,
last_modified_timestamp,
last_modified_user_id,
client_id,
tank_number,
maximum_water_volume,
low_tank_threshold,
low_tank_status,
daily_variance_sales_percent_threshold,
daily_variance_volume_threshold,
active_flag,
atg_flag
)
SELECT 
rsda.data_accessor_id,
fpt.fuel_tank_id_assigned,
ftt.fuel_tank_type_id,
GETDATE(),
42,
@ClientId,
fpt.tank_number_fpt,
fpt.maximum_water_volume_fpt,
fpt.low_tank_threshold_fpt,
fpt.low_tank_status_fpt,
fpt.daily_variance_sales_percent_threshold_fpt,
fpt.daily_variance_volume_threshold_fpt,
fpt.active_flag_fpt,
'n'
FROM #fuel_tank AS fpt
JOIN Rad_Sys_Data_Accessor AS rsda
ON   fpt.business_unit_code = rsda.name
JOIN Fuel_Tank_Type AS ftt
ON   fpt.fuel_tank_type_name_fpt = ftt.name
JOIN item AS i
ON   fpt.xref_code = i.xref_code

/* Cleanup of temporary tables */
IF OBJECT_ID('tempdb..#fuel_tank') IS NOT NULL
  DROP TABLE #fuel_tank
  
IF OBJECT_ID('tempdb..#fuel_tank_ini') IS NOT NULL
  DROP TABLE #fuel_tank_ini

