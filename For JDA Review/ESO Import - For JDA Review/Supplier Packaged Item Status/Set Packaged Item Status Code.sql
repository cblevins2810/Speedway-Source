/*  Because the catalog import process populates the supplier item status code and keeps it in synch with the 
    packaged item status code, we populate the description field in the import with a special string to indicate
	the packaged item status.  After the supplier item import, we change the status code based upon the name 
	column which maps to the description in the import xml */

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM rad_sys_client

UPDATE spi
SET status_code = 'u',
name = si.name
FROM supplier_packaged_item AS spi
JOIN supplier_item AS si
ON   spi.supplier_item_id = si.supplier_item_id
AND  spi.client_id = si.client_id
WHERE spi.client_id = @ClientId
AND   spi.name = '*UNAVAILABLE*'

UPDATE spi
SET status_code = 'i',
name = si.name
FROM supplier_packaged_item AS spi
JOIN supplier_item AS si
ON   spi.supplier_item_id = si.supplier_item_id
AND  spi.client_id = si.client_id
WHERE spi.client_id = @ClientId
AND   spi.name = '*INACTIVE*'
