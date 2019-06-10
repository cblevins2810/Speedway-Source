-- Added to support the export/import of item groups for retail items

IF OBJECT_ID('bcssa_custom_integration..bc_extract_item_group') IS NOT NULL
	DROP TABLE bcssa_custom_integration..bc_extract_item_group

CREATE TABLE bcssa_custom_integration..bc_extract_item_group (
	item_id int NOT NULL,
	group_name1 nvarchar(128) NOT NULL,
	group_name2 nvarchar(128) NULL,
	group_name3 nvarchar(128) NULL,
	group_name4 nvarchar(128) NULL,
	group_name5 nvarchar(128) NULL,
	group_name6 nvarchar(128) NULL,
	group_name7 nvarchar(128) NULL,
	group_name8 nvarchar(128) NULL,
	group_name9 nvarchar(128) NULL,
	group_name10 nvarchar(128) NULL
)

GO


