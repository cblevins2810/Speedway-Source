IF OBJECT_ID('bc_extract_bu_price_change_item') IS NOT NULL
	DROP TABLE bc_extract_bu_price_change_item
GO

CREATE TABLE [dbo].[bc_extract_bu_price_change_item](
	[item_id] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO

