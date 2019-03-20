/* Save the state of the catalog review flag and set the review flag to false for all suppliers */
/* This will prevent catalogs from being reviewed during the initial data load */

IF OBJECT_ID('bc_extract_save_catalog_import_review_flag') IS NOT NULL
	DROP TABLE bc_extract_save_catalog_import_review_flag
GO	

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

SELECT supplier_id, catalog_import_review_flag INTO bc_extract_save_catalog_import_review_flag
FROM supplier
WHERE client_id = @ClientId

UPDATE supplier
SET catalog_import_review_flag = 'n'
WHERE client_id = @ClientId

