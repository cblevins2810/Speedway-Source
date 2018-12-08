/*
   This procedure returns a list of items with reconciliation adjustment details based upon a business unit and date.
   It will include all reconciliation adjustments that are not draft and occurred on or after the business date.
   This procedure handles both items and items within shipper supplier items.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBUInvcRecon') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBUInvcRecon
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBUInvcRecon
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

-- Receivings (non-shipper) which are received and reconciled on different business date


SELECT  rsi.inventory_item_id             AS inventory_item_id,
        rd.received_id                    AS received_id,
        rsi.supplier_item_id              AS supplier_item_id,
        ((iri.supplier_price - iri.received_unit_cost) * iri.received_qty) 
                                          AS discrepancy_adj_amt,
        ir.business_date                  AS reconciled_date
 
FROM    spwy_eso..received_document       	rd WITH (NOLOCK)

JOIN    spwy_eso..received_item	          	ri WITH (NOLOCK)
ON      ri.business_unit_id               	= rd.business_unit_id
AND     ri.received_id                    	= rd.received_id

JOIN    spwy_eso..received_supplier_item	rsi WITH (NOLOCK)
ON      rsi.business_unit_id              	= ri.business_unit_id
AND     rsi.received_id                   	= ri.received_id
AND     rsi.received_item_id              	= ri.received_item_id
AND     rsi.inventory_item_id             	IS NOT NULL

JOIN    @discontinued_item 				  	di
ON      rsi.inventory_item_id			  	= di.resolved_item_id

JOIN  	spwy_eso..invoice_received_document_list      irdl WITH (NOLOCK)
ON      irdl.received_id                  	= rsi.received_id
AND     irdl.business_unit_id             	= rsi.business_unit_id

JOIN  	spwy_eso..invoice_item              ii WITH (NOLOCK)
ON      ii.invoice_id                     	= irdl.invoice_id
AND     ii.supplier_item_id               	= rsi.supplier_item_id
AND     ii.business_unit_id               	= rsi.business_unit_id

JOIN 	spwy_eso..invoice_reconciliation    ir WITH (NOLOCK)
ON      ir.business_unit_id               	= ii.business_unit_id
AND     ir.invoice_id                     	= ii.invoice_id

JOIN 	spwy_eso..invoice_reconciliation_item          iri WITH (NOLOCK)
ON      iri.invoice_id                    	= ii.invoice_id
AND     iri.invoice_item_id               	= ii.invoice_item_id
AND     iri.business_unit_id              	= ii.business_unit_id

WHERE   ir.business_unit_id               	=  @business_unit_id
AND     ir.business_date                  	>=  @business_date
AND     ir.business_date                  	<> rd.business_date
AND     iri.supplier_price                	<> iri.received_unit_cost
AND     ri.shipper_flag                   	=  'N'
AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM spwy_eso..purchase_order po
                     WHERE rd.purchase_order_id 	= po.purchase_order_id
                       AND po.investment_buy_flag 	= 'y' 
                  )

UNION ALL
                  
-- Receivings (shipper) which are received and reconciled on different business date

SELECT  ricl.inventory_item_id            AS inventory_item_id,
        rd.received_id                    AS received_id,
        rsi.supplier_item_id              AS supplier_item_id,
        ((iri.supplier_price - iri.received_unit_cost) * (ricl.cost_allocation_percentage / 100)* iri.received_qty) 
                                          AS discrepancy_adj_amt,
        ir.business_date                  AS reconciled_date
         
FROM    spwy_eso..received_document         rd WITH (NOLOCK)
 
JOIN    spwy_eso..received_item             ri WITH (NOLOCK)
ON      ri.business_unit_id					= rd.business_unit_id
AND     ri.received_id                    	= rd.received_id
 
JOIN    spwy_eso..received_supplier_item    rsi WITH (NOLOCK)
ON      rsi.business_unit_id              	= ri.business_unit_id
AND     rsi.received_id                   	= ri.received_id
AND     rsi.received_item_id              	= ri.received_item_id
 
JOIN    spwy_eso..received_item_component_list      ricl WITH (NOLOCK)
ON      ricl.business_unit_id             	= ri.business_unit_id
AND     ricl.received_id                  	= ri.received_id
AND     ricl.received_item_id             	= ri.received_item_id

JOIN    @discontinued_item 				  	di
ON      ricl.inventory_item_id			  	= di.resolved_item_id
 
JOIN 	spwy_eso..invoice_received_document_list irdl WITH (NOLOCK)
ON      irdl.received_id                 	= rsi.received_id
AND     irdl.business_unit_id             	= rsi.business_unit_id
 
JOIN 	spwy_eso..invoice_item              ii WITH (NOLOCK)
ON      ii.invoice_id                     	= irdl.invoice_id
AND     ii.supplier_item_id               	= rsi.supplier_item_id
AND     ii.business_unit_id               	= rsi.business_unit_id

JOIN 	spwy_eso..invoice_reconciliation    ir WITH (NOLOCK)
ON      ir.business_unit_id               	= ii.business_unit_id
AND     ir.invoice_id                     	= ii.invoice_id
 
JOIN 	spwy_eso..invoice_reconciliation_item  iri WITH (NOLOCK)
ON      iri.invoice_id                    	= ii.invoice_id
AND     iri.invoice_item_id               	= ii.invoice_item_id
AND     iri.business_unit_id              	= ii.business_unit_id
 
WHERE   ir.business_unit_id               	=  @business_unit_id
        AND     ir.business_date          	>=  @business_date
        AND     ir.business_date          	<> rd.business_date
        AND     iri.supplier_price        	<> iri.received_unit_cost
        AND     ri.shipper_flag           	=  'Y'
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM spwy_eso..purchase_order po
                     WHERE rd.purchase_order_id 	= po.purchase_order_id
                       AND po.investment_buy_flag 	= 'y' 
                  )

END

GO


