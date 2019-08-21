/* Assign the most recent (there should be only one) device group to the retail item */
/* This is only being done to avoid having to change the more complicated import process/spreadsheets */

DECLARE @ClientId INT
DECLARE @DeviceGroupId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

SELECT @DeviceGroupId = MAX(device_group_id)
FROM POS_Device_Group
WHERE client_id = @ClientId

UPDATE Retail_Item
SET device_group_id = @DeviceGroupId
WHERE client_id = @ClientId
AND device_group_id IS NULL