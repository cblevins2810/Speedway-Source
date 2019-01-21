/*
Step 1 - Create a table to hold the item to manufacturer association.
*/
IF OBJECT_ID('bc_extract_item_manufacturer') IS NOT NULL
  DROP TABLE bc_extract_item_manufacturer
GO

SELECT i.xref_code, m.name as manufacturer_name
INTO   bc_extract_item_manufacturer
FROM   item AS i
JOIN   inventory_item AS ii
ON     i.item_id = ii.inventory_item_id
JOIN   Manufacturer as m
ON     ii.manufacturer_id = m.manufacturer_id
WHERE  xref_code IS NOT NULL
