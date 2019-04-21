BEGIN TRANSACTION

UPDATE 	ri
SET 	merch_group_id = repair.merch_group_id
FROM 	retail_item AS ri
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	ri.retail_item_id = repair.item_id
WHERE 	ri.merch_group_id <> repair.merch_group_id

SELECT  @@ROWCOUNT, 'Changed Strategies'

UPDATE 	rmi
SET 	merch_group_id = repair.merch_group_id,
		merch_group_member_id = repair.merch_group_member_id
FROM 	retail_modified_item AS rmi
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	rmi.retail_item_id = repair.item_id
AND  	rmi.retail_modified_item_id = repair.retail_modified_item_id
WHERE 	rmi.merch_group_id <> repair.merch_group_id
OR 		rmi.merch_group_member_id <> repair.merch_group_member_id

SELECT  @@ROWCOUNT, 'Changed Merch Groups'

UPDATE 	mrc
SET 	merch_level_id = repair.default_merch_level_id
FROM 	merch_retail_change AS mrc
JOIN 	retail_modified_item AS rmi
ON   	rmi.retail_modified_item_id = mrc.retail_modified_item_id
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	rmi.retail_modified_item_id = repair.retail_modified_item_id
AND  	rmi.merch_group_id = repair.merch_group_id
AND  	rmi.merch_group_member_id = repair.merch_group_member_id
WHERE   mrc.merch_level_id <> repair.default_merch_level_id

SELECT  @@ROWCOUNT, 'Changed Retail Levels'

ROLLBACK TRANSACTION




