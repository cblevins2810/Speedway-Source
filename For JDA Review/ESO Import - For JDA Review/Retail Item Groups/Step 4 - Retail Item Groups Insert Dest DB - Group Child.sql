IF OBJECT_ID('bc_extract_rmi_group_child') IS NOT NULL
	DROP TABLE bc_extract_rmi_group_child
GO	

CREATE TABLE [dbo].[bc_extract_rmi_group_child](
	[group_xref_code] [nvarchar](255) NULL,
	[child_group_xref_code] [nvarchar](255) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[bc_extract_rmi_group_child] ([group_xref_code], [child_group_xref_code]) VALUES (N'xref-1003714', N'xref-1003350')
INSERT [dbo].[bc_extract_rmi_group_child] ([group_xref_code], [child_group_xref_code]) VALUES (N'xref-1003714', N'xref-1003713')