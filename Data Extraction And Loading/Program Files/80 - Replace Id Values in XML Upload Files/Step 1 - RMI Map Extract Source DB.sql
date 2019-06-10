/* After completing this script, extract the data from the table using SQL Server Management Studio */


IF OBJECT_ID('bcssa_custom_integration..bc_extract_rmi_bc_eso_map') IS NOT NULL
   DROP TABLE bcssa_custom_integration..bc_extract_rmi_bc_eso_map

GO


CREATE TABLE bcssa_custom_integration..bc_extract_rmi_bc_eso_map
(
	rmi_id_bc		INT NOT NULL,
	rmi_xref_code	NVARCHAR(255),
	rmi_id_eso		INT NOT NULL
)

INSERT INTO bcssa_custom_integration..bc_extract_rmi_bc_eso_map
		(
			rmi_id_bc,
			rmi_xref_code,
			rmi_id_eso
		)
SELECT DISTINCT 
		rmi.retail_modified_Item_id																	AS rmi_id_bc,
		COALESCE(i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)), 'None')	AS rmi_xref_code,
		0																							AS rmi_id_eso
FROM	item								AS	i
JOIN	retail_item							AS	ri
ON		i.item_id 							=	ri.retail_item_id
JOIN	retail_modified_item				AS	rmi
ON		ri.retail_item_id					=	rmi.retail_item_id
JOIN	retail_modified_item_dimension_list	AS	rmidl
ON		rmi.retail_modified_item_id			=	rmidl.retail_modified_item_id
JOIN	retail_item_dimension_member		AS	ridm
ON		rmidl.dimension_member_id			=	ridm.dimension_member_id
JOIN	unit_of_measure						AS	ridmuom
ON		ridm.unit_of_measure_id				=	ridmuom.unit_of_measure_id

WHERE	i.purge_flag				=	'n'
AND		i.item_type_code			=	'i'
AND		ri.retail_item_type_code	IN	('g')
AND		CASE
			WHEN	ISNUMERIC(i.xref_code) = 1
			AND		LEN(i.xref_code) < 9
			AND		LEFT(i.xref_code, 1) NOT IN ('0')
			AND		i.xref_code NOT LIKE '%[^0-9]%' 
			THEN	CONVERT(INT, i.xref_code)
			ELSE	0
		END
		BETWEEN 10000 AND 99999999
