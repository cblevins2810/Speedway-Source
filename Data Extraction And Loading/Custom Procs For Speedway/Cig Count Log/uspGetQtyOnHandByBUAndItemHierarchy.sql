/*

   This procedure should be installed in the main ESO database.
   It accepts two required input parameters, the Business Unit Code
   and the Name of a node in the Item Hierarchy.
   It accepts one output parameter.  The qty on hand for the
   Business Unit and Item Hierarchy will be set to the output parameter.
   This procedure does not return an error code.  If an invalid 
   Business Unit Code or Item Hierarchy Name is passed in, the output
   parameter variable will be set to NULL.
   
*/ 
USE VP60_Spwy
GO
  
IF OBJECT_ID('uspGetQtyOnHandByBUAndItemHierarchy') IS NOT NULL
    DROP PROCEDURE uspGetQtyOnHandByBUAndItemHierarchy
GO

CREATE PROCEDURE uspGetQtyOnHandByBUAndItemHierarchy
@BU_Code nvarchar(20),
@Item_Hierarchy_Name nvarchar(50), 
@Qty_On_Hand INT OUTPUT
AS

SET NOCOUNT ON

BEGIN

/* Drop the table for the list of items with the Hierarchy.  It should not be there, so this is just a safety measure */
IF OBJECT_ID('tempdb..#item') IS NOT NULL
    DROP TABLE #item

DECLARE @Item_Hierarchy_Id INT
DECLARE @Item_Hierarchy_Level TINYINT
DECLARE @Highest_Item_Hierarchy_Level TINYINT
DECLARE @current_datetime DATETIME
DECLARE @Business_Unit_Id INT

/* Always use the current date */
SET @current_datetime = GETDATE()

/* Get the id of the Business Unit based upon the Code */
SELECT @Business_Unit_Id = Data_Accessor_id
FROM VP60_eso..Rad_Sys_Data_Accessor
WHERE name = @BU_Code

/* Get the id of the Item Hierarchy based upon the Name */
SELECT @Item_Hierarchy_Id = item_hierarchy_id,
       @Item_Hierarchy_Level = hierarchy_level
FROM VP60_eso..item_hierarchy WHERE name = @Item_Hierarchy_Name

/* Determine the highest level of the tree (subcategory) */
SELECT @Highest_Item_Hierarchy_Level = MAX(tree_depth)
FROM VP60_eso..item_hierarchy_level

/* Create a list of items within the subcategory */
SELECT i.item_id INTO #Item
FROM VP60_eso..Item AS i
JOIN VP60_eso..Item_Hierarchy_List AS ihl
ON ihl.item_hierarchy_id = i.item_hierarchy_id
WHERE ihl.hierarchy_level = @Highest_Item_Hierarchy_Level
AND ihl.parent_hierarchy_level = @Item_Hierarchy_Level
AND ihl.parent_item_hierarchy_id = @Item_Hierarchy_Id

/* Get the total Qty on Hand for the items in the Item Hierarchy and the Business Unit */
SELECT @Qty_On_Hand = SUM(oh.atomic_on_hand_qty / oh.factor) 
        
FROM
(
        SELECT  atomic_oh.business_unit_id                                    AS business_unit_id,
                atomic_oh.inventory_item_id                                   AS inventory_item_id,
				atomic_oh.atomic_on_hand_qty                                  AS atomic_on_hand_qty,
                COALESCE(uomcv.atomic_conversion_factor * uom.factor, uom.factor) AS factor
        
        FROM
        (
                SELECT  atomic_oh.*,
				COALESCE(iibl.default_reporting_uom_id, invitm.valuation_uom_id) AS valuation_uom_id 
                FROM
                (
                        SELECT  oh.business_unit_id                           AS business_unit_id,
                                oh.inventory_item_id                          AS inventory_item_id,
                                SUM(COALESCE(ohl.atomic_transaction_quantity, 0)) + MIN(COALESCE(oh.atomic_total_count,0))  AS atomic_on_hand_qty
          
                        FROM    VP60_eso..inventory_item_bu_on_hand           oh                                
        
                        LEFT OUTER JOIN VP60_eso..inventory_item_bu_on_hand_list        ohl
                        ON      ohl.business_unit_id                          = oh.business_unit_id
                        AND     ohl.business_unit_id                          = @business_unit_Id
                        AND     ohl.inventory_item_id                         = oh.inventory_item_id
                        AND     ohl.begin_date                                >= oh.begin_date
                        AND     ohl.begin_date                                < @current_datetime                             
                      
                        WHERE   oh.business_unit_id                           = @business_unit_Id
                        AND     oh.begin_date                                 <= @current_datetime
                        AND     oh.end_date                                   > @current_datetime
                     
                        GROUP BY oh.business_unit_id, oh.inventory_item_id
                ) atomic_oh

                JOIN    VP60_eso..item                                          itm
                ON      itm.item_id                                   = atomic_oh.inventory_item_id
                AND     itm.item_type_code                            = 'i'
                AND     itm.purge_flag                                <> 'y'
                AND     itm.track_flag                                = 'y'
                AND     itm.recipe_flag                               = 'n'

                JOIN    VP60_eso..inventory_item                                invitm
                ON      invitm.inventory_item_id                      = atomic_oh.inventory_item_id
                AND     invitm.exclude_on_hand_tracking_flag          = 'n'
              
                LEFT OUTER JOIN VP60_eso..inventory_item_bu_list                iibl
                ON      iibl.business_unit_id                         = atomic_oh.business_unit_id
                AND     iibl.business_unit_id                         = @business_unit_Id
                AND     iibl.inventory_item_id                        = atomic_oh.inventory_item_id
          
        ) atomic_oh
  
        JOIN    VP60_eso..unit_of_measure                                       uom
        ON      uom.unit_of_measure_id                                = atomic_oh.valuation_uom_id
        
        LEFT OUTER JOIN VP60_eso..item_uom_conversion                           uomcv
        ON      uomcv.item_id                                         = atomic_oh.inventory_item_id
        AND     uomcv.unit_of_measure_class_id                        = uom.unit_of_measure_class_id

) oh

/* Only pull items based upon the Hierarchy */
JOIN #Item AS ifilter
ON   oh.inventory_item_id = ifilter.item_id

/* Drop the table for the list of items with the Hierarchy.  It should not be there, so this is just a safety measure */
IF OBJECT_ID('tempdb..#item') IS NOT NULL
    DROP TABLE #item

END