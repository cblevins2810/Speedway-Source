/*
   This procedure returns a list of items with return details based upon a business unit and date.
   It will include all returns that are not draft and occurred on or after the business date.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBUReturn') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBUReturn
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBUReturn
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Returns (non-shipper)
/*INSERT  #f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)
*/
SELECT  rd.return_id,
        rsi.supplier_item_id,
        rsi.inventory_item_id,
        rd.return_date,
        CASE WHEN ri.catch_weight_flag = 'y' THEN   
          COALESCE(ri.priced_in_quantity_returned, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)     
        ELSE
          COALESCE(ri.packaged_in_quantity_returned, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)        
        END                               AS atomic_qty
 
FROM    spwy_eso..return_document                   rd WITH (NOLOCK)
 
JOIN    spwy_eso..return_item                       ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.return_id                      = rd.return_id
 
JOIN    spwy_eso..return_supplier_item              rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = rd.business_unit_id
AND     rsi.return_id                     = rd.return_id
AND     rsi.return_item_id                = ri.return_item_id
AND     rsi.inventory_item_id             IS NOT NULL
 
JOIN    @discontinued_item                di
ON      rsi.inventory_item_id             = di.resolved_item_id
 
JOIN    spwy_eso..unit_of_measure                   uompkg WITH (NOLOCK)
ON      uompkg.unit_of_measure_id         = rsi.packaged_in_uom_id
 
LEFT OUTER JOIN spwy_eso..unit_of_measure           uomprc WITH (NOLOCK)
ON      uomprc.unit_of_measure_id         = rsi.priced_in_uom_id
 
LEFT OUTER JOIN spwy_eso..item_uom_conversion       uomcvpkg WITH (NOLOCK)
ON      uomcvpkg.unit_of_measure_class_id = uompkg.unit_of_measure_class_id
AND     uomcvpkg.item_Id                  = rsi.inventory_item_id
 
LEFT OUTER JOIN spwy_eso..item_uom_conversion       uomcvprc WITH (NOLOCK)
ON      uomcvprc.item_id                  = rsi.inventory_item_id
AND     uomcvprc.unit_of_measure_class_id = uomprc.unit_of_measure_class_id
 
WHERE   rd.business_unit_id               = @business_unit_id
AND     rd.business_date                  >= @business_date
AND     rd.status_code                    NOT IN ('d', 's') -- no draft or submitted returns
AND     NOT EXISTS( SELECT 1                                -- not to include returns having non-saleable quantity
                      FROM spwy_eso..received_document  AS recd
                      JOIN spwy_eso..purchase_order     AS po
                        ON recd.purchase_order_id = po.purchase_order_id
                       AND rd.received_id         = recd.received_id
                     WHERE po.investment_buy_flag = 'y'
                  )

-- Returns (shipper)
/*INSERT  #f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)*/
UNION ALL
SELECT  rd.return_id,
        rsi.supplier_item_id,
        ricl.inventory_item_id,
        rd.return_date,
        ricl.extended_quantity * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)   
                                          AS atomic_qty
 
FROM    spwy_eso..return_document                   rd WITH (NOLOCK)
 
JOIN    spwy_eso..return_item                       ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.return_id                      = rd.return_id
 
JOIN    spwy_eso..return_supplier_item              rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = rd.business_unit_id
AND     rsi.return_id                     = rd.return_id
AND     rsi.return_item_id                = ri.return_item_id
 
JOIN    spwy_eso..return_item_component_list        ricl WITH (NOLOCK)
ON      ricl.business_unit_id             = rd.business_unit_id
AND     ricl.return_id                    = rd.return_id
AND     ricl.return_item_id               = ri.return_item_id

JOIN    @discontinued_item                di
ON      ricl.inventory_item_id            = di.resolved_item_id
 
JOIN    spwy_eso..unit_of_measure                   uom WITH (NOLOCK)
ON      uom.unit_of_measure_id            = ricl.unit_of_measure_id
 
LEFT OUTER JOIN spwy_eso..item_uom_conversion       uomcv WITH (NOLOCK)
ON      uomcv.item_id                     = rsi.inventory_item_id
AND     uomcv.unit_of_measure_class_id    = uom.unit_of_measure_class_id
 
WHERE   rd.business_unit_id               = @business_unit_id
AND     rd.business_date                  >= @business_date
AND     rd.status_code                    NOT IN ('d', 's') -- no draft or submitted returns
AND     NOT EXISTS( SELECT 1                                -- not to include returns having non-saleable quantity
                      FROM spwy_eso..received_document  AS recd
                      JOIN spwy_eso..purchase_order     AS po
                        ON recd.purchase_order_id = po.purchase_order_id
                       AND rd.received_id         = recd.received_id
                     WHERE po.investment_buy_flag = 'y'
                  )

END

GO

