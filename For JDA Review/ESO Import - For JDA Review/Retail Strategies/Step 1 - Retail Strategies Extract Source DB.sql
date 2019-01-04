/*  
	Extract Retail Strategies from a Source DB 
	August 2018
	
	This script will create a de-normalized extract table and copy the strategy rows into it.
	The table can be scripted out and used to load the data into a destination system.
	
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
 resolved_merch_group_id INT NULL,
 resolved_merch_group_member_id INT NULL,
 resolved_merch_level_id INT NULL)
 
INSERT bc_extract_retail_strategy
(mg_name,
mg_retail_item_type_code,
mg_standard_flag,
mgm_name,
ml_name,
ml_default_ranking,
ml_high_margin,
ml_low_margin,
ml_target_margin)
SELECT 
mg.name,
mg.retail_item_type_code,
mg.standard_flag,
mgm.name,
ml.name,
ml.default_ranking,
ml.high_margin,
ml.low_margin,
ml.target_margin
FROM Merch_Group as mg
JOIN Merch_Group_Member as mgm
ON mg.merch_group_id = mgm.merch_group_id
JOIN Merch_Level as ml
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
WHERE ml.supplier_id IS NULL
AND EXISTS (SELECT 1 FROM retail_modified_item as rmi
            WHERE rmi.merch_group_id = mg.merch_group_id
            AND   rmi.merch_group_member_id = mgm.merch_group_member_id)
AND ml.default_ranking > 0

