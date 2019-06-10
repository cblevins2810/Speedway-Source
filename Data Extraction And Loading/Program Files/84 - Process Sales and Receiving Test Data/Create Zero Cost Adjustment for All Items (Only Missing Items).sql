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

SELECT @BusinessDate = MAX(day_to_close) + 1 FROM bc_extract_replenishment

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
'0006462')

INSERT @InventoryItems (
ii.inventory_item_id)
select distinct (si.item_id) from vp60_eso_wh..f_gen_sales_item_trans as t
join vp60_eso_wh..sales_item as si
on   t.sales_item_id = si.sales_item_id
and  t.sales_item_id <> 0
join item as i
on   si.item_id = i.item_id
and  i.item_type_code = 'i'
where t.bu_id = (SELECT MAX(BusinessUnitId) FROM @BusinessUnitList)
and not exists (select 1 from vp60_eso_wh..F_GEN_INV_ITEM_ACTIVITY_BU_DAY as a
                where  a.bu_id = t.bu_id
				and a.inventory_item_id = si.item_id)


IF @@ROWCOUNT > 0 

BEGIN

SELECT @CurrentBusinessUnit = 1
SELECT @NumberOfBusinessUnits = COUNT(*) FROM @BusinessUnitList

WHILE @CurrentBusinessUnit <= @NumberOfBusinessUnits
BEGIN

	SELECT 	@BusinessUnitId 	= BusinessUnitId
	FROM    @BusinessUnitList
	WHERE	@CurrentBusinessUnit = SequenceNumber  

	SET @BatchNumber = 0

  WHILE @BatchNumber < 1
  
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

--SELECT * FROM @InventoryItems  as i WHERE not exists (SELECT 1 from inventory_item as ii 
--where i.inventory_item_id = ii.inventory_item_id)

SELECT @NumberOfTickets = COUNT(*) FROM @InventoryItems
--WHERE id % 10 = @BatchNumber

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
--WHERE id % 10 = @BatchNumber

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

SELECT @InventoryEventId,
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

END

select * from inventory_event where inventory_event_id = (SELECT MAX(inventory_event_id) FROM inventory_event)
select * from inventory_event_item_list where inventory_event_id = (SELECT MAX(inventory_event_id) FROM inventory_event)
select * from Inventory_Event_List where inventory_event_id = (SELECT MAX(inventory_event_id) FROM inventory_event)



COMMIT TRANSACTION

