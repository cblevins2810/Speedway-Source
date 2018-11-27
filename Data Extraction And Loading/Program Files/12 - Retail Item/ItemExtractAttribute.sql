SET NOCOUNT ON
IF OBJECT_ID('tempdb..#rmi_attribute') IS NOT NULL
    DROP TABLE #rmi_attribute
GO

SELECT rmi.retail_modified_item_id,
rmi.name AS rmi_name, 
ROW_NUMBER() over (partition by rmi.retail_modified_item_id ORDER by ria.name) AS Sequence,
REPLACE(ria.name,',','~') AS attribute,
REPLACE(riavl.value,',','~') AS value
INTO #rmi_attribute
FROM  Retail_Modified_Item_Attribute AS ria  
JOIN  Retail_Modified_Item_Attribute_RMI_List AS ril
ON     ril.retail_modified_item_attribute_id = ria.retail_modified_item_attribute_id
JOIN   Retail_Modified_Item_Attribute_Value_List AS riavl
ON riavl.value_id = ril.value_id
JOIN   Retail_Modified_Item AS rmi
ON rmi.retail_modified_item_id = ril.retail_modified_item_id
ORDER BY rmi.name, Sequence, ria.name, value

DELETE bc_extract_rmi_attribute
INSERT bc_extract_rmi_attribute (
retail_modified_item_id,
rmi_name,
attribute1,
attribute_value1)
SELECT retail_modified_item_id, 
rmi_name,
attribute,
value
FROM   #rmi_attribute
WHERE  sequence = 1

DECLARE @counter INT
DECLARE @sql NVARCHAR(MAX)

SET @counter = 2

WHILE @counter <= 30
BEGIN

	SET @sql = 'UPDATE t
				SET attribute' + CONVERT(NVARCHAR(2), @counter) + '= a.attribute, 
				attribute_value' + CONVERT(NVARCHAR(2), @counter) + '= a.value
				FROM bc_extract_rmi_attribute AS t
				JOIN #rmi_attribute AS a
				ON a.retail_modified_item_id = t.retail_modified_item_id
				WHERE a.sequence = ' + CONVERT(NVARCHAR(2), @counter)

	EXECUTE(@sql)
	SET @counter += 1
END

SELECT * FROM bc_extract_rmi_attribute

