IF OBJECT_ID('bc_extract_retail_strategy_from_eso') IS NOT NULL
	DROP TABLE bc_extract_retail_strategy_from_eso
GO

CREATE TABLE bc_extract_retail_strategy_from_eso(
	[mg_name] [nvarchar](50) NOT NULL,
	[mgm_name] [nvarchar](50) NOT NULL,
	[rmi_xref_code] [nvarchar](255) NOT NULL
) 

GO

INSERT bc_extract_retail_strategy_from_eso(
mg_name,
mgm_name,
rmi_xref_code
) 

SELECT mg.name,
mgm.name,
rmi.xref_code
FROM retail_modified_item AS rmi
JOIN merch_group AS mg
ON   rmi.merch_group_id = mg.merch_group_id
JOIN Merch_Group_Member AS mgm
ON   rmi.merch_group_id = mgm.merch_group_id
AND  rmi.merch_group_member_id = mgm.merch_group_member_id
WHERE rmi.xref_code IS NOT NULL






