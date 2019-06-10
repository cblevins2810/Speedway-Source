BEGIN TRANSACTION

-- Resolve item_id values based upon imported repair values
UPDATE repair
SET    repair.item_id = i.item_id,
	   repair.isSold = CASE WHEN ri.retail_item_type_code <> 'n' THEN 'y' ELSE 'n' END
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   item AS i
ON     repair.itemXrefId = i.xref_code
JOIN   retail_item AS ri
ON     ri.retail_item_id = i.item_id

-- If there are any unknown items in the data, report them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE item_id IS NULL) > 0

BEGIN
	
	SELECT 'Missing Item', * FROM bc_extract_repair_manufacturer_and_strategy
	WHERE item_id IS NULL

END

ELSE
   SELECT COUNT(DISTINCT itemXrefId), 'Retail Items Verified' FROM bc_extract_repair_manufacturer_and_strategy
   WHERE isSold = 'y'
   UNION 
   SELECT COUNT(DISTINCT itemXrefId), 'Not Sold Items Verified' FROM bc_extract_repair_manufacturer_and_strategy
   WHERE isSold = 'n'

-- Resolve retail_modified_item_id values based upon imported repair values
UPDATE repair
SET    repair.retail_modified_item_id = rmi.retail_modified_item_id
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   retail_modified_item AS rmi
ON     repair.rmiXrefId = rmi.xref_code
AND    repair.item_id = rmi.retail_item_id
WHERE  isSold = 'y'

-- If there are any unknown items in the data, report them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE (retail_modified_item_id IS NULL AND isSold = 'y')) > 0

BEGIN
	
	SELECT 'Missing RMI', * FROM bc_extract_repair_manufacturer_and_strategy
	WHERE (retail_modified_item_id IS NULL AND isSold = 'y')

END

ELSE

   SELECT COUNT(DISTINCT rmiXrefId), 'RMI Items Verified' FROM bc_extract_repair_manufacturer_and_strategy
   	WHERE (retail_modified_item_id IS NOT NULL AND isSold ='y')

-- Resolve merch group id
UPDATE repair
SET    repair.merch_group_id = mg.merch_group_id
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   merch_group AS mg
ON     repair.itemStrategy = mg.name
WHERE  isSold = 'y'

-- If there are any unknown merch groups in the data, report them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE merch_group_id IS NULL AND isSold = 'y') > 0

BEGIN
	
	SELECT 'Missing Merch Group', *
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE merch_group_id IS NULL
	AND  isSold = 'y'

END

ELSE

   SELECT COUNT(DISTINCT merch_group_id), 'Strategies Verified' FROM bc_extract_repair_manufacturer_and_strategy
   WHERE isSold = 'y'

-- Resolve merch group member id
UPDATE repair
SET    repair.merch_group_member_id = mgm.merch_group_member_id
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   merch_group_member AS mgm
ON     repair.merch_group_id = mgm.merch_group_id
AND    repair.rmiMerchGroup = mgm.name
WHERE  repair.isSold = 'y'

-- If there are any unknown merch groups in the data, report them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE merch_group_member_id IS NULL AND isSold = 'y') > 0

BEGIN
	
	SELECT 'Missing Merch Group Member', *
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE (merch_group_member_id IS NULL AND isSold = 'y')

END

ELSE

   SELECT COUNT(DISTINCT merch_group_member_id), 'Merch Groups Verified' FROM bc_extract_repair_manufacturer_and_strategy
   WHERE  (rmiMerchGroup IS NOT NULL AND isSold = 'y')

-- Resolve default merch level id
UPDATE	repair
SET    	repair.default_merch_level_id = ml.merch_level_id
FROM   	bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   	merch_level AS ml
ON     	repair.merch_group_id = ml.merch_group_id
AND    	repair.merch_group_member_id = ml.merch_group_member_id
AND		ml.default_ranking = 999 
WHERE   repair.isSold = 'y'

-- If there are any unknown merch groups in the data, report them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE default_merch_level_id IS NULL AND isSold = 'y') > 0

BEGIN
	
	SELECT 'Missing Retail Level', *
	FROM   bc_extract_repair_manufacturer_and_strategy
	WHERE default_merch_level_id IS NULL
    AND   isSold = 'y'

END

ELSE

   SELECT COUNT(DISTINCT default_merch_level_id), 'Merch Levels Verified' FROM bc_extract_repair_manufacturer_and_strategy
   WHERE merch_group_member_id IS NOT NULL
   AND   default_merch_level_id IS NOT NULL
   AND   isSold = 'y'


SELECT * FROM  bc_extract_repair_manufacturer_and_strategy as r

ROLLBACK TRANSACTION







  
