SET NOCOUNT ON

DECLARE @Modulus INT
DECLARE @Remainder INT
DECLARE @StartDate NVARCHAR(10)
DECLARE @EndDate NVARCHAR(10)
DECLARE @PromoFlag NVARCHAR(1)
DECLARE @BatchNumber NVARCHAR(6)

DECLARE @Today nvarchar(10)
SET @Today = CONVERT(nvarchar(10), GETDATE(),120)

/*
:SETVAR PriceEventId
*/

SET @Modulus = '$(Modulus)'
SET @Remainder = '$(Remainder)'
SET @StartDate = '$(StartDate)'
SET @EndDate = '$(EndDate)'
SET @PromoFlag = '$(PromoFlag)'
SET @BatchNumber = '$(BatchNumber)'

/*
--1,0,2019-07-20,2075-12-31,n,1
SET @Modulus = 1
SET @Remainder = 0
SET @StartDate = '2019-07-20'
SET @EndDate = '2075-12-31'
SET @PromoFlag = 'n'
SET @BatchNumber = '1'
*/

IF @BatchNumber = '1' 
   SET @BatchNumber = ''
ELSE
   SET @BatchNumber = '(' + @BatchNumber + ')' 

SELECT DISTINCT
CASE WHEN @PromoFlag = 'n' THEN 'Perm ' + @StartDate + @BatchNumber ELSE
'Temp ' + @StartDate + ' - ' + @EndDate + @BatchNumber  END AS EventName, 
@StartDate AS StartDate,
CASE WHEN @PromoFlag = 'n' THEN '' ELSE @EndDate END AS EndDate,
i.xref_code AS itemXRefId ,
REPLACE(i.name,',','~') AS ItemName,
REPLACE(rse.mg_Name,',','~') AS RetailStrategy,

COALESCE (eso_xref_code, i.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor))) AS RMIXrefId,

REPLACE(rse.mgm_name,',','~') AS RetailLevelGroup,
REPLACE(ml.name,',','~') AS RetailLevelName,

mrc.retail_price AS ListPrice 
FROM Merch_Retail_Change AS mrc
JOIN Retail_Modified_Item as rmi
ON   rmi.retail_modified_item_id = mrc.retail_modified_item_id
JOIN merch_group_member AS mgm
ON   rmi.merch_group_id = mgm.merch_group_id
AND  rmi.merch_group_member_id = mgm.merch_group_member_id
JOIN Merch_Group AS mg
ON   rmi.merch_group_id = mg.merch_group_id
JOIN merch_level AS ml
ON   mrc.merch_level_id = ml.merch_level_id
JOIN bcssa_custom_integration..bc_extract_price_event_item AS i
ON   rmi.retail_item_id = i.item_id
JOIN merch_price_event AS mpe
ON   mpe.merch_price_event_id = mrc.merch_price_event_id

LEFT JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id

LEFT JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
LEFT JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id

-- There are some items in BC that have been split into a separate item in ESO, 
-- an entry in the mapping table will result in the ESO rmi external id replacing the
-- BC rmi external id.  This table is created based upon a spreadsheet provided
-- by the pricebook team.
LEFT JOIN bcssa_custom_integration..bc_extract_item_split_mapping AS m
ON i.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor)) = m.bc_xref_code

JOIN bcssa_custom_integration..bc_extract_retail_strategy_from_eso AS rse
ON   rse.rmi_xref_code = COALESCE (eso_xref_code, i.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor)))

WHERE CASE WHEN mrc.start_date < @Today THEN @Today ELSE mrc.start_date END = @StartDate
AND   mrc.End_Date = @EndDate
AND   mrc.promo_flag = @PromoFlag
AND   change_type_code IN ('a','c')
AND   mpe.status_code = 'p'
AND   ml.business_unit_id IS NULL
AND   ml.supplier_id IS NULL
AND   ml.default_ranking > 0
AND   mrc.retail_modified_item_id % @Modulus = @Remainder

-- This is used if we want to exclude and item because it does not exist in ESO
-- As of 08/19, there are no items that meet this condition.
AND NOT EXISTS (SELECT 1
                FROM bcssa_custom_integration..bc_extract_item_split_mapping AS m
				WHERE i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)) = m.bc_xref_code
				AND   m.eso_xref_code IS NULL)
				

ORDER BY itemXRefId, RMIXrefId



