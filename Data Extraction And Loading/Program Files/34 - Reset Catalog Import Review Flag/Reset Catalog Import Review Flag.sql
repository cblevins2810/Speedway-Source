/* Restore the catalog review flag to it's prior state */

DECLARE @ClientId INT
SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE s
SET catalog_import_review_flag = s2.catalog_import_review_flag
FROM Supplier AS s
JOIN bc_extract_save_catalog_import_review_flag AS s2
ON   s.supplier_id = s2.supplier_id
WHERE s.client_id = @ClientId

IF OBJECT_ID('bc_extract_save_catalog_import_review_flag') IS NOT NULL
	DROP TABLE bc_extract_save_catalog_import_review_flag
GO	
