/****** Object:  Table [dbo].[bc_extract_POS_Button_Action_Frame_Group_List]    Script Date: 01/18/2019 14:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_POS_Button_Action_Frame_Group_List]') AND type in (N'U'))
DROP TABLE [bc_extract_POS_Button_Action_Frame_Group_List]
GO
/****** Object:  Table [dbo].[bc_extract_pos_button_template]    Script Date: 01/18/2019 14:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_button_template]') AND type in (N'U'))
DROP TABLE [bc_extract_pos_button_template]
GO
/****** Object:  Table [dbo].[bc_extract_pos_frame_group_type]    Script Date: 01/18/2019 14:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_frame_group_type]') AND type in (N'U'))
DROP TABLE [bc_extract_pos_frame_group_type]
GO
/****** Object:  Table [dbo].[bc_extract_pos_frame_template]    Script Date: 01/18/2019 14:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_frame_template]') AND type in (N'U'))
DROP TABLE [bc_extract_pos_frame_template]
GO
/****** Object:  Table [dbo].[bc_extract_pos_menu_frame_group_type_list]    Script Date: 01/18/2019 14:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_menu_frame_group_type_list]') AND type in (N'U'))
DROP TABLE [bc_extract_pos_menu_frame_group_type_list]
GO
/****** Object:  Table [dbo].[bc_extract_pos_menu_frame_group_type_list]    Script Date: 01/18/2019 14:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_menu_frame_group_type_list]') AND type in (N'U'))
BEGIN
CREATE TABLE [bc_extract_pos_menu_frame_group_type_list](
	[menu_type_id] [int] NOT NULL,
	[frame_group_type_id] [int] NOT NULL,
	[client_id] [int] NULL,
	[last_modified_user_id] [int] NULL,
	[last_modified_timestamp] [datetime] NULL,
	[max_count] [int] NULL,
	[min_count] [int] NULL,
	[default_frame_template_id] [int] NULL,
	[data_guid] [uniqueidentifier] NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
INSERT [bc_extract_pos_menu_frame_group_type_list] ([menu_type_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [max_count], [min_count], [default_frame_template_id], [data_guid], [name], [description]) VALUES (9, 31, 0, 42, CAST(0x0000993F0178B7BF AS DateTime), NULL, 1, 90, N'6b59dff7-fcbb-482a-846c-78e61f203d0f', N'PCS Main Frame (5X5)', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_menu_frame_group_type_list] ([menu_type_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [max_count], [min_count], [default_frame_template_id], [data_guid], [name], [description]) VALUES (9, 33, 0, 42, CAST(0x000099F20107E13A AS DateTime), NULL, 0, 92, N'b8a8e729-d8b4-458a-a2a9-984820183c4e', N'PCS Enhancement Frame (5X5)', N'PCS Enhancement Frame, 5X5')
/****** Object:  Table [dbo].[bc_extract_pos_frame_template]    Script Date: 01/18/2019 14:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_frame_template]') AND type in (N'U'))
BEGIN
CREATE TABLE [bc_extract_pos_frame_template](
	[pos_frame_template_id] [int] NOT NULL,
	[left_position] [smallint] NOT NULL,
	[top_position] [smallint] NOT NULL,
	[height] [smallint] NOT NULL,
	[width] [smallint] NOT NULL,
	[description] [nvarchar](255) NULL,
	[color_id] [int] NOT NULL,
	[client_id] [int] NOT NULL,
	[last_modified_user_id] [int] NOT NULL,
	[last_modified_timestamp] [datetime] NOT NULL,
	[frame_group_type_id] [int] NOT NULL,
	[data_guid] [uniqueidentifier] NULL,
	[global_flag] [nchar](1) NOT NULL,
	[frame_resolution_type_code] [nchar](1) NOT NULL,
	[name] [nvarchar](50) NOT NULL
) ON [PRIMARY]
END
GO
INSERT [bc_extract_pos_frame_template] ([pos_frame_template_id], [left_position], [top_position], [height], [width], [description], [color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [frame_group_type_id], [data_guid], [global_flag], [frame_resolution_type_code], [name]) VALUES (90, 316, 212, 263, 484, N'PCS Menu Frame, 5X5', 17, 0, 42, CAST(0x0000993F0178B7BF AS DateTime), 31, N'f18492d4-b58d-4db7-ab8b-d895487f1095', N'y', N'1', N'PCS Main Frame (5X5)')
INSERT [bc_extract_pos_frame_template] ([pos_frame_template_id], [left_position], [top_position], [height], [width], [description], [color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [frame_group_type_id], [data_guid], [global_flag], [frame_resolution_type_code], [name]) VALUES (92, 316, 212, 263, 484, N'PCS Enhancement Frame, 5X5', 17, 0, 42, CAST(0x000099F201075D25 AS DateTime), 33, N'9ce03c9d-a590-4177-ac8b-96c6c288d386', N'y', N'1', N'PCS Enhancement Frame (5X5)')
/****** Object:  Table [dbo].[bc_extract_pos_frame_group_type]    Script Date: 01/18/2019 14:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_frame_group_type]') AND type in (N'U'))
BEGIN
CREATE TABLE [bc_extract_pos_frame_group_type](
	[frame_group_type_id] [int] NOT NULL,
	[frame_group_type_code] [nchar](1) NULL,
	[name] [nvarchar](50) NOT NULL,
	[client_id] [int] NULL,
	[last_modified_user_id] [int] NULL,
	[last_modified_timestamp] [datetime] NULL,
	[data_guid] [uniqueidentifier] NULL
) ON [PRIMARY]
END
GO
INSERT [bc_extract_pos_frame_group_type] ([frame_group_type_id], [frame_group_type_code], [name], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (31, NULL, N'PCS Main Frame (5X5)', 0, 42, CAST(0x0000993F0178B7BF AS DateTime), N'd286246a-26f7-4754-a349-d5965d2fb8bf')
INSERT [bc_extract_pos_frame_group_type] ([frame_group_type_id], [frame_group_type_code], [name], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid]) VALUES (33, NULL, N'PCS Enhancement Frame (5X5)', 0, 42, CAST(0x000099F20104CDDD AS DateTime), N'a806c114-2f93-4768-992c-38eed7254df3')
/****** Object:  Table [dbo].[bc_extract_pos_button_template]    Script Date: 01/18/2019 14:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_pos_button_template]') AND type in (N'U'))
BEGIN
CREATE TABLE [bc_extract_pos_button_template](
	[pos_frame_template_id] [int] NOT NULL,
	[pos_button_template_id] [int] NOT NULL,
	[name] [nvarchar](30) NULL,
	[pos_font_id] [int] NOT NULL,
	[action_id] [int] NULL,
	[pos_file_id] [int] NULL,
	[pos_button_type_code] [nchar](1) NOT NULL,
	[left_position] [smallint] NOT NULL,
	[top_position] [smallint] NOT NULL,
	[height] [smallint] NOT NULL,
	[width] [smallint] NOT NULL,
	[text_color_id] [int] NULL,
	[button_color_id] [int] NULL,
	[client_id] [int] NOT NULL,
	[last_modified_user_id] [int] NOT NULL,
	[last_modified_timestamp] [datetime] NOT NULL,
	[data_guid] [uniqueidentifier] NULL,
	[description] [nvarchar](255) NULL
) ON [PRIMARY]
END
GO
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2300, NULL, 683, NULL, NULL, N'a', 12, 10, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'efd1ea25-611d-498d-9996-d221ff801bfc', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2301, NULL, 683, NULL, NULL, N'a', 105, 10, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'97e0ba81-074f-43f5-87df-15dc7e67d157', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2302, NULL, 683, NULL, NULL, N'a', 198, 10, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'b9b6952e-51aa-406c-894f-8f7625068d42', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2303, NULL, 683, NULL, NULL, N'a', 291, 10, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'94214cf5-444f-4cd2-bfbb-a4a912a58d97', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2304, NULL, 683, NULL, NULL, N'a', 384, 10, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'acc70348-625b-4d9e-8a4e-8ba8def22dae', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2305, NULL, 683, NULL, NULL, N'a', 12, 60, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'5e39cbc2-4826-4977-8c4d-a8b1e052df0a', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2306, NULL, 683, NULL, NULL, N'a', 105, 60, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'9b833bb8-be73-49d7-8764-9b3a7bb7c256', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2307, NULL, 683, NULL, NULL, N'a', 198, 60, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'e217d396-0a42-4954-96c4-0a8737a4c08c', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2308, NULL, 683, NULL, NULL, N'a', 291, 60, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'681556d2-db86-47e1-999d-27a311c51e37', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2309, NULL, 683, NULL, NULL, N'a', 384, 60, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'7f81a7a7-71e4-46df-874f-a0eaf3b56019', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2310, NULL, 683, NULL, NULL, N'a', 12, 110, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'36888116-7303-4e07-8b50-8347c837c1f9', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2311, NULL, 683, NULL, NULL, N'a', 105, 110, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'4f2a8a87-3670-47f4-b3ed-cebe81d657a2', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2312, NULL, 683, NULL, NULL, N'a', 198, 110, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'bd75ea9d-9e7e-4c5f-8b4b-939950b71606', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2313, NULL, 683, NULL, NULL, N'a', 291, 110, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'76a19717-063a-45cb-a24e-66e7c67a5e6e', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2314, NULL, 683, NULL, NULL, N'a', 384, 110, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'afe58fe9-4103-4b02-8235-4c7c88647ba9', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2315, NULL, 683, NULL, NULL, N'a', 12, 160, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'a392e87d-c2fc-4a1d-979c-335fc101f20f', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2316, NULL, 683, NULL, NULL, N'a', 105, 160, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'ad5ad322-e98e-47e9-a0a0-04d6a5526b5b', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2317, NULL, 683, NULL, NULL, N'a', 198, 160, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'dcc99300-bf9f-4798-9201-07868288b1b5', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2318, NULL, 683, NULL, NULL, N'a', 291, 160, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'986ce91e-1b8c-4bf1-bb3c-fb16aad8f453', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2319, NULL, 683, NULL, NULL, N'a', 384, 160, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'39ed056f-897e-4a6c-9b63-28364e4f5f59', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2320, NULL, 683, NULL, NULL, N'a', 12, 210, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'e57f3fe7-d7d2-4ed5-ab6b-4a63c7087b7a', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2321, NULL, 683, NULL, NULL, N'a', 105, 210, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'33b4dc01-86c8-4912-9cbe-386f9c53f182', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2322, NULL, 683, NULL, NULL, N'a', 198, 210, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'eb7511cd-0f8d-4c16-a122-0056e3502dc7', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2323, NULL, 683, NULL, NULL, N'a', 291, 210, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'472b46e1-dd10-4eee-b0a0-dfd39c41a22e', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (90, 2324, NULL, 683, NULL, NULL, N'a', 384, 210, 44, 87, 21, 17, 0, 42, CAST(0x0000984F00000000 AS DateTime), N'e162c3c5-31f8-4da5-98a1-539c195506de', N'PCS Menu Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2341, NULL, 683, NULL, NULL, N'a', 12, 10, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'f3d646f4-1d93-4fc3-b715-47444b2799a5', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2342, NULL, 683, NULL, NULL, N'a', 105, 10, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'7ff455ae-529d-4fe7-b79a-5f5fdc9621d8', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2343, NULL, 683, NULL, NULL, N'a', 198, 10, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'39cf1bea-8382-4f5d-984e-11f44bd9cbc7', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2344, NULL, 683, NULL, NULL, N'a', 291, 10, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'70c85efc-06a9-4a0f-8993-8869b02fd0e0', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2345, NULL, 683, NULL, NULL, N'a', 384, 10, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'008542ff-8135-43a6-b79d-bd6477fca5ba', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2346, NULL, 683, NULL, NULL, N'a', 12, 60, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'32ae4327-68d0-4be3-b731-9765728e180e', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2347, NULL, 683, NULL, NULL, N'a', 105, 60, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'd5258b90-e431-44a3-bd26-b45c49ab3759', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2348, NULL, 683, NULL, NULL, N'a', 198, 60, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'855c0beb-abdd-4f7e-b643-c2c19ae8c20e', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2349, NULL, 683, NULL, NULL, N'a', 291, 60, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'f6331860-aa01-4d54-9e3f-83eefce1c9a9', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2350, NULL, 683, NULL, NULL, N'a', 384, 60, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'9422426d-394d-4a04-8538-6c013d7953c8', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2351, NULL, 683, NULL, NULL, N'a', 12, 110, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'd62d8017-bc4f-4c2a-9e04-8fa51de49621', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2352, NULL, 683, NULL, NULL, N'a', 105, 110, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'6fb9df04-8276-4831-a81a-31e25cc0316d', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2353, NULL, 683, NULL, NULL, N'a', 198, 110, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'e76c0b5b-e164-4895-9946-8c69c254a277', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2354, NULL, 683, NULL, NULL, N'a', 291, 110, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'90af1e0f-3408-4d4f-92ca-9c14bb4d4484', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2355, NULL, 683, NULL, NULL, N'a', 384, 110, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'69f6ff24-71c0-459b-91c0-5ff3ee834655', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2356, NULL, 683, NULL, NULL, N'a', 12, 160, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'a576d262-e529-40aa-bc7b-4e5407d3f2e7', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2357, NULL, 683, NULL, NULL, N'a', 105, 160, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'2afd8eb1-0013-4101-9707-853523506292', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2358, NULL, 683, NULL, NULL, N'a', 198, 160, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'da08654a-ea88-4331-81bc-8bb210e97650', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2359, NULL, 683, NULL, NULL, N'a', 291, 160, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'bce1a91f-a02f-4114-bd4a-16f184e360cf', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2360, NULL, 683, NULL, NULL, N'a', 384, 160, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'be27c43b-62f9-4ec3-9893-c8ef40c7ab93', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2361, NULL, 683, NULL, NULL, N'a', 12, 210, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'2d67da89-742f-42ff-a870-78c4ed054952', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2362, NULL, 683, NULL, NULL, N'a', 105, 210, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'c5c9ab96-1b14-415a-898c-b7b89ed2e45e', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2363, NULL, 683, NULL, NULL, N'a', 198, 210, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'aa6f9eb0-92a8-4f81-b7b6-eb7fbd1f9f34', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2364, NULL, 683, NULL, NULL, N'a', 291, 210, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'5f9a8acb-ac06-4164-bb43-10e488f6e286', N'PCS Enhancement Frame, 5X5')
INSERT [bc_extract_pos_button_template] ([pos_frame_template_id], [pos_button_template_id], [name], [pos_font_id], [action_id], [pos_file_id], [pos_button_type_code], [left_position], [top_position], [height], [width], [text_color_id], [button_color_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [description]) VALUES (92, 2365, NULL, 683, 40, 136, N'f', 384, 210, 44, 87, 21, 17, 0, 42, CAST(0x000099F2011D9363 AS DateTime), N'933c6257-2003-4845-a60a-30224646cbaf', N'PCS Enhancement Frame, 5X5')
/****** Object:  Table [dbo].[bc_extract_POS_Button_Action_Frame_Group_List]    Script Date: 01/18/2019 14:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[bc_extract_POS_Button_Action_Frame_Group_List]') AND type in (N'U'))
BEGIN
CREATE TABLE [bc_extract_POS_Button_Action_Frame_Group_List](
	[action_id] [int] NOT NULL,
	[frame_group_type_id] [int] NOT NULL,
	[client_id] [int] NOT NULL,
	[last_modified_user_id] [int] NOT NULL,
	[last_modified_timestamp] [datetime] NOT NULL,
	[data_guid] [uniqueidentifier] NULL,
	[name] [nvarchar](50) NOT NULL
) ON [PRIMARY]
END
GO
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (1, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'7ec4c538-c407-49ab-a4df-39073cb31a56', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (2, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'0a5a5d40-3a02-4337-adc9-8c994d061471', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (5, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'72846c32-e9de-40bf-a802-bde208888150', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (6, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'cb25ea53-62cd-4d0e-afd6-c2cabe770060', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (7, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'38dbbf02-380d-42c2-84fd-9794310a3b40', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (8, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'861f5d29-f204-44f4-9243-203279ddfeb4', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (9, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'6f69edb9-4b6e-484c-b57f-2cf4328988b4', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (76, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'276307bd-c67f-4160-8212-52366afdcc20', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (86, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'40da07f5-c939-4912-8afc-f4f9d40fa001', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (89, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'eec09960-302f-4874-8b73-a07732c89644', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (99, 31, 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'1ae53442-6a57-46b4-bfec-18585b9a5bcd', N'PCS Main Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (1, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'3354409e-e30a-4037-b3fe-ac3601c3b68f', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (2, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'12c0e307-f56e-44a3-bdc5-61d9c61d15d5', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (5, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'feef955f-ab3a-4d64-9687-3c64b667898a', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (6, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'49db262c-a419-4b2a-961e-56eebfa7c753', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (7, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'582cdb18-3416-4566-99e7-b5d0840795e3', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (8, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'38608727-e9a2-4770-a0c8-f9ce3976ee15', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (9, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'a8fad974-fca2-4c62-b0a0-2726f09dbbd1', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (76, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'b91f9c1b-4afa-4d5c-8d7b-a5552a5b2d53', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (86, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'a04fdc59-ad7c-44fa-9147-4583f1b56fb5', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (89, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'3aab690e-b17c-496f-99ac-040290cd2554', N'PCS Enhancement Frame (5X5)')
INSERT [bc_extract_POS_Button_Action_Frame_Group_List] ([action_id], [frame_group_type_id], [client_id], [last_modified_user_id], [last_modified_timestamp], [data_guid], [name]) VALUES (99, 33, 0, 42, CAST(0x000099F20120244E AS DateTime), N'14eda442-3eac-4b8e-ae20-f6afdb2d941d', N'PCS Enhancement Frame (5X5)')
