--DECLARE @XMLInput AS NTEXT
DECLARE @XMLInput AS NVARCHAR(MAX)

SET @XMLInput = N'<ShelfLabelBatch clientId="10000001" businessUnitCode="0007610" businessUnitName="0007610-University Park,IL" batchName="New Products" >
   <RetailItemList>
       <RetailItem retailItemName="MACYS $25, Each" retailPackExternalID="32006426-1" shelfLabelPrintQuantity="11"/>
	   <RetailItem retailItemName="ICE 22LB BAG, Each" retailPackExternalID="114308-1" shelfLabelPrintQuantity="12"/>
   </RetailItemList>
</ShelfLabelBatch>'


--
--   Internal Declarations, Variables and Tables.
--
DECLARE @existing_Shelf_Label_batch_id INT
DECLARE @header_ticket                 INT
DECLARE @idoc                          INT
DECLARE @OpenShelfLabelBatchID         INT
DECLARE @ClientId                      INT

IF OBJECT_ID('tempdb..#ImportBatch') IS NOT NULL
    DROP TABLE #ImportBatch

IF OBJECT_ID('tempdb..#ImportBatchRMI') IS NOT NULL
    DROP TABLE #ImportBatchRMI

CREATE TABLE #ImportBatch (
BusinessUnitCode        NVARCHAR(50) NOT NULL,
BusinessUnitName        NVARCHAR(50) NOT NULL,
BatchName               NVARCHAR(50) NOT NULL,
ResolvedBusinessUnitId  INT NULL)

CREATE TABLE #ImportBatchRMI (
RetailItemName          NVARCHAR(255) NOT NULL,
RetailPackExternalId    NVARCHAR(100) NOT NULL,
ShelfLabelPrintQuantity INT,
ResolvedRMIId           INT NULL)

--
--   Load XML content into temporary tables.
--
EXEC sp_xml_preparedocument @idoc OUTPUT, @XMLInput

SELECT 
@ClientId = ClientId
FROM OPENXML (@iDoc, '/ShelfLabelBatch',2)  
WITH (ClientId           INT         '@clientId')

INSERT #ImportBatch (
BatchName,
BusinessUnitCode,
BusinessUnitName)
SELECT 
BatchName,
BusinessUnitCode,
BusinessUnitName
FROM OPENXML (@iDoc, '/ShelfLabelBatch',2)  
WITH (BatchName           NVARCHAR(50)         '@batchName',
      BusinessUnitCode    NVARCHAR(50)         '@businessUnitCode',
      BusinessUnitName    NVARCHAR(50)         '@businessUnitName')

INSERT #ImportBatchRMI (
RetailItemName,
RetailPackExternalId,
ShelfLabelPrintQuantity)
SELECT 
RetailItemName,
RetailPackExternalId,
ShelfLabelPrintQuantity
FROM OPENXML (@iDoc, '/ShelfLabelBatch/RetailItemList/RetailItem',2)  
WITH (RetailItemName          NVARCHAR(30)         '@retailItemName',
      RetailPackExternalId    NVARCHAR(30)         '@retailPackExternalID',
      ShelfLabelPrintQuantity INT                  '@shelfLabelPrintQuantity')

-- Free the xml pointer
EXEC sp_xml_removedocument @iDoc  

-- Set the business unit id	  
UPDATE imported
SET    ResolvedBusinessUnitId = data_accessor_id
FROM   #ImportBatch AS imported
JOIN   Rad_Sys_Data_Accessor AS rsda
ON     imported.BusinessUnitCode = rsda.name
WHERE  rsda.client_id = @ClientId 

-- Set the RMI Id	  
UPDATE imported
SET    ResolvedRMIId = retail_modified_item_id
FROM   #ImportBatchRMI AS imported
JOIN   Retail_Modified_Item AS rmi
ON     rmi.xref_code = imported.RetailPackExternalId
AND    rmi.client_id = @ClientId  

-- Determine if there is currently an open batch
SELECT @OpenShelfLabelBatchID = existing.shelf_label_batch_id
FROM   Shelf_Label_Batch AS existing
JOIN   #ImportBatch AS imported
ON     existing.business_unit_id = imported.ResolvedBusinessUnitId
WHERE  existing.client_id = @clientId
AND    existing.status_code = 'o'

IF @OpenShelfLabelBatchID IS NOT NULL  -- There is already an open batch, update it
BEGIN

PRINT 'Existing Batch'

END
ELSE  -- Create a new batch
BEGIN

Print 'New Batch'

END

SELECT * FROM #ImportBatch
SELECT * FROM #ImportBatchRMI

IF OBJECT_ID('tempdb..#ImportBatch') IS NOT NULL
    DROP TABLE #ImportBatch

IF OBJECT_ID('tempdb..#ImportBatchRMI') IS NOT NULL
    DROP TABLE #ImportBatchRMI

