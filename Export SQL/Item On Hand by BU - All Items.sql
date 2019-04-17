DECLARE @business_unit_id   int
DECLARE @bu_code VARCHAR(100)
DECLARE @timestampString CHAR(14)
DECLARE @bu_local_time DATETIME
DECLARE @bu_local_timestring VARCHAR(50)

CREATE TABLE #inventory_items (inventory_item_id INT PRIMARY KEY)

INSERT #inventory_items
SELECT ii.inventory_item_id
FROM   inventory_item AS ii
   
SELECT
@bu_code = name,
@bu_local_time = lt.current_bu_local_time
FROM  Rad_Sys_Data_Accessor WITH (NOLOCK)
JOIN  plt_Get_BU_Local_Time_View  lt   WITH (NOLOCK)
ON    lt.business_unit_id  = @business_unit_id
WHERE  data_Accessor_id = @business_unit_id

SELECT  @bu_local_timestring = REPLACE(REPLACE(REPLACE (CONVERT(VARCHAR,@bu_local_time,120),'-',''),' ',''),':','')
  
DELETE Inventory_Item_BU_On_Hand_Export_List
WHERE business_unit_id    =  @business_unit_id
             
INSERT Inventory_Item_BU_On_Hand_Export_List (
business_unit_id,
inventory_item_id,
atomic_quantity,
last_modified_timestamp,
last_modified_user_id,
client_id)

SELECT @business_unit_id,
oh.inventory_item_id,
oh.atomic_quantity,
CURRENT_TIMESTAMP,
42,
oh.client_id


FROM (SELECT
      oh.inventory_item_id, 
      ISNULL(oh.atomic_total_count,0)+ISNULL(ohl.atomic_transaction_quantity,0) atomic_quantity,
	  oh.client_id
      FROM Inventory_Item_BU_On_Hand  oh WITH (NOLOCK)
      JOIN #Inventory_Items i
      ON i.inventory_item_id = oh.inventory_item_id
      OUTER APPLY ( SELECT
                    SUM(ohl.atomic_transaction_quantity) atomic_transaction_quantity
                    FROM Inventory_Item_BU_On_Hand_list      ohl WITH (NOLOCK)
                    WHERE ohl.business_unit_id  = @business_unit_id
                    AND ohl.inventory_item_id = oh.inventory_item_id
                    AND ohl.begin_date       >= oh.begin_date 
                    AND ohl.begin_date       <  @bu_local_time ) ohl
      WHERE oh.business_unit_id    =  @business_unit_id
      AND oh.begin_date <= @bu_local_time
      AND oh.end_date > @bu_local_time ) oh
                 
SELECT
@bu_code bu_code,
@timestampString local_bu_time,
inventory_item_id internal_item_id,
i.xref_code external_item_id,
atomic_quantity     atomic_quantity              
FROM Inventory_Item_BU_On_Hand_Export_List AS l
JOIN Item AS i
ON   l.inventory_item_id = i.item_id
WHERE business_unit_id = @business_unit_id
ORDER  by business_unit_id, inventory_item_id

DROP TABLE #inventory_items



  