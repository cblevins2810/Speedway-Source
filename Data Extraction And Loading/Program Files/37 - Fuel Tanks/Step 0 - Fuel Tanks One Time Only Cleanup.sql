/* This is a one time only script that cleans up existing Fuel Tank data from the failed import */

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

DELETE FROM Fuel_Tank
WHERE client_id = @ClientId
and last_modified_user_id = '42'

DELETE FROM Fuel_Physical_Tank
WHERE client_id = @ClientId
and last_modified_user_id = '42'


