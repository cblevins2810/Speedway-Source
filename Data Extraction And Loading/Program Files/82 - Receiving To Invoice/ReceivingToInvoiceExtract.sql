SET NOCOUNT ON

DECLARE @BusinessDate SMALLDATETIME
DECLARE @BusinessUnitCode NVARCHAR(30)
DECLARE @BusinessUnitId INT

SET @BusinessDate = '$(BusinessDate)'
SET @BusinessUnitCode = '$(BusinessUnitCode)'

--SET @BusinessUnitCode = '0001001'
--SET @BusinessDate = '2019-01-02'

SELECT @BusinessUnitId =  data_accessor_id
FROM   rad_sys_data_accessor AS rsda
WHERE  name = @BusinessUnitCode

SELECT 
'_' + rsda.name,
s.xref_code,
s.edi_number,
rd.invoice_reference_number,
CONVERT(nvarchar(10),rd.invoice_date,120) InvoiceDate,
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
AND   s.xref_code IN (
'EBYAUROR',
'EBYSAWIS',
'EBYSMOKE',
'MCLNCRLN',
'MCLNNTHE',
'MCLNSUNE',
'MCLNPENN',
'MCLNCONC',
'MCLNSTHE',
'MCLNDTHN',
'MCLNMIDA',
'MCLNSTHW',
'COKEFLOR',
'COKNEWRI',
'COKLBRTY',
'COKEIND',
'COKCCBCC',
'COKCOLOH',
'COKALSIL',
'COKDAYOH',
'COKGREAT',
'COKCINOH',
'COKABRTA',
'COKEFLNT',
'COKCCCNC',
'COKAKROH',
'COKMLWWI',
'COKTOLOH',
'COKCLAYT',
'COKECLEV',
'COKANCCC',
'COKCINKY',
'COKHLYWD',
'COKKALMI',
'COKSTCIL',
'COKLVRGN',
'COKBAYMI',
'COKFTWIN',
'COKGRNVL',
'COKNESYR',
'COKEMANS',
'COKSTHIN',
'COKEELYR',
'COKCTGTN',
'COKNBERN',
'COKECHIL',
'COKPRKIL',
'COKCHARL',
'COKAB3PA',
'COKZANOH',
'COKWILOH',
'COKNEROC',
'COKECARM',
'COKLIMOH',
'COKCONWY',
'COKTERIN',
'COKCCCVA',
'COKLELND',
'COKEYOUN',
'COKNEELM',
'COKLAFIN',
'COKCCCTN',
'COKCCRGA',
'COKETRAV',
'COKNECCD',
'COKEMDLB',
'COKBLOIN',
'COKNEBUF',
'COKHALFX',
'COKEHTN',
'COKPRKWI',
'COKFAYTV',
'COKFINOH',
'COKINDIN',
'COKDURNC',
'COKNELWL',
'COKCCCSC',
'COKNESCT', 
'COKNELDY',
'COKCCCIN',
'COKMADWI',
'COKCHCIL',
'COKRCKWI',
'COKNELSR', 
'COKNEWTD',
'COKSKYLD',
'COKINCC',
'COKCININ',
'COKNEALB',
'COKFTWOH',
'COKNORWI',
'COKPTMOH',
'COKCCCDE',
'COKUNTSC',
'COKSHEWI')
ORDER BY rd.received_id, ri.received_item_id 

