SET NOCOUNT ON
IF OBJECT_ID('tempdb..#item_extract') IS NOT NULL
    DROP TABLE #item_extract
GO

IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO

CREATE TABLE #item_extract
(department_id int not null,
 batch_total int not null,
 batch_count int not null)

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley

CREATE TABLE #talley (batch_number int)
INSERT #talley SELECT 1
INSERT #talley SELECT 2    
INSERT #talley SELECT 3
INSERT #talley SELECT 4
INSERT #talley SELECT 5
INSERT #talley SELECT 6
INSERT #talley SELECT 7
INSERT #talley SELECT 8
INSERT #talley SELECT 9
INSERT #talley SELECT 10
INSERT #talley SELECT 11
INSERT #talley SELECT 12
INSERT #talley SELECT 13
INSERT #talley SELECT 14
INSERT #talley SELECT 15
INSERT #talley SELECT 16
INSERT #talley SELECT 17
INSERT #talley SELECT 18
INSERT #talley SELECT 19
INSERT #talley SELECT 20
INSERT #talley SELECT 21
INSERT #talley SELECT 22
INSERT #talley SELECT 23
INSERT #talley SELECT 24
INSERT #talley SELECT 25
INSERT #talley SELECT 26
INSERT #talley SELECT 27
INSERT #talley SELECT 28
INSERT #talley SELECT 29
INSERT #talley SELECT 30
INSERT #talley SELECT 31
INSERT #talley SELECT 32
INSERT #talley SELECT 33
INSERT #talley SELECT 34
INSERT #talley SELECT 35
INSERT #talley SELECT 36
INSERT #talley SELECT 37
INSERT #talley SELECT 38
INSERT #talley SELECT 39
INSERT #talley SELECT 40
INSERT #talley SELECT 41
INSERT #talley SELECT 42
INSERT #talley SELECT 43
INSERT #talley SELECT 44
INSERT #talley SELECT 45
INSERT #talley SELECT 46
INSERT #talley SELECT 47
INSERT #talley SELECT 48
INSERT #talley SELECT 49
INSERT #talley SELECT 50
 
SELECT rmi.retail_modified_item_id, bc.barcode_id
INTO #rmi_barcode
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
AND ri.retail_item_type_code in ('g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
 
INSERT #item_extract 
SELECT ihl.parent_item_hierarchy_id,
COUNT(*),
CEILING(COUNT(*)/2500)+1 
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
JOIN Retail_Modified_Item AS rmi
ON ri.retail_item_id = rmi.retail_item_id
JOIN Merch_Group_Member AS mgm
ON rmi.merch_group_id = mgm.merch_group_id
AND rmi.merch_group_member_id = mgm.merch_group_member_id
JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id
JOIN Merch_Level as ml
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
JOIN Merch_Retail_Change AS mrc
ON mrc.retail_modified_item_id = rmi.retail_modified_item_id
AND mrc.merch_level_id = ml.merch_level_id
JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id
LEFT JOIN #rmi_barcode AS rmibcl --Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
LEFT JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id

WHERE --i.purge_flag ='n'
--AND 
i.item_type_code = 'i'
AND ri.retail_item_type_code in ('g')
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
GROUP BY ihl.parent_item_hierarchy_id
ORDER BY 2 DESC

SELECT b.batch_count,
t.batch_number-1,
REPLACE(REPLACE(ih.name,'/',' '),',',' '),
CASE WHEN t.batch_number < 10 THEN '0' + CONVERT(NVARCHAR(1), t.batch_number) ELSE CONVERT(NVARCHAR(2), t.batch_number) END
FROM #item_extract as b
JOIN item_hierarchy as ih
ON   ih.item_hierarchy_id = b.department_id
JOIN #talley as t
ON   t.batch_number <= b.batch_count
ORDER BY b.batch_total DESC, t.batch_number

IF OBJECT_ID('tempdb..#item_extract') IS NOT NULL
    DROP TABLE #item_extract
GO

IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO
 
