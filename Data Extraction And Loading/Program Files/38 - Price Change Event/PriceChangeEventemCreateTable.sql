IF OBJECT_ID('bcssa_custom_integration.dbo.bc_extract_price_event_item') IS NOT NULL
  DROP TABLE bcssa_custom_integration.dbo.bc_extract_price_event_item
GO

CREATE TABLE bcssa_custom_integration.dbo.bc_extract_price_event_item(
	[item_id] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[xref_code] [nvarchar](255) NOT NULL
) ON [PRIMARY]

GO