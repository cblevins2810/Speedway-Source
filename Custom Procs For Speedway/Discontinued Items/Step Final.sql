exec sp_executesql N'DECLARE @default_valuation_method_code      NCHAR(1)
SELECT  @default_valuation_method_code      = valuation_method_code
FROM    inventory_client_parameters
WHERE   client_id                           = @current_client_id

SELECT  da.name                                                       AS display_org_hierarchy_name, 
        t.display_org_hierarchy_id                                    AS display_org_hierarchy_id, 
        t.item_hierarchy_name                                         AS item_hierarchy_name,
        t.item_hierarchy_id                                           AS item_hierarchy_id,
        t.business_date                                               AS business_date,
        t.item_id                                                     AS item_id,
        t.item_name                                                   AS item_name,
        t.uom                                                         AS uom,
        t.boh                                                         AS boh,
        t.purch                                                       AS purch,
        t.trans                                                       AS trans,
        t.adj                                                         AS adj,
        t.variance                                                    AS variance,
        t.usage                                                       AS usage,
        t.eoh                                                         AS eoh,
        t.wac                                                         AS wac,
        t.open_wac                                                    AS open_wac,
        t.eoh_amt                                                     AS eoh_amt,
        t.eoh_amt                                                     AS total_eoh_amt,
        t.sales_cost                                                  AS sales_cost,
        @data_source_code                                    AS data_source_code


FROM
(
        SELECT  fgen.bu_id                                            AS display_org_hierarchy_id,
                ih.name                                               AS item_hierarchy_name,
                fgen.valuation_cat_id                                 AS item_hierarchy_id,
                @business_date                          AS business_date,
                i.name + CASE WHEN ISNULL(fgen.wac_adjustment,0)>0 
                              THEN '' **''
                              ELSE ''''
                         END                                          AS item_name,
                i.item_id                                             AS item_id,
                uom.name                                              AS uom,

                CASE      @business_date
                  WHEN    fgen.start_business_date 
                    THEN  fgen.begin_onhand_qty
                  ELSE    fgen.end_onhand_qty 
                END / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS boh,
                ---------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  (fgen.recv_qty - fgen.return_qty) / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS purch,
                ---------------------------------------------------------------|  

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.xfer_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS trans,
                ---------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  (fgen.adjust_qty - fgen.waste_qty + fgen.production_qty)
                            / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS adj,
                ----------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.count_variance_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS variance,
                -----------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.sales_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0                                           
                END                                                   AS usage,
                -----------------------------------------------------------------|

                COALESCE(fgen.end_onhand_qty, 0)
                  / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)          
                                                                      AS eoh,

                COALESCE(fgen.closing_weighted_average_cost, 0)
                  * COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS wac,

                COALESCE(fgen.opening_weighted_average_cost, 0)
                  * COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS open_wac,

                COALESCE(fgen.end_onhand_qty, 0) * COALESCE(fgen.closing_weighted_average_cost, 0)
                                                                      AS eoh_amt,

                COALESCE(fgen.sales_qty, 0) * COALESCE(fgen.closing_weighted_average_cost, 0)
                                                                      AS sales_cost


    
        FROM
        (
                SELECT  fgen.bu_id                                    AS bu_id,
                        fgen.inventory_item_id                        AS inventory_item_id,
                        fgen.valuation_cat_id                         AS valuation_cat_id,
                        fgen.start_business_date                      AS start_business_date,
                        ''12/31/2075''                                  AS end_business_date,
                        fgen.begin_onhand_qty                         AS begin_onhand_qty,
                        fgen.end_onhand_qty                           AS end_onhand_qty,
                        fgen.recv_qty                                 AS recv_qty,
                        fgen.return_qty                               AS return_qty,
                        fgen.xfer_qty                                 AS xfer_qty,
                        fgen.adjust_qty                               AS adjust_qty,
                        fgen.waste_qty                                AS waste_qty,
                        fgen.production_qty                           AS production_qty,
                        fgen.count_variance_qty                       AS count_variance_qty,
                        fgen.sales_qty                                AS sales_qty,
                        fgen.closing_weighted_average_cost            AS closing_weighted_average_cost,
                        fgen.opening_weighted_average_cost            AS opening_weighted_average_cost,
                        fgen.wac_adjustment                           AS wac_adjustment

                FROM    #new_f_gen_inv_item_activity_bu_day               fgen    
                
                UNION ALL

                SELECT  fgen.bu_id                                    AS bu_id,
                        fgen.inventory_item_id                        AS inventory_item_id,
                        fgen.valuation_cat_id                         AS valuation_cat_id,
                        fgen.start_business_date                      AS start_business_date,
                        fgen.end_business_date                        AS end_business_date,
                        fgen.end_onhand_qty                           AS begin_onhand_qty,
                        fgen.end_onhand_qty                           AS end_onhand_qty,
                        0                                             AS recv_qty,
                        0                                             AS return_qty,
                        0                                             AS xfer_qty,
                        0                                             AS adjust_qty,
                        0                                             AS waste_qty,
                        0                                             AS production_qty,
                        0                                             AS count_variance_qty,
                        0                                             AS sales_qty,
                        fgen.closing_weighted_average_cost            AS closing_weighted_average_cost,
                        fgen.closing_weighted_average_cost            AS opening_weighted_average_cost,
                        0                                             AS wac_adjustment
        
                FROM    dm_f_gen_inv_item_activity_bu_day             fgen
                WHERE   fgen.bu_id                                    = @org_hierarchy_id     
                AND     @business_date                  BETWEEN fgen.start_business_date AND COALESCE(fgen.end_business_date, ''12/31/2075'')
                AND     @business_date                  <> fgen.start_business_date
                AND NOT EXISTS
                (
                        SELECT  1
                        FROM    #new_f_gen_inv_item_activity_bu_day   nfgen
                        WHERE   nfgen.inventory_item_id               = fgen.inventory_item_id
                )
        ) fgen

        JOIN    item_hierarchy                                        ih
        ON      ih.item_hierarchy_id                                  = fgen.valuation_cat_id

        JOIN    item                                                  i
        ON      i.item_id                                             = fgen.inventory_item_id

        JOIN    inventory_item                                        ii
        ON      ii.inventory_item_id                                  = fgen.inventory_item_id
        
        LEFT OUTER JOIN inventory_item_bu_list                        iibl
        ON      iibl.inventory_item_id                                = ii.inventory_item_id
        AND     iibl.business_unit_id                                 = fgen.bu_id

        JOIN    unit_of_measure                                       uom
        ON      COALESCE(iibl.default_reporting_uom_id, ii.valuation_uom_id)
                                                                      = uom.unit_of_measure_id

        LEFT OUTER JOIN item_hierarchy_bu_override_list               ihbol
        ON      ihbol.item_hierarchy_id                               = ih.item_hierarchy_id
        AND     ihbol.business_unit_id                                = fgen.bu_id

        LEFT OUTER JOIN item_uom_conversion                           iuc
        ON      iuc.item_id                                           = fgen.inventory_item_id
        AND     iuc.unit_of_measure_class_id                          = uom.unit_of_measure_class_id

        WHERE   COALESCE(ihbol.valuation_method_code, ih.valuation_method_code, @default_valuation_method_code, ''i'') 
                                                                      = ''w''

             

        
        AND     i.item_id                                             = @item_id
        

        

        

        

        

        

        

        
        AND
        (
                        COALESCE(fgen.begin_onhand_qty, 0)            <> 0
                OR      COALESCE(fgen.end_onhand_qty, 0)              <> 0
                OR      fgen.start_business_date                      = @business_date
        )
        
) t

LEFT OUTER JOIN rad_sys_data_accessor                                 da
ON      da.data_accessor_id                                           = t.display_org_hierarchy_id

        
WHERE
(
        COALESCE(t.purch + t.trans, 0)                                <> 0
OR      COALESCE(t.adj, 0)                                            <> 0
OR      COALESCE(t.variance, 0)                                       <> 0
OR      COALESCE(t.usage, 0)                                          <> 0
OR      COALESCE(t.eoh, 0)                                            <> 0
OR      COALESCE(t.wac, 0) - COALESCE(t.open_wac, 0)                  <> 0
OR      COALESCE(t.sales_cost, 0)                                     <> 0
)


ORDER BY da.name, t.item_hierarchy_name, t.business_date, t.item_name',
N'
@audit_result_max numeric(28,10), 
@audit_result_min numeric(28,10), 
@business_date smalldatetime, 
@category_id int, 
@current_client_id int, 
@data_source_code nvarchar(4000), 
@eoh_max money, 
@eoh_min money, 
@exclude_items_without_data_flag nchar(1), 
@item_id int, 
@org_hierarchy_id int, 
@template_client_id int, 
@wac_change_max numeric(28,10), 
@wac_change_min numeric(28,10)',

@audit_result_max = NULL, 
@audit_result_min = NULL, 
@business_date = N'11/21/2018', 
@category_id = NULL, 
@current_client_id = 1000102, 
@data_source_code = N'c', 
@eoh_max = NULL, 
@eoh_min = NULL, 
@exclude_items_without_data_flag = N'y', 
@item_id = 1048384, 
@org_hierarchy_id = 1000397, 
@template_client_id = NULL, 
@wac_change_max = NULL, 
@wac_change_min = NULL