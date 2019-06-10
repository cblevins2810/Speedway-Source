BEGIN TRANSACTION

UPDATE 	repair
SET    	prior_merch_group_id = ri.merch_group_id
FROM  	bc_extract_repair_manufacturer_and_strategy AS repair
JOIN    retail_item AS ri
ON   	ri.retail_item_id = repair.item_id
WHERE   repair.isSold = 'y'

UPDATE 	ri
SET 	merch_group_id = repair.merch_group_id
FROM 	retail_item AS ri
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	ri.retail_item_id = repair.item_id
WHERE 	ri.merch_group_id <> repair.merch_group_id
AND     repair.isSold = 'y'

SELECT  @@ROWCOUNT, 'Changed Strategies'

UPDATE 	repair
SET 	prior_merch_group_member_id = rmi.merch_group_member_id
FROM  	bc_extract_repair_manufacturer_and_strategy AS repair
JOIN    retail_modified_item AS rmi
ON   	rmi.retail_item_id = repair.item_id
AND  	rmi.retail_modified_item_id = repair.retail_modified_item_id
AND     repair.isSold = 'y'

/*
SELECT * FROM retail_item WHERE retail_item_id = 50057565
SELECT * FROM retail_modified_item where retail_modified_item_id = 50033245
SELECT * FROM merch_group WHERE merch_group_id = 1000104
SELECT * FROM merch_group_member WHERE merch_group_id = 1000104 and merch_group_member_id = 1000122
SELECT * FROM merch_retail_change where retail_modified_item_id = 50033245
SELECT * FROM merch_level where merch_level_id = 1000454
*/

UPDATE 	rmi
SET 	merch_group_id = repair.merch_group_id,
		merch_group_member_id = repair.merch_group_member_id
FROM 	retail_modified_item AS rmi
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	rmi.retail_item_id = repair.item_id
AND  	rmi.retail_modified_item_id = repair.retail_modified_item_id
WHERE 	(rmi.merch_group_id <> repair.merch_group_id
OR 		rmi.merch_group_member_id <> repair.merch_group_member_id)
AND     repair.isSold = 'y'

SELECT  @@ROWCOUNT, 'Changed Merch Groups'

UPDATE 	repair
SET     prior_default_merch_level_id = mrc.merch_level_id
FROM  	bc_extract_repair_manufacturer_and_strategy AS repair
JOIN 	merch_retail_change AS mrc
ON   	repair.retail_modified_item_id = repair.retail_modified_item_id
JOIN    merch_level AS ml
ON      ml.merch_group_id = repair.prior_merch_group_id
AND     ml.merch_group_member_id = repair.prior_merch_group_member_id
AND  	ml.default_ranking = 999
WHERE   repair.isSold = 'y'

UPDATE 	mrc
SET 	merch_level_id = repair.default_merch_level_id
FROM 	merch_retail_change AS mrc
JOIN 	bc_extract_repair_manufacturer_and_strategy AS repair
ON   	mrc.retail_modified_item_id = repair.retail_modified_item_id
JOIN    merch_level AS ml
ON      ml.merch_group_id = repair.merch_group_id
AND     ml.merch_group_member_id = repair.merch_group_member_id
AND  	ml.default_ranking = 999
WHERE   mrc.merch_level_id <> repair.default_merch_level_id
AND     repair.isSold = 'y'

SELECT  @@ROWCOUNT, 'Changed Retail Levels'

SELECT * FROM bc_extract_repair_manufacturer_and_strategy
WHERE isSold = 'y'

ROLLBACK TRANSACTION




