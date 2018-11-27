/*

   This procedure should be installed in the main ESO database.
   It accepts two required input parameters, the Business Unit Code
   and a xml document with a list of items.
   It returns a result set with the item xref_code, qty on hand,
   and the weighted average cost of the item. If an invalid 
   Business Unit Code is passed in, the result set will be
   empty, if the item xref_code is invalid, no row will be returned
   for that item.
   
*/   
IF OBJECT_ID('sp_Get_Qty_On_Hand_And_WAC_by_BU_and_ItemList') IS NOT NULL
    DROP PROCEDURE sp_Get_Qty_On_Hand_And_WAC_by_BU_and_ItemList
GO

CREATE PROCEDURE sp_Get_Qty_On_Hand_And_WAC_by_BU_and_ItemList
@ClientId 	INT,
@BUCode 	NVARCHAR(20),
@XMLInput AS NTEXT
AS

SET NOCOUNT ON
--
--   Internal Declarations, Variables and Tables.
--
DECLARE @idoc                       INT
DECLARE @BusinessUnitCode           NVARCHAR(50)
DECLARE @BusinessUnitId             INT
DECLARE @CurrentDateTime			DATETIME

/* Always use the current date */
SET @CurrentDateTime = GETDATE()

IF OBJECT_ID('tempdb..#DiscontinuedItem') IS NOT NULL
    DROP TABLE #DiscontinuedItem

CREATE TABLE #DiscontinuedItem (
		ItemExternalId    		NVARCHAR(100) NOT NULL,
		ResolvedItemId			INT NULL,
		QuantityOnHand			INT NOT NULL DEFAULT 0,
		WeightedAverageCost     SMALLMONEY NOT NULL DEFAULT 0)

/* Get the id of the Business Unit based upon the Code */
SELECT 	@BusinessUnitId = Data_Accessor_id
FROM 	Rad_Sys_Data_Accessor
WHERE 	name 		= @BUCode
AND  	client_id 	= @ClientId

IF @BusinessUnitId IS NOT NULL
BEGIN

	EXEC sp_xml_preparedocument @idoc OUTPUT, @XMLInput

	INSERT 	#DiscontinuedItem (
			ItemExternalId)
	SELECT 	ItemExternalId
	FROM OPENXML (@iDoc, '/DiscontinuedItemList/Item',2)  
	WITH  	(ItemExternalId    NVARCHAR(30)	'@ItemExternalID')

	-- Free the xml pointer
	EXEC sp_xml_removedocument @iDoc  

	UPDATE di
	SET  ResolvedItemId = i.item_id
	FROM #DiscontinuedItem AS di
	JOIN Item As i
	ON   i.xref_code = di.ItemExternalId

	/* Get the total Qty on Hand for the items in the Item Hierarchy and the Business Unit */
SELECT i.*, oh.atomic_on_hand_qty / oh.factor 
FROM #DiscontinuedItem AS i
LEFT JOIN 
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
          
                        FROM    inventory_item_bu_on_hand                     oh                                
        
                        LEFT OUTER JOIN inventory_item_bu_on_hand_list        ohl
                        ON      ohl.business_unit_id                          = oh.business_unit_id
                        AND     ohl.business_unit_id                          = @BusinessUnitId
                        AND     ohl.inventory_item_id                         = oh.inventory_item_id
                        AND     ohl.begin_date                                >= oh.begin_date
                        AND     ohl.begin_date                                < @CurrentDateTime                             
                      
                        WHERE   oh.business_unit_id                           = @BusinessUnitId
                        AND     oh.begin_date                                 <= @CurrentDateTime
                        AND     oh.end_date                                   > @CurrentDateTime
                     
                        GROUP BY oh.business_unit_id, oh.inventory_item_id
                ) atomic_oh

                JOIN    item                                          itm
                ON      itm.item_id                                   = atomic_oh.inventory_item_id
                --AND     itm.item_type_code                            = 'i'
                --AND     itm.purge_flag                                <> 'y'
                --AND     itm.track_flag                                = 'y'
                --AND     itm.recipe_flag                               = 'n'

                JOIN    inventory_item                                invitm
                ON      invitm.inventory_item_id                      = atomic_oh.inventory_item_id
                --AND     invitm.exclude_on_hand_tracking_flag          = 'n'
              
                LEFT OUTER JOIN inventory_item_bu_list                iibl
                ON      iibl.business_unit_id                         = atomic_oh.business_unit_id
                AND     iibl.business_unit_id                         = @BusinessUnitId
                AND     iibl.inventory_item_id                        = atomic_oh.inventory_item_id
          
        ) atomic_oh
  
        JOIN    unit_of_measure                                       uom
        ON      uom.unit_of_measure_id                                = atomic_oh.valuation_uom_id
        
        LEFT OUTER JOIN item_uom_conversion                           uomcv
        ON      uomcv.item_id                                         = atomic_oh.inventory_item_id
        AND     uomcv.unit_of_measure_class_id                        = uom.unit_of_measure_class_id

) oh

ON   oh.inventory_item_id = i.ResolvedItemId

SELECT	ItemExternalId,
		QuantityOnHand,
		WeightedAverageCost
FROM 	#DiscontinuedItem
WHERE   ResolvedItemId IS NOT NULL

END

IF OBJECT_ID('tempdb..#DiscontinuedItem') IS NOT NULL
    DROP TABLE #DiscontinuedItem

