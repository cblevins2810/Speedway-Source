/*
	This script will replace the "|" character with a single quote
	It is needed because of a bug in the item hierarchy import where single quotes
	would not be accepted for parent hierarchy names
*/

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE item_hierarchy
SET name = REPLACE(name,'|','''')
WHERE client_id = @ClientId
AND name like '%|%'