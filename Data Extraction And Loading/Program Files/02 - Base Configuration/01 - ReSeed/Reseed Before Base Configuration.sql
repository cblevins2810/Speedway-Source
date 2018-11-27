/* Sets the seed values for data Accessor, security Accessor, and menu items to start at 10,000,001 */
DECLARE @TableName NVARCHAR(50)
DECLARE @NextTicket INT
DECLARE @CurrentTicket INT
DECLARE @NumberOfTickets INT

-- RAD_SYS_Data_Accessor
SET @TableName = 'RAD_SYS_Data_Accessor'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- RAD_SYS_Security_Accessor
SET @TableName = 'RAD_SYS_Security_Accessor'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Menu_Header
SET @TableName = 'Menu_Header'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Menu_Item
SET @TableName = 'Menu_Item'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'
