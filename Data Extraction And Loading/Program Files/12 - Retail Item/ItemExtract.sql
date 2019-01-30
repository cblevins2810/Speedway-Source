SET NOCOUNT ON
IF OBJECT_ID('tempdb..#item_extract') IS NOT NULL
    DROP TABLE #item_extract
GO

IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO

DECLARE @Today nvarchar(10)
SET @Today = CONVERT(nvarchar(10), GETDATE(),120)

DECLARE @DepartmentName nvarchar(50)
DECLARE @Modulus INT
DECLARE @Remainder INT
DECLARE @DepartmentId INT

/*
:SETVAR Modulus -1
:SETVAR Remainder -1
:SETVAR DepartmentName "XXX"
*/

SET @Modulus = '$(Modulus)'
SET @Remainder = '$(Remainder)'
SET @DepartmentName = '$(DepartmentName)'

--SET @Modulus = 1
--SET @Remainder = 0
--SET @DepartmentName = '201 Other Fast Food'

SELECT @DepartmentId = item_hierarchy_id
FROM item_hierarchy WHERE name = @DepartmentName

CREATE TABLE #item_extract
(item_id int not null,
 ItemRowNumber int not null,
 ItemExternalID nvarchar(255) not null,
 PurgeFlag nvarchar(1) not null,
 ItemName nvarchar(50) not null,
 ItemDescription nvarchar(255) null,
 SoldAs nvarchar(1) null,
 Category nvarchar(50) null,
 BaseUOMClass nvarchar(50) null, 
 ReportedInUOM nvarchar(50) null,
 Manufacturer nvarchar(50) null, 
 SKUNumber nvarchar(255) null, 
 Taxability nvarchar(50) null,
 Active nvarchar(1) null,
 Track nvarchar(1) null,
 ExpenseUponReceiving nvarchar(1) null,
 AllowFractionalQuantities nvarchar(1) null,
 SetVarianceToZero nvarchar(1) null,
 WasteTolerance nvarchar(20) null,
 MissingTolerance nvarchar(20) null,
 DefaultAdjustmentUOM nvarchar(30) null, 
 DefaultTransferUOM nvarchar(30) null,
 ConvertFromUOMName1 nvarchar(30) null,
 ConvertFromUOMQty1 nvarchar(30) null,
 ConvertToUOMClass1 nvarchar(30) null,
 ConvertToUOMName1 nvarchar(30) null,
 ConvertToUOMQty1 nvarchar(30) null,
 ConvertFromUOMName2 nvarchar(30) null,
 ConvertFromUOMQty2 nvarchar(30) null,
 ConvertToUOMClass2 nvarchar(30) null,
 ConvertToUOMName2 nvarchar(30) null,
 ConvertToUOMQty2 nvarchar(30) null,
 RetailStrategy nvarchar(126) null,
 PromptForQtyAtPos nvarchar(1) null,
 AutoQueueShelfLabel nvarchar(1) null,
 RequiresSwipeAtPos nvarchar(1) null,
 CreditCategoryCode nvarchar(10) null,
 ShelfLabelUOM nvarchar(30) null,
 RetailModifiedItemId int null,
 PackRowNumber int null,
 PackName nvarchar(30) null,
 PackQty  nvarchar(10) null,
 RetailLevelGroup nvarchar(126) null,
 PackExternalId nvarchar(255) null,
 ListPrice nvarchar(10) null,
 BarcodeType nvarchar(1) null,
 BarcodeNumber nvarchar(255) null,
 BarcodeCompressible nvarchar(1)) 

CREATE TABLE #rmi_barcode
(retail_modified_item_id INT NOT NULL,
 barcode_number NVARCHAR(255) NOT NULL,
 barcode_type_code NVARCHAR(1) NOT NULL,
 compressible NVARCHAR(1) NOT NULL DEFAULT 'n')

CREATE CLUSTERED INDEX X1 ON #rmi_barcode (retail_modified_item_id, compressible) 

INSERT #rmi_barcode (retail_modified_item_id, barcode_number, barcode_type_code)
SELECT bc.retail_modified_item_id, bc.barcode_number, bc.barcode_type_code
--INTO #rmi_barcode
FROM (SELECT rmi.retail_modified_item_id,
bc.complete_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE --i.purge_flag ='n'
--AND 
i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.compressed_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE --i.purge_flag ='n'
--AND 
i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.primitive_complete_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE --i.purge_flag ='n'
--AND
i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.primitive_compressed_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE --i.purge_flag ='n'
--AND
 i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')

) AS bc

DELETE bc
FROM #rmi_barcode AS bc
WHERE EXISTS
	(SELECT 1
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND   bc.barcode_number = SUBSTRING(bc2.barcode_number,1,11)
	AND   bc.barcode_type_code =  bc2.barcode_type_code)
AND EXISTS 
	(SELECT 1 
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND LEN(bc2.barcode_number) = 10)   
AND LEN(bc.barcode_number) = 11	

DELETE bc
FROM #rmi_barcode AS bc
WHERE EXISTS
	(SELECT 1
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND   bc.barcode_number = SUBSTRING(bc2.barcode_number,1,7)
	AND   bc.barcode_type_code =  bc2.barcode_type_code)
AND EXISTS 
	(SELECT 1 
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND LEN(bc2.barcode_number) = 6)   
AND LEN(bc.barcode_number) = 7	   

DELETE bc
FROM #rmi_barcode AS bc
WHERE LEN(bc.barcode_number) = 8
AND bc.barcode_type_code = 'u'

UPDATE rmibc
SET compressible = 'y'
FROM #rmi_barcode AS rmibc
JOIN BarCode AS bc
ON rmibc.barcode_number = bc.primitive_complete_code
WHERE rmibc.barcode_type_code = 'u'
AND   LEN(barcode_number) = 12
AND   SUBSTRING(barcode_number,1,1) = '0'
AND bc.primitive_complete_code != bc.primitive_compressed_code

/* Since we are pulling purged items, duplicate xref codes can exists.  Noting these as dupes */
/* Need to do this every time to allow for refresh of the source DB */
UPDATE i
SET xref_code = RTRIM(i.xref_code) + 'Dupe'
FROM Item AS i
JOIN (SELECT xref_code, COUNT(*) AS dupe_count
      FROM item
      GROUP by xref_code
      HAVING COUNT(*) > 1) AS d
ON d.xref_code = i.xref_code
WHERE i.purge_flag = 'y'
AND i.xref_code not like '%Dupe%'


INSERT #item_extract 
SELECT 
i.item_id AS Item_ID,
ROW_NUMBER() over (partition by i.item_id order by i.item_id, ridmuom.factor) AS ItemRowNumber,
ISNULL(i.xref_code, CONVERT(nvarchar(20), item_id)) AS ItemExternalID, 
i.purge_flag AS PurgeFlag,
RTRIM(i.name) AS ItemName, 
ISNULL(i.description,'') AS ItemDescription, 
ri.retail_item_type_code AS SoldAs, 
RTRIM(ISNULL(REPLACE(REPLACE(RTRIM(ih.name), ',','~'),'''','|'),'')) AS Category,
--REPLACE(RTRIM(ISNULL(ih.name,'')),'''','*apos*') AS Category,
ISNULL(uomc.name,'') AS BaseUOMClass, 
ISNULL(ruom.name,'') AS ReportedInUOM, 
ISNULL(m.name,'') AS Manufacturer, 
ISNULL(ii.sku_number,'') AS SKUNumber, 
CASE ri.taxability_flag
     WHEN 'y' THEN 'Taxable' 
     WHEN 'n' THEN 'Non-Taxable'
	 ELSE 'Use Category Setting' END AS Taxability, 
ii.active_flag AS Active,
i.track_flag AS Track, 
ii.exclude_on_hand_tracking_flag AS ExpenseUponReceiving, 
ii.allow_fractional_quantity_flag AS AllowFractionalQuantities, 
ii.set_variance_to_zero_flag AS SetVarianceToZero, 
ISNULL(CONVERT(NVARCHAR(20), ii.waste_tolerance),'') AS WasteTolerance, 
ISNULL(CONVERT(NVARCHAR(20), ii.missing_tolerance),'') AS MissingTolerance, 
ISNULL(dauom.name,'') AS DefaultAdjustmentUOM, 
ISNULL(dtuom.name,'') AS DefaultTransferUOM,
uomconv1.ConvertFromUOMName,
uomconv1.ConvertFromUOMQty,
uomconv1.ConvertToUOMClass,
uomconv1.ConvertToUOMName,
uomconv1.ConvertToUOMQty,

uomconv2.ConvertFromUOMName,
uomconv2.ConvertFromUOMQty,
uomconv2.ConvertToUOMClass,
uomconv2.ConvertToUOMName,
uomconv2.ConvertToUOMQty,

mg.name AS RetailStrategy,
--'Default Strategy' AS RetailStrategy,
ri.prompt_for_quantity_flag AS PromptForQtyAtPos,
ri.shelf_label_flag AS AutoQueueShelfLabel, 
ri.swipe_flag AS RequiresSwipeAtPos,
ISNULL(CONVERT(nvarchar(10), ih.credit_category),'') AS CreditCategoryCode,
ISNULL(sluom.name,'') AS ShelfLabelUOM,
rmi.retail_modified_item_id,
ROW_NUMBER() over (partition by i.item_id, rmi.retail_modified_item_id order by i.item_id, rmi.retail_modified_item_id) AS PackRowNumber, 
CASE WHEN uomc.unit_of_measure_class_id = 3 THEN
     CASE WHEN ridmuom.factor = 1 THEN 'Each'
     ELSE CONVERT(NVARCHAR(20),CONVERT(INT,ridmuom.factor)) + '-Each' END
ELSE ridm.name END AS PackName,
--CONVERT(NVARCHAR(20),CONVERT(INT,ridmuom.factor)) + '-Each' AS PackName,
-- ridm.name AS PackName,
CONVERT(INT, ridmuom.factor) AS PackQty,
mgm.name AS RetailLevelGroup,
i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)) AS PackExternalId,
mrc.retail_price AS ListPrice,
ISNULL(rmibcl.barcode_type_code,'') AS BarcodeTypeCode,
ISNULL(rmibcl.barcode_number,'') AS BarcodeNumber,
ISNULL(rmibcl.compressible,'') AS BarcodeCompressible
FROM Item as i
jOIN item_hierarchy as ih
ON i.item_hierarchy_id = ih.item_hierarchy_id
JOIN item_hierarchy_list as ihl
on ih.item_hierarchy_id = ihl.item_hierarchy_id
JOIN item_hierarchy as ihdept
ON ihl.parent_item_hierarchy_id = ihdept.item_hierarchy_id
JOIN Unit_Of_Measure_Class as uomc
ON i.unit_of_measure_class_id = uomc.unit_of_measure_class_id
JOIN Inventory_Item as ii
ON i.item_id = ii.inventory_item_id
LEFT JOIN Unit_of_Measure AS ruom 
ON ii.default_reporting_uom_id = ruom.unit_of_measure_id


LEFT JOIN (SELECT ROW_NUMBER() over (partition by v.item_id order by uomc.name) AS RowNumber,
      v.item_id AS citem_id, 
      uomf.name AS ConvertFromUOMName,
      v.from_display_quantity AS ConvertFromUOMQty,
      uomc.name AS ConvertToUOMClass,
      uomt.name AS ConvertToUOMName,
      v.to_display_quantity AS ConvertToUOMQty
      from item_uom_conversion as v
      join Unit_Of_Measure as uomf
      on   v.from_uom_id = uomf.unit_of_measure_id
      join Unit_of_Measure as uomt
      on   v.to_uom_id = uomt.unit_of_measure_id
      join Unit_Of_Measure_Class as uomc
      on   uomc.unit_of_measure_class_id = uomt.unit_of_measure_class_id) as uomconv1
ON i.item_id = uomconv1.citem_id
AND uomconv1.RowNumber = 1

LEFT JOIN (SELECT ROW_NUMBER() over (partition by v.item_id order by uomc.name) AS RowNumber,
      v.item_id AS citem_id, 
      uomf.name AS ConvertFromUOMName,
      v.from_display_quantity AS ConvertFromUOMQty,
      uomc.name AS ConvertToUOMClass,
      uomt.name AS ConvertToUOMName,
      v.to_display_quantity AS ConvertToUOMQty
      from item_uom_conversion as v
      join Unit_Of_Measure as uomf
      on   v.from_uom_id = uomf.unit_of_measure_id
      join Unit_of_Measure as uomt
      on   v.to_uom_id = uomt.unit_of_measure_id
      join Unit_Of_Measure_Class as uomc
      on   uomc.unit_of_measure_class_id = uomt.unit_of_measure_class_id) as uomconv2
ON i.item_id = uomconv2.citem_id
AND uomconv2.RowNumber = 2

LEFT JOIN Retail_Item as ri
ON i.item_id = ri.retail_item_id
LEFT JOIN Merch_Group AS mg
ON ri.merch_group_id = mg.merch_group_id
LEFT JOIN Manufacturer as m 
ON ii.manufacturer_id = m.manufacturer_id
LEFT JOIN Unit_of_Measure AS dauom 
ON ii.default_adjustment_uom_id = dauom.unit_of_measure_id
LEFT JOIN Unit_of_Measure AS dtuom 
ON ii.default_transfer_uom_id = dtuom.unit_of_measure_id
LEFT JOIN Unit_of_Measure AS sluom 
ON ri.shelf_label_uom_id = sluom.unit_of_measure_id
LEFT JOIN Retail_Modified_Item AS rmi
ON ri.retail_item_id = rmi.retail_item_id
LEFT JOIN Merch_Group_Member AS mgm
ON rmi.merch_group_id = mgm.merch_group_id
AND rmi.merch_group_member_id = mgm.merch_group_member_id
LEFT JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id

LEFT JOIN Merch_Level as ml
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
AND ml.default_ranking = 999

LEFT JOIN Merch_Retail_Change AS mrc
ON mrc.retail_modified_item_id = rmi.retail_modified_item_id
AND mrc.merch_level_id = ml.merch_level_id
AND mrc.start_date <= @Today
AND mrc.end_date >= @Today
AND mrc.promo_flag = 'n'
AND mrc.change_type_code in ('a','c')

LEFT JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
LEFT JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id
LEFT JOIN #rmi_barcode AS rmibcl 
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id


WHERE --i.name not like '%inactive%'
--AND ii.active_flag = 'y'
--i.purge_flag ='n'
--AND i.item_type_code = 'i'
--AND 
ri.retail_item_type_code in ('n','g')
--AND SUBSTRING(i.name, 1, 2) <> 'z-'
--AND SUBString(i.name, 1, 3) <> 'i/a'
AND ml.default_ranking = 999
AND mrc.start_date <= GETDATE()
AND mrc.promo_flag = 'n'
AND CASE WHEN ISNUMERIC(i.xref_code) = 1
		   AND LEN(i.xref_code) < 9
		   AND LEFT(i.xref_code, 1) NOT IN ('0')
		   AND i.xref_code NOT LIKE '%[^0-9]%' 
		    THEN CONVERT(int, i.xref_code)
		   ELSE	0
	END	BETWEEN 10000 AND 99999999
AND ihl.hierarchy_level = 3
AND ihl.parent_hierarchy_level = 1
AND ihl.parent_item_hierarchy_id = @DepartmentId
AND i.item_id % @Modulus = @Remainder

DELETE #item_extract
WHERE SoldAs = 'y'
AND NOT EXISTS (SELECT 1 
         FROM retail_modified_item AS rmi
         WHERE rmi.retail_item_id = item_id)


SELECT --TOP 10
 ItemExternalID,
 CASE WHEN ItemRowNumber = 1 THEN PurgeFlag ELSE '' END AS PurgeFlag,
 CASE WHEN ItemRowNumber = 1 THEN RTRIM(REPLACE(ItemName,',','~')) ELSE '' END AS ItemName,
 CASE WHEN ItemRowNumber = 1 THEN REPLACE(ItemDescription,',','~') ELSE '' END AS ItemDescription,
 CASE WHEN ItemRowNumber = 1 THEN SoldAs ELSE '' END AS SoldAs,
 CASE WHEN ItemRowNumber = 1 THEN RTRIM(REPLACE(Category,',','~')) ELSE '' END AS Category,
 CASE WHEN ItemRowNumber = 1 THEN BaseUOMClass ELSE '' END AS BaseUOMClass, 
 CASE WHEN ItemRowNumber = 1 THEN ReportedInUOM ELSE '' END AS ReportedInUOM,
 CASE WHEN ItemRowNumber = 1 THEN REPLACE(Manufacturer,',','~') ELSE '' END AS Manufacturer, 
 CASE WHEN ItemRowNumber = 1 THEN SKUNumber ELSE '' END AS SKUNumber, 
 CASE WHEN ItemRowNumber = 1 THEN Taxability ELSE '' END AS Taxabililty,
 CASE WHEN ItemRowNumber = 1 THEN Active ELSE '' END AS Active,
 CASE WHEN ItemRowNumber = 1 THEN Track ELSE '' END AS Track,
 CASE WHEN ItemRowNumber = 1 THEN ExpenseUponReceiving ELSE '' END AS ExpenseUponReceiving,
 CASE WHEN ItemRowNumber = 1 THEN AllowFractionalQuantities ELSE '' END AS AllowFractionalQuantities,
 CASE WHEN ItemRowNumber = 1 THEN SetVarianceToZero ELSE '' END AS SetVarianceToZero,
 CASE WHEN ItemRowNumber = 1 THEN WasteTolerance ELSE '' END AS WasteTolerance,
 CASE WHEN ItemRowNumber = 1 THEN MissingTolerance ELSE '' END MissingTolerance,
 CASE WHEN ItemRowNumber = 1 THEN DefaultAdjustmentUOM ELSE '' END DefaultAdjustmentUOM, 
 CASE WHEN ItemRowNumber = 1 THEN DefaultTransferUOM ELSE '' END DefaultTransferUOM,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertFromUOMName1,'') ELSE '' END ConvertFromUOMName1,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertFromUOMQty1,'') ELSE '' END ConvertFromUOMQty1,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMClass1,'') ELSE '' END ConvertToUOMClass1,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMName1,'') ELSE '' END ConvertToUOMName1,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMQty1,'') ELSE '' END ConvertToUOMQty1,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertFromUOMName2,'') ELSE '' END ConvertFromUOMName2,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertFromUOMQty2,'') ELSE '' END ConvertFromUOMQty2,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMClass2,'') ELSE '' END ConvertToUOMClass2,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMName2,'') ELSE '' END ConvertToUOMName2,
 CASE WHEN ItemRowNumber = 1 THEN ISNULL(ConvertToUOMQty2,'') ELSE '' END ConvertToUOMQty2,
 CASE WHEN ItemRowNumber = 1 THEN RetailStrategy ELSE '' END RetailStrategy,
 CASE WHEN ItemRowNumber = 1 THEN PromptForQtyAtPos ELSE '' END PrompForQtyAtPOS,
 CASE WHEN ItemRowNumber = 1 THEN AutoQueueShelfLabel ELSE '' END AutoQueueShelfLabel,
 CASE WHEN ItemRowNumber = 1 THEN RequiresSwipeAtPos ELSE '' END RequiresSwipeAtPos,
 CASE WHEN ItemRowNumber = 1 THEN CreditCategoryCode ELSE '' END CreditCategoryCode,
 CASE WHEN ItemRowNumber = 1 THEN ShelfLabelUOM ELSE '' END ShelfLabelUOM,
 PackName,
 PackQty,
 CASE WHEN PackRowNumber = 1 THEN RetailLevelGroup ELSE '' END RetailLevelGroup,
 CASE WHEN PackRowNumber = 1 THEN PackExternalId ELSE '' END PackExternalId,
 CASE WHEN PackRowNumber = 1 THEN ListPrice ELSE '' END ListPrice,
 BarcodeType,
 '_' + BarcodeNumber AS BarcodeNumber,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute1,'') ELSE '' END AS attribute1,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value1,'') ELSE '' END AS attribute_value1,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute2,'') ELSE '' END AS attribute2,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value2,'') ELSE '' END AS attribute_value2,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute3,'') ELSE '' END AS attribute3,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value3,'') ELSE '' END AS attribute_value3,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute4,'') ELSE '' END AS attribute4,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value4,'') ELSE '' END AS attribute_value4,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute5,'') ELSE '' END AS attribute5,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value5,'') ELSE '' END AS attribute_value5,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute6,'') ELSE '' END AS attribute6,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value6,'') ELSE '' END AS attribute_value6,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute7,'') ELSE '' END AS attribute7,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value7,'') ELSE '' END AS attribute_value7,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute8,'') ELSE '' END AS attribute8,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value8,'') ELSE '' END AS attribute_value8,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute9,'') ELSE '' END AS attribute9,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value9,'') ELSE '' END AS attribute_value9,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute10,'') ELSE '' END AS attribute10,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value10,'') ELSE '' END AS attribute_value10,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute11,'') ELSE '' END AS attribute11,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value11,'') ELSE '' END AS attribute_value11,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute12,'') ELSE '' END AS attribute12,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value12,'') ELSE '' END AS attribute_value12,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute13,'') ELSE '' END AS attribute13,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value13,'') ELSE '' END AS attribute_value13,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute14,'') ELSE '' END AS attribute14,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value14,'') ELSE '' END AS attribute_value14,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute15,'') ELSE '' END AS attribute15,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value15,'') ELSE '' END AS attribute_value15,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute16,'') ELSE '' END AS attribute16,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value16,'') ELSE '' END AS attribute_value16,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute17,'') ELSE '' END AS attribute17,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value17,'') ELSE '' END AS attribute_value17,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute18,'') ELSE '' END AS attribute18,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value18,'') ELSE '' END AS attribute_value18,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute19,'') ELSE '' END AS attribute19,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value19,'') ELSE '' END AS attribute_value19,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute20,'') ELSE '' END AS attribute20,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value20,'') ELSE '' END AS attribute_value20,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute21,'') ELSE '' END AS attribute21,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value21,'') ELSE '' END AS attribute_value21,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute22,'') ELSE '' END AS attribute22,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value22,'') ELSE '' END AS attribute_value22,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute23,'') ELSE '' END AS attribute23,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value23,'') ELSE '' END AS attribute_value23,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute24,'') ELSE '' END AS attribute24,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value24,'') ELSE '' END AS attribute_value24,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute25,'') ELSE '' END AS attribute25,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value25,'') ELSE '' END AS attribute_value25,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute26,'') ELSE '' END AS attribute26,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value26,'') ELSE '' END AS attribute_value26,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute27,'') ELSE '' END AS attribute27,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value27,'') ELSE '' END AS attribute_value27,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute28,'') ELSE '' END AS attribute28,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value28,'') ELSE '' END AS attribute_value28,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute29,'') ELSE '' END AS attribute29,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value29,'') ELSE '' END AS attribute_value29,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute30,'') ELSE '' END AS attribute30,
CASE WHEN PackRowNumber = 1 THEN ISNULL(attribute_value30,'') ELSE '' END AS attribute_value30,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name1,'') ELSE '' END AS group_name1,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name2,'') ELSE '' END AS group_name2,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name3,'') ELSE '' END AS group_name3,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name4,'') ELSE '' END AS group_name4,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name5,'') ELSE '' END AS group_name5,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name6,'') ELSE '' END AS group_name6,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name7,'') ELSE '' END AS group_name7,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name8,'') ELSE '' END AS group_name8,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name9,'') ELSE '' END AS group_name9,
CASE WHEN ItemRowNumber = 1 THEN ISNULL(group_name10,'') ELSE '' END AS group_name10

FROM #item_extract 
LEFT JOIN bc_extract_rmi_attribute AS a
ON #item_extract.RetailModifiedItemId = a.retail_modified_item_id

LEFT JOIN bc_extract_item_group AS g
ON #item_extract.Item_id = g.item_id

ORDER by item_id, ItemRowNumber, RetailModifiedItemId, PackRowNumber, BarcodeCompressible DESC

IF OBJECT_ID('tempdb..#item_extract') IS NOT NULL
    DROP TABLE #item_extract
GO

IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO
 

