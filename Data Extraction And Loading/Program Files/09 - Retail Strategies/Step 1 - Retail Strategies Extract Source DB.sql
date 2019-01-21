/*  
	Extract Retail Strategies from a Source DB 
	August 2018
	
	This script will create a de-normalized extract table and copy the strategy rows into it.
	The table can be scripted out and used to load the data into a destination system.
	
	January 2019 - Amended code to remove retail strategies related to unused levels
*/


IF OBJECT_ID('bc_extract_retail_strategy') IS NOT NULL
  DROP TABLE bc_extract_retail_strategy
GO

CREATE TABLE bc_extract_retail_strategy
(mg_name NVARCHAR(50) NOT NULL,
 mg_retail_item_type_code NVARCHAR(1) NOT NULL,
 mg_standard_flag NVARCHAR(1) NOT NULL,
 mgm_name NVARCHAR(50) NOT NULL,
 ml_name NVARCHAR(50) NOT NULL,
 ml_default_ranking int NOT NULL,
 ml_high_margin smallmoney NOT NULL,
 ml_low_margin smallmoney NOT NULL,
 ml_target_margin smallmoney NOT NULL,
-- Added these 3 columns (will be used for price events)
 orig_merch_group_id INT NULL,
 orig_merch_group_member_id INT NULL,
 orig_merch_level_id INT NULL,
-- End additional columns
 resolved_merch_group_id INT NULL,
 resolved_merch_group_member_id INT NULL,
 resolved_merch_level_id INT NULL)

-- Added to support check for valid (used) levels
DECLARE @ValidLevels TABLE (Merch_Level_Id INT)

INSERT @ValidLevels (Merch_Level_id)
SELECT DISTINCT	Merch_Level_Id 
FROM merch_bu_rmi_retail_list AS l
JOIN business_unit AS bu
ON l.business_unit_id = bu.business_unit_id
WHERE bu.status_code != 'c'
-- End additional code
 
 
-- Insert the rows for the default ranking (999) if the merch group and merch group member are in use by a retail modified item
-- We must always have at least the default ranking if the merch group and merch group member are in use
INSERT bc_extract_retail_strategy
(mg_name,
mg_retail_item_type_code,
mg_standard_flag,
mgm_name,
ml_name,
ml_default_ranking,
ml_high_margin,
ml_low_margin,
ml_target_margin,
-- Added these 3 columns (will be used for price events)
orig_merch_group_id,
orig_merch_group_member_id,
orig_merch_level_id
-- End additional columns
)
SELECT 
mg.name,
mg.retail_item_type_code,
mg.standard_flag,
mgm.name,
ml.name,
ml.default_ranking,
ml.high_margin,
ml.low_margin,
ml.target_margin,
-- Added these 3 columns (will be used for price events)
mg.merch_group_id,
mgm.merch_group_member_id,
ml.merch_level_id
-- End additional columns
FROM Merch_Group as mg
JOIN Merch_Group_Member as mgm
ON mg.merch_group_id = mgm.merch_group_id
JOIN Merch_Level as ml
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
WHERE EXISTS (SELECT 1
			  FROM	retail_modified_item as rmi
			  WHERE	rmi.merch_group_id = mg.merch_group_id
			  AND	rmi.merch_group_member_id = mgm.merch_group_member_id)
AND ml.default_ranking = 999

-- Insert the Levels that are in use by an open business unit that are not the default (between 1 and 998)
INSERT bc_extract_retail_strategy
(mg_name,
mg_retail_item_type_code,
mg_standard_flag,
mgm_name,
ml_name,
ml_default_ranking,
ml_high_margin,
ml_low_margin,
ml_target_margin,
-- Added these 3 columns (will be used for price events)
orig_merch_group_id,
orig_merch_group_member_id,
orig_merch_level_id
-- End additional columns
)
SELECT 
mg.name,
mg.retail_item_type_code,
mg.standard_flag,
mgm.name,
ml.name,
ml.default_ranking,
ml.high_margin,
ml.low_margin,
ml.target_margin,
-- Added these 3 columns (will be used for price events)
mg.merch_group_id,
mgm.merch_group_member_id,
ml.merch_level_id
-- End additional columns
FROM Merch_Group as mg
JOIN Merch_Group_Member as mgm
ON mg.merch_group_id = mgm.merch_group_id
JOIN Merch_Level as ml
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
-- Added this check for valid levels
JOIN @ValidLevels AS vl
ON   ml.merch_level_id = vl.merch_level_id
-- End additional code
WHERE ml.default_ranking > 0
AND   ml.default_Ranking < 999
AND   ml.supplier_id IS NULL



