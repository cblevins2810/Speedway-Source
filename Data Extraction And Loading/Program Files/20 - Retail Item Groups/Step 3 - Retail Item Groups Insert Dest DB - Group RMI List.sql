IF OBJECT_ID('bc_extract_rmi_group_rmi_list') IS NOT NULL
	DROP TABLE bc_extract_rmi_group_rmi_list
GO	

CREATE TABLE [dbo].[bc_extract_rmi_group_rmi_list](
	[group_xref_code] [nvarchar](255) NULL,
	[rmi_xref_code] [nvarchar](255) NULL
) ON [PRIMARY]
GO

