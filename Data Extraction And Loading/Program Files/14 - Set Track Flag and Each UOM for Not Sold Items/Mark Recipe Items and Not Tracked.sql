BEGIN TRANSACTION

UPDATE i
SET track_flag = 'n'
FROM Item AS i
WHERE EXISTS (SELECT 1 FROM recipe_item AS r
              WHERE r.recipe_item_id = i.item_id)

DELETE i
FROM Inventory_Item_Count_UOM_List AS i
WHERE EXISTS (SELECT 1 FROM recipe_item AS r
              WHERE r.recipe_item_id = i.inventory_item_id)

COMMIT TRANSACTION
