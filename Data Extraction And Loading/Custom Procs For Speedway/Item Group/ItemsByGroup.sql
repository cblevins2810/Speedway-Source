DECLARE @ItemGroupName NVARCHAR(50)

SET @ItemGroupName = 'McLane Critical'

SELECT
g.name AS GroupName, 
gl.inventory_item_id AS ItemInteralId,
i.xref_code AS ItemExternalId,
i.name AS ItemName
FROM  inventory_item_group as g
JOIN  inventory_item_group_list as gl
ON    g.item_group_id = gl.item_group_id
JOIN  item AS i
ON    i.item_id = gl.inventory_item_id
WHERE g.name like ('%' + @ItemGroupName + '%') 
AND   i.purge_flag = 'n'
AND   i.item_type_code = 'i'
AND   i.xref_code IS NOT NULL
ORDER BY i.xref_code

