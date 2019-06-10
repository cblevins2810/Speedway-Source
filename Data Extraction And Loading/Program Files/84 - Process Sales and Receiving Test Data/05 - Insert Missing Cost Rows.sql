DECLARE @business_date datetime
DECLARE @business_unit_id int 
DECLARE @current_client_id int
DECLARE @item_hierarchy_level_id        INT
DECLARE @default_valuation_method_code  NCHAR(1)

SET @current_client_id = 10000001

SELECT @business_unit_id = data_accessor_id
FROM   rad_sys_data_accessor
WHERE  name IN (
'0006472')

SELECT @business_date = MAX(day_to_close) + 1 FROM bc_extract_replenishment

SELECT  @item_hierarchy_level_id        = item_hierarchy_level_id
FROM    item_hierarchy_level            ihl
WHERE   client_id                       = @current_client_id
AND     valuation_level_flag            = 'y'

SELECT  @default_valuation_method_code  = valuation_method_code
FROM    inventory_client_parameters     icp
WHERE   icp.client_id                   = @current_client_id

--SELECT @item_hierarchy_level_id
--SELECT @default_valuation_method_code


--Cannot insert duplicate key in object 'dbo.f_gen_inv_item_activity_bu_day'. The duplicate key value is (Jan  1 1900 12:00AM, 10001577, 10017398).

INSERT VP60_eso_wh..F_GEN_INV_ITEM_ACTIVITY_BU_DAY
(bu_id,
start_business_date,
inventory_item_id,
atomic_uom_id,
closing_weighted_average_cost)

SELECT DISTINCT @business_unit_id,
'1900-01-01',
i.item_id,
3,
0
        
        FROM    dm_f_gen_inv_sales_usage  usg
        
        JOIN    item                      i
        ON      i.item_id                 = usg.inventory_item_id
        
        JOIN    item_hierarchy            ih
        ON      ih.item_hierarchy_id      = i.item_hierarchy_id
        
        JOIN    item_hierarchy            pih
        ON      pih.item_hierarchy_level_id = @item_hierarchy_level_id
        AND     ih.setstring              LIKE pih.setstring + '%'
        
        LEFT OUTER JOIN item_hierarchy_bu_override_list ihbol
        ON      ihbol.item_hierarchy_id   = pih.item_hierarchy_id
        AND     ihbol.business_unit_id    = @business_unit_id
        
        WHERE   usg.bu_id                 = @business_unit_id
        AND     usg.business_date         = @business_date
        AND     COALESCE(ihbol.valuation_method_code, pih.valuation_method_code, @default_valuation_method_code, 'i') = 'w'
        AND     i.item_type_code          = 'i' 
        AND NOT EXISTS (  SELECT 1 FROM retail_item ri
                 WHERE  ri.retail_item_id = i.item_id
                 AND    ri.retail_item_type_code IN ( 'e', 's', 'r', 'j', 'k' ) )
        AND (i.recipe_flag = 'y' OR (i.track_flag = 'y' AND i.recipe_flag <> 'y'))
        AND NOT EXISTS
        (
            SELECT  1
            FROM    dm_f_gen_inv_item_activity_bu_day cost
            WHERE   cost.bu_id     = @business_unit_id
            AND     cost.inventory_item_id    = i.item_id
            AND     cost.start_business_date  <= @business_date
            AND     cost.closing_weighted_average_cost IS NOT NULL
        )
        AND NOT EXISTS
        (
            SELECT  1
            FROM    inventory_item_bu_cost_list cost
            WHERE   cost.business_unit_id     = @business_unit_id
            AND     cost.inventory_item_id    = i.item_id
            AND     cost.business_date        <= @business_date
                    
        )

		