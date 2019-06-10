IF OBJECT_ID('bc_extract_repair_manufacturer_and_strategy') IS NOT NULL
	DROP TABLE bc_extract_repair_manufacturer_and_strategy
GO	

CREATE TABLE bc_extract_repair_manufacturer_and_strategy(
	fileName NVARCHAR (128) NOT NULL,
	itemXrefId NVARCHAR(255) NOT NULL,
	item_id INT NULL,
	isSold NVARCHAR(1) NOT NULL default 'y',
	manufacturer NVARCHAR(50) NULL,
	manufacturer_id INT NULL,
	prior_manufacturer_id INT NULL,
	itemStrategy NVARCHAR(255) NOT NULL,
	merch_group_id INT NULL,
	prior_merch_group_id INT NULL,
	rmiXrefId NVARCHAR(255) NULL,
	retail_modified_item_id INT NULL,
	rmiMerchGroup NVARCHAR(50) NULL,
	merch_group_member_id INT NULL,
	prior_merch_group_member_id INT NULL,
	default_merch_level_id INT NULL,
	prior_default_merch_level_id INT NULL
)
GO
