BEGIN TRANSACTION

DECLARE @ItemGroupId INT

SELECT	@ItemGroupId	= item_group_id
FROM	inventory_item_group
WHERE	name = 'Transfer Group'

SELECT @ItemGroupId

DELETE iigl
FROM   inventory_item_group_list AS iigl
WHERE  iigl.item_group_id = @ItemGroupId
AND    EXISTS (SELECT 1 FROM recipe_item AS ri
               WHERE  iigl.inventory_item_id = ri.recipe_item_id)

ROLLBACK TRANSACTION