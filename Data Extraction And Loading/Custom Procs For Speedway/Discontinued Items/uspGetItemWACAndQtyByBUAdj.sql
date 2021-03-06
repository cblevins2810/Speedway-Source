/*
   This procedure returns a list of items with adjustment details based upon a business unit and date.
   It will include all adjustments that are not draft and occurred on or after the business date.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBUAdj') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBUAdj
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBUAdj
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Adjustments

SELECT  ie.inventory_event_id, 
        ieil.inventory_event_list_id,
        ieil.inventory_item_id,
        ie.event_timestamp,
        ie.reason_code,
        -- production usage quantity is stored as negative in WH, waste is stored as positive
        CASE WHEN ie.reason_code = 'w' THEN -1 ELSE 1 END * COALESCE(ieil.quantity, 0)
         * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)
                                         AS atomic_event_qty, 
        COALESCE(ieil.cost,0) / COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)
                                         AS atomic_cost, 
        CASE WHEN (ie.reason_code = 'w' OR (ie.reason_code = 'p' AND iel.inventory_item_id != ieil.inventory_item_id))
             THEN -1 
             ELSE 1 
        END * COALESCE(ieil.quantity,0)* COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor) 
                                         AS production_usage_qty,
                                     
        CASE WHEN ie.reason_code = 'a' AND r.include_in_gross_margin_report_with_rebates_flag = 'y' 
             THEN 'y'
             ELSE 'n'
        END                              AS include_in_gross_margin_report_with_rebates_flag                               

FROM    VP60_Spwy..inventory_event_list  iel WITH (NOLOCK)

JOIN    VP60_Spwy..inventory_event ie     WITH (NOLOCK)
ON      ie.business_unit_id              = iel.business_unit_id
AND     ie.inventory_event_id            = iel.inventory_event_id

JOIN    VP60_Spwy..inventory_event_item_list   ieil WITH (NOLOCK)
ON      iel.business_unit_id             = ieil.business_unit_id
AND     iel.inventory_event_id           = ieil.inventory_event_id
AND     iel.inventory_event_list_id      = ieil.inventory_event_list_id

JOIN    @discontinued_item di
ON      ieil.inventory_item_id			 = di.resolved_item_id

JOIN    VP60_Spwy..unit_of_measure        uom WITH (NOLOCK)
ON      uom.unit_of_measure_id           = ieil.unit_of_measure_id

LEFT OUTER JOIN VP60_Spwy..item_uom_conversion      uomcv WITH (NOLOCK)
ON      uomcv.item_id                    = ieil.inventory_item_id
AND     uomcv.unit_of_measure_class_id   = uom.unit_of_measure_class_id

LEFT OUTER JOIN VP60_Spwy..reason         r WITH (NOLOCK)
ON    r.reason_id                        = iel.reason_id

WHERE ie.business_unit_id                = @business_unit_id
AND   ie.business_date                   >= @business_date -- Include everything from the passed in date forward
AND   ie.status_code                     <> 'd' -- Consider all but draft
AND   ie.status_code                     <> 'w' -- w is for workflow and should be ignored 
END

GO


