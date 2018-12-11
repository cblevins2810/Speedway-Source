/*
   This procedure returns a list of items with count details based upon a business unit and date.
   It will include all counts that are not draft and occurred on or after the business date.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBUCount') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBUCount
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBUCount
@business_unit_id INT,
@business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

SELECT  ic.item_count_id AS item_count_id,
        oh.inventory_item_id AS inventory_item_id,
        oh.begin_date AS timestamp,
        oh.atomic_total_count AS atomic_count_qty,
        ic.frequency_code AS frequency_code
  
FROM    VP60_eso..inventory_count ic WITH (NOLOCK)
 
JOIN    VP60_eso..inventory_item_bu_on_hand oh WITH (NOLOCK)
ON      oh.business_unit_id       	= ic.business_unit_id
AND     oh.item_count_id          	= ic.item_count_id
 
JOIN    @discontinued_item di
ON		oh.inventory_item_id		= di.resolved_item_id
 
WHERE   ic.business_unit_id       	= @business_unit_id
AND     ic.business_date          	>= @business_date -- Include all from current date forward
AND     ic.status_code            	<> 'd' -- Do not include draft counts
AND     ic.critical_inventory_flag 	= 'n'
AND     ic.investment_buy_flag 		= 'n'  

END

GO

