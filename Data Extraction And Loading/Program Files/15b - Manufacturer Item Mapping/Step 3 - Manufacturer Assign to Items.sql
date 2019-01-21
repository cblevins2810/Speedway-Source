/*
Step 3 - Assign the Manufacturer to an item based upon mapping table extracted from 
*/
DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE ii
SET manufacturer_id = m.manufacturer_id
FROM inventory_item AS ii
JOIN item AS i
ON   ii.inventory_item_id = i.item_id
JOIN bc_extract_item_manufacturer AS em
ON   em.xref_code = i.xref_code
JOIN Manufacturer AS m
ON   m.name = em.manufacturer_name
WHERE i.client_id = @ClientId