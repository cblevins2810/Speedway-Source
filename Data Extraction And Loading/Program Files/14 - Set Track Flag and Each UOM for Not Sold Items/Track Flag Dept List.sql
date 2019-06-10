-- BC Prod
SELECT ihdept.name,
COUNT(*)
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
JOIN retail_item AS ri
ON i.item_id = ri.retail_item_id
WHERE i.item_type_code = 'i'
AND   i.purge_flag = 'n'
AND ri.retail_item_type_code in ('g','n')
AND CASE WHEN ISNUMERIC(i.xref_code) = 1
		   AND LEN(i.xref_code) < 9
		   AND LEFT(i.xref_code, 1) NOT IN ('0')
		   AND i.xref_code NOT LIKE '%[^0-9]%' 
		    THEN CONVERT(int, i.xref_code)
		   ELSE	0
	END	BETWEEN 10000 AND 99999999
AND ihdept.name IN ('201 Other Fast Food',
'206 Franchise Food',
'212 Hot Beverage',
'215 Cold Beverage',
'218 Hot Food',
'221 Sandwich',
'231 Fresh Bakery',
'76 Office Supplies',
'77 Store Supplies',
'94 M&S Food',
'95 M&S Petroleum')
GROUP BY ihdept.name
ORDER BY ihdept.name

-- BC Depts
SELECT ihdept.name,
COUNT(*)
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
AND ihl.hierarchy_level = 3
AND ihl.parent_hierarchy_level = 1
AND ihdept.name IN ('201 Other Fast Food',
'206 Franchise Food',
'212 Hot Beverage',
'215 Cold Beverage',
'218 Hot Food',
'221 Sandwich',
'231 Fresh Bakery',
'76 Office Supplies',
'77 Store Supplies',
'94 M&S Food',
'95 M&S Petroleum')
GROUP BY ihdept.name
ORDER BY ihdept.name

-- ESO Depts
SELECT ihdept.name,
COUNT(*)
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
GROUP BY ihdept.name
ORDER BY ihdept.name



