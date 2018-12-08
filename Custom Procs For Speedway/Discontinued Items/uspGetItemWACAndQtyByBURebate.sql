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

-- Rebate amts from purchase based rebates
/*INSERT  #f_gen_inv_rebate_accrual_supplier_item_list
(
        item_id,
        non_retroactive_non_withheld_rebate_amt
)
*/
SELECT  rasil.item_id,
        SUM(rasil.rebate_amt)             AS rebate_amt
 
FROM    spwy_eso..rebate_accrual          ra WITH (NOLOCK)
 
JOIN    spwy_eso..rebate_accrual_supplier_item_list rasil WITH (NOLOCK)
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


