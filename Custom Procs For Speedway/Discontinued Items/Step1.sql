exec sp_executesql @statement=N'--{1000397} 
/*Applications.Inventory.WaveDO.RadPost.ItemActivityBUDay  CollectDailyTransactionsFromWave*/
-- Counts
INSERT  #f_gen_inv_count
(
        item_count_id,
        inventory_item_id,
        timestamp,
        atomic_count_qty,
        frequency_code  
)
SELECT  ic.item_count_id,
        oh.inventory_item_id,
        oh.begin_date,
        oh.atomic_total_count,
        ic.frequency_code
  
FROM    inventory_count           ic WITH (NOLOCK)
 
JOIN    inventory_item_bu_on_hand oh WITH (NOLOCK)
ON      oh.business_unit_id       = ic.business_unit_id
AND     oh.item_count_id          = ic.item_count_id
 
WHERE   ic.business_unit_id       = @bu_id
AND     ic.business_date          = @business_date
AND     ic.status_code            <> ''d''
AND     ic.critical_inventory_flag = ''n''
AND     ic.investment_buy_flag = ''n''  

-- Receivings (non shipper) which are received and reconciled on the same day
INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
SELECT  recv.inventory_item_id,
        recv.received_id,
        recv.supplier_item_id,
        recv.received_date,
        SUM(recv.atomic_qty),
        SUM(recv.atomic_free_quantity),
        MAX(recv.atomic_cost)
FROM
(
        SELECT  rsi.inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
 
                CASE WHEN ri.catch_weight_flag = ''y'' THEN
                  COALESCE(ri.priced_in_quantity, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                ELSE
                  COALESCE(ri.packaged_in_quantity, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)
                END AS atomic_qty,
                             
                CASE WHEN (ri.catch_weight_flag = ''y'' AND ri.priced_in_uom_flag = ''y'') THEN
                  COALESCE(ri.free_quantity, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                ELSE 
                  CASE WHEN ri.catch_weight_flag = ''y'' THEN 
                    COALESCE(ri.free_quantity, 0) * ri.package_weight * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)
                  ELSE 
                    COALESCE(ri.free_quantity, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)
                  END
                END AS atomic_free_quantity,
     
                CASE WHEN ri.catch_weight_flag = ''y'' THEN
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
    
        FROM    received_document                 rd WITH (NOLOCK)
        
        JOIN    received_item                     ri
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        
        JOIN    received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        AND     rsi.inventory_item_id             IS NOT NULL
        
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
 
        JOIN    unit_of_measure                   uompkg WITH (NOLOCK)
        ON      uompkg.unit_of_measure_id         = rsi.packaged_in_uom_id
        
        LEFT OUTER JOIN unit_of_measure           uomprc WITH (NOLOCK)
        ON      uomprc.unit_of_measure_id         = rsi.priced_in_uom_id
        
        LEFT OUTER JOIN item_uom_conversion       uomcvpkg WITH (NOLOCK)
        ON      uomcvpkg.item_id                  = rsi.inventory_item_id
        AND     uomcvpkg.unit_of_measure_class_id = uompkg.unit_of_measure_class_id
        
        LEFT OUTER JOIN item_uom_conversion       uomcvprc WITH (NOLOCK)
        ON      uomcvprc.item_id                  = rsi.inventory_item_id
        AND     uomcvprc.unit_of_measure_class_id = uomprc.unit_of_measure_class_id
        
        WHERE   rd.business_unit_id               = @bu_id
        AND     rd.business_date                  = @business_date
        AND     rd.status_code                    <> ''d''
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )

        UNION ALL
        
        SELECT  ri.crate_inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
        
                COALESCE(ri.packaged_in_quantity, 0) + 
                  COALESCE(ri.free_quantity, 0)   AS atomic_qty,
                
                NULL                              AS atomic_free_quantity, -- since we''re not tracking cost we don''t bother splitting free value
                NULL                              AS atomic_cost
        
        FROM    received_document                 rd WITH (NOLOCK)
        
        JOIN    received_item                     ri WITH (NOLOCK)
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        AND     ri.crate_inventory_item_id        IS NOT NULL
        
        JOIN    received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        
        WHERE   rd.business_unit_id               = @bu_id
        AND     rd.business_date                  = @business_date
        AND     rd.status_code                    <> ''d'' 
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )

        UNION ALL
        
        SELECT  ri.bottle_inventory_item_id,
                rd.received_id,
                rsi.supplier_item_id,
                rd.received_date,
        
                (COALESCE(ri.packaged_in_quantity, 0) + 
                  COALESCE(ri.free_quantity, 0)) * COALESCE(ri.bottle_to_crate_factor, 0) 
                                                  AS atomic_qty,
                
                NULL                              AS atomic_free_quantity, -- since we''re not tracking cost we don''t bother splitting free value
                NULL                              AS atomic_cost
        
        FROM    received_document                 rd WITH (NOLOCK)
        
        JOIN    received_item                     ri WITH (NOLOCK)
        ON      ri.business_unit_id               = rd.business_unit_id
        AND     ri.received_id                    = rd.received_id
        AND     ri.bottle_inventory_item_id       IS NOT NULL
        
        JOIN    received_supplier_item            rsi WITH (NOLOCK)
        ON      rsi.business_unit_id              = ri.business_unit_id
        AND     rsi.received_id                   = ri.received_id
        AND     rsi.received_item_id              = ri.received_item_id
        
        WHERE   rd.business_unit_id               = @bu_id
        AND     rd.business_date                  = @business_date
        AND     rd.status_code                    <> ''d'' 
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )

) recv
GROUP BY recv.inventory_item_id,
        recv.received_id,
        recv.supplier_item_id,
        recv.received_date        
 
-- Receivings (shipper) which are received and reconciled on the same day
INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
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
 
WHERE   rd.business_unit_id               = @bu_id
AND     rd.business_date                  = @business_date
AND     rd.status_code                    <> ''d''
AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )

-- Receivings (non-shipper) which are received and reconciled on different business date
INSERT  #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 

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

WHERE   ir.business_unit_id               =  @bu_id
AND     ir.business_date                  =  @business_date
AND     ir.business_date                  <> rd.business_date
AND     iri.supplier_price                <> iri.received_unit_cost
AND     ri.shipper_flag                   =  ''N''
AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )
                  
-- Receivings (shipper) which are received and reconciled on different business date
INSERT  #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 
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
 
WHERE   ir.business_unit_id               =  @bu_id
        AND     ir.business_date          =  @business_date
        AND     ir.business_date          <> rd.business_date
        AND     iri.supplier_price        <> iri.received_unit_cost
        AND     ri.shipper_flag           =  ''Y''
        AND     NOT EXISTS( SELECT 1                          --not to include receivings having non-saleable quantity
                      FROM purchase_order AS po
                     WHERE rd.purchase_order_id = po.purchase_order_id
                       AND po.investment_buy_flag = ''y'' 
                  )
-- Adjustments
INSERT  #f_gen_inv_adjustment
(
        inventory_event_id,
        inventory_event_list_id,
        inventory_item_id,
        timestamp,
        adjustment_type_code,
        atomic_event_qty,
        atomic_cost,
        production_usage_qty,
        include_in_gross_margin_report_with_rebates_flag
)

SELECT  ie.inventory_event_id, 
        ieil.inventory_event_list_id,
        ieil.inventory_item_id,
        ie.event_timestamp,
        ie.reason_code,
        -- production usage quantity is stored as negative in WH, waste is stored as positive
        CASE WHEN ie.reason_code = ''w'' THEN -1 ELSE 1 END * COALESCE(ieil.quantity, 0)
         * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)
                                         AS atomic_event_qty, 
        COALESCE(ieil.cost,0) / COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)
                                         AS atomic_cost, 
        CASE WHEN (ie.reason_code = ''w'' OR (ie.reason_code = ''p'' AND iel.inventory_item_id != ieil.inventory_item_id))
             THEN -1 
             ELSE 1 
        END * COALESCE(ieil.quantity,0)* COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor) 
                                         AS production_usage_qty,
                                     
        CASE WHEN ie.reason_code = ''a'' AND r.include_in_gross_margin_report_with_rebates_flag = ''y'' 
             THEN ''y''
             ELSE ''n''
        END                              AS include_in_gross_margin_report_with_rebates_flag                               

FROM    inventory_event_list             iel WITH (NOLOCK)

JOIN    inventory_event ie                WITH (NOLOCK)
ON      ie.business_unit_id              = iel.business_unit_id
AND     ie.inventory_event_id            = iel.inventory_event_id

JOIN    inventory_event_item_list   ieil WITH (NOLOCK)
ON      iel.business_unit_id             = ieil.business_unit_id
AND     iel.inventory_event_id           = ieil.inventory_event_id
AND     iel.inventory_event_list_id      = ieil.inventory_event_list_id

JOIN    unit_of_measure                  uom WITH (NOLOCK)
ON      uom.unit_of_measure_id           = ieil.unit_of_measure_id

LEFT OUTER JOIN item_uom_conversion      uomcv WITH (NOLOCK)
ON      uomcv.item_id                    = ieil.inventory_item_id
AND     uomcv.unit_of_measure_class_id   = uom.unit_of_measure_class_id

LEFT OUTER JOIN reason                   r WITH (NOLOCK)
ON    r.reason_id                        = iel.reason_id

WHERE ie.business_unit_id                = @bu_id
AND   ie.business_date                   = @business_date
AND   ie.status_code                     <> ''d''
AND   ie.status_code                     <> ''w'' /* Added by JIB.C2.1: ''''w'''' is for workflow and should be ignored WIT#1085024*/

-- Transfers
INSERT  #f_gen_inv_transfer
(
        inventory_transfer_id,
        inventory_item_id,
        timestamp,
        transfer_type_code,
        atomic_transfer_qty,
        atomic_cost
)
SELECT  it.inventory_transfer_id,
        itil.inventory_item_id,
        it.transfer_timestamp,
        it.reason_code,
        CASE WHEN it.transfer_type_code = ''o'' THEN
          -itil.atomic_quantity
        ELSE
          itil.atomic_quantity
        END                             AS atomic_transfer_qty,
        itil.atomic_cost                AS atomic_cost
 
FROM    inventory_transfer              it WITH (NOLOCK)
 
JOIN    inventory_transfer_item_list    itil WITH (NOLOCK)
ON      itil.business_unit_id           = it.business_unit_id
AND     itil.inventory_transfer_id      = it.inventory_transfer_id
 
WHERE   it.business_unit_id             = @bu_id
AND     it.business_date                = @business_date
AND     it.status_code                  NOT IN (''d'', ''a'', ''q'') -- no draft, action required or requested transfers
 
-- Returns (non-shipper)
INSERT  #f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)
SELECT  rd.return_id,
        rsi.supplier_item_id,
        rsi.inventory_item_id,
        rd.return_date,
        CASE WHEN ri.catch_weight_flag = ''y'' THEN   
          COALESCE(ri.priced_in_quantity_returned, 0) * COALESCE(uomcvprc.atomic_conversion_factor * uomprc.factor, uomprc.factor)     
        ELSE
          COALESCE(ri.packaged_in_quantity_returned, 0) * COALESCE(uomcvpkg.atomic_conversion_factor * uompkg.factor, uompkg.factor)        
        END                               AS atomic_qty
 
FROM    return_document                   rd WITH (NOLOCK)
 
JOIN    return_item                       ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.return_id                      = rd.return_id
 
JOIN    return_supplier_item              rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = rd.business_unit_id
AND     rsi.return_id                     = rd.return_id
AND     rsi.return_item_id                = ri.return_item_id
AND     rsi.inventory_item_id             IS NOT NULL
 
JOIN    unit_of_measure                   uompkg WITH (NOLOCK)
ON      uompkg.unit_of_measure_id         = rsi.packaged_in_uom_id
 
LEFT OUTER JOIN unit_of_measure           uomprc WITH (NOLOCK)
ON      uomprc.unit_of_measure_id         = rsi.priced_in_uom_id
 
LEFT OUTER JOIN item_uom_conversion       uomcvpkg WITH (NOLOCK)
ON      uomcvpkg.unit_of_measure_class_id = uompkg.unit_of_measure_class_id
AND     uomcvpkg.item_Id                  = rsi.inventory_item_id
 
LEFT OUTER JOIN item_uom_conversion       uomcvprc WITH (NOLOCK)
ON      uomcvprc.item_id                  = rsi.inventory_item_id
AND     uomcvprc.unit_of_measure_class_id = uomprc.unit_of_measure_class_id
 
WHERE   rd.business_unit_id               = @bu_id
AND     rd.business_date                  = @business_date
AND     rd.status_code                    NOT IN (''d'', ''s'') -- no draft or submitted returns
AND     NOT EXISTS( SELECT 1                                -- not to include returns having non-saleable quantity
                      FROM received_document  AS recd
                      JOIN purchase_order     AS po
                        ON recd.purchase_order_id = po.purchase_order_id
                       AND rd.received_id         = recd.received_id
                     WHERE po.investment_buy_flag = ''y''
                  )

-- Returns (shipper)
INSERT  #f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)
SELECT  rd.return_id,
        rsi.supplier_item_id,
        ricl.inventory_item_id,
        rd.return_date,
        ricl.extended_quantity * COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor)   
                                          AS atomic_qty
 
FROM    return_document                   rd WITH (NOLOCK)
 
JOIN    return_item                       ri WITH (NOLOCK)
ON      ri.business_unit_id               = rd.business_unit_id
AND     ri.return_id                      = rd.return_id
 
JOIN    return_supplier_item              rsi WITH (NOLOCK)
ON      rsi.business_unit_id              = rd.business_unit_id
AND     rsi.return_id                     = rd.return_id
AND     rsi.return_item_id                = ri.return_item_id
 
JOIN    return_item_component_list        ricl WITH (NOLOCK)
ON      ricl.business_unit_id             = rd.business_unit_id
AND     ricl.return_id                    = rd.return_id
AND     ricl.return_item_id               = ri.return_item_id
 
JOIN    unit_of_measure                   uom WITH (NOLOCK)
ON      uom.unit_of_measure_id            = ricl.unit_of_measure_id
 
LEFT OUTER JOIN item_uom_conversion       uomcv WITH (NOLOCK)
ON      uomcv.item_id                     = rsi.inventory_item_id
AND     uomcv.unit_of_measure_class_id    = uom.unit_of_measure_class_id
 
WHERE   rd.business_unit_id               = @bu_id
AND     rd.business_date                  = @business_date
AND     rd.status_code                    NOT IN (''d'', ''s'') -- no draft or submitted returns
AND     NOT EXISTS( SELECT 1                                -- not to include returns having non-saleable quantity
                      FROM received_document  AS recd
                      JOIN purchase_order     AS po
                        ON recd.purchase_order_id = po.purchase_order_id
                       AND rd.received_id         = recd.received_id
                     WHERE po.investment_buy_flag = ''y''
                  )

-- Rebate amts from purchase based rebates
INSERT  #f_gen_inv_rebate_accrual_supplier_item_list
(
        item_id,
        non_retroactive_non_withheld_rebate_amt
)
SELECT  rasil.item_id,
        SUM(rasil.rebate_amt)             AS rebate_amt
 
FROM    rebate_accrual                    ra WITH (NOLOCK)
 
JOIN    rebate_accrual_supplier_item_list rasil WITH (NOLOCK)
ON      rasil.business_unit_id            = ra.business_unit_id
AND     rasil.rebate_accrual_id           = ra.rebate_accrual_id
AND     rasil.lost_reason_code            = ''n''
AND     rasil.item_id                     IS NOT NULL
 
WHERE   ra.business_unit_id               = @bu_id
AND     ra.business_date                  = @business_date
AND     ra.status_code                    IN (''d'', ''p'')
AND     ra.retroactive_type_code          = ''n''
AND     ra.withheld_flag                  = ''n''
 
GROUP BY rasil.item_id
 
-- populating #f_gen_inv_rebate_accrual_rmi_list and #f_gen_sales_item_dest_bu_day are
-- only needed for the Gross Margin Report with Rebates which uses posted data',@parameters=N'@bu_id int, @business_date smalldatetime',@bu_id=1000397,@business_date=N'11/21/2018'