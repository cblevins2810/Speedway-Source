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

-- Speedway Frame Types
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
SELECT frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid
FROM bc_extract_pos_frame_group_type

SELECT @TicketCount = @@RowCount

EXEC plt_get_next_named_ticket @table_name=N'pos_frame_group_type',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output

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
SELECT left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name
FROM bc_extract_pos_frame_template

SELECT @TicketCount = @@RowCount

EXEC plt_get_next_named_ticket @table_name=N'pos_frame_template',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output

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
SELECT pos_frame_template_id, pos_button_template_id, name, pos_font_id, action_id, pos_file_id, pos_button_type_code, left_position, top_position, height, width, text_color_id, button_color_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid, description
FROM bc_extract_pos_button_template

SELECT @TicketCount = @@ROWCOUNT

EXEC plt_get_next_named_ticket @table_name=N'pos_button_template',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output

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
INSERT pos_menu_frame_group_type_list (menu_type_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, max_count, min_count, default_frame_template_id, data_guid)
SELECT m.menu_type_id, fgt.frame_group_type_id, @clientId, 42, GETDATE(), max_count, min_count, ft.pos_frame_template_id, NULL 
FROM bc_extract_pos_menu_frame_group_type_list AS l
JOIN pos_frame_group_type AS fgt
ON   l.name = fgt.name
JOIN pos_menu_type AS m
ON   m.name = 'PCS Menu (Non-Fuel)'
JOIN pos_frame_template AS ft
ON   l.description = ft.description
WHERE fgt.frame_group_type_id > 100000

-- Button Actions
INSERT POS_Button_Action_Frame_Group_List (action_id, frame_group_type_id, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
SELECT action_id, fgt.frame_group_type_id, @clientid, 42, GETDATE(), NULL
FROM bc_extract_POS_Button_Action_Frame_Group_List AS l
JOIN POS_Frame_Group_Type fgt
ON   l.name = fgt.name
WHERE fgt.frame_group_type_id > 100000





