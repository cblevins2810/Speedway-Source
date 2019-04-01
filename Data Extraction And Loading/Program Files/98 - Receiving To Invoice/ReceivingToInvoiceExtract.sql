DECLARE @BusinessDate SMALLDATETIME
DECLARE @BusinessUnitCode NVARCHAR(30)
DECLARE @BusinessUnitId INT

--SET @BusinessDate = '$(BusinessDate)'
--SET @BusinessUnitCode = '$(BusinessUnitCode)'

SET @BusinessUnitCode = '0001001'
SET @BusinessDate = '2019-01-02'

SELECT @BusinessUnitId =  data_accessor_id
FROM   rad_sys_data_accessor AS rsda
WHERE  name = @BusinessUnitCode

SELECT 
'_' + rsda.name,
s.xref_code,
s.edi_number,
rd.invoice_reference_number,
rd.invoice_date,
'_' + spi.supplier_item_code,
COALESCE(rid.discrepancy_quantity, ri.received_quantity) ReceivedQty,
COALESCE(rid.discrepancy_cost, ri.supplier_price) ReceivedCost

FROM Received_Document AS rd
JOIN Received_Item AS ri
ON   rd.received_id = ri.received_id
JOIN Received_Supplier_Item AS rsi
ON   ri.received_id = rsi.received_id
AND  ri.received_item_id = rsi.received_item_id
LEFT JOIN Supplier_Received_Item_Discrepancy AS rid
ON   rid.received_id = rd.received_id
AND  rid.received_item_id = ri.received_item_id
JOIN supplier AS s
ON   s.supplier_id = rd.supplier_id
JOIN Supplier_Item AS si
ON   si.supplier_id = s.supplier_id
AND  si.supplier_item_id = rsi.supplier_item_id
JOIN Supplier_Packaged_Item as spi
ON   spi.supplier_id = si.supplier_id
AND  spi.supplier_item_id = rsi.supplier_item_id
AND  spi.packaged_item_id = rsi.packaged_item_id
JOIN Business_Unit AS bu
ON   rd.business_unit_id = bu.business_unit_id
JOIN Rad_Sys_Data_Accessor AS rsda
ON   bu.business_unit_id = rsda.data_accessor_id
WHERE rd.business_unit_id = @BusinessUnitId
AND   rd.business_date = @BusinessDate
AND   rd.status_code = 'p'
AND   rd.invoice_date IS NOT NULL
AND   rd.invoice_reference_number IS NOT NULL
ORDER BY rd.received_id, ri.received_item_id 

