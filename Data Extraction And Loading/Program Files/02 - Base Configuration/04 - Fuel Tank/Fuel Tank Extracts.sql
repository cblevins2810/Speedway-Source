SELECT rsda.name AS business_unit_code,
i.name AS fuel_item_name,
ft.active_flag 
FROM Fuel_Tank AS ft
JOIN Rad_Sys_Data_Accessor AS rsda
ON   ft.business_unit_id = rsda.data_accessor_id
JOIN item AS i
ON   ft.fuel_inventory_item_id = i.item_id

SELECT rsda.name AS business_unit_code,
ftt.name AS fuel_tank_type_name,
fpt.tank_number,
fpt.maximum_water_volume,
fpt.low_tank_threshold,
fpt.low_tank_status,
fpt.daily_variance_sales_percent_threshold,
fpt.daily_variance_volume_threshold,
fpt.active_flag
FROM Fuel_Physical_Tank AS fpt
JOIN Rad_Sys_Data_Accessor AS rsda
ON   fpt.business_unit_id = rsda.data_accessor_id
JOIN Fuel_Tank_Type AS ftt
ON   fpt.fuel_tank_type_id = ftt.fuel_tank_type_id


