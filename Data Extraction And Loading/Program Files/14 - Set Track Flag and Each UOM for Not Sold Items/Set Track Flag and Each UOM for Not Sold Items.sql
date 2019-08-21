DECLARE @NotTrackedItems TABLE (item_id INT NOT NULL)

INSERT @NotTrackedItems
SELECT i.item_id
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
WHERE i.item_type_code = 'i'
AND i.track_flag = 'n'
AND ihl.hierarchy_level = 3
AND ihl.parent_hierarchy_level = 1
AND ihdept.name IN ('201 Alternative Food Service',
'206 Franchise Food',
'212 Hot Beverage',
'215 Cold Beverage',
'218 Pre-Packaged Food Service',
'221 Prepared Food Service',
'231 Food Service Bakery',
'76 Office Supplies',
'77 Store Supplies',
'94 M&S Food',
'95 M&S Petroleum')
AND NOT  EXISTS (SELECT 1 FROM recipe_item AS r
				WHERE r.recipe_item_id = i.item_id)

INSERT Inventory_Item_Count_UOM_List (
inventory_item_id,
unit_of_measure_id, 
cdm_owner_id,
client_id,
purge_flag,
sort_order,
last_modified_user_id,
last_modified_timestamp )
SELECT ii.inventory_item_id,
5,
ii.client_id,
i.cdm_owner_id,
'n',
0,
42,
GETDATE()
FROM  inventory_item AS ii
JOIN  @NotTrackedItems AS nt
ON    ii.inventory_item_id = nt.item_id
JOIN  item AS i
ON    nt.item_id = i.item_id
WHERE NOT EXISTS (SELECT 1
                  FROM Inventory_Item_Count_UOM_List AS iicul
				  WHERE ii.inventory_item_id = iicul.inventory_item_id
				  AND   iicul.unit_of_measure_id = 3)
AND i.unit_of_measure_class_id = 1
AND NOT  EXISTS (SELECT 1 FROM recipe_item AS r
				WHERE r.recipe_item_id = ii.inventory_item_id)

INSERT Inventory_Item_Count_UOM_List (
inventory_item_id,
unit_of_measure_id, 
cdm_owner_id,
client_id,
purge_flag,
sort_order,
last_modified_user_id,
last_modified_timestamp )
SELECT ii.inventory_item_id,
4,
ii.client_id,
i.cdm_owner_id,
'n',
0,
42,
GETDATE()
FROM  inventory_item AS ii
JOIN  @NotTrackedItems AS nt
ON    ii.inventory_item_id = nt.item_id
JOIN  item AS i
ON    nt.item_id = i.item_id
WHERE NOT EXISTS (SELECT 1
                  FROM Inventory_Item_Count_UOM_List AS iicul
				  WHERE ii.inventory_item_id = iicul.inventory_item_id
				  AND   iicul.unit_of_measure_id = 3)
AND i.unit_of_measure_class_id = 2
AND NOT  EXISTS (SELECT 1 FROM recipe_item AS r
				WHERE r.recipe_item_id = ii.inventory_item_id)
INSERT Inventory_Item_Count_UOM_List (
inventory_item_id,
unit_of_measure_id, 
cdm_owner_id,
client_id,
purge_flag,
sort_order,
last_modified_user_id,
last_modified_timestamp )
SELECT ii.inventory_item_id,
3,
ii.client_id,
i.cdm_owner_id,
'n',
0,
42,
GETDATE()
FROM  inventory_item AS ii
JOIN  @NotTrackedItems AS nt
ON    ii.inventory_item_id = nt.item_id
JOIN  item AS i
ON    nt.item_id = i.item_id
WHERE NOT EXISTS (SELECT 1
                  FROM Inventory_Item_Count_UOM_List AS iicul
				  WHERE ii.inventory_item_id = iicul.inventory_item_id
				  AND   iicul.unit_of_measure_id = 3)
AND i.unit_of_measure_class_id = 3
AND NOT  EXISTS (SELECT 1 FROM recipe_item AS r
				WHERE r.recipe_item_id = ii.inventory_item_id)
UPDATE i
SET track_flag = 'y'
FROM item AS i
JOIN  @NotTrackedItems AS nt
ON    i.item_id = nt.item_id
WHERE track_flag = 'n'

