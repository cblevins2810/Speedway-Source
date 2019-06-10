/* Restore the create receiving from invoice to it's prior state */

DECLARE @ClientId INT
SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE s
SET create_receive_from_invoice_flag = s2.create_receive_from_invoice_flag
FROM Supplier AS s
JOIN bc_extract_save_receive_from_invoice_flag AS s2
ON   s.supplier_id = s2.supplier_id
WHERE s.client_id = @ClientId


IF OBJECT_ID('bc_extract_save_receive_from_invoice_flag') IS NOT NULL
	DROP TABLE bc_extract_save_receive_from_invoice_flag
GO	
