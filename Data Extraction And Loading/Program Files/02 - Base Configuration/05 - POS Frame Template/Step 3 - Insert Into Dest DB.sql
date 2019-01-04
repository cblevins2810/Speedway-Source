-- The 4X4 Frame is no longer needed, but is only commented out in case the business need changes

IF OBJECT_ID('tempdb..#bc_extract_pos_frame_group_type') IS NOT NULL
  DROP TABLE #bc_extract_pos_frame_group_type
GO

IF OBJECT_ID('tempdb..#bc_extract_pos_frame_template') IS NOT NULL
  DROP TABLE #bc_extract_pos_frame_template
GO

IF OBJECT_ID('tempdb..#bc_extract_pos_menu_frame_group_type_list') IS NOT NULL
  DROP TABLE #bc_extract_pos_menu_frame_group_type_list
GO

IF OBJECT_ID('tempdb..#bc_extract_pos_button_template') IS NOT NULL
  DROP TABLE #bc_extract_pos_button_template
GO

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

CREATE TABLE #bc_extract_pos_frame_group_type(
	frame_group_type_id int IDENTITY (1,1) NOT NULL,
	frame_group_type_code nchar(1) NULL,
	name nvarchar(50) NOT NULL,
	client_id int NULL,
	last_modified_user_id int NULL,
	last_modified_timestamp datetime NULL,
	data_guid uniqueidentifier NULL
) 

CREATE TABLE #bc_extract_pos_frame_template(
	pos_frame_template_id int IDENTITY (1,1) NOT NULL,
	left_position smallint NOT NULL,
	top_position smallint NOT NULL,
	height smallint NOT NULL,
	width smallint NOT NULL,
	description nvarchar(255) NULL,
	color_id int NOT NULL,
	client_id int NOT NULL,
	last_modified_user_id int NOT NULL,
	last_modified_timestamp datetime NOT NULL,
	frame_group_type_id int NOT NULL,
	data_guid uniqueidentifier NULL,
	global_flag nchar(1) NOT NULL,
	frame_resolution_type_code nchar(1) NOT NULL,
	name nvarchar(50) NOT NULL
)

CREATE TABLE #bc_extract_pos_button_template(
	new_button_id int IDENTITY(1,1),
	pos_frame_template_id int NOT NULL,
	pos_button_template_id int NOT NULL,
	name nvarchar(30) NULL,
	pos_font_id int NOT NULL,
	action_id int NULL,
	pos_file_id int NULL,
	pos_button_type_code nchar(1) NOT NULL,
	left_position smallint NOT NULL,
	top_position smallint NOT NULL,
	height smallint NOT NULL,
	width smallint NOT NULL,
	text_color_id int NULL,
	button_color_id int NULL,
	client_id int NOT NULL,
	last_modified_user_id int NOT NULL,
	last_modified_timestamp datetime NOT NULL,
	data_guid uniqueidentifier NULL,
	description nvarchar(255) NULL
)

CREATE TABLE #bc_extract_pos_menu_frame_group_type_list(
	menu_type_id int NOT NULL,
	frame_group_type_id int NOT NULL,
	client_id int NULL,
	last_modified_user_id int NULL,
	last_modified_timestamp datetime NULL,
	max_count int NULL,
	min_count int NULL,
	default_frame_template_id int NULL,
	data_guid uniqueidentifier NULL,
	name nvarchar(50) NOT NULL,
	description nvarchar(255) NULL
) 

-- Speedway menu types
SELECT @TicketCount = 1

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_group_type'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT POS_Menu_Type (menu_type_id, name, client_id,	last_modified_user_id, last_modified_timestamp, data_guid,	max_frames,	quick_author_flag)
VALUES(@NextId, 'PCS Menu (5X5)', @clientid, 42, GETDATE(), NULL, NULL,'n')

/*
INSERT POS_Menu_Type (menu_type_id, name, client_id,	last_modified_user_id, last_modified_timestamp, data_guid,	max_frames,	quick_author_flag)
VALUES(@NextId - 1, 'PCS Menu (4X4)', @clientid, 42, GETDATE(), NULL, NULL,'n')
*/

-- Speedway Frame Types
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, 'PCS Main Frame (5X5)', 0, 42, GETDATE(), 'd286246a-26f7-4754-a349-d5965d2fb8bf')
--INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
--VALUES (NULL, 'PCS Enhancement Frame (4X4)', 0, 42, GETDATE(), '72b62368-86ee-4db5-85a1-d4df4afee021')
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, 'PCS Enhancement Frame (5X5)', 0, 42, GETDATE(), 'a806c114-2f93-4768-992c-38eed7254df3')
--INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
--VALUES (NULL, 'PCS Main Frame (4X4)', 0, 42, GETDATE(), 'bd833855-fa56-4078-bd8a-a27a3dda045f')

SELECT @TicketCount = COUNT(*)
FROM #bc_extract_pos_frame_group_type

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_group_type'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT pos_frame_group_type (frame_group_type_id, frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
SELECT @NextId - frame_group_type_id + 1,  -- Disregard the id from the source database and replace with a non-red table id
frame_group_type_code,
name,
@ClientId,
42,
GETDATE(),
NULL
FROM #bc_extract_pos_frame_group_type

-- Speedway Frame Templates
INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, 'PCS Menu Frame, 5X5', 17, 0, 42, GETDATE(), 31, 'f18492d4-b58d-4db7-ab8b-d895487f1095', 'y', '1', 'PCS Main Frame (5X5)')
--INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
--VALUES (316, 212, 263, 484, 'PCS Enhancement Frame, 4X4', 17, 0, 42, GETDATE(), 32, '64f9a85e-77f3-4e7e-809b-325107a3dd3b', 'y', '1', 'PCS Enhancement Frame (4X4)')
INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, 'PCS Enhancement Frame, 5X5', 17, 0, 42, GETDATE(), 33, '9ce03c9d-a590-4177-ac8b-96c6c288d386', 'y', '1', 'PCS Enhancement Frame (5X5)')
--INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
--VALUES (316, 212, 263, 484, 'PCS Menu Frame, 4X4', 17, 0, 42, GETDATE(), 34, 'f2e448f9-e3ed-463e-9bb3-52f5408d4f20', 'y', '1', 'PCS Main Frame (4X4)')

SELECT @TicketCount = COUNT(*)
FROM #bc_extract_pos_frame_template

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_template'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT pos_frame_template (pos_frame_template_id, left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code)
SELECT @NextId - t.pos_frame_template_id +1, -- Disregard the id from the source database and replace with a non-red table id
t.left_position,
t.top_position,
t.height,
t.width,
t.description,
t.color_id, 
@ClientId,
42,
GETDATE(),
g.frame_group_type_id,
t.data_guid,
t.global_flag,
t.frame_resolution_type_code
FROM #bc_extract_pos_frame_template AS t 
JOIN pos_frame_group_type AS g 
ON   t.name = g.name

-- Buttons associated to the frame groups
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2300, NULL, 683, NULL, NULL, 'a', 12, 10, 44, 87, 21, 17, 0, 42, GETDATE(), 'efd1ea25-611d-498d-9996-d221ff801bfc', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2301, NULL, 683, NULL, NULL, 'a', 105, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '97e0ba81-074f-43f5-87df-15dc7e67d157', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2302, NULL, 683, NULL, NULL, 'a', 198, 10, 44, 87, 21, 17, 0, 42, GETDATE(), 'b9b6952e-51aa-406c-894f-8f7625068d42', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2303, NULL, 683, NULL, NULL, 'a', 291, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '94214cf5-444f-4cd2-bfbb-a4a912a58d97', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2304, NULL, 683, NULL, NULL, 'a', 384, 10, 44, 87, 21, 17, 0, 42, GETDATE(), 'acc70348-625b-4d9e-8a4e-8ba8def22dae', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2305, NULL, 683, NULL, NULL, 'a', 12, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '5e39cbc2-4826-4977-8c4d-a8b1e052df0a', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2306, NULL, 683, NULL, NULL, 'a', 105, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '9b833bb8-be73-49d7-8764-9b3a7bb7c256', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2307, NULL, 683, NULL, NULL, 'a', 198, 60, 44, 87, 21, 17, 0, 42, GETDATE(), 'e217d396-0a42-4954-96c4-0a8737a4c08c', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2308, NULL, 683, NULL, NULL, 'a', 291, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '681556d2-db86-47e1-999d-27a311c51e37', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2309, NULL, 683, NULL, NULL, 'a', 384, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '7f81a7a7-71e4-46df-874f-a0eaf3b56019', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2310, NULL, 683, NULL, NULL, 'a', 12, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '36888116-7303-4e07-8b50-8347c837c1f9', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2311, NULL, 683, NULL, NULL, 'a', 105, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '4f2a8a87-3670-47f4-b3ed-cebe81d657a2', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2312, NULL, 683, NULL, NULL, 'a', 198, 110, 44, 87, 21, 17, 0, 42, GETDATE(), 'bd75ea9d-9e7e-4c5f-8b4b-939950b71606', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2313, NULL, 683, NULL, NULL, 'a', 291, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '76a19717-063a-45cb-a24e-66e7c67a5e6e', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2314, NULL, 683, NULL, NULL, 'a', 384, 110, 44, 87, 21, 17, 0, 42, GETDATE(), 'afe58fe9-4103-4b02-8235-4c7c88647ba9', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2315, NULL, 683, NULL, NULL, 'a', 12, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'a392e87d-c2fc-4a1d-979c-335fc101f20f', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2316, NULL, 683, NULL, NULL, 'a', 105, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'ad5ad322-e98e-47e9-a0a0-04d6a5526b5b', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2317, NULL, 683, NULL, NULL, 'a', 198, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'dcc99300-bf9f-4798-9201-07868288b1b5', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2318, NULL, 683, NULL, NULL, 'a', 291, 160, 44, 87, 21, 17, 0, 42, GETDATE(), '986ce91e-1b8c-4bf1-bb3c-fb16aad8f453', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2319, NULL, 683, NULL, NULL, 'a', 384, 160, 44, 87, 21, 17, 0, 42, GETDATE(), '39ed056f-897e-4a6c-9b63-28364e4f5f59', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2320, NULL, 683, NULL, NULL, 'a', 12, 210, 44, 87, 21, 17, 0, 42, GETDATE(), 'e57f3fe7-d7d2-4ed5-ab6b-4a63c7087b7a', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2321, NULL, 683, NULL, NULL, 'a', 105, 210, 44, 87, 21, 17, 0, 42, GETDATE(), '33b4dc01-86c8-4912-9cbe-386f9c53f182', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2322, NULL, 683, NULL, NULL, 'a', 198, 210, 44, 87, 21, 17, 0, 42, GETDATE(), 'eb7511cd-0f8d-4c16-a122-0056e3502dc7', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2323, NULL, 683, NULL, NULL, 'a', 291, 210, 44, 87, 21, 17, 0, 42, GETDATE(), '472b46e1-dd10-4eee-b0a0-dfd39c41a22e', 'PCS Menu Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (90, 2324, NULL, 683, NULL, NULL, 'a', 384, 210, 44, 87, 21, 17, 0, 42, GETDATE(), 'e162c3c5-31f8-4da5-98a1-539c195506de', 'PCS Menu Frame, 5X5')

/*
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2325, NULL, 683, NULL, NULL, 'a', 6, 8, 55, 110, 21, 17, 0, 42, GETDATE(), 'd1583273-f492-4833-91c4-bd7cb54b9d28', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2326, NULL, 683, NULL, NULL, 'a', 126, 8, 55, 110, 21, 17, 0, 42, GETDATE(), '26c83d23-dc27-4137-86d6-81e7973fbda2', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2327, NULL, 683, NULL, NULL, 'a', 246, 8, 55, 110, 21, 17, 0, 42, GETDATE(), '672fd5c7-5141-4183-80d7-0cf530441147', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2328, NULL, 683, NULL, NULL, 'a', 366, 8, 55, 110, 21, 17, 0, 42, GETDATE(), '932fb612-89b6-4334-b7dc-05f09326d871', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2329, NULL, 683, NULL, NULL, 'a', 6, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '598152ff-b3dc-4043-a5a3-c7a3fc022cd2', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2330, NULL, 683, NULL, NULL, 'a', 126, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '82091ca5-46d6-43a1-8cf5-2a6a7c4516ad', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2331, NULL, 683, NULL, NULL, 'a', 246, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '9b7cd274-7057-42ef-8f7a-b94b06215cab', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2332, NULL, 683, NULL, NULL, 'a', 366, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '4f32001d-ca15-4f8d-b0b0-b74e01cf52c8', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2333, NULL, 683, NULL, NULL, 'a', 6, 134, 55, 110, 21, 17, 0, 42, GETDATE(), '9e1205cb-c86d-40ae-b0bc-a078e5739704', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2334, NULL, 683, NULL, NULL, 'a', 126, 134, 55, 110, 21, 17, 0, 42, GETDATE(), '42c1ee99-21f3-4107-8256-39d9f3089546', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2335, NULL, 683, NULL, NULL, 'a', 246, 134, 55, 110, 21, 17, 0, 42, GETDATE(), 'afb9afcc-b829-4644-9194-0e1eec577642', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2336, NULL, 683, NULL, NULL, 'a', 366, 134, 55, 110, 21, 17, 0, 42, GETDATE(), 'c8bffc8f-7e70-4656-a56e-78d8a85809f1', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2337, NULL, 683, NULL, NULL, 'a', 6, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '89349c89-cfe0-468e-a180-86c8daaef5cc', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2338, NULL, 683, NULL, NULL, 'a', 126, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '02e26662-4572-4db9-9824-b3bef289f87e', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2339, NULL, 683, NULL, NULL, 'a', 246, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '752cd0fd-3266-47f2-a260-fc262746add8', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (91, 2340, NULL, 683, 40, 526, 'f', 366, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '53b45839-beed-41f4-bf91-a6179890a59c', 'PCS Enhancement Frame, 4X4')
*/
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2341, NULL, 683, NULL, NULL, 'a', 12, 10, 44, 87, 21, 17, 0, 42, GETDATE(), 'f3d646f4-1d93-4fc3-b715-47444b2799a5', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2342, NULL, 683, NULL, NULL, 'a', 105, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '7ff455ae-529d-4fe7-b79a-5f5fdc9621d8', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2343, NULL, 683, NULL, NULL, 'a', 198, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '39cf1bea-8382-4f5d-984e-11f44bd9cbc7', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2344, NULL, 683, NULL, NULL, 'a', 291, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '70c85efc-06a9-4a0f-8993-8869b02fd0e0', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2345, NULL, 683, NULL, NULL, 'a', 384, 10, 44, 87, 21, 17, 0, 42, GETDATE(), '008542ff-8135-43a6-b79d-bd6477fca5ba', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2346, NULL, 683, NULL, NULL, 'a', 12, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '32ae4327-68d0-4be3-b731-9765728e180e', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2347, NULL, 683, NULL, NULL, 'a', 105, 60, 44, 87, 21, 17, 0, 42, GETDATE(), 'd5258b90-e431-44a3-bd26-b45c49ab3759', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2348, NULL, 683, NULL, NULL, 'a', 198, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '855c0beb-abdd-4f7e-b643-c2c19ae8c20e', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2349, NULL, 683, NULL, NULL, 'a', 291, 60, 44, 87, 21, 17, 0, 42, GETDATE(), 'f6331860-aa01-4d54-9e3f-83eefce1c9a9', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2350, NULL, 683, NULL, NULL, 'a', 384, 60, 44, 87, 21, 17, 0, 42, GETDATE(), '9422426d-394d-4a04-8538-6c013d7953c8', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2351, NULL, 683, NULL, NULL, 'a', 12, 110, 44, 87, 21, 17, 0, 42, GETDATE(), 'd62d8017-bc4f-4c2a-9e04-8fa51de49621', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2352, NULL, 683, NULL, NULL, 'a', 105, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '6fb9df04-8276-4831-a81a-31e25cc0316d', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2353, NULL, 683, NULL, NULL, 'a', 198, 110, 44, 87, 21, 17, 0, 42, GETDATE(), 'e76c0b5b-e164-4895-9946-8c69c254a277', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2354, NULL, 683, NULL, NULL, 'a', 291, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '90af1e0f-3408-4d4f-92ca-9c14bb4d4484', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2355, NULL, 683, NULL, NULL, 'a', 384, 110, 44, 87, 21, 17, 0, 42, GETDATE(), '69f6ff24-71c0-459b-91c0-5ff3ee834655', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2356, NULL, 683, NULL, NULL, 'a', 12, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'a576d262-e529-40aa-bc7b-4e5407d3f2e7', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2357, NULL, 683, NULL, NULL, 'a', 105, 160, 44, 87, 21, 17, 0, 42, GETDATE(), '2afd8eb1-0013-4101-9707-853523506292', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2358, NULL, 683, NULL, NULL, 'a', 198, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'da08654a-ea88-4331-81bc-8bb210e97650', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2359, NULL, 683, NULL, NULL, 'a', 291, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'bce1a91f-a02f-4114-bd4a-16f184e360cf', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2360, NULL, 683, NULL, NULL, 'a', 384, 160, 44, 87, 21, 17, 0, 42, GETDATE(), 'be27c43b-62f9-4ec3-9893-c8ef40c7ab93', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2361, NULL, 683, NULL, NULL, 'a', 12, 210, 44, 87, 21, 17, 0, 42, GETDATE(), '2d67da89-742f-42ff-a870-78c4ed054952', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2362, NULL, 683, NULL, NULL, 'a', 105, 210, 44, 87, 21, 17, 0, 42, GETDATE(), 'c5c9ab96-1b14-415a-898c-b7b89ed2e45e', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2363, NULL, 683, NULL, NULL, 'a', 198, 210, 44, 87, 21, 17, 0, 42, GETDATE(), 'aa6f9eb0-92a8-4f81-b7b6-eb7fbd1f9f34', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2364, NULL, 683, NULL, NULL, 'a', 291, 210, 44, 87, 21, 17, 0, 42, GETDATE(), '5f9a8acb-ac06-4164-bb43-10e488f6e286', 'PCS Enhancement Frame, 5X5')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (92, 2365, NULL, 683, 40, 136, 'f', 384, 210, 44, 87, 21, 17, 0, 42, GETDATE(), '933c6257-2003-4845-a60a-30224646cbaf', 'PCS Enhancement Frame, 5X5')
/*
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2366, NULL, 683, NULL, NULL, 'a', 6, 8, 55, 110, 21, 17, 0, 42, GETDATE(), 'e31c0b71-5a77-4832-92e5-28afe9d4cf66', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2367, NULL, 683, NULL, NULL, 'a', 126, 8, 55, 110, 21, 17, 0, 42, GETDATE(), '96cf11de-96f8-47cf-8478-f3dcd8d17f0a', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2368, NULL, 683, NULL, NULL, 'a', 246, 8, 55, 110, 21, 17, 0, 42, GETDATE(), 'b853f497-687e-4099-ae7f-82eb69d6ae1d', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2369, NULL, 683, NULL, NULL, 'a', 366, 8, 55, 110, 21, 17, 0, 42, GETDATE(), '9b2c9d2a-b597-4ec9-8242-96f8976794ea', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2370, NULL, 683, NULL, NULL, 'a', 6, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '52ffa125-9631-4c63-94c0-852cb331be02', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2371, NULL, 683, NULL, NULL, 'a', 126, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '91f31eb7-e5af-407d-b607-32a44cc28b2e', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2372, NULL, 683, NULL, NULL, 'a', 246, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '767953ad-deb6-4235-a68a-37dc0f00cf7a', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2373, NULL, 683, NULL, NULL, 'a', 366, 71, 55, 110, 21, 17, 0, 42, GETDATE(), '1e2ee125-c25a-466c-9627-d7f0bf1ad1fc', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2374, NULL, 683, NULL, NULL, 'a', 6, 134, 55, 110, 21, 17, 0, 42, GETDATE(), 'f205e501-e379-4e98-bdb5-98b2c7a10800', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2375, NULL, 683, NULL, NULL, 'a', 126, 134, 55, 110, 21, 17, 0, 42, GETDATE(), '9367170a-d36d-4d80-bab5-07c0b18546a2', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2376, NULL, 683, NULL, NULL, 'a', 246, 134, 55, 110, 21, 17, 0, 42, GETDATE(), '73ecc983-0ad2-413a-9484-2f37a24a273f', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2377, NULL, 683, NULL, NULL, 'a', 366, 134, 55, 110, 21, 17, 0, 42, GETDATE(), '8bc72f7f-3b79-4a31-a54e-a4d19093efa7', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2378, NULL, 683, NULL, NULL, 'a', 6, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '305eef01-ad3d-48c3-8a6f-05cf18b7fa65', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2379, NULL, 683, NULL, NULL, 'a', 126, 198, 55, 110, 21, 17, 0, 42, GETDATE(), 'a5c1163a-7a4d-4aac-bbb7-beda877b4b03', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2380, NULL, 683, NULL, NULL, 'a', 246, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '42f12368-86a1-4f1d-85fc-9a40d664bc86', 'PCS Menu Frame, 4X4')
INSERT #bc_extract_pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description)
VALUES (93, 2381, NULL, 683, NULL, NULL, 'a', 366, 198, 55, 110, 21, 17, 0, 42, GETDATE(), '31896958-80be-4f8b-92a0-e6086c8af449', 'PCS Menu Frame, 4X4')
*/
SELECT @TicketCount = COUNT(*)
FROM #bc_extract_pos_button_template

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_button_template'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT pos_button_template (pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid)

SELECT  t.pos_frame_template_id, -- Get the template id from the newly created template
@NextId - b.new_button_id +1,  -- Disregard the id from the source database and replace with a non-red table id
b.name,
b.pos_font_id,
b.action_id,
b.pos_file_id,
b.pos_button_type_code,
b.left_position,
b.top_position,
b.height,
b.width,
b.text_color_id,
b.button_color_id,
@ClientId,
42,
GETDATE(),
b.data_guid
FROM #bc_extract_pos_button_template AS b
JOIN pos_frame_template AS t 
ON   t.description = b.description

-- Frame Group type list
INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
VALUES (9, 31, 0, 42, GETDATE(), NULL, 1, 90, '6b59dff7-fcbb-482a-846c-78e61f203d0f', 'PCS Main Frame (5X5)', 'PCS Menu Frame, 5X5')
--INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
--VALUES (9, 32, 0, 42, GETDATE(), NULL, 1, 91, 'c454deaf-fbc3-4aaf-946c-6eb7251f5574', 'PCS Enhancement Frame (4X4)', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
VALUES (9, 33, 0, 42, GETDATE(), NULL, 0, 92, 'b8a8e729-d8b4-458a-a2a9-984820183c4e', 'PCS Enhancement Frame (5X5)', 'PCS Enhancement Frame, 5X5')
--INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
--VALUES (10, 32, 0, 42, GETDATE(), NULL, 1, 91, '902c28b2-b288-4b38-8e27-1dd96e6ff641', 'PCS Enhancement Frame (4X4)', 'PCS Enhancement Frame, 4X4')
INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
VALUES (10, 33, 0, 42, GETDATE(), NULL, 0, 92, '38966770-4a7f-4d83-b70a-5d684eaf248b', 'PCS Enhancement Frame (5X5)', 'PCS Enhancement Frame, 5X5')
--INSERT #bc_extract_pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid, name, description)
--VALUES (10, 34, 0, 42, GETDATE(), NULL, 1, 93, '619d8ce9-8bc4-471b-a41a-e7ed8ce44d11', 'PCS Main Frame (4X4)', 'PCS Menu Frame, 4X4')

/*
INSERT pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid)
SELECT m.menu_type_id, g.frame_group_type_id, @clientId, l.last_modified_user_id, l.last_modified_timestamp, max_count, min_count, default_frame_template_id, l.data_guid
FROM #bc_extract_pos_menu_frame_group_type_list AS l
JOIN pos_frame_group_type AS g
ON   l.name = g.name
JOIN pos_menu_type AS m
ON   mlname = 'PCS Menu (4X4)'
WHERE l.menu_type_id = 9
*/

INSERT pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid)
SELECT m.menu_type_id, g.frame_group_type_id, @clientId, l.last_modified_user_id, l.last_modified_timestamp, max_count, min_count, default_frame_template_id, l.data_guid
FROM #bc_extract_pos_menu_frame_group_type_list AS l
JOIN pos_frame_group_type AS g
ON   l.name = g.name
JOIN pos_menu_type AS m
ON   m.name = 'PCS Menu (5X5)'
WHERE l.menu_type_id = 10
