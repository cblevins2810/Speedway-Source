SET NOCOUNT ON

DECLARE @MerchCostChangeEffectiveDate AS smalldatetime
SET		@MerchCostChangeEffectiveDate = CONVERT(smalldatetime, SYSDATETIME())
DECLARE @supplier_id INT
DECLARE @SupplierXRef nvarchar(255)
DECLARE @SequenceNumber INT
DECLARE @cost_level TABLE (supplier_id INT, merch_cost_level_id INT)

--:SETVAR SupplierXRef "XXX"
--:SETVAR SequenceNumber 1

--SET @SupplierXRef = '$(SupplierXRef)'
--SET @SequenceNumber = '$(SequenceNumber)'

SET @SupplierXRef = 'PEPBTLNC'
SET @SequenceNumber = 1

SELECT @supplier_id = supplier_id
FROM supplier
WHERE xref_code = @SupplierXRef

INSERT @cost_level
SELECT supplier_id, merch_cost_level_id
FROM   merch_cost_level
WHERE  supplier_id = @supplier_Id

IF OBJECT_ID('tempdb..#supplier_item_counts') IS NOT NULL
    DROP TABLE #supplier_item_counts
CREATE TABLE #supplier_item_counts
(supplier_id int,
 supplier_item_id int,
 cost_level_count int,
 barcode_count int)
 
IF OBJECT_ID('tempdb..#supplier_item_extract') IS NOT NULL
    DROP TABLE #supplier_item_extract
CREATE TABLE #supplier_item_extract
(supplier_id int not null,
 supplier_item_id int not null,
 supplier_item_row_number int not null,
 supplier_item_code nvarchar(50) not null,
 barcode_type nvarchar(1) null,
 barcode_number nvarchar(255) null,
 cost_level_name nvarchar(50) null,
 package_cost smallmoney null,
 package_allowance smallmoney null,
 start_date smalldatetime null,
 end_date smalldatetime null)
 
CREATE INDEX IX1 ON #supplier_item_extract (supplier_id, supplier_item_id, supplier_item_row_number)

IF OBJECT_ID('tempdb..#merch_cost_change') IS NOT NULL
    DROP TABLE #merch_cost_change
CREATE TABLE #merch_cost_change
(supplier_id INT NOT NULL,
 supplier_item_id INT NOT NULL,
 merch_cost_level_id INT NOT NULL,
 start_date smalldatetime NOT NULL,
 end_date smalldatetime NULL,
 supplier_price smallmoney NOT NULL,
 supplier_allowance smallmoney NOT NULL)

INSERT #merch_cost_change
(supplier_id,
supplier_item_id,
merch_cost_level_id,
start_date,
end_date,
supplier_price,
supplier_allowance)
SELECT DISTINCT ci.ResolvedSupplierId,
cii.ResolvedSupplierItemId,
cii.ResolvedCostLevelId,
cii.StartDate,
cii.EndDate,
cii.SupplierPrice,
cii.SupplierAllowance
FROM VP60_Spwy..bc_extract_cost_import AS ci
JOIN VP60_Spwy..bc_extract_cost_import_supplier_item AS cii
ON   ci.ImportId = cii.ImportId

JOIN @cost_level as cl
ON   ci.ResolvedSupplierId = cl.supplier_Id
AND  cii.ResolvedCostLevelId = cl.merch_cost_level_id

WHERE ci.ResolvedSupplierId = @supplier_id
AND   cii.SequenceNumber = @SequenceNumber

SELECT * FROM @cost_level
WHERE supplier_id = 10001491
SELECT @supplier_id
SELECT @SequenceNumber
SELECT * FROM #merch_cost_change

INSERT #Supplier_Item_Counts(Supplier_Id, Supplier_Item_Id, Cost_Level_Count, Barcode_Count)  
SELECT si.supplier_Id, si.supplier_item_id, clc.cost_level_count, barcode_count
FROM supplier_item AS si (NOLOCK)
LEFT JOIN (SELECT supplier_Id, supplier_Item_Id, COUNT(*) AS cost_level_count
      FROM #merch_cost_change AS mcc (NOLOCK)
      GROUP BY supplier_id, supplier_item_id) AS clc
ON  si.supplier_id = clc.supplier_id
AND si.supplier_item_id = clc.supplier_item_id
LEFT JOIN (SELECT supplier_Id, supplier_Item_Id, 0 AS barcode_count
      FROM supplier_item_barcode AS sib (NOLOCK)
      WHERE 1<>1
      GROUP BY supplier_id, supplier_item_id) AS bcc
ON  si.supplier_id = bcc.supplier_id
AND si.supplier_item_id = bcc.supplier_item_id
WHERE si.supplier_id = @supplier_id

INSERT #supplier_item_extract
(supplier_id,
 supplier_item_id,
 supplier_item_row_number,
 supplier_item_code,
 cost_level_name,
 package_cost,
 package_allowance,
 start_date,
 end_date)

SELECT sics.supplier_id,
sics.supplier_item_id,
ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, mcl.merch_cost_level_id) AS supplier_item_row_number, 
spi.supplier_item_code,
mcl.name,
mcc.supplier_price,
mcc.supplier_allowance,
mcc.start_date,
mcc.end_date
FROM #supplier_item_counts AS sics (NOLOCK)
JOIN Supplier_Packaged_Item AS spi (NOLOCK)
ON   spi.supplier_id = sics.supplier_id
AND  spi.supplier_item_id = sics.supplier_item_id
JOIN #merch_cost_change AS mcc (NOLOCK)
ON   spi.supplier_id = mcc.supplier_id
AND  spi.supplier_item_id = mcc.supplier_item_id
JOIN Merch_Cost_Level as mcl (NOLOCK)
ON   mcl.supplier_id = mcc.supplier_id
AND  mcl.merch_cost_level_id = mcc.merch_cost_level_id
WHERE ISNULL(sics.barcode_count,0) < sics.cost_level_count

UPDATE sie
SET sie.barcode_type = bc.barcode_type_code,
sie.barcode_number = bc.barcode_number
FROM #supplier_item_extract AS sie
JOIN (SELECT sics.supplier_id,
      sics.supplier_item_id,
      ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, sib.barcode_type_code, sib.barcode_number) AS supplier_item_row_number, 
      spi.supplier_item_code,
      sib.barcode_type_code,
      sib.barcode_number
      FROM #supplier_item_counts AS sics
      JOIN Supplier_Packaged_Item AS spi
      ON   spi.supplier_id = sics.supplier_id
      AND  spi.supplier_item_id = sics.supplier_item_id
      JOIN supplier_item_barcode AS sib
      ON sics.supplier_id = sib.supplier_id
      AND sics.supplier_item_id = sib.supplier_item_id
      WHERE barcode_type_code IN ('e','g','u')
      AND sics.barcode_count < sics.cost_level_count ) AS bc
ON sie.supplier_Id = bc.supplier_Id
AND sie.supplier_Item_Id = bc.supplier_Item_Id
AND sie.supplier_item_row_number = bc.supplier_item_row_number

UPDATE sie
SET sie.cost_level_name = mcc.name,
    sie.package_cost = mcc.supplier_price,
    sie.package_allowance = mcc.supplier_allowance,
    sie.start_date = mcc.start_date,
    sie.end_date = mcc.end_date
FROM #supplier_item_extract AS sie
JOIN (SELECT sics.supplier_id,
      sics.supplier_item_id,
      ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, mcl.merch_cost_level_id) AS supplier_item_row_number, 
      spi.supplier_item_code,
      mcl.name,
      mcc.supplier_price,
      mcc.supplier_allowance,
      mcc.start_date,
      mcc.end_date
      FROM #supplier_item_counts AS sics (NOLOCK)
      JOIN Supplier_Packaged_Item AS spi (NOLOCK)
      ON   spi.supplier_id = sics.supplier_id
      AND  spi.supplier_item_id = sics.supplier_item_id
      JOIN #merch_cost_change AS mcc (NOLOCK)
      ON   spi.supplier_id = mcc.supplier_id
      AND  spi.supplier_item_id = mcc.supplier_item_id
      JOIN Merch_Cost_Level as mcl (NOLOCK)
      ON   mcl.supplier_id = mcc.supplier_id
      AND  mcl.merch_cost_level_id = mcc.merch_cost_level_id
      WHERE ISNULL(sics.barcode_count,0) >= sics.cost_level_count) AS mcc
ON  sie.supplier_Id = mcc.supplier_Id
AND sie.supplier_Item_Id = mcc.supplier_Item_Id
AND sie.supplier_item_row_number = mcc.supplier_item_row_number

SELECT  '_' + spi.supplier_item_code AS ProductCode, 
		CASE sie.supplier_item_row_number WHEN 1 THEN REPLACE(REPLACE(si.name, ',','~'),'"','''''') ELSE '' END AS Name, 
		CASE sie.supplier_item_row_number WHEN 1 THEN ISNULL(si.xref_value,i.xref_code) ELSE '' END AS XRefID,
		CASE sie.supplier_item_row_number WHEN 1 THEN ISNULL(i.xref_code,'') ELSE '' END AS ItemXRefID,

		'' AS SpreadSheetPlaceholder1,
		'' AS SpreadSheetPlaceholder2,
		
		CASE sie.supplier_item_row_number 
		WHEN 1 THEN CASE spi.status_code 
				WHEN 'i' THEN '*INACTIVE*' + ISNULL(REPLACE(REPLACE(ISNULL(si.description,''),',','~'),'"',''''';'),'')
				WHEN 'u' THEN '*UNAVAILABLE*' + ISNULL(REPLACE(REPLACE(ISNULL(si.description,''),',','~'),'"',''''';'),'')
				ELSE ISNULL(si.description,'') END 
		ELSE ''	 END AS Description,

		CASE sie.supplier_item_row_number WHEN 1 THEN si.status_code ELSE '' END AS Status, 
		CASE sie.supplier_item_row_number WHEN 1 THEN REPLACE(REPLACE(RTRIM(sic.name),',','~'),'"',''''';') ELSE '' END AS SupplierItemGroupName,

        CASE sie.supplier_item_row_number 
		     WHEN 1 THEN CASE WHEN CHARINDEX('-', uom.name,1) > 1 THEN RTRIM(SUBSTRING(uom.name,1,CHARINDEX('-',uom.name,1)-1))
				ELSE CASE WHEN uom.name='228' THEN 'Case'
				ELSE uom.name END
				END
			 ELSE '' END AS SupplierPackageUOM, 		
		
		CASE sie.supplier_item_row_number WHEN 1 THEN CAST(CAST(uom.factor AS DECIMAL(8,2)) AS nvarchar(20)) ELSE '' END AS QuantityFactor,
		CASE sie.supplier_item_row_number WHEN 1 THEN ISNULL(CONVERT (nvarchar(10), si.availability_start_date,120),'') ELSE '' END AS AvailabilityStartDate,
		CASE sie.supplier_item_row_number WHEN 1 THEN ISNULL(CONVERT (nvarchar(10), si.availability_end_date,120),'') ELSE '' END AS AvailabilityEndDate,
		ISNULL(sie.barcode_type, '') AS TypeCode,
		ISNULL('_' + sie.barcode_number,'') AS Number, 
		REPLACE(REPLACE(ISNULL(sie.cost_level_name, ''),',','~'),'"',''''';') AS CostLevel, 
		CASE WHEN sie.cost_level_name IS NULL  THEN '' ELSE CONVERT(nvarchar(10), sie.package_cost) END AS PackageCost,
		CASE WHEN sie.cost_level_name IS NULL  THEN '' ELSE CONVERT(nvarchar(10), sie.package_allowance) END AS PackageAllowance,
		ISNULL(CONVERT(nvarchar(10), sie.start_date,120),'') AS CostStartDate,
		ISNULL(CONVERT(nvarchar(10), sie.end_date,120),'') AS CostEndDate

FROM  #supplier_item_extract AS sie
INNER JOIN Supplier_Item AS si 
ON    sie.supplier_id = si.supplier_id
AND   sie.supplier_item_id = si.supplier_item_id
INNER JOIN Supplier AS s
ON    si.supplier_id = s.supplier_id
INNER JOIN Supplier_Item_Category AS sic
ON    si.supplier_item_category_id = sic.supplier_item_category_id
AND   si.supplier_id = sic.supplier_id
INNER JOIN Supplier_Packaged_Item AS spi
ON    si.supplier_item_id = spi.supplier_item_id
AND   si.supplier_id = spi.supplier_id
INNER JOIN Unit_of_Measure AS uom
ON    spi.packaged_in_uom_id = uom.unit_of_measure_id
INNER JOIN Rad_Sys_Client AS rsc
ON s.client_id = rsc.client_id
INNER JOIN Rad_Sys_Data_Accessor AS rsda 
ON rsc.client_id = rsda.data_accessor_id
LEFT JOIN Item AS i
ON si.item_id = i.item_id
WHERE	s.status_code IN ('a')
AND s.supplier_type_code IN ('m') 
AND si.status_code in ('a','u')
AND i.purge_flag IN ('n')
AND (CASE 
	WHEN	(ISNUMERIC(i.xref_code) = 1 
			AND LEN(i.xref_code) < 9
     		AND LEFT(i.xref_code, 1) NOT IN ('0')
			AND i.xref_code NOT LIKE '%[^0-9]%' 
			)	THEN CONVERT(int, i.xref_code)
			WHEN i.xref_code IS NULL THEN 0
			ELSE	-1
			END	) >= 0
		
ORDER BY sie.supplier_item_code, sie.supplier_item_row_number

IF OBJECT_ID('tempdb..#supplier_item_counts') IS NOT NULL
    DROP TABLE #supplier_item_counts
    
IF OBJECT_ID('tempdb..#supplier_item_extract') IS NOT NULL
    DROP TABLE #supplier_item_extract

IF OBJECT_ID('tempdb..#merch_cost_change') IS NOT NULL
    DROP TABLE #merch_cost_change


