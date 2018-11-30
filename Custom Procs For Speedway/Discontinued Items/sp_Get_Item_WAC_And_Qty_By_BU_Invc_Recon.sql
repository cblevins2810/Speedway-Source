IF OBJECT_ID('sp_Get_Item_WAC_And_Qty_By_BU_Invc_Recon') IS NOT NULL
    DROP PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Invc_Recon
GO

CREATE PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_Invc_Recon
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Receivings (non-shipper) which are received and reconciled on different business date
/*INSERT  #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 
*/

SELECT  rsi.inventory_item_id             AS inventory_item_id,
        rd.received_id                    AS received_id,
        rsi.supplier_item_id              AS supplier_item_id,
        ((iri.supplier_price - iri.received_unit_cost) * iri.received_qty) 
                                          AS discrepancy_adj_amt,
        ir.business_date                  AS reconciled_date
 
FROM    received_document                 rd WITH (NOLOCK)

JOIN    received_item                     ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.received_id                    = rd.received_id

JOIN    received_supplier_item            rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = ri.business_unit_id
AND     rsi.received_id                   = ri.received_id
AND     rsi.received_item_id              = ri.received_item_id
AND     rsi.inventory_item_id             IS NOT NULL

JOIN    @discontinued_item 				  di
ON      rsi.inventory_item_id			  = di.resolved_item_id

JOIN  invoice_received_document_list      irdl WITH (NOLOCK)
ON      irdl.received_id                  = rsi.received_id
AND     irdl.business_unit_id             = rsi.business_unit_id

JOIN  invoice_item                        ii WITH (NOLOCK)
ON      ii.invoice_id                     = irdl.invoice_id
AND     ii.supplier_item_id               = rsi.supplier_item_id
AND     ii.business_unit_id               = rsi.business_unit_id

JOIN invoice_reconciliation               ir WITH (NOLOCK)
ON      ir.business_unit_id               = ii.business_unit_id
AND     ir.invoice_id                     = ii.invoice_id

JOIN invoice_reconciliation_item          iri WITH (NOLOCK)
ON      iri.invoice_id                    = ii.invoice_id
AND     iri.invoice_item_id               = ii.invoice_item_id
AND     iri.business_unit_id              = ii.business_unit_id

WHERE   ir.business_unit_id               =  @business_unit_id
AND     ir.business_date                  =  @business_date
AND     ir.business_date                  <> rd.business_date
AND     iri.supplier_price                <> iri.received_unit_cost
AND     ri.shipper_flag                   =  'N'
AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )

UNION ALL
                  
-- Receivings (shipper) which are received and reconciled on different business date
/*INSERT  #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 
*/
SELECT  ricl.inventory_item_id            AS inventory_item_id,
        rd.received_id                    AS received_id,
        rsi.supplier_item_id              AS supplier_item_id,
        ((iri.supplier_price - iri.received_unit_cost) * (ricl.cost_allocation_percentage / 100)* iri.received_qty) 
                                          AS discrepancy_adj_amt,
        ir.business_date                  AS reconciled_date
         
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

JOIN    @discontinued_item 				  di
ON      ricl.inventory_item_id			  = di.resolved_item_id
 
JOIN invoice_received_document_list irdl WITH (NOLOCK)
ON      irdl.received_id                  = rsi.received_id
AND     irdl.business_unit_id             = rsi.business_unit_id
 
JOIN invoice_item              ii WITH (NOLOCK)
ON      ii.invoice_id                     = irdl.invoice_id
AND     ii.supplier_item_id               = rsi.supplier_item_id
AND     ii.business_unit_id               = rsi.business_unit_id

JOIN invoice_reconciliation    ir WITH (NOLOCK)
ON      ir.business_unit_id               = ii.business_unit_id
AND     ir.invoice_id                     = ii.invoice_id
 
JOIN invoice_reconciliation_item  iri WITH (NOLOCK)
ON      iri.invoice_id                    = ii.invoice_id
AND     iri.invoice_item_id               = ii.invoice_item_id
AND     iri.business_unit_id              = ii.business_unit_id
 
WHERE   ir.business_unit_id               =  @business_unit_id
        AND     ir.business_date          =  @business_date
        AND     ir.business_date          <> rd.business_date
        AND     iri.supplier_price        <> iri.received_unit_cost
        AND     ri.shipper_flag           =  'Y'
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = 'y' 
                  )

END


