IF OBJECT_ID('sp_Get_Item_WAC_And_Qty_By_BU_Xfer') IS NOT NULL
    DROP PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Xfer
GO

CREATE PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Xfer
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Transfers
/*INSERT  #f_gen_inv_transfer
(
        inventory_transfer_id,
        inventory_item_id,
        timestamp,
        transfer_type_code,
        atomic_transfer_qty,
        atomic_cost
)
*/
SELECT  it.inventory_transfer_id,
        itil.inventory_item_id,
        it.transfer_timestamp,
        it.reason_code,
        CASE WHEN it.transfer_type_code = 'o' THEN
          -itil.atomic_quantity
        ELSE
          itil.atomic_quantity
        END                             AS atomic_transfer_qty,
        itil.atomic_cost                AS atomic_cost
 
FROM    inventory_transfer              it WITH (NOLOCK)
 
JOIN    inventory_transfer_item_list    itil WITH (NOLOCK)
ON      itil.business_unit_id           = it.business_unit_id
AND     itil.inventory_transfer_id      = it.inventory_transfer_id

JOIN    @discontinued_item di 			
ON      itil.inventory_item_id			= di.resolved_item_id
 
WHERE   it.business_unit_id             = @business_unit_id
AND     it.business_date                = @business_date
AND     it.status_code                  NOT IN ('d', 'a', 'q') -- no draft, action required or requested transfers


END


