/* Save the state of the create receiving from invoice flag and set the flag to true for all suppliers */
/* This will allow for receiving test data to be creaated from the invoice import */

IF OBJECT_ID('bc_extract_save_receive_from_invoice_flag') IS NOT NULL
	DROP TABLE bc_extract_save_receive_from_invoice_flag
GO	

DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

SELECT supplier_id, create_receive_from_invoice_flag INTO bc_extract_save_receive_from_invoice_flag
FROM supplier
WHERE client_id = @ClientId

UPDATE supplier
SET create_receive_from_invoice_flag = 'y'
WHERE client_id = @ClientId
