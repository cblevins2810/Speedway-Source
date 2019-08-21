UPDATE rsie
SET  rmi_id = rmi.retail_modified_item_id
FROM bcssa_custom_integration..bc_extract_retail_strategy_item_from_eso rsie
JOIN (SELECT i.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor)) AS xref_code,
      rmi.retail_modified_item_id
      FROM  Retail_Modified_Item as rmi
      JOIN  item AS i
      ON    i.item_id = rmi.retail_item_id
	  JOIN Retail_Modified_Item_Dimension_List AS rmidl
      ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id
      JOIN retail_item_dimension_member AS ridm
      ON rmidl.dimension_member_id = ridm.dimension_member_id
      JOIN unit_of_measure as ridmuom
      ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id) AS rmi
ON rsie.rmi_xref_code = rmi.xref_code

--select * from bcssa_custom_integration..bc_extract_retail_strategy_item_from_eso where rmi_id IS NULL



SET NOCOUNT ON

--DECLARE @Modulus INT
--DECLARE @Remainder INT
--DECLARE @StartDate NVARCHAR(10)
--DECLARE @EndDate NVARCHAR(10)
--DECLARE @StartDate2 SMALLDATETIME
--DECLARE @EndDate2 SMALLDATETIME
--DECLARE @PromoFlag NVARCHAR(1)
--DECLARE @BatchNumber NVARCHAR(6)

DECLARE @Today nvarchar(10)
SET @Today = CONVERT(nvarchar(10), GETDATE(),120)

SELECT DISTINCT
REPLACE(rse.mg_Name,',','~') AS RetailStrategy,
REPLACE(rse.mgm_name,',','~') AS RetailLevelGroup,
REPLACE(ml.name,',','~') AS RetailLevelName

--SELECT *

FROM Merch_Retail_Change AS mrc
JOIN Retail_Modified_Item as rmi
ON   rmi.retail_modified_item_id = mrc.retail_modified_item_id

JOIN merch_level AS ml
ON   mrc.merch_level_id = ml.merch_level_id

JOIN bcssa_custom_integration..bc_extract_price_event_item AS i
ON   rmi.retail_item_id = i.item_id

JOIN merch_price_event AS mpe
ON   mpe.merch_price_event_id = mrc.merch_price_event_id

JOIN bcssa_custom_integration..bc_extract_retail_strategy AS bcrs
ON	 ml.merch_level_id = bcrs.orig_merch_level_id

--CREATE INDEX IX1 ON bcssa_custom_integration..bc_extract_retail_strategy_item_from_eso (rmi_xref_code)
--ALTER TABLE bcssa_custom_integration..bc_extract_retail_strategy_item_from_eso ADD rmi_id INT NULL

JOIN bcssa_custom_integration..bc_extract_retail_strategy_item_from_eso AS rsie
ON   rsie.rmi_id = rmi.retail_modified_item_id

JOIN bcssa_custom_integration..bc_extract_retail_strategy_from_eso AS rse
ON   rse.mg_name = rsie.mg_name
AND  rse.mgm_name = rsie.mgm_name
AND  rse.ml_name = ml.name

WHERE mrc.end_date > @Today
AND   change_type_code IN ('a','c')
AND   mpe.status_code = 'p'
AND   ml.business_unit_id IS NULL
AND   ml.supplier_id IS NULL
AND   ml.default_ranking > 0


/*

LEFT JOIN bcssa_custom_integration..bc_extract_item_split_mapping AS m
ON i.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor)) = m.bc_xref_code





AND NOT EXISTS (SELECT 1
                FROM bcssa_custom_integration..bc_extract_item_split_mapping AS m
				WHERE i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)) = m.bc_xref_code
				AND   m.eso_xref_code IS NULL)

ORDER BY 1,2,3

--select * from bcssa_custom_integration..bc_extract_retail_strategy
*/