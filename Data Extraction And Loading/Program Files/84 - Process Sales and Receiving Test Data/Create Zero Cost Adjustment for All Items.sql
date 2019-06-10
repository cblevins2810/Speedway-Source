BEGIN TRANSACTION

DECLARE @NumberOfTickets INT
DECLARE @NextId INT
DECLARE @BusinessDate DATETIME
DECLARE @InventoryEventId INT
DECLARE @BusinessUnitId INT 
DECLARE @ClientId INT 
DECLARE @CurrentBusinessUnit INT
DECLARE @NumberOfBusinessUnits INT
DECLARE @BatchNumber INT

SET @ClientId = 10000001
SET @BusinessDate = '2019-04-18'

DECLARE @BusinessUnitList TABLE (
SequenceNumber INT IDENTITY (1,1),
BusinessUnitCode VARCHAR(20),
BusinessUnitId INT)

DECLARE @InventoryItems TABLE (
id INT IDENTITY (1,1),
inventory_item_id INT)

INSERT @BusinessUnitList (
BusinessUnitCode,
BusinessUnitId)
SELECT name,
data_accessor_id
FROM   rad_sys_data_accessor
WHERE  name IN (
'0009605')

INSERT @InventoryItems (
inventory_item_id)
SELECT inventory_item_id
FROM inventory_item

SELECT @CurrentBusinessUnit = 1
SELECT @NumberOfBusinessUnits = COUNT(*) FROM @BusinessUnitList

WHILE @CurrentBusinessUnit <= @NumberOfBusinessUnits
BEGIN

	SELECT 	@BusinessUnitId 	= BusinessUnitId
	FROM    @BusinessUnitList
	WHERE	@CurrentBusinessUnit = SequenceNumber  

	SET @BatchNumber = 0

  WHILE @BatchNumber < 25
  
  BEGIN
  
  
	
	
SET @NumberOfTickets = 1

EXEC plt_get_next_named_ticket @table_name=N'inventory_event',@isred=N'N',@numtickets=@NumberOfTickets,@next_ticket=@NextId output

SET @InventoryEventId = @NextId

INSERT inventory_event (
business_unit_id,
inventory_event_id,
business_date,
event_type_code,
event_timestamp,
client_id,
last_modified_user_id,
last_modified_timestamp,
item_filter_code,
status_code,
imported_flag,
handheld_flag,
reconcile_event_flag,
purge_flag,
archive_status_code,
on_hand_purged_flag,
sort_by_bin_number_flag,
moved_to_datamart_flag,
reason_code)

SELECT @BusinessUnitId,
@InventoryEventId,
@BusinessDate,
'a',
GETDATE(),
@ClientId,
42,
GETDATE(),
'a',
'p',
'n',
'n',
'n',
'n',
'1',
'n',
'n',
'n',
'a'

SELECT @NumberOfTickets = COUNT(*) FROM @InventoryItems
WHERE id % 10 = @BatchNumber

EXEC plt_get_next_named_ticket @table_name=N'inventory_event_list',@isred=N'N',@numtickets=@NumberOfTickets,@next_ticket=@NextId output

INSERT Inventory_Event_List (
inventory_event_id,
inventory_event_list_id,
inventory_item_id,
business_unit_id,
unit_of_measure_id,
quantity,
cost,
client_id,
last_modified_user_id,
last_modified_timestamp)

SELECT @InventoryEventId,
@NextId - id + 1,
inventory_item_id,
@BusinessUnitId,
3,
0,
0,
@ClientID,
42,
GETDATE()
FROM @InventoryItems
WHERE id % 10 = @BatchNumber

INSERT Inventory_Event_Item_List (
inventory_event_id,
inventory_event_list_id,
inventory_item_id,
business_unit_id,
unit_of_measure_id,
quantity,
cost,
client_id,
last_modified_user_id,
last_modified_timestamp)

SELECT TOP 10 @InventoryEventId,
--@NextId - id + 1,
inventory_event_list_id,
inventory_item_id,
@BusinessUnitId,
3,
0,
0,
@ClientID,
42,
GETDATE()
FROM Inventory_Event_List 
WHERE inventory_event_id = @InventoryEventId

   INSERT INTO Inventory_Transaction_Queue (
   business_unit_id,
   business_date,
   transaction_type_code,
   inventory_event_id,
   action_code,
   client_id,
   queued_timestamp)
   select 
   @BusinessUnitId,
   @BusinessDate,
   'a',
   @InventoryEventId,
   'p',  
   @ClientId,
   getdate()     
   
   UPDATE  inventory_event
   SET     status_code = 'k'  
   WHERE   business_unit_id = @BusinessUnitId
   AND     inventory_event_id = @InventoryEventId 

   SET @BatchNumber += 1
   
END
   
   SET @CurrentBusinessUnit += 1
	
END

COMMIT TRANSACTION
