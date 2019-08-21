SET NOCOUNT ON

SELECT DISTINCT i.SupplierXrefCode, si.SequenceNumber
FROM	VP60_Spwy..bc_extract_cost_import_supplier_item as si
JOIN    VP60_Spwy..bc_extract_cost_import AS i
ON      si.ImportId = i.ImportId
WHERE   i.StatusCode = 'r'

UPDATE VP60_Spwy..bc_extract_cost_import
SET    StatusCode = 'e'
WHERE  StatusCode = 'r'


