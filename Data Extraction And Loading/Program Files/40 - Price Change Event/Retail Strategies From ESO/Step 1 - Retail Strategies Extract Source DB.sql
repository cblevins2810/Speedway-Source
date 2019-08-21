/*  
	Extract Retail Strategies from the ESO DB 
	August 2018
*/

IF OBJECT_ID('bc_extract_retail_strategy_from_eso') IS NOT NULL
  DROP TABLE bc_extract_retail_strategy_from_eso
GO
 
CREATE TABLE bc_extract_retail_strategy_from_eso
(mg_name NVARCHAR(50) NOT NULL,
 mgm_name NVARCHAR(50) NOT NULL,
 ml_name NVARCHAR(255) NOT NULL
)

IF OBJECT_ID('bc_extract_retail_strategy_item_from_eso') IS NOT NULL
  DROP TABLE bc_extract_retail_strategy_item_from_eso
GO
 
CREATE TABLE bc_extract_retail_strategy_item_from_eso
(mg_name NVARCHAR(50) NOT NULL,
 mgm_name NVARCHAR(50) NOT NULL,
 rmi_xref_code NVARCHAR(255) NOT NULL
)

INSERT bc_extract_retail_strategy_from_eso
(mg_name,
mgm_name,
ml_name
)
SELECT 
mg.name,
mgm.name,
ml.name
FROM Merch_Group as mg (NOLOCK)
JOIN Merch_Group_Member as mgm (NOLOCK)
ON mg.merch_group_id = mgm.merch_group_id
JOIN merch_level AS ml
ON   ml.merch_group_id = mgm.merch_group_id
AND  ml.merch_group_member_id = mgm.merch_group_member_id
WHERE ml.default_ranking > 0

INSERT bc_extract_retail_strategy_item_from_eso
(mg_name,
mgm_name,
rmi_xref_code
)
SELECT 
mg.name,
mgm.name,
rmi.xref_code
FROM Merch_Group as mg (NOLOCK)
JOIN Merch_Group_Member as mgm (NOLOCK)
ON mg.merch_group_id = mgm.merch_group_id
JOIN retail_modified_item AS rmi
ON  rmi.merch_group_id = mgm.merch_group_id
AND rmi.merch_group_member_id = mgm.merch_group_member_id
WHERE rmi.xref_code IS NOT NULL