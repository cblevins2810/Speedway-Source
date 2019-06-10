-- Added to support the export/import of item groups for retail items

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#item_group') IS NOT NULL
    DROP TABLE #item_group
GO


SELECT
gl.inventory_item_id AS item_id,
g.name AS group_name, 
ROW_NUMBER() over (partition by inventory_item_id ORDER by g.name) AS Sequence
INTO #item_group
FROM inventory_item_group as g
JOIN inventory_item_group_list as gl
ON   g.item_group_id = gl.item_group_id
WHERE g.name in (
'SCM EBY Aurora & McLane [Without Food Supplies]',
'SCM Eby Aurora',
'Week 3 Deli Case PHO Gift Card Item Group',
'SCM Coca Cola Products',
'SCM Pepsi G&J',
'SCM Coca Cola Products less 12z and 2L',
'SCM - 501 Cigs Authorized',
'SCM Marlboro Loyalty 2019',
'SCM-Cold cups & lids',
'SCM-Hot cups & lids',
'601 All items',
'Transfer Group'
)
ORDER BY gl.inventory_item_id, Sequence


-- The table bcssa_custom_integration..bc_extract_item_group is created through ItemExtractGroupCreateTable.sql
-- which will be executed prior to this code
-- Clear the table first
DELETE bcssa_custom_integration..bc_extract_item_group

-- Need at least one group otherwise there should be no entry for the item (some items are not in any group)
INSERT bcssa_custom_integration..bc_extract_item_group
(
item_id,
group_name1
)
SELECT item_id, 
group_name
FROM   #item_group
WHERE  sequence = 1


-- Use dynamic SQL to build updates for the remaining 9 potential groups

DECLARE @counter INT
DECLARE @sql NVARCHAR(MAX)

SET @counter = 2

WHILE @counter <= 9
BEGIN
	SET @sql = 'UPDATE g
		SET g.group_name' + CONVERT(NVARCHAR(2), @counter) + ' = ig.group_name
		FROM bcssa_custom_integration..bc_extract_item_group AS g
		JOIN #item_group AS ig
		ON g.item_id = ig.item_id
		WHERE ig.sequence = ' + CONVERT(NVARCHAR(2), @counter)
	EXECUTE(@sql)
	SET @counter += 1
END

