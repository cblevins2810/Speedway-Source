exec sp_executesql @statement=N' /*Applications.Inventory.WaveDO.RadPost.ItemActivityBUDay CollectDaysActivity*/
DECLARE @item_hierarchy_level_id    INT
SELECT  @item_hierarchy_level_id    = item_hierarchy_level_id
FROM    item_hierarchy_level
WHERE   valuation_level_flag        = ''y''
AND     client_id                   IN (0, @current_client_id, @template_client_id)

DECLARE @tmp_agg_sum TABLE
(
        bu_id                           INT,
        business_date                   SMALLDATETIME,
        prev_start_date                 SMALLDATETIME,        
        inventory_item_id               INT,
        item_hierarchy_id               INT,
        atomic_uom_id                   INT,
        bu_date_last_count_timestamp    DATETIME,
        last_count_qty                  NUMERIC(28,10),
        last_count_frequency            NCHAR(1),
        receive_qty                     NUMERIC(28,10),
        negative_receive_qty            NUMERIC(28,10),
        receive_qty_after_cnt           NUMERIC(28,10),
        return_qty                      NUMERIC(28,10),
        return_qty_after_cnt            NUMERIC(28,10),
        adjust_qty                      NUMERIC(28,10),
        negative_adjust_qty             NUMERIC(28,10),
        adjust_qty_after_cnt            NUMERIC(28,10),
        gross_margin_report_with_rebates_adjust_qty  NUMERIC(28,10),
        gross_margin_report_with_rebates_adjust_amt  NUMERIC(28,10),
        production_qty                  NUMERIC(28,10),
        production_qty_after_cnt        NUMERIC(28,10),
        xfer_qty                        NUMERIC(28,10),
        xfer_qty_after_cnt              NUMERIC(28,10),
        xfer_out_qty                    NUMERIC(28,10),
        waste_qty                       NUMERIC(28,10),
        waste_qty_after_cnt             NUMERIC(28,10),
        sales_qty                       NUMERIC(28,10),
        sales_qty_after_cnt             NUMERIC(28,10),
        begin_onhand_qty                NUMERIC(28,10),
        onorder_qty                     NUMERIC(28,10),
        exclude_on_hand_tracking_flag   NCHAR(1),
        set_variance_to_zero_flag       NCHAR(1),
        opening_weighted_average_cost   NUMERIC(28,10),

        begin_wac_backout_qty           NUMERIC(28,10),
        purchase_rebate_cost_amt        NUMERIC(28,10),
        end_wac_qty                     NUMERIC(28,10),
        end_wac_amt                     NUMERIC(28,10),
        previous_last_activity_cost     NUMERIC(28,10),
        previous_last_received_cost_amt NUMERIC(28,10),
        previous_min_supplier_cost      NUMERIC(28,10),
        previous_max_supplier_cost      NUMERIC(28,10),
        previous_avg_supplier_cost      NUMERIC(28,10),
        previous_standard_cost          NUMERIC(28,10),
        previous_retail_valuation_amt   NUMERIC(28,10),
        previous_vat_amt                NUMERIC(28,10),
        act_count_variance_qty          NUMERIC(23,10),
        act_count_variance_cost_amt     NUMERIC(23,10),
        production_usage_qty            NUMERIC(19,6),
        non_withheld_rebate_amt         NUMERIC(28,10),
        withheld_rebate_amt             NUMERIC(28,10),
        net_sales_amt                   NUMERIC(28,10),
        wac_adjustment                  NUMERIC(28,10),
        PRIMARY KEY (inventory_iteM_id)
)

DECLARE @local_bu_datetime DATETIME

SELECT  @local_bu_datetime                    = v.current_bu_local_time
FROM    PLT_Get_BU_Local_Time_View  v
WHERE   v.business_unit_id                    = @bu_id

INSERT @tmp_agg_sum 
(
        bu_id,
        business_date,
        inventory_item_id,
        item_hierarchy_id,
        prev_start_date,
        begin_onhand_qty,
        receive_qty,
        negative_receive_qty,
        receive_qty_after_cnt,
        return_qty,
        return_qty_after_cnt,
        adjust_qty,
        negative_adjust_qty,
        adjust_qty_after_cnt,
        production_qty,
        production_qty_after_cnt,
        xfer_qty,
        xfer_qty_after_cnt,
        xfer_out_qty,
        waste_qty,
        waste_qty_after_cnt,
        sales_qty,
        sales_qty_after_cnt,
        onorder_qty,
        last_count_qty,
        last_count_frequency,
        exclude_on_hand_tracking_flag,
        set_variance_to_zero_flag,
        atomic_uom_id,
        opening_weighted_average_cost,

        begin_wac_backout_qty,
        purchase_rebate_cost_amt,
        end_wac_qty,
        end_wac_amt,

        previous_last_activity_cost,
        previous_last_received_cost_amt,
        production_usage_qty,
        non_withheld_rebate_amt,
        withheld_rebate_amt,
        net_sales_amt,
        gross_margin_report_with_rebates_adjust_qty,
        gross_margin_report_with_rebates_adjust_amt,
        wac_adjustment
)

SELECT  t.bu_id,
        t.business_date,
        t.inventory_item_id,
        itm.item_hierarchy_id,
        act.start_business_date,
        COALESCE(act.end_onhand_qty, 0),
        t.receive_qty,
        t.negative_receive_qty,
        t.receive_qty_after_cnt,
        t.return_qty,
        t.return_qty_after_cnt,
        t.adjust_qty,
        t.negative_adjust_qty,
        t.adjust_qty_after_cnt,
        t.production_qty,
        t.production_qty_after_cnt,
        t.xfer_qty,
        t.xfer_qty_after_cnt,
        t.xfer_out_qty,
        t.waste_qty,
        t.waste_qty_after_cnt,
        t.sales_qty,
        t.sales_qty_after_cnt,
        t.onorder_qty,
        t.last_count_qty,
        t.last_count_frequency,
        invitm.exclude_on_hand_tracking_flag,
        
          invitm.set_variance_to_zero_flag,
        
        itm.atomic_uom_id,
        act.closing_weighted_average_cost,
        t.begin_wac_backout_qty,
        t.purchase_rebate_cost_amt,
        t.end_wac_qty,
        t.end_wac_amt,
        act.last_activity_cost,
        act.last_received_cost_amt,
        t.production_usage_qty,
        t.non_withheld_rebate_amt,
        t.withheld_rebate_amt,
        t.net_sales_amt,
        t.gross_margin_report_with_rebates_adjust_qty,
        t.gross_margin_report_with_rebates_adjust_amt,
        t.wac_adjustment

FROM
(            
        SELECT  @bu_id                                      AS bu_id,
                @business_date                    AS business_date,
                t.inventory_item_id                             AS inventory_item_id, 
                SUM(COALESCE(t.receive_qty,0))                  AS receive_qty,
                SUM(COALESCE(t.negative_receive_qty,0))         AS negative_receive_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.receive_qty END, 0)) AS receive_qty_after_cnt,
                SUM(COALESCE(t.return_qty,0))                   AS return_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.return_qty END, 0)) AS return_qty_after_cnt,
                SUM(COALESCE(t.adjust_qty,0))                   AS adjust_qty,
                SUM(COALESCE(t.negative_adjust_qty,0))          AS negative_adjust_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.adjust_qty END, 0)) AS adjust_qty_after_cnt,
                SUM(COALESCE(t.production_qty,0))               AS production_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.production_qty END, 0)) AS production_qty_after_cnt,
                SUM(COALESCE(t.xfer_qty,0))                     AS xfer_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.xfer_qty END, 0)) AS xfer_qty_after_cnt,
                SUM(COALESCE(t.xfer_out_qty,0))                 AS xfer_out_qty,
                SUM(COALESCE(t.waste_qty,0))                    AS waste_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.waste_qty END, 0)) AS waste_qty_after_cnt,
                SUM(COALESCE(t.sales_qty,0))                    AS sales_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.sales_qty END, 0)) AS sales_qty_after_cnt,
                SUM(COALESCE(t.onorder_qty,0))                  AS onorder_qty,
                MIN(COALESCE(lastcnt.atomic_count_qty, -999))   AS last_count_qty,
                MIN(COALESCE(lastcnt.frequency_code, ''d''))      AS last_count_frequency,
                SUM(COALESCE(t.begin_wac_backout_qty, 0))       AS begin_wac_backout_qty,
                -MIN(COALESCE(rasil.non_retroactive_non_withheld_rebate_amt, 0))  AS purchase_rebate_cost_amt, -- store as a negative since it decreases received/inventory cost
                SUM(COALESCE(t.end_wac_qty, 0))                 AS end_wac_qty,
                SUM(COALESCE(t.end_wac_amt, 0))                 AS end_wac_amt,
                SUM(COALESCE(t.production_usage_qty,0))         AS production_usage_qty,
                MIN(COALESCE(rasil.non_retroactive_non_withheld_rebate_amt, 0) + 
                    COALESCE(rasil.retroactive_non_withheld_rebate_amt, 0) +
                    COALESCE(rarl.non_withheld_rebate_amt, 0))     AS non_withheld_rebate_amt,
                MIN(COALESCE(rasil.withheld_rebate_amt, 0) +
                    COALESCE(rarl.withheld_rebate_amt, 0))         AS withheld_rebate_amt,
                MIN(COALESCE(sidbd.net_sales_amt, 0))              AS net_sales_amt,
                SUM(COALESCE(t.gross_margin_report_with_rebates_adjust_qty, 0)) AS gross_margin_report_with_rebates_adjust_qty,
                SUM(COALESCE(t.gross_margin_report_with_rebates_adjust_amt, 0)) AS gross_margin_report_with_rebates_adjust_amt,
                MAX(ISNULL(t.wac_adjustment,0))                                 AS wac_adjustment

        FROM
        (
                -- Counts
                SELECT  cnt.inventory_item_id           AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt,
                        NULL                            As Production_Usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_inv_count                cnt WITH (NOLOCK)
                
                UNION ALL
                
                -- Receivings
                SELECT  rcv.inventory_item_id           AS inventory_item_id,
                        rcv.recv_date                   AS timestamp,
                        COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)
                                                        AS receive_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) < 0 
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) < 0 
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS begin_wac_backout_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) >= 0
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS end_wac_qty,
                        CASE WHEN COALESCE(rcv.atomic_qty, 0) >= 0
                             THEN COALESCE(rcv.atomic_qty, 0) * COALESCE(rcv.atomic_cost, 0)
                             ELSE 0
                        END                             AS end_wac_amt,
                        NULL                            AS prodcution_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_inv_receive              rcv
                
                UNION ALL 

                -- Recevings reconciled on different business date

                SELECT  inventory_item_id               AS inventory_item_id,
                        reconciled_date                 AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        discrepancy_adj_amt             AS end_wac_amt,
                        NULL                            AS prodcution_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC                


                UNION ALL
                
                --Adjustments
                SELECT  adj.inventory_item_id           AS inventory_item_id,
                        adj.timestamp                   AS timestamp,
                        CASE WHEN adj.adjustment_type_code = ''r'' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        CASE WHEN adj.adjustment_type_code = ''a'' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS adjust_qty,
                        CASE WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty < 0 THEN
                          COALESCE(adj.atomic_event_qty, 0)
                        WHEN adj.adjustment_type_code = ''w'' THEN
                          -COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS negative_adjust_qty,
                        -- flag will only be set for adjustments of type adjustment, only need to check flag
                        CASE WHEN adj.include_in_gross_margin_report_with_rebates_flag = ''y'' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS gross_margin_report_with_rebates_adjust_qty,
                        -- flag will only be set for adjustments of type adjustment, only need to check flag
                        CASE WHEN adj.include_in_gross_margin_report_with_rebates_flag = ''y'' THEN 
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                        ELSE 
                          0
                        END                             AS gross_margin_report_with_rebates_adjust_amt,
                        CASE WHEN adj.adjustment_type_code = ''p'' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS production_qty,
                        
                                                
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        CASE WHEN adj.adjustment_type_code = ''w'' THEN 
                          COALESCE(adj.atomic_event_qty, 0)

                        ELSE 
                          0
                        END                             AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                         --picks the negative adjustments quantities that are manually created
                        CASE WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)<>coalesce(ie.invoice_id,1)THEN
                          COALESCE(adj.atomic_event_qty, 0)
                             WHEN adj.adjustment_type_code = ''w'' THEN
                          -COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS begin_wac_backout_qty,
                        --picks all the positive adjustments quantities 
                        CASE WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty >= 0 THEN
                          COALESCE(adj.atomic_event_qty, 0)
                             --for case when adjustment quantities are less than zero and are created from invoice reconciliation
                             WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)=coalesce(ie.invoice_id,1)  THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS end_wac_qty,
                        --picks the amounts for all positive adjustments
                        CASE WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty >= 0 THEN
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                          --picks the amounts for -ve adjustments that are created from invoice reconciliation
                             WHEN adj.adjustment_type_code IN (''r'', ''p'', ''a'') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)=coalesce(ie.invoice_id,1)  THEN 
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                        ELSE
                          0
                        END                             AS end_wac_amt ,
                        CASE WHEN adj.adjustment_type_Code = ''p'' THEN 
                              COALESCE(adj.production_usage_qty, 0) ELSE 0 
                        END                             as production_usage_qty,
                        NULL                            As wac_adjustment
                      
                
                FROM            #f_gen_inv_adjustment           adj WITH (NOLOCK)
                JOIN inventory_event_list  iel WITH (NOLOCK)
                ON adj.inventory_event_id                       =iel.inventory_event_id
                AND iel.inventory_item_id                       =adj.inventory_item_id
                AND iel.inventory_event_list_id                 =adj.inventory_event_list_id
                JOIN inventory_event       ie WITH (NOLOCK)
                ON ie.inventory_event_id                        =iel.inventory_event_id
                LEFT OUTER JOIN invoice_reconciliation  ir WITH (NOLOCK)
                ON ir.invoice_id                                =ie.invoice_id
                
                UNION ALL
                
                SELECT  xfer.inventory_item_id          AS inventory_item_id,
                        xfer.timestamp                  AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        CASE WHEN xfer.transfer_type_code IN (''t'', ''o'') THEN 
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE 
                          0
                        END                             AS xfer_qty,
                        CASE WHEN xfer.transfer_type_code IN (''t'', ''o'') AND xfer.atomic_transfer_qty < 0 THEN 
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE 
                          0
                        END                             AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,

                        CASE WHEN xfer.transfer_type_code IN (''t'', ''o'') AND COALESCE(xfer.atomic_transfer_qty, 0) < 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE
                          0
                        END                             AS begin_wac_backout_qty,
                        CASE WHEN xfer.transfer_type_code IN (''t'', ''o'') AND COALESCE(xfer.atomic_transfer_qty, 0) > 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE
                          0
                        END                             AS end_wac_qty,
                        CASE WHEN xfer.transfer_type_code IN (''t'', ''o'') AND COALESCE(xfer.atomic_transfer_qty, 0) > 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0) * COALESCE(xfer.atomic_cost, 0)
                        ELSE
                          0
                        END                             AS end_wac_amt ,
                        NULL                            AS production_usage_qty ,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_inv_transfer             xfer WITH (NOLOCK)
                
                UNION ALL 
                
                -- Returns
                
                SELECT  ret.inventory_item_id           AS inventory_item_id,
                        ret.return_date                 AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        COALESCE(ret.atomic_qty, 0)     AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        -COALESCE(ret.atomic_qty, 0)    AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                                
                FROM    #f_gen_inv_return               ret
                                
                UNION ALL 
                -- on order qty
                
                SELECT  poi.item_id AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        poi.atomic_inventory_item_quantity       
                                                        AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt, 
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM 
                ( 
                        SELECT  po.business_unit_id, 
                                po.purchase_order_id 
                        FROM    purchase_order po
                        WHERE   po.business_unit_id     = @bu_id
                        AND     po.order_date           <= @local_bu_datetime
                        AND     po.hq_order_id          IS NULL
                        AND     po.purge_flag           = ''n''
                        AND     po.status_code          = ''s''
                ) po
                
                JOIN    purchase_order_item   poi 
                ON      poi.business_unit_id            = po.business_unit_id
                AND     poi.purchase_order_id           = po.purchase_order_id
                AND     poi.item_id                     IS NOT NULL
                
                UNION ALL 
                
                -- sales_qty
                SELECT  usg.inventory_item_id           AS inventory_item_id,
                        usg.trans_timestamp             AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        COALESCE(usg.atomic_sales_usage_qty,0)      
                                                        AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM     spwy_eso_wh..f_gen_inv_sales_usage   usg
                
                WHERE   usg.bu_id                       = @bu_id
                AND     usg.business_date               = @business_date

                UNION ALL 

                SELECT  rasil.item_id                   AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_inv_rebate_accrual_supplier_item_list rasil

                UNION ALL 

                SELECT  rarl.item_id                    AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_inv_rebate_accrual_rmi_list rarl

                UNION ALL 

                SELECT  sidbd.item_id                   AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    #f_gen_sales_item_dest_bu_day sidbd

                UNION ALL 

                SELECT  inventory_item_id               AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        atomic_cost                     As wac_adjustment                        
                
                FROM    #Inventory_WAC_Adjustment_BU_List  wac
               WHERE    business_date IS NOT NULL

        ) t

        LEFT OUTER JOIN #tmp_bu_day_count               lastcnt
        ON      lastcnt.inventory_item_id               = t.inventory_item_id

        LEFT OUTER JOIN #f_gen_inv_rebate_accrual_supplier_item_list rasil
        ON      rasil.item_id                           = t.inventory_item_id
        
        LEFT OUTER JOIN #f_gen_inv_rebate_accrual_rmi_list rarl
        ON      rarl.item_id                            = t.inventory_item_id

        LEFT OUTER JOIN #f_gen_sales_item_dest_bu_day   sidbd
        ON      sidbd.item_id                           = t.inventory_item_id
 
        GROUP BY t.inventory_item_id
) t

JOIN     spwy_eso_wh..inventory_item                          invitm
ON      invitm.inventory_item_id                        = t.inventory_item_id

JOIN     spwy_eso_wh..item                                    itm
ON      itm.item_id                                     = t.inventory_item_id

LEFT OUTER JOIN  spwy_eso_wh..f_gen_inv_item_activity_bu_day act
ON      act.bu_id                                       = t.bu_id
AND     act.inventory_item_id                           = t.inventory_item_id
AND     DATEADD(dd, -1, @business_date)   BETWEEN act.start_business_date AND COALESCE(act.end_business_date, ''12/31/2075'')





INSERT #new_f_gen_inv_item_activity_bu_day 
(
        bu_id,
        start_business_date,
        inventory_item_id,
        valuation_cat_id,
        atomic_uom_id,
        recv_qty,
        negative_recv_qty,
        return_qty,
        adjust_qty,
        production_qty,
        xfer_qty,
        xfer_out_qty,
        waste_qty,
        sales_qty,
        onorder_qty,
        end_onhand_qty,
        begin_onhand_qty,
        count_variance_qty,
        exclude_on_hand_tracking_flag,
        opening_weighted_average_cost,

        begin_wac_backout_qty,
        purchase_rebate_cost_amt,
        end_wac_qty,
        end_wac_amt,
        previous_last_activity_cost,
        previous_last_received_cost_amt,
        negative_adjust_qty, 
        production_usage_qty,
        non_withheld_rebate_amt,
        withheld_rebate_amt,
        net_sales_amt,
        gross_margin_report_with_rebates_adjust_qty,
        gross_margin_report_with_rebates_adjust_amt,
        wac_adjustment
        

)
SELECT  t.bu_id,
        t.start_business_date,
        t.inventory_item_id,
        t.valuation_cat_id,
        t.atomic_uom_id,
        t.recv_qty,
        t.negative_recv_qty,
        t.return_qty,
        t.adjust_qty,
        t.production_qty,
        t.xfer_qty,
        t.xfer_out_qty,
        t.waste_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = ''y'' THEN -- exclude on hand tracking necessitates set variance to zero (through the UI) 
                                                             --   so check it first (and account for set variance to zero when it is on by including variance)
          COALESCE(t.sales_qty, 0) - COALESCE(t.count_variance_qty, 0) + COALESCE(t.end_onhand_qty, 0)
        WHEN t.set_variance_to_zero_flag = ''y'' THEN
          COALESCE(t.sales_qty, 0) - COALESCE(t.count_variance_qty, 0)
        ELSE
          COALESCE(t.sales_qty, 0)
        END AS sales_qty,

        t.onorder_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = ''y'' THEN
          0
        ELSE
          t.end_onhand_qty
        END AS end_onhand_qty,


        t.begin_onhand_qty AS begin_onhand_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = ''y'' OR t.set_variance_to_zero_flag = ''y'' THEN
          0
        ELSE
          t.count_variance_qty
        END,

        t.exclude_on_hand_tracking_flag,
        t.opening_weighted_average_cost,

        t.begin_wac_backout_qty + 
          CASE WHEN t.exclude_on_hand_tracking_flag = ''y'' OR t.set_variance_to_zero_flag = ''y'' THEN
            0
          ELSE
            t.count_variance_qty 
          END AS begin_wac_backout_qty,
        t.purchase_rebate_cost_amt,
        t.end_wac_qty,
        t.end_wac_amt + t.purchase_rebate_cost_amt AS end_wac_amt,
        t.previous_last_activity_cost,
        t.previous_last_received_cost_amt,
        t.negative_adjust_qty,
        t.production_usage_qty,
        t.non_withheld_rebate_amt,
        t.withheld_rebate_amt,
        t.net_sales_amt,
        t.gross_margin_report_with_rebates_adjust_qty,
        t.gross_margin_report_with_rebates_adjust_amt,
        t.wac_adjustment


FROM
(
        SELECT  agg.bu_id                 AS bu_id,
                agg.business_date         AS start_business_date,
                agg.inventory_item_id     AS inventory_item_id,
                pih.item_hierarchy_id     AS valuation_cat_id,
                agg.atomic_uom_id         AS atomic_uom_id,
                agg.receive_qty           AS recv_qty,
                agg.negative_receive_qty  AS negative_recv_qty,
                agg.return_qty            AS return_qty,
                agg.adjust_qty            AS adjust_qty,
                agg.production_qty        AS production_qty,
                agg.xfer_qty              AS xfer_qty,
                agg.xfer_out_qty          AS xfer_out_qty,
                agg.waste_qty             AS waste_qty,
                -- sales
                agg.sales_qty             AS sales_qty, 
                -- end sales
                agg.onorder_qty           AS onorder_qty,
        
                -- end onhand
                CASE WHEN COALESCE(last_count_qty, -999) = -999 THEN 
                  agg.begin_onhand_qty + agg.receive_qty - agg.return_qty + agg.adjust_qty + agg.production_qty + agg.xfer_qty - agg.waste_qty - 
                      agg.sales_qty                      
                ELSE 
                  COALESCE(last_count_qty, 0) + agg.receive_qty_after_cnt - agg.return_qty_after_cnt + 
                    agg.adjust_qty_after_cnt + agg.production_qty_after_cnt + agg.xfer_qty_after_cnt - agg.waste_qty_after_cnt - 
                      agg.sales_qty_after_cnt                                          
                END                       AS end_onhand_qty,
                -- end end onhand
        
                -- begin onhand qty
                agg.begin_onhand_qty AS begin_onhand_qty,
                -- end begin onhand qty

                -- variance
                CASE WHEN COALESCE(last_count_qty, -999) = -999 THEN 
                  0
                WHEN last_count_frequency = ''i'' THEN 
                  0        
                ELSE 
                  ( COALESCE(last_count_qty, 0) + agg.receive_qty_after_cnt - agg.return_qty_after_cnt + 
                      agg.adjust_qty_after_cnt + agg.production_qty_after_cnt + agg.xfer_qty_after_cnt - 
                        agg.waste_qty_after_cnt - agg.sales_qty_after_cnt                    
                  ) - 
                    ( agg.begin_onhand_qty + agg.receive_qty - agg.return_qty + agg.adjust_qty + agg.production_qty +
                        agg.xfer_qty - agg.waste_qty - agg.sales_qty
                    ) 
                END                             AS count_variance_qty,
                -- end variance
                agg.set_variance_to_zero_flag AS set_variance_to_zero_flag,
                agg.exclude_on_hand_tracking_flag AS exclude_on_hand_tracking_flag,
                agg.opening_weighted_average_cost,
                agg.begin_wac_backout_qty,
               CASE WHEN agg.purchase_rebate_cost_amt IS NOT NULL AND  agg.purchase_rebate_cost_amt < 0
                    THEN agg.purchase_rebate_cost_amt
                    ELSE 0
               END AS purchase_rebate_cost_amt,
                agg.end_wac_qty,
                agg.end_wac_amt,
                agg.previous_last_activity_cost,
                agg.previous_last_received_cost_amt,
                agg.negative_adjust_qty,
                agg.act_count_variance_qty,
                agg.act_count_variance_cost_amt,
                Coalesce(agg.production_usage_qty,0) as production_usage_qty,
                agg.non_withheld_rebate_amt,
                agg.withheld_rebate_amt,
                agg.net_sales_amt,
                agg.gross_margin_report_with_rebates_adjust_qty,
                agg.gross_margin_report_with_rebates_adjust_amt,
                agg.wac_adjustment
        
        FROM    @tmp_agg_sum                    agg 
        
        JOIN    item_hierarchy        ih
        ON      ih.item_hierarchy_id            = agg.item_hierarchy_id
        
        JOIN    item_hierarchy        pih
        ON      ih.setstring                    LIKE pih.setstring + ''%''
        AND     pih.item_hierarchy_level_id     = @item_hierarchy_level_id
) t',@parameters=N'@bu_id int, @business_date smalldatetime, @current_client_id int, @end_business_date smalldatetime, @set_variance_to_zero_override_flag nchar(1), @template_client_id int, @wave_data_flag nchar(1)',@bu_id=1000397,@business_date=N'11/21/2018',@current_client_id=1000102,@end_business_date=NULL,@set_variance_to_zero_override_flag=N'n ',@template_client_id=NULL,@wave_data_flag=N'y '