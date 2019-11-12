SET NOCOUNT ON

SELECT DISTINCT ci.SupplierXrefCode, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(s.name,'/',' '),',',' '),'_',' '),'[',' '), ']',' '),
cisi.SequenceNumber
FROM	VP60_Spwy..bc_extract_cost_import_supplier_item as cisi
JOIN    VP60_Spwy..bc_extract_cost_import AS ci
ON      cisi.ImportId = ci.ImportId
JOIN    VP60_eso..Supplier AS s
ON      s.supplier_id = ci.ResolvedSupplierId
WHERE   ci.StatusCode = 'r'
AND     cisi.SequenceNumber IS NOT NULL





