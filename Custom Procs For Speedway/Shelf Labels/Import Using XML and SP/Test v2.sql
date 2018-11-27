
DELETE Shelf_Label_Batch_RMI_List
DELETE Shelf_Label_Batch

SELECT * FROM Shelf_Label_Batch
SELECT * FROM Shelf_Label_Batch_RMI_List

DECLARE @XMLInput AS NVARCHAR(MAX)
DECLARE @NewBatchCreated CHAR(1) 
DECLARE @RMIRowsUpdatedOrAdded INT 
DECLARE @InvalidRMIRows	INT

SET @XMLInput = N'<ShelfLabelBatch clientId="10000001" businessUnitCode="0007610" businessUnitName="0007610-University Park,IL" batchName="New Products" >
   <RetailItemList>
       <RetailItem retailItemName="MACYS $25, Each" retailPackExternalID="32006426-1" shelfLabelPrintQuantity="11"/>
	   <RetailItem retailItemName="ICE 22LB BAG, Each" retailPackExternalID="114308-1" shelfLabelPrintQuantity="12"/>
	   <RetailItem retailItemName="ICE 22LB BAG, Each" retailPackExternalID="114308-x" shelfLabelPrintQuantity="12"/>
   </RetailItemList>
</ShelfLabelBatch>'

exec sp_Import_Shelf_Label_Batch @XMLInput, @NewBatchCreated OUTPUT, @RMIRowsUpdatedOrAdded OUTPUT, @InvalidRMIRows OUTPUT

SELECT @NewBatchCreated, @RMIRowsUpdatedOrAdded, @InvalidRMIRows