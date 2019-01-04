DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

SELECT @TicketCount = 2

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'pos_frame_group_type'
AND db_id = 1

EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

INSERT POS_Menu_Type
(menu_type_id, name, client_id,	last_modified_user_id, last_modified_timestamp, data_guid,	max_frames,	quick_author_flag)
VALUES(@NextId, 'PCS Menu (5X5)', @ClientId, 42, GETDATE(), NULL, NULL,'n')

INSERT POS_Menu_Type
(menu_type_id, name, client_id,	last_modified_user_id, last_modified_timestamp, data_guid,	max_frames,	quick_author_flag)
VALUES(@NextId - 1, 'PCS Menu (4X4)', @ClientId, 42, GETDATE(), NULL, NULL,'n')





