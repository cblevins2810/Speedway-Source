/* After completing this script, extract the data from the table using SQL Server Management Studio */

IF OBJECT_ID('bcssa_custom_integration..bc_extract_fuel_tanks') IS NOT NULL
	DROP TABLE bcssa_custom_integration..bc_extract_fuel_tanks
GO	

-- Added for support of incremental extract
DECLARE	@last_max_id		INT
-- Set this to the max Item Id from the last extract
SET		@last_max_id		= 0
-- END for additional changes

SELECT		rsda.name									AS business_unit_code,
			i.name										AS fuel_item_name,
			i.xref_code									AS xref_code,
			ft.active_flag								AS active_flag_ft,
			ft.business_unit_id							AS bu_id_ft,
			ft.fuel_tank_id								AS fuel_tank_id_ft,
			fpt.physical_fuel_tank_id					AS fuel_tank_id_fpt,
			fpt.business_unit_id						AS bu_id_fpt,
			ftt.name									AS fuel_tank_type_name_fpt,
			fpt.tank_number								AS tank_number_fpt,
			fpt.maximum_water_volume					AS maximum_water_volume_fpt,
			fpt.low_tank_threshold						AS low_tank_threshold_fpt,
			fpt.low_tank_status							AS low_tank_status_fpt,
			fpt.daily_variance_sales_percent_threshold	AS daily_variance_sales_percent_threshold_fpt,
			fpt.daily_variance_volume_threshold			AS daily_variance_volume_threshold_fpt,
			fpt.active_flag								AS active_flag_fpt
INTO		bcssa_custom_integration..bc_extract_fuel_tanks
FROM		Fuel_Tank AS ft
LEFT JOIN	Fuel_Physical_Tank AS fpt
ON			ft.fuel_tank_id = fpt.physical_fuel_tank_id
LEFT JOIN	Fuel_Tank_Type AS ftt
ON			fpt.fuel_tank_type_id = ftt.fuel_tank_type_id
JOIN		Rad_Sys_Data_Accessor AS rsda
ON			ft.business_unit_id = rsda.data_accessor_id
JOIN		item AS i
ON			ft.fuel_inventory_item_id = i.item_id
JOIN		business_unit AS bu
ON			ft.business_unit_id = bu.business_unit_id
WHERE 		bu.status_code <> 'c'
AND 		fpt.physical_fuel_tank_id is not null
-- Added for support of incremental extract
AND 		ft.fuel_tank_id > @last_max_id
-- END for additional changes

GO
