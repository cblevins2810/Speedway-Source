SET NOCOUNT ON

IF OBJECT_ID('tempdb..#assigned_nodes') IS NOT NULL
    DROP TABLE #assigned_nodes
GO

SELECT ihl.parent_item_hierarchy_id AS 'item_hierarchy_id'
INTO #assigned_nodes
FROM item_hierarchy_list AS ihl
WHERE EXISTS (SELECT 1
			FROM item AS i
            WHERE i.item_hierarchy_id = ihl.item_hierarchy_id
			--AND i.purge_flag ='n'
			AND i.item_type_code = 'i'
			AND CASE WHEN ISNUMERIC(i.xref_code) = 1
				AND LEN(i.xref_code) < 9
				AND LEFT(i.xref_code, 1) NOT IN ('0')
				AND i.xref_code NOT LIKE '%[^0-9]%' 
				THEN CONVERT(int, i.xref_code)
			ELSE	0
			END	BETWEEN 10000 AND 99999999)
OR EXISTS 	(SELECT 1
			FROM item AS i
            WHERE i.item_hierarchy_id = ihl.item_hierarchy_id
			--AND i.purge_flag ='n'
			AND i.item_type_code != 'i')

UNION			
SELECT DISTINCT i.item_hierarchy_id
FROM item AS i
WHERE --i.purge_flag ='n'
--AND
 i.item_type_code = 'i'
AND CASE WHEN ISNUMERIC(i.xref_code) = 1
AND LEN(i.xref_code) < 9
AND LEFT(i.xref_code, 1) NOT IN ('0')
AND i.xref_code NOT LIKE '%[^0-9]%' 
THEN CONVERT(int, i.xref_code)
ELSE	0
END	BETWEEN 10000 AND 99999999
UNION			
SELECT DISTINCT i.item_hierarchy_id
FROM item AS i
WHERE --i.purge_flag ='n'
--AND 
i.item_type_code != 'i'


SELECT REPLACE(REPLACE(RTRIM(ihc.name), ',','~'),'''','|') AS ExternalId, 
REPLACE(REPLACE(RTRIM(ihc.name), ',','~'),'''','|') AS CategoryName,
ihc.hierarchy_level AS CategoryLevel,
REPLACE(REPLACE(RTRIM(ihp.name),',','~'),'''','|') AS ParentCategoryExternalId,
ihc.non_taxable_flag
FROM item_hierarchy AS ihc
LEFT JOIN item_hierarchy AS ihp
ON ihc.parent_item_hierarchy_id = ihp.item_hierarchy_id
WHERE ihc.purge_flag = 'n'
AND EXISTS (SELECT 1
			FROM #assigned_nodes AS an
			WHERE ihc.item_hierarchy_id = an.item_hierarchy_id
			UNION
			SELECT 1
			FROM #assigned_nodes AS an
			WHERE ihp.item_hierarchy_id = an.item_hierarchy_id )
ORDER BY ihc.hierarchy_level

IF OBJECT_ID('tempdb..#assigned_nodes') IS NOT NULL
    DROP TABLE #assigned_nodes
GO
