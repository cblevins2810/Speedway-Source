/* This is a one time only script that cleans up existing Manufacturer from the failed item import */

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE inventory_item
SET Manufacturer_id = NULL
WHERE client_id = @ClientId

DELETE Manufacturer
WHERE client_id = @ClientId