/* Creates a single group for the most recently added client in the database */

DECLARE @POSOptionGroupId INT
DECLARE @POSOptionTemplateId INT

DECLARE @ClientId INT
SELECT @ClientId = MAX(client_id) FROM RAD_SYS_Client

DECLARE @NumberOfTickets INT
DECLARE @NextTicket INT
SET @NumberOfTickets = 1

EXEC plt_get_next_named_ticket 'POS_Option_Group','n', @NumberOfTickets, @NextTicket OUTPUT
SET @POSOptionGroupId = @NextTicket

INSERT POS_Option_Group (pos_option_group_id, name, description, client_id, last_modified_user_id, last_modified_timestamp, pos_option_template_id)
VALUES (@POSOptionGroupId, N'Speedway Default POS Option', N'Default PCS Options', @ClientId, 42, GETDATE(), NULL)








