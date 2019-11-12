USE VP60_spwy
GO

IF OBJECT_ID('uspImportShelfLabelBatch') IS NOT NULL
    DROP PROCEDURE uspImportShelfLabelBatch
GO

CREATE PROCEDURE uspImportShelfLabelBatch
@XMLInput AS NTEXT,
@ExistingBatchClosed		CHAR(1) = NULL OUTPUT,
@RMIRowsUpdatedOrAdded		INT = NULL OUTPUT,
@InvalidRMIRows				INT = NULL OUTPUT
AS

SET NOCOUNT ON

--
--   Internal Declarations, Variables and Tables.
--
DECLARE @idoc                       INT
DECLARE @OpenShelfLabelBatchID      INT
DECLARE @BusinessUnitCode           NVARCHAR(50)
DECLARE @BusinessUnitId             INT
DECLARE @ClientId                   INT
DECLARE @NewShelfLabelBatchID 	 	INT
DECLARE @TableId					INT

IF OBJECT_ID('tempdb..#ImportBatchRMI') IS NOT NULL
    DROP TABLE #ImportBatchRMI

CREATE TABLE #ImportBatchRMI (
--		RetailItemName          NVARCHAR(255) NOT NULL,
		RetailPackExternalId    NVARCHAR(100) NOT NULL,
		ShelfLabelPrintQuantity INT,
		ResolvedRMIId           INT NULL)

--
--   Load XML content into temporary tables.
--
EXEC sp_xml_preparedocument @idoc OUTPUT, @XMLInput

SELECT 	@ClientId           = ClientId,
		@BusinessUnitCode   = BusinessUnitCode
FROM OPENXML (@iDoc, '/ShelfLabelBatch',2)  
WITH  	(ClientId           INT          '@clientId',
		BusinessUnitCode    NVARCHAR(50) '@businessUnitCode')

SELECT 	@BusinessUnitId = data_accessor_id
FROM   	spwy_eso..Rad_Sys_Data_Accessor 
WHERE  	client_id = @ClientId
AND    	name      = @BusinessUnitCode

INSERT 	#ImportBatchRMI (
--		RetailItemName,
		RetailPackExternalId,
		ShelfLabelPrintQuantity)
SELECT 	RetailItemName,
		RetailPackExternalId,
		ShelfLabelPrintQuantity
FROM OPENXML (@iDoc, '/ShelfLabelBatch/RetailItemList/RetailItem',2)  
WITH  	(RetailItemName          NVARCHAR(30)        '@retailItemName',
		RetailPackExternalId    NVARCHAR(30)         '@retailPackExternalID',
		ShelfLabelPrintQuantity INT                  '@shelfLabelPrintQuantity')

-- Free the xml pointer
EXEC sp_xml_removedocument @iDoc  

-- Set the RMI Id	  
UPDATE imported
SET    ResolvedRMIId = retail_modified_item_id
FROM   #ImportBatchRMI AS imported
JOIN   spwy_eso..Retail_Modified_Item AS rmi
ON     rmi.xref_code = imported.RetailPackExternalId
AND    rmi.client_id = @ClientId  

DELETE #ImportBatchRMI
WHERE  ResolvedRMIId IS NULL

SET @InvalidRMIRows = @@ROWCOUNT

SELECT @OpenShelfLabelBatchID = existing.shelf_label_batch_id
FROM   spwy_eso..Shelf_Label_Batch AS existing
WHERE  existing.business_unit_id = @BusinessUnitId
AND	   existing.client_id = @clientId
AND    existing.status_code = 'o'

IF @OpenShelfLabelBatchID IS NOT NULL  -- There is already an open batch, update it
BEGIN

	SET @ExistingBatchClosed = 'y'

	UPDATE 	spwy_eso..Shelf_Label_Batch
	SET    	status_code = 'c',
			last_modified_timestamp = GETDATE(),
			last_modified_user_id = 42
	WHERE	shelf_label_batch_id  = @OpenShelfLabelBatchID
	AND		client_id             = @ClientId 
	
/*  Use this code if we decide to update the existing batch 
	SET @NewBatchCreated = 'n'

	UPDATE 	spwy_eso..Shelf_Label_Batch
	SET    	last_modified_timestamp = GETDATE(),
			last_modified_user_id = 42
	WHERE	shelf_label_batch_id  = @OpenShelfLabelBatchID
	AND		client_id             = @ClientId 

	MERGE	spwy_eso..Shelf_Label_Batch_RMI_List AS RMIList
	USING	#ImportBatchRMI AS imported
	ON		(RMIList.retail_modified_item_id = imported.ResolvedRMIId AND
			RMIList.shelf_label_batch_id    = @OpenShelfLabelBatchID AND
			RMIList.client_id               = @ClientId)
	WHEN MATCHED 
        THEN UPDATE
	    SET  RMIList.last_modified_timestamp = GETDATE(),
             RMIList.last_modified_user_id   = 42,
		     RMIList.print_quantity          = RMIList.print_quantity + imported.ShelfLabelPrintQuantity
	WHEN NOT MATCHED BY TARGET
		THEN 	INSERT (business_unit_id, shelf_label_batch_id, retail_modified_item_id, print_quantity, client_id, last_modified_user_id, last_modified_timestamp)
				VALUES (@BusinessUnitId, @OpenShelfLabelBatchID, resolvedRMIId, ShelfLabelPrintQuantity, @ClientId, 42, GETDATE());

	SET @RMIRowsUpdatedOrAdded = @@RowCount
*/

END
ELSE
BEGIN

	SET @ExistingBatchClosed = 'n'

END

-- Create a new batch

SELECT @TableId = table_id
FROM spwy_eso..Rad_Sys_Table
WHERE name = 'Shelf_Label_Batch'
AND db_id = 1

-- Return the starting value of the next ticket 
EXEC sp_get_next_ticket @TableId, 'n',  1, @NewShelfLabelBatchID OUTPUT

-- Insert the header
INSERT 		spwy_eso..Shelf_Label_Batch(
			shelf_label_batch_id,
			business_unit_id,
			status_code,
			client_id,
			last_modified_user_id,
			last_modified_timestamp)
SELECT		@NewShelfLabelBatchID,
			@BusinessUnitId,
			'o',
			@ClientId,
			42,
			GETDATE()
				
-- Insert the RMI and quantities
INSERT 		spwy_eso..Shelf_Label_Batch_RMI_List(
			shelf_label_batch_id,
			business_unit_id,
			retail_modified_item_id,
			print_quantity,
			client_id,
			last_modified_user_id,
			last_modified_timestamp)
SELECT		@NewShelfLabelBatchID,
			@BusinessUnitId,
			ResolvedRMIId ,
			ShelfLabelPrintQuantity,
			@ClientId,
			42,
			GETDATE()
FROM 		#ImportBatchRMI 
WHERE 		ResolvedRMIId IS NOT NULL

SET @RMIRowsUpdatedOrAdded = @@RowCount

IF OBJECT_ID('tempdb..#ImportBatchRMI') IS NOT NULL
    DROP TABLE #ImportBatchRMI

SELECT @ExistingBatchClosed ExistingBatchClosed, @RMIRowsUpdatedOrAdded RMIRowsUpdatedOrAdded, @InvalidRMIRows InvalidRMIRows			

GO
