IF OBJECT_ID('bc_extract_retail_level_from_eso') IS NOT NULL
	DROP TABLE bc_extract_retail_level_from_eso
GO

CREATE TABLE bc_extract_retail_level_from_eso(
	[mg_name] [nvarchar](50) NOT NULL,
	[mgm_name] [nvarchar](50) NOT NULL,
	[ml_name] [nvarchar](50) NOT NULL
) 

GO

INSERT bc_extract_retail_level_from_eso(
mg_name,
mgm_name,
ml_name
) 

SELECT mg.name,
mgm.name,
ml.name
FROM  merch_group AS mg
JOIN Merch_Group_Member AS mgm
ON   mg.merch_group_id = mgm.merch_group_id
JOIN merch_level as ml
ON   ml.merch_group_id = mgm.merch_group_id
AND  ml.merch_group_member_id = mgm.merch_group_member_id
WHERE ml.default_ranking > 0






