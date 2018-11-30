IF OBJECT_ID('sp_Get_Item_WAC_And_Qty_By_BU_Recv_Shipper') IS NOT NULL
    DROP PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Recv_Shipper
GO

CREATE PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Recv_Shipper
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Receivings (shipper) which are received and reconciled on the same day
/*INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
*/
SELECT  ricl.inventory_item_id,
        rd.received_id,
        rsi.supplier_item_id,
        rd.received_date,
        ricl.extended_quantity * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor) 
              AS atomic_qty,
        ri.free_quantity * ricl.quantity * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor) 
              AS atomic_free_quantity,
 
        --Consider the Authorized cost
        ((CASE WHEN (ir.current_action_code <> 1 AND rd.business_date = ir.business_date) THEN
              (iri.supplier_price * (ricl.cost_allocation_percentage / 100)) / 
              (COALESCE((ricl. quantity),0)+ COALESCE((ri.free_quantity * ricl.quantity),0))
        ELSE
              ricl.cost
        END) / COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)) 
              AS atomic_cost
 
FROM    received_document                 rd WITH (NOLOCK)
 
JOIN    received_item                     ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.received_id                    = rd.received_id
 
JOIN    received_supplier_item            rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = ri.business_unit_id
AND     rsi.received_id                   = ri.received_id
AND     rsi.received_item_id              = ri.received_item_id
 
JOIN    received_item_component_list      ricl WITH (NOLOCK)
ON      ricl.business_unit_id             = ri.business_unit_id
AND     ricl.received_id                  = ri.received_id
AND     ricl.received_item_id             = ri.received_item_id

JOIN 	@discontinued_item di
ON   	ricl.inventory_item_id			  = di.resolved_item_id
 
LEFT OUTER JOIN invoice_received_document_list irdl WITH (NOLOCK)
ON      irdl.received_id                  = rsi.received_id
AND     irdl.business_unit_id             = rsi.business_unit_id
 
LEFT OUTER JOIN invoice_item              ii WITH (NOLOCK)
ON      ii.invoice_id                     = irdl.invoice_id
AND     ii.supplier_item_id               = rsi.supplier_item_id
AND     ii.business_unit_id               = rsi.business_unit_id
 
LEFT OUTER JOIN invoice_reconciliation_item  iri WITH (NOLOCK)
ON      iri.invoice_id                    = ii.invoice_id
AND     iri.invoice_item_id               = ii.invoice_item_id
AND     iri.business_unit_id              = ii.business_unit_id
 
LEFT OUTER JOIN invoice_reconciliation    ir WITH (NOLOCK)
ON      ir.business_unit_id               = ii.business_unit_id
AND     ir.invoice_id                     = ii.invoice_id
 
JOIN    unit_of_measure                   uom WITH (NOLOCK)
ON      uom.unit_of_measure_id            = ricl.unit_of_measure_id
 
LEFT OUTER JOIN item_uom_conversion       uomcv WITH (NOLOCK)
ON      uomcv.item_id                     = ricl.inventory_item_id
AND     uomcv.unit_of_measure_class_id    = uom.unit_of_measure_class_id
 
WHERE   rd.business_unit_id               = @business_unit_id
AND     rd.business_date                  = @business_date
AND     rd.status_code                    <> 'd'
AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )      

END


