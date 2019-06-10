IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_item_split_mapping') IS NOT NULL
	DROP TABLE bcssa_custom_integration.dbo.bc_extract_item_split_mapping
GO

CREATE TABLE bcssa_custom_integration.dbo.bc_extract_item_split_mapping(
	[bc_xref_code] [nvarchar](255) NOT NULL,
	[eso_xref_code]  [nvarchar](255) NULL
) 

GO
