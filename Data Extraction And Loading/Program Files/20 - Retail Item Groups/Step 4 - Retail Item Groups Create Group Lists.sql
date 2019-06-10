DECLARE @NextId BIGINT
DECLARE @ClientId INT
DECLARE @TableId INT
DECLARE @NumberOfTickets INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

-- Set the group id for the child groups
UPDATE 	gc
SET 	gc.resolved_retail_modified_item_group_id = g.resolved_retail_modified_item_group_id
FROM 	bc_extract_rmi_group_child AS gc
JOIN	bc_extract_rmi_group AS g
ON 		gc.group_xref_code = g.group_xref_code

-- Set the child group id 
UPDATE 	gc
SET 	gc.resolved_child_retail_modified_item_group_id = g.resolved_retail_modified_item_group_id
FROM 	bc_extract_rmi_group_child AS gc
JOIN	bc_extract_rmi_group AS g
ON 		gc.child_group_xref_code = g.group_xref_code

-- Set the group id for the item list
UPDATE 	gl
SET 	gl.resolved_retail_modified_item_group_id = g.resolved_retail_modified_item_group_id
FROM 	bc_extract_rmi_group_rmi_list AS gl
JOIN	bc_extract_rmi_group AS g
ON 		gl.group_xref_code = g.group_xref_code

-- Set the rmi id for the item list 
UPDATE  gl
SET 	gl.resolved_retail_modified_item_id = rmi.retail_modified_item_id
FROM    bc_extract_rmi_group_rmi_list AS gl
JOIN    retail_modified_item AS rmi
ON      gl.rmi_xref_code = rmi.xref_code

-- Add child groups that are not already present 
INSERT retail_modified_item_group_list (
retail_modified_item_group_id, 
retail_modified_item_group_child_id,
client_id, 
last_modified_user_id,
last_modified_timestamp)
SELECT gc.resolved_retail_modified_item_group_id,
gc.resolved_child_retail_modified_item_group_id,
@ClientId,
42,
GETDATE()   
FROM bc_extract_rmi_group_child AS gc
WHERE NOT EXISTS (	SELECT 	1
					FROM 	retail_modified_item_group_list AS rmigl
					WHERE   gc.resolved_retail_modified_item_group_id = rmigl.retail_modified_item_group_id
					AND     gc.resolved_child_retail_modified_item_group_id = rmigl.retail_modified_item_group_child_id)

-- Add retail modified items that are not already present
INSERT Retail_Modified_Item_Group_RMI_List
(retail_modified_item_group_id,
 retail_modified_item_id, 
 client_id,
 last_modified_user_id,
 last_modified_timestamp)
SELECT gl.resolved_retail_modified_item_group_id,
gl.resolved_retail_modified_item_id,
@ClientId,
42,
GETDATE()   
FROM bc_extract_rmi_group_rmi_list AS gl
WHERE NOT EXISTS (	SELECT 	1
					FROM 	Retail_Modified_Item_Group_RMI_List AS rmigrl
					WHERE	gl.resolved_retail_modified_item_group_id = rmigrl.retail_modified_item_group_id
					AND     gl.resolved_retail_modified_item_id = rmigrl.retail_modified_item_id)
AND		gl.resolved_retail_modified_item_id IS NOT NULL

-- Delete child groups that are no longer present 
DELETE rmigl
FROM retail_modified_item_group_list AS rmigl
WHERE NOT EXISTS (	SELECT 	1
					FROM 	bc_extract_rmi_group_child AS gc
					WHERE   gc.resolved_retail_modified_item_group_id = rmigl.retail_modified_item_group_id
					AND     gc.resolved_child_retail_modified_item_group_id = rmigl.retail_modified_item_group_child_id)

-- Delete retail modified items that are no longer present
DELETE rmigrl
FROM Retail_Modified_Item_Group_RMI_List AS rmigrl
WHERE NOT EXISTS (	SELECT 	1
					FROM 	bc_extract_rmi_group_rmi_list AS gl
					WHERE	gl.resolved_retail_modified_item_group_id = rmigrl.retail_modified_item_group_id
					AND     gl.resolved_retail_modified_item_id = rmigrl.retail_modified_item_id
					AND     gl.resolved_retail_modified_item_id IS NOT NULL)
				

