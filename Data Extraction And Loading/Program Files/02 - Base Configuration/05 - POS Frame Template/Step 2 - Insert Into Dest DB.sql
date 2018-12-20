IF OBJECT_ID('tempdb..#bc_extract_pos_frame_group_type') IS NOT NULL
  DROP TABLE #bc_extract_pos_frame_group_type
GO

IF OBJECT_ID('tempdb..#bc_extract_pos_frame_template') IS NOT NULL
  DROP TABLE #bc_extract_pos_frame_template
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

INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, N'PCS Main Frame (5X5)', 0, 42, CAST(0x0000993F0178B7BF AS DateTime), N'd286246a-26f7-4754-a349-d5965d2fb8bf')
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, N'PCS Enhancement Frame (4X4)', 0, 42, CAST(0x0000993F0178B7C3 AS DateTime), N'72b62368-86ee-4db5-85a1-d4df4afee021')
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, N'PCS Enhancement Frame (5X5)', 0, 42, CAST(0x000099F20104CDDD AS DateTime), N'a806c114-2f93-4768-992c-38eed7254df3')
INSERT #bc_extract_pos_frame_group_type (frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
VALUES (NULL, N'PCS Main Frame (4X4)', 0, 42, CAST(0x000099F20104EAFA AS DateTime), N'bd833855-fa56-4078-bd8a-a27a3dda045f')

SELECT @TicketCount = COUNT(*)
FROM #bc_extract_pos_frame_group_type

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_group_type'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT pos_frame_group_type (frame_group_type_id, frame_group_type_code, name, client_id, last_modified_user_id, last_modified_timestamp, data_guid)
SELECT @NextId - frame_group_type_id + 1,
frame_group_type_code,
name,
@ClientId,
42,
GETDATE(),
NULL
FROM #bc_extract_pos_frame_group_type

INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, N'PCS Menu Frame, 5X5', 17, 0, 42, CAST(0x0000993F0178B7BF AS DateTime), 31, N'f18492d4-b58d-4db7-ab8b-d895487f1095', N'y', N'1', N'PCS Main Frame (5X5)')
INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, N'PCS Enhancement Frame, 4X4', 17, 0, 42, CAST(0x0000993F0178B7BF AS DateTime), 32, N'64f9a85e-77f3-4e7e-809b-325107a3dd3b', N'y', N'1', N'PCS Enhancement Frame (4X4)')
INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, N'PCS Enhancement Frame, 5X5', 17, 0, 42, CAST(0x000099F201075D25 AS DateTime), 33, N'9ce03c9d-a590-4177-ac8b-96c6c288d386', N'y', N'1', N'PCS Enhancement Frame (5X5)')
INSERT #bc_extract_pos_frame_template (left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code, name)
VALUES (316, 212, 263, 484, N'PCS Menu Frame, 4X4', 17, 0, 42, CAST(0x000099F2010793F0 AS DateTime), 34, N'f2e448f9-e3ed-463e-9bb3-52f5408d4f20', N'y', N'1', N'PCS Main Frame (4X4)')

SELECT @TicketCount = COUNT(*)
FROM #bc_extract_pos_frame_template

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_template'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT pos_frame_template (pos_frame_template_id, left_position, top_position, height, width, description, color_id, client_id, last_modified_user_id, last_modified_timestamp, frame_group_type_id, data_guid, global_flag, frame_resolution_type_code)
SELECT @NextId - t.pos_frame_template_id +1,
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
JOIN #bc_extract_pos_frame_group_type AS g 
ON   t.name = g.name

