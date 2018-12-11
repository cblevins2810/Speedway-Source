/*
   This procedure returns a list of items with transfer details based upon a business unit and date.
   It will include all transfers that are not draft and occurred on or after the business date.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBUXfer') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBUXfer
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBUXfer
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

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
 
FROM    VP60_Spwy..inventory_transfer	it WITH (NOLOCK)
 
JOIN    VP60_Spwy..inventory_transfer_item_list    itil WITH (NOLOCK)
ON      itil.business_unit_id           = it.business_unit_id
AND     itil.inventory_transfer_id      = it.inventory_transfer_id

JOIN    @discontinued_item di 			
ON      itil.inventory_item_id			= di.resolved_item_id
 
WHERE   it.business_unit_id             = @business_unit_id
AND     it.business_date                >= @business_date
AND     it.status_code                  NOT IN ('d', 'a', 'q') -- no draft, action required or requested transfers


END

GO


