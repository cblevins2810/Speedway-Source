/*
   This procedure returns a list of items with rebate details based upon a business unit and date.
   It will include all rebates that are not draft and occurred on or after the business date.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBURebate') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBURebate
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBURebate
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

SELECT  rasil.item_id,
        SUM(rasil.rebate_amt)             AS rebate_amt
 
FROM    VP60_Spwy..rebate_accrual          ra WITH (NOLOCK)
 
JOIN    VP60_Spwy..rebate_accrual_supplier_item_list rasil WITH (NOLOCK)
ON      rasil.business_unit_id            = ra.business_unit_id
AND     rasil.rebate_accrual_id           = ra.rebate_accrual_id
AND     rasil.lost_reason_code            = 'n'
AND     rasil.item_id                     IS NOT NULL

JOIN    @discontinued_item                di
ON      rasil.item_id					  = di.resolved_item_id
 
WHERE   ra.business_unit_id               = @business_unit_id
AND     ra.business_date                  >= @business_date
AND     ra.status_code                    IN ('d', 'p')
AND     ra.retroactive_type_code          = 'n'
AND     ra.withheld_flag                  = 'n'
 
GROUP BY rasil.item_id

END

GO


