DECLARE @NextId BIGINT
DECLARE @ClientId INT
DECLARE @TableId INT
DECLARE @GroupXrefCode NVARCHAR(255)

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE bc_extract_rmi_group 
SET name = REPLACE(name,'''''',''''),
description = REPLACE(description,'''''','''')

UPDATE bc_extract_rmi_group 
SET name = REPLACE(name,'~',','),
description = REPLACE(description,'~',',')

UPDATE  g
SET 	resolved_retail_modified_item_group_id = rmig.retail_modified_item_group_id
FROM 	bc_extract_rmi_group AS g
JOIN    retail_modified_item_group AS rmig
ON      g.name = rmig.name

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Retail_Modified_Item_Group'

WHILE EXISTS (SELECT 1 FROM bc_extract_rmi_group WHERE resolved_retail_modified_item_group_id IS NULL)

BEGIN

	SELECT @GroupXrefCode = MAX(group_xref_code)
	FROM bc_extract_rmi_group
	WHERE resolved_retail_modified_item_group_id IS NULL

	EXEC sp_get_next_ticket @TableId, 'n', 1, @NextId OUTPUT

	INSERT Retail_Modified_Item_Group	
	(retail_modified_item_group_id,
	name,
	active_flag, 
	purge_flag,
	description,
	cdm_owner_id,
	client_id,
	last_modified_user_id,
	last_modified_timestamp)
	SELECT @NextId,
	name,
	'y',
	'n',
	description,
	@ClientId,
	@ClientId,
	42,
	GETDATE()
	FROM bc_extract_rmi_group
	WHERE group_xref_code =  @GroupXrefCode

	UPDATE bc_extract_rmi_group
	SET resolved_retail_modified_item_group_id =  @NextId
	WHERE group_xref_code =  @GroupXrefCode

END



