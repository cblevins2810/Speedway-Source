IF OBJECT_ID('bcssa_custom_integration..bc_extract_bu_price_change_item') IS NOT NULL
	DROP TABLE bcssa_custom_integration..bc_extract_bu_price_change_item
GO

CREATE TABLE bcssa_custom_integration..bc_extract_bu_price_change_item(
	item_id int NOT NULL,
	name nvarchar(50) NOT NULL
)

GO
