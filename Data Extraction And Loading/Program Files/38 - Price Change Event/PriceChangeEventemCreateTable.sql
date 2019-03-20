
/****** Object:  Table [dbo].[bcssa_custom_integration..bc_extract_price_event_item]    Script Date: 08/30/2018 22:05:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bcssa_custom_integration..bc_extract_price_event_item](
	[item_id] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[xref_code] [nvarchar](255) NOT NULL
) ON [PRIMARY]

GO

