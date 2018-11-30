IF OBJECT_ID('sp_Get_Item_WAC_And_Qty_By_BU_Count') IS NOT NULL
    DROP PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Count
GO

CREATE PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Count
@business_unit_id INT,
@business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

/*
INSERT  #f_gen_inv_count
(
        item_count_id,
        inventory_item_id,
        timestamp,
        atomic_count_qty,
        frequency_code  
)
*/

SELECT  ic.item_count_id AS item_count_id,
        oh.inventory_item_id AS inventory_item_id,
        oh.begin_date AS timestamp,
        oh.atomic_total_count AS atomic_count_qty,
        ic.frequency_code AS frequency_code
  
FROM    inventory_count           ic WITH (NOLOCK)
 
JOIN    inventory_item_bu_on_hand oh WITH (NOLOCK)
ON      oh.business_unit_id       = ic.business_unit_id
AND     oh.item_count_id          = ic.item_count_id
 
JOIN    @discontinued_item di
ON		oh.inventory_item_id	  = di.resolved_item_id
 
WHERE   ic.business_unit_id       = @business_unit_id
AND     ic.business_date          = @business_date
AND     ic.status_code            <> 'd'
AND     ic.critical_inventory_flag = 'n'
AND     ic.investment_buy_flag = 'n'  

END


