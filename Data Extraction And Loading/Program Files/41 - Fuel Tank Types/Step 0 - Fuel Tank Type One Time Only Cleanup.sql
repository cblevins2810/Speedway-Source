/* This is a one time only script that cleans up existing Manufacturer from the failed item import */

DECLARE	@ClientId INT

SELECT	@ClientId = MAX(client_id) FROM Rad_Sys_Client


DELETE	Fuel_Tank_Type
WHERE	client_id = @ClientId
