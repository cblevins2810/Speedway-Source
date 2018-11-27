SET NOCOUNT ON

SET NOCOUNT ON

DECLARE @AlcoholDepartmentId INT
SELECT @AlcoholDepartmentId = item_hierarchy_id
FROM item_hierarchy WHERE name = '401 Beer & Wine' --@DepartmentName

DECLARE @CigaretteDepartmentId INT
SELECT @CigaretteDepartmentId = item_hierarchy_id
FROM item_hierarchy WHERE name = '501 Cigarettes' --@DepartmentName

DELETE bc_extract_bu_price_change_item
INSERT bc_extract_bu_price_change_item

SELECT DISTINCT i.item_id, i.name
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
LEFT JOIN Merch_Retail_Change AS mrc
ON mrc.retail_modified_item_id = rmi.retail_modified_item_id
AND mrc.merch_level_id = ml.merch_level_id
JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id
WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
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
AND ihl.parent_item_hierarchy_id IN (@AlcoholDepartmentId, @CigaretteDepartmentId)