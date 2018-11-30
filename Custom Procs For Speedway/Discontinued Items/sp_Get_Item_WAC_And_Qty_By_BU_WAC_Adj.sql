IF OBJECT_ID('sp_Get_Item_WAC_And_Qty_By_BU_WAC_Adj') IS NOT NULL
    DROP PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_WAC_Adj
GO

CREATE PROCEDURE sp_Get_Item_WAC_And_Qty_By_BU_WAC_Adj
@Business_unit_id INT,
@Business_Date SMALLDATETIME,
@discontinued_item discontinued_item READONLY
AS

SET NOCOUNT ON

BEGIN

DECLARE @item_hierarchy_level_id    INT
DECLARE @client_id INT

SELECT  @item_hierarchy_level_id    = item_hierarchy_level_id,
        @client_id                  = ihl.client_id
FROM    item_hierarchy_level        ihl
JOIN    rad_sys_data_accessor       rsda
ON      ihl.client_id               = rsda.client_id
WHERE   valuation_level_flag        = 'y'
AND     rsda.data_accessor_id       = @business_unit_id

INSERT #Inventory_WAC_Adjustment_BU_List (
       wac_adjustment_id,
       inventory_item_id,
       atomic_cost,
       active_flag,
       valuation_cat_id     
     )
SELECT		w.wac_adjustment_id,
			w.inventory_item_id,
			wl.atomic_cost,
			wl.active_flag,
			pih.item_hierarchy_id
FROM  		Inventory_WAC_Adjustment    w

JOIN		Inventory_WAC_Adjustment_BU_List wl    
ON 			wl.wac_adjustment_id 	= w.wac_adjustment_id

JOIN 		Item                	itm
ON 			itm.item_id 			= w.inventory_item_id

JOIN 		@discontinued_item 		di 
ON 			itm.item_id 			= di.resolved_item_id  

JOIN 		Item_hierarchy        	ih
ON 			ih.item_hierarchy_id 	= itm.item_hierarchy_id

JOIN 		Item_hierarchy        	pih
ON 			ih.setstring            LIKE pih.setstring + '%'
AND 		pih.item_hierarchy_level_id     = @item_hierarchy_level_id

LEFT JOIN	inventory_client_parameters icp
ON 			icp.client_id  			= @client_id

LEFT JOIN  	item_hierarchy_bu_override_list ihbol
ON 			ihbol.item_hierarchy_id = pih.item_hierarchy_id
AND 		ihbol.business_unit_id  = @business_unit_id

WHERE 		w.status_Code in ('p')
AND 		wl.business_unit_id 	= @business_unit_id
AND 		wl.active_flag 			= 'a'
AND 		wl.atomic_cost 			> 0 
AND	 		COALESCE(ihbol.valuation_method_code, ih.valuation_method_code, icp.valuation_method_code, 'i') = 'w'

UPDATE wl
SET business_date = @business_date
FROM #Inventory_WAC_Adjustment_BU_List wl
JOIN (
        select inventory_item_id, MAX(ABS(wl.wac_adjustment_id)) wac_adjustment_id
          from #Inventory_WAC_Adjustment_BU_List wl
         group by inventory_item_id
       ) t
ON 	t.inventory_item_id = wl.inventory_item_id
AND t.wac_adjustment_id = wl.wac_adjustment_id

SELECT wac_adjustment_id,
       inventory_item_id,
       atomic_cost,
       active_flag,
       valuation_cat_id     
FROM #Inventory_WAC_Adjustment_BU_List
   
END


