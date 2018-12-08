USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBURecv') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBURecv
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBURecv
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Receivings (non shipper) which are received and reconciled on the same day
/*INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)*/

SELECT  recv.inventory_item_id,
        recv.received_id,
        recv.supplier_item_id,
        recv.received_date AS recv_date,
        SUM(recv.atomic_qty),
        SUM(recv.atomic_free_quantity),
        MAX(recv.atomic_cost)
FROM
(
        SELECT  rsi.inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
 
                CASE WHEN ri.catch_weight_flag = 'y' THEN
                  COALESCE(ri.priced_in_quantity, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                ELSE
                  COALESCE(ri.packaged_in_quantity, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)
                END AS atomic_qty,
                             
                CASE WHEN (ri.catch_weight_flag = 'y' AND ri.priced_in_uom_flag = 'y') THEN
                  COALESCE(ri.free_quantity, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                ELSE 
                  CASE WHEN ri.catch_weight_flag = 'y' THEN 
                    COALESCE(ri.free_quantity, 0) * ri.package_weight * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                  ELSE 
                    COALESCE(ri.free_quantity, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)
                  END
                END AS atomic_free_quantity,
     
                CASE WHEN ri.catch_weight_flag = 'y' THEN
                  --Consider the Authorized cost
                  (CASE WHEN (ir.current_action_code <> 1 AND rd.business_date = ir.business_date) THEN
                    iri.supplier_price
                  ELSE
                    ri.supplier_price
                  END) / COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                ELSE
                  --Consider the Authorized cost
                  (CASE WHEN (ir.current_action_code <> 1 AND rd.business_date = ir.business_date) THEN
                    iri.supplier_price
                  ELSE
                    ri.supplier_price
                  END) / COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)
                END AS atomic_cost
    
        FROM    spwy_eso..received_document                 rd WITH (NOLOCK)
        
        JOIN    spwy_eso..received_item                     ri
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        
        JOIN    spwy_eso..received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        AND     rsi.inventory_item_id             IS NOT NULL
        
        LEFT OUTER JOIN spwy_eso..invoice_received_document_list irdl WITH (NOLOCK)
        ON      irdl.received_id                  = rsi.received_id
        AND     irdl.business_unit_id             = rsi.business_unit_id
    
        LEFT OUTER JOIN spwy_eso..invoice_item              ii WITH (NOLOCK)
        ON      ii.invoice_id                     = irdl.invoice_id
        AND     ii.supplier_item_id               = rsi.supplier_item_id
        AND     ii.business_unit_id               = rsi.business_unit_id
    
        LEFT OUTER JOIN spwy_eso..invoice_reconciliation_item  iri WITH (NOLOCK)
        ON      iri.invoice_id                    = ii.invoice_id
        AND     iri.invoice_item_id               = ii.invoice_item_id
        AND     iri.business_unit_id              = ii.business_unit_id
    
        LEFT OUTER JOIN spwy_eso..invoice_reconciliation    ir WITH (NOLOCK)
        ON      ir.business_unit_id               = ii.business_unit_id
        AND     ir.invoice_id                     = ii.invoice_id
 
        JOIN    spwy_eso..unit_of_measure                   uompkg WITH (NOLOCK)
        ON      uompkg.unit_of_measure_id         = rsi.packaged_in_uom_id
        
        LEFT OUTER JOIN spwy_eso..unit_of_measure           uomprc WITH (NOLOCK)
        ON      uomprc.unit_of_measure_id         = rsi.priced_in_uom_id
        
        LEFT OUTER JOIN spwy_eso..item_uom_conversion       uomcvpkg WITH (NOLOCK)
        ON      uomcvpkg.item_id                  = rsi.inventory_item_id
        AND     uomcvpkg.unit_of_measure_class_id = uompkg.unit_of_measure_class_id
        
        LEFT OUTER JOIN spwy_eso..item_uom_conversion       uomcvprc WITH (NOLOCK)
        ON      uomcvprc.item_id                  = rsi.inventory_item_id
        AND     uomcvprc.unit_of_measure_class_id = uomprc.unit_of_measure_class_id
        
        WHERE   rd.business_unit_id               = @business_unit_id
        AND     rd.business_date                  >= @business_date
        AND     rd.status_code                    <> 'd'
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM spwy_eso..purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )

        UNION ALL
        
        SELECT  ri.crate_inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
        
                COALESCE(ri.packaged_in_quantity, 0) + 
                  COALESCE(ri.free_quantity, 0)   AS atomic_qty,
                
                NULL                              AS atomic_free_quantity, -- since we're not tracking cost we don't bother splitting free value
                NULL                              AS atomic_cost
        
        FROM    spwy_eso..received_document                 rd WITH (NOLOCK)
        
        JOIN    spwy_eso..received_item                     ri WITH (NOLOCK)
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        AND     ri.crate_inventory_item_id        IS NOT NULL
        
        JOIN    spwy_eso..received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        
        WHERE   rd.business_unit_id               = @business_unit_id
        AND     rd.business_date                  >= @business_date
        AND     rd.status_code                    <> 'd' 
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM spwy_eso..purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )

        UNION ALL
        
        SELECT  ri.bottle_inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
        
                (COALESCE(ri.packaged_in_quantity, 0) + 
                  COALESCE(ri.free_quantity, 0)) * COALESCE(ri.bottle_to_crate_factor, 0) 
                                                  AS atomic_qty,
                
                NULL                              AS atomic_free_quantity, -- since we're not tracking cost we don't bother splitting free value
                NULL                              AS atomic_cost
        
        FROM    spwy_eso..received_document                 rd WITH (NOLOCK)
        
        JOIN    spwy_eso..received_item                     ri WITH (NOLOCK)
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        AND     ri.bottle_inventory_item_id       IS NOT NULL
        
        JOIN    spwy_eso..received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        
        WHERE   rd.business_unit_id               = @business_unit_id
        AND     rd.business_date                  >= @business_date
        AND     rd.status_code                    <> 'd' 
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM spwy_eso..purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )

) recv
JOIN 	@discontinued_item di
ON   	recv.inventory_item_id = di.resolved_item_id
GROUP BY recv.inventory_item_id,
        recv.received_id,
        recv.supplier_item_id,
        recv.received_date        

END


