DECLARE @NextId BIGINT
DECLARE @ClientId INT
DECLARE @TableId INT
DECLARE @NumberOfTickets INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

UPDATE bc_extract_rmi_group 
SET name = REPLACE(name,'''''',''''),
description = REPLACE(description,'''''','''')

UPDATE bc_extract_rmi_group 
SET name = REPLACE(name,'~',','),
description = REPLACE(description,'~',',')

DELETE Retail_Modified_Item_Group_RMI_List WHERE client_id = @ClientId
DELETE Retail_Modified_Item_Group_List WHERE client_id = @ClientId
DELETE Retail_Modified_Item_Group WHERE client_id = @ClientId

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Retail_Modified_Item_Group'

SELECT @NumberOfTickets = COUNT(*) FROM bc_extract_rmi_group

EXEC sp_get_next_ticket @TableId, 'n', @NumberOfTickets, @NextId OUTPUT

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
SELECT @NextId - group_id + 1,
name,
'y',
'n',
description,
@ClientId,
@ClientId,
42,
GETDATE()
FROM bc_extract_rmi_group

UPDATE bc_extract_rmi_group
SET resolved_retail_modified_item_group_id =  @NextId - group_id + 1

INSERT retail_modified_item_group_list (
retail_modified_item_group_id, 
retail_modified_item_group_child_id,
client_id, 
last_modified_user_id,
last_modified_timestamp)

SELECT rip.resolved_retail_modified_item_group_id,
ric.resolved_retail_modified_item_group_id,
@ClientId,
42,
GETDATE()   
FROM bc_extract_rmi_group_child AS rci
JOIN bc_extract_rmi_group AS rip
ON   rci.group_xref_code = rip.group_xref_code
JOIN bc_extract_rmi_group AS ric
ON   rci.child_group_xref_code = ric.group_xref_code

INSERT Retail_Modified_Item_Group_RMI_List
(retail_modified_item_group_id,
 retail_modified_item_id, 
 client_id,
 last_modified_user_id,
 last_modified_timestamp)

SELECT ri.resolved_retail_modified_item_group_id,
rmi.retail_modified_item_id,
@ClientId,
42,
GETDATE()   
FROM bc_extract_rmi_group_rmi_list AS rmii
JOIN bc_extract_rmi_group AS ri
ON   rmii.group_xref_code = ri.group_xref_code
JOIN retail_modified_item AS rmi
ON   rmii.rmi_xref_code = rmi.xref_code

