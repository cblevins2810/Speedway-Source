/* After completing this script, extract the data from the table using SQL Server Management Studio */
IF OBJECT_ID('bcssa_custom_integration..bc_extract_item_map') IS NOT NULL
   DROP TABLE bcssa_custom_integration..bc_extract_item_map

GO

CREATE TABLE bcssa_custom_integration..bc_extract_item_map
(
	source_item_id			INT NOT NULL,
	xref_code				NVARCHAR(255),
	dest_item_id			INT NULL
)

INSERT INTO bcssa_custom_integration..bc_extract_item_map
(
	source_item_id,
	xref_code
)
SELECT	i.item_id,
		i.xref_code	AS rmi_id_eso
FROM	item			AS	i
JOIN	retail_item		AS	ri
ON		i.item_id 		=	ri.retail_item_id

WHERE	i.purge_flag				=	'n'
AND		i.item_type_code			=	'i'
AND		ri.retail_item_type_code	IN	('n','g')
AND		CASE
			WHEN	ISNUMERIC(i.xref_code) = 1
			AND		LEN(i.xref_code) < 9
			AND		LEFT(i.xref_code, 1) NOT IN ('0')
			AND		i.xref_code NOT LIKE '%[^0-9]%' 
			THEN	CONVERT(INT, i.xref_code)
			ELSE	0
		END
		BETWEEN 10000 AND 99999999
AND EXISTS (SELECT 1
            FROM Item_DA_Effective_Date_List AS l
            WHERE l.item_id = i.item_id) 