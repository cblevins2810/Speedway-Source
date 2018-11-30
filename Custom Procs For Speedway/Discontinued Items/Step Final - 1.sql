exec sp_executesql @statement=N'--CACHE_ID{1000397}
UPDATE  act
SET     last_activity_cost            = ( SELECT  atomic_cost
                                          FROM    inventory_item_bu_cost_list cl1
                                          WHERE   cl1.business_unit_id              = act.bu_id
                                          AND     cl1.inventory_item_id             = act.inventory_item_id
                                          AND     cl1.business_date                 = act.start_business_date
                                          AND     cl1.business_unit_id              = @business_unit_id
                                          AND     cl1.business_date                 = @business_date
                                          AND NOT EXISTS 
                                          ( 
                                                  SELECT  1
                                                  FROM    inventory_item_bu_cost_list cl2 WITH (NOLOCK)
                                                  WHERE   cl1.business_unit_id      = cl2.business_unit_id
                                                  AND     cl1.inventory_item_id     = cl2.inventory_item_id 
                                                  AND     cl2.business_date         = cl1.business_date
                                                  AND     cl2.end_date              > cl1.end_date 
                                          )
                                        )
FROM    #new_f_gen_inv_item_activity_bu_day act

UPDATE  act
SET     last_received_cost_amt        = ( SELECT  atomic_cost
                                          FROM    inventory_item_bu_cost_list cl1
                                          WHERE   cl1.business_unit_id              = act.bu_id
                                          AND     cl1.inventory_item_id             = act.inventory_item_id
                                          AND     cl1.business_date                 = act.start_business_date
                                          AND     cl1.business_unit_id              = @business_unit_id
                                          AND     cl1.business_date                 = @business_date
                                          AND     cl1.cost_source_code              = ''r''
                                          AND NOT EXISTS 
                                          ( 
                                                  SELECT  1
                                                  FROM    inventory_item_bu_cost_list cl2 WITH (NOLOCK)
                                                  WHERE   cl1.business_unit_id      = cl2.business_unit_id
                                                  AND     cl1.inventory_item_id     = cl2.inventory_item_id 
                                                  AND     cl2.business_date         = cl1.business_date
                                                  AND     cl2.end_date              > cl1.end_date 
                                                  AND     cl2.cost_source_code      = ''r''
                                          )
                                        )
FROM    #new_f_gen_inv_item_activity_bu_day act

UPDATE  act
SET     min_supplier_cost               = cost.min_supplier_cost,
        max_supplier_cost               = cost.max_supplier_cost,
        avg_supplier_cost               = cost.avg_supplier_cost
FROM    #new_f_gen_inv_item_activity_bu_day act
JOIN 
(
        SELECT  x.item_id, 
                MIN(x.item_cost) AS min_supplier_cost,
                MAX(x.item_cost) AS max_supplier_cost,
                AVG(x.item_cost) AS avg_supplier_cost
        FROM 
        (
                SELECT  i.item_id,
                        cost.net_supplier_cost / 
                          COALESCE( CASE WHEN spi.catch_weight_flag = ''y'' THEN 
                            pricedinUOM.factor * COALESCE(iuomcpricedin.atomic_conversion_factor,1)
                          ELSE
                            packagedinUOM.factor * COALESCE(iuomcpackagedin.atomic_conversion_factor,1)
                          END,1) as item_cost 
                
                FROM     spwy_eso_wh..f_gen_supplier_item_unit_cost     cost 
                JOIN    supplier_item                   si
                ON      si.supplier_id                            = cost.supplier_id
                AND     si.supplier_item_id                       = cost.supplier_item_id
                JOIN    supplier_packaged_item          spi
                ON      spi.supplier_id                           = cost.supplier_id
                AND     spi.supplier_item_id                      = cost.supplier_item_id
                AND     spi.packaged_item_id                      = cost.packaged_item_id
                JOIN    item                            i 
                ON      i.item_id                                 = si.item_id
                JOIN    Unit_of_Measure                 packagedinUOM
                ON      packagedinUOM.unit_of_measure_id          = SPI.packaged_in_uom_id 
                LEFT OUTER JOIN unit_of_measure         pricedinUOM
                ON      pricedinUOM.unit_of_measure_id            = SPI.priced_in_uom_id 
                LEFT OUTER JOIN item_uom_conversion     iuomcpricedin
                ON      iuomcpricedin.item_id                     = i.item_id
                AND     iuomcpricedin.unit_of_measure_class_id    = pricedinUOM.unit_of_measure_class_id
                LEFT OUTER JOIN item_uom_conversion     iuomcpackagedin
                ON      iuomcpackagedin.item_id                   = i.item_id
                AND     iuomcpackagedin.unit_of_measure_class_id  = packagedinUOM.unit_of_measure_class_id
                WHERE   cost.bu_id                                = @business_unit_id
                AND     @business_date              BETWEEN cost.start_date AND COALESCE(cost.end_date, ''12/31/2075'')
        ) as x
        GROUP BY x.item_id
) cost 
ON      cost.item_id = act.inventory_item_id

UPDATE  act
SET     standard_cost                               = COALESCE(cstdcost.standard_cost, tstdcost.standard_cost) / 
                                                        COALESCE(uom.factor * uomcv.atomic_conversion_factor, uom.factor)
FROM    #new_f_gen_inv_item_activity_bu_day         act
JOIN    inventory_item                    ii
ON      ii.inventory_item_id                        = act.inventory_item_id
JOIN    unit_of_measure                   uom
ON      uom.unit_of_measure_id                      = ii.valuation_uom_id
LEFT OUTER JOIN item_uom_conversion       uomcv
ON      uomcv.unit_of_measure_class_id              = uom.unit_of_measure_class_id
AND     uomcv.item_id                               = act.inventory_item_id
LEFT OUTER JOIN inventory_item_org_hier_std_cost cstdcost
ON      cstdcost.inventory_item_id                  = act.inventory_item_id
AND     cstdcost.org_hierarchy_id                   = @current_client_id
LEFT OUTER JOIN inventory_item_org_hier_std_cost tstdcost
ON      tstdcost.inventory_item_id                  = act.inventory_item_id
AND     tstdcost.org_hierarchy_id                   = @template_client_id

UPDATE  act
SET     retail_valuation_amt                        = 
                                                        price.retail_price / rmi.unit_of_measure_quantity / 
                                                          COALESCE(uomrmi.factor * uomcvrmi.atomic_conversion_factor, uomrmi.factor)
                                                      
        , vat_amt                                  =  
                                                        round((retail_price - (retail_price / (1+tax_percentage/100))),2)
                                                      
FROM    #new_f_gen_inv_item_activity_bu_day         act
JOIN    retail_modified_item              rmi
ON      rmi.retail_item_id                          = act.inventory_item_id
AND     rmi.retail_valuation_flag                   = ''y''

JOIN    merch_bu_rmi_retail_list          price
ON      price.business_unit_id                      = @business_unit_id
AND     price.retail_modified_item_id               = rmi.retail_modified_item_id

JOIN    unit_of_measure                   uomrmi
ON      uomrmi.unit_of_measure_id                   = rmi.unit_of_measure_id
LEFT OUTER JOIN item_uom_conversion       uomcvrmi
ON      uomcvrmi.unit_of_measure_class_id           = uomrmi.unit_of_measure_class_id
AND     uomcvrmi.item_id                            = act.inventory_item_id

UPDATE act
SET closing_weighted_average_cost = CASE 
    WHEN (CASE WHEN COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) <= 0 AND COALESCE(act.end_wac_qty, 0) > 0 THEN 
                    CAST(COALESCE(act.end_wac_amt, 0) AS NUMERIC(28, 10)) / CAST(COALESCE(act.end_wac_qty, 0) AS NUMERIC(28, 10))

               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)

               -- handle the special case of no incoming goods but return based rebates exist by increasing WAC through the purchase based rebates
               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.purchase_rebate_cost_amt, 0) <> 0
                    AND (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) <> 0 THEN 
                    CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.purchase_rebate_cost_amt, 0)) AS NUMERIC(28, 10)) /  
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10))

               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.end_wac_amt, 0) = 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
               
               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)
         
          ELSE CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.end_wac_amt, 0)) AS NUMERIC(28, 10)) / 
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10))

          END) <= 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
    ELSE (CASE WHEN COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) <= 0 AND COALESCE(act.end_wac_qty, 0) > 0 THEN 
                    CAST(COALESCE(act.end_wac_amt, 0) AS NUMERIC(28, 10)) / CAST(COALESCE(act.end_wac_qty, 0) AS NUMERIC(28, 10))

               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10)) < 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)

                    -- handle the special case of no incoming goods but return based rebates exist by increasing WAC through the purchase based rebates
               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.purchase_rebate_cost_amt, 0) <> 0
                    AND (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) <> 0 THEN 
                    CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.purchase_rebate_cost_amt, 0)) AS NUMERIC(28, 10)) /  
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10))

               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.end_wac_amt, 0) = 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
               
               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)
         
          ELSE CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.end_wac_amt, 0)) AS NUMERIC(28, 10)) / 
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10))
          END)
    END
FROM #new_f_gen_inv_item_activity_bu_day act
JOIN  item_hierarchy ih ON ih.item_hierarchy_id = act.valuation_cat_id
LEFT OUTER JOIN  inventory_client_parameters icp ON icp.client_id = @current_client_id
LEFT OUTER JOIN  item_hierarchy_bu_override_list ihbol ON ihbol.item_hierarchy_id = ih.item_hierarchy_id
  AND ihbol.business_unit_id = @business_unit_id
WHERE COALESCE(ihbol.valuation_method_code, ih.valuation_method_code, icp.valuation_method_code, ''i'') = ''w'' -- calculate weigted average costs
 
UPDATE  w
   SET  closing_weighted_average_cost = a.closing_weighted_average_cost,
        end_onhand_qty = a.end_onhand_qty,
        adjustment_amt = (w.atomic_cost - a.closing_weighted_average_cost) * a.end_onhand_qty
  FROM  #new_f_gen_inv_item_activity_bu_day a
  JOIN  #Inventory_WAC_Adjustment_BU_List w
    ON  w.inventory_item_id = a.inventory_item_id
   AND  w.business_date IS NOT NULL

UPDATE  #new_f_gen_inv_item_activity_bu_day 
   SET  closing_weighted_average_cost = wac_adjustment
 WHERE  wac_adjustment > 0

',@parameters=N'@business_date smalldatetime, @business_unit_id int, @current_client_id int, @template_client_id int, @wave_data_flag nchar(1)',@business_date=N'11/21/2018',@business_unit_id=1000397,@current_client_id=1000102,@template_client_id=NULL,@wave_data_flag=N'y '