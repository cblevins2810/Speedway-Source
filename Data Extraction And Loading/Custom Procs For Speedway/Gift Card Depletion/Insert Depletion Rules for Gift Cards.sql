DECLARE @ClientId INT
DECLARE @NumberOfTickets INT
DECLARE @NextTicket INT
DECLARE @ItemId INT
DECLARE @RetailItemId INT
DECLARE @RetailModifiedItemId INT

SELECT @ClientId = MAX(client_id) FROM VP60_eso..RAD_SYS_Client

SET @RetailItemId = 10061375
SET @ItemId = 10061381
SET @RetailModifiedItemId = 10064411
SET @NumberOfTickets = 1

EXEC VP60_eso..plt_get_next_named_ticket 'rmi_depletion_item_list','n', @NumberOfTickets, @NextTicket OUTPUT

INSERT VP60_eso..Retail_Item_Depletion_List
(retail_item_id,
item_id,
unit_of_measure_id,
client_id,
last_modified_user_id,
last_modified_timestamp)
VALUES (@RetailItemId,
@ItemId,
3,
@ClientId,
42,
GETDATE())

INSERT VP60_eso..rmi_depletion_item_list
(retail_item_id,
item_id,
retail_modified_item_id,
depletion_id,
quantity,
client_id,
last_modified_user_id,
last_modified_timestamp)
VALUES (@RetailItemId,
@ItemId,
@RetailModifiedItemId,
@NextTicket,
1,
@ClientId,
42,
GETDATE())

INSERT VP60_eso_wh..sales_item_inventory_depletion_list
(sales_item_id,
inventory_item_id,
data_accessor_id,
sales_dest_id,
atomic_depletion_quantity,
depletion_id,
start_date,
end_date)
SELECT
retail_modified_item_id,
item_id,
client_id,
0,
quantity,
depletion_id,
'1900-01-01',
'2075-12-31'
FROM VP60_eso..rmi_depletion_item_list
WHERE retail_item_id = @RetailItemId
AND   item_Id = @ItemId
AND   retail_modified_item_id = @RetailModifiedItemId

