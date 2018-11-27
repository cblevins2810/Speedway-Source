/* After completing this script, extract the data from the tables using SQL Server Management Studio */

IF OBJECT_ID('bc_extract_rmi_group') IS NOT NULL
   DROP TABLE bc_extract_rmi_group

IF OBJECT_ID('bc_extract_rmi_group_child') IS NOT NULL
    DROP TABLE bc_extract_rmi_group_child

IF OBJECT_ID('bc_extract_rmi_group_rmi_list') IS NOT NULL
    DROP TABLE bc_extract_rmi_group_rmi_list
GO

CREATE TABLE bc_extract_rmi_group
(group_id INT IDENTITY(1,1),
 group_xref_code nvarchar(255),
 name NVARCHAR(50),
 description NVARCHAR(255),
 resolved_retail_modified_item_group_id INT NULL)

CREATE TABLE bc_extract_rmi_group_child
(group_xref_code nvarchar(255), child_group_xref_code nvarchar(255))

CREATE TABLE bc_extract_rmi_group_rmi_list
(group_xref_code nvarchar(255), rmi_xref_code nvarchar(255))
GO

INSERT bc_extract_rmi_group (group_xref_code, name, description)
SELECT 'xref-' + CONVERT(NVARCHAR(15), retail_modified_item_group_id),
       REPLACE(REPLACE(RTRIM(name),',','~'), 'Chocolate', 'Choco') + 
       CASE WHEN CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) = 1 THEN '' 
       ELSE ' (' + CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) + ')' END,
       CASE WHEN descriptiON IS NULL  THEN NULL ELSE REPLACE(RTRIM(description),',','~') END
FROM retail_modified_item_group

INSERT bc_extract_rmi_group_child (group_xref_code, child_group_xref_code)
SELECT 'xref-' + CONVERT(NVARCHAR(15), retail_modified_item_group_id),
       'xref-' + CONVERT(NVARCHAR(15), retail_modified_item_group_child_id)
FROM retail_modified_item_group_list

INSERT bc_extract_rmi_group_rmi_list
(group_xref_code,
 rmi_xref_code)
SELECT 'xref-' + CONVERT(NVARCHAR(15), retail_modified_item_group_id),
rmi.rmi_xref_code
FROM retail_modified_item_group_rmi_list AS rmigrl
JOIN (SELECT DISTINCT 
rmi.retail_modified_Item_id,
i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)) AS rmi_xref_code
FROM Item AS i
JOIN Retail_Item as ri
ON i.item_id = ri.retail_item_id
JOIN Merch_Group AS mg
ON ri.merch_group_id = mg.merch_group_id
JOIN Retail_Modified_Item AS rmi
ON ri.retail_item_id = rmi.retail_item_id
JOIN Merch_Group_Member AS mgm
ON rmi.merch_group_id = mgm.merch_group_id
AND rmi.merch_group_member_id = mgm.merch_group_member_id
JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id
JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id

WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
AND ri.retail_item_type_code in ('g')
AND CASE WHEN ISNUMERIC(i.xref_code) = 1
		   AND LEN(i.xref_code) < 9
		   AND LEFT(i.xref_code, 1) NOT IN ('0')
		   AND i.xref_code NOT LIKE '%[^0-9]%' 
    	    THEN CONVERT(int, i.xref_code)
		   ELSE	0
	END	BETWEEN 10000 AND 99999999
) AS rmi

ON rmigrl.retail_modified_Item_id = rmi.retail_modified_Item_id

