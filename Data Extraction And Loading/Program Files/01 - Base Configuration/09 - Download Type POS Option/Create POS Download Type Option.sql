BEGIN TRANSACTION

/*  This script adds a new POS option that was requested by Speedway */

DECLARE @ClientId INT
DECLARE @POSOptionGroupId INT
DECLARE @POSOptionTemplateId INT
DECLARE @POSOptionId INT
SELECT @ClientId = MAX(client_id) FROM RAD_SYS_Client

DECLARE @NumberOfTickets INT
DECLARE @NextTicket INT

SELECT @POSOptionGroupId = MAX(pos_option_group_id)
FROM   pos_option_group
WHERE  client_id = @ClientId

SELECT @POSOptionTemplateId = MAX(pos_option_template_id)
FROM   pos_option_template
WHERE  client_id = @ClientId

SET @NumberOfTickets = 1
EXEC plt_get_next_named_ticket 'POS_Option','n', @NumberOfTickets, @NextTicket OUTPUT
SET @POSOptionId = @NextTicket

INSERT POS_Option (pos_option_id,
valid_value_group_id,
pos_option_category_id,
name,
description,
value_editable_flag,
option_type_code,
default_value,
valid_expression,
sort_order,
lh_identifier,
pos_translate_code,
client_id,
last_modified_user_id,
last_modified_timestamp,
data_guid)
VALUES (@POSOptionId,
4,
102,
'Download Type',
'Represents the download type of the location',
'y',
'i',
 '1',
NULL,
 0, 
 '10061',
 'n',
 0,
 42,
 GETDATE(),
 NULL)

INSERT POS_Option_Group_List (pos_option_group_id, pos_option_id, value, client_id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
VALUES (@POSOptionGroupId, @POSOptionId, '1', @ClientId, 'y', 42, GETDATE())

INSERT POS_Option_Template_List (pos_option_template_id, pos_option_id, Client_Id, value_editable_flag, last_modified_user_id, last_modified_timestamp)
SELECT @POSOptionTemplateId, pos_option_id, @ClientId, value_editable_flag, 42, GETDATE()
FROM POS_Option_Group_List
WHERE pos_option_group_id = @POSOptionGroupId
AND   pos_option_id = @POSOptionId

COMMIT TRANSACTION

