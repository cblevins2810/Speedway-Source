SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#retail_level') IS NOT NULL
    DROP TABLE #retail_level

IF OBJECT_ID('tempdb..#business_unit') IS NOT NULL
    DROP TABLE #business_unit

DECLARE @Modulus INT
DECLARE @Remainder INT
DECLARE @start_date SMALLDATETIME
SET @start_date = GETDATE()

SET @Modulus = '$(Modulus)'
SET @Remainder = '$(Remainder)'

CREATE TABLE #business_unit
( RowNumber INT NOT NULL,
business_unit_id INT NOT NULL)

INSERT #business_unit
SELECT ROW_NUMBER() OVER (ORDER BY business_unit_id) + 600 AS RowNumber, --over (partition by business_unit_id order by business_unit_id) AS RowNumber,
business_unit_id AS business_unit_id
FROM business_unit
WHERE status_code <> 'c'

DELETE #business_unit
WHERE RowNumber % @Modulus != @Remainder

CREATE TABLE #retail_level
( business_unit_id INT NOT NULL,
 merch_level_id int not null, 
 ranking int not null)

DECLARE @org_hierarchy_list TABLE
(business_unit_id int not null,
 org_hierarchy_id int not null,
 org_hierarchy_level int not null)

INSERT @org_hierarchy_list
( business_unit_id,
 org_hierarchy_id,
 org_hierarchy_level)
SELECT org_hierarchy_id as business_unit_id,
       parent_org_hierarchy_id    AS org_hierarchy_id,   
       parent_org_hierarchy_level  AS org_hierarchy_level
FROM  org_hierarchy_list AS ohl (NOLOCK) 
WHERE ohl.virtual_level_flag = 'n'   
AND  org_hierarchy_id IN (SELECT business_unit_id FROM #business_unit) --@BusinessUnitId   
UNION ALL   
SELECT business_unit_id,business_unit_id, 999 FROM #business_unit

INSERT #retail_level
( business_unit_id, 
  merch_level_id,
  ranking )
SELECT ohl.business_unit_id, --ohl.org_hierarchy_id, --@BusinessUnitId,
mrlgl.merch_level_id,
mrlgl.ranking
FROM merch_retail_level_group_change_list AS mrlgcl (NOLOCK) 
JOIN @org_hierarchy_list AS ohl   
 ON  @start_date BETWEEN mrlgcl.start_date and mrlgcl.end_date      
 AND ohl.org_hierarchy_id = mrlgcl.org_hierarchy_id   
 AND NOT EXISTS ( SELECT 1    
          FROM merch_retail_level_group_change_list AS mrlgcl2  (NOLOCK) 
          JOIN @org_hierarchy_list AS ohl2     
           ON ohl2.org_hierarchy_id = mrlgcl2.org_hierarchy_id   
          WHERE mrlgcl2.merch_group_id = mrlgcl.merch_group_id   
           AND mrlgcl2.merch_group_member_id = mrlgcl.merch_group_member_id   
           AND @start_date BETWEEN mrlgcl2.start_date and mrlgcl2.end_date 
           AND ohl.org_hierarchy_level < ohl2.org_hierarchy_level ) 
JOIN merch_retail_level_group_list mrlgl (NOLOCK)
ON  mrlgl.merch_retail_level_group_id = mrlgcl.merch_retail_level_group_id
JOIN merch_level ml (NOLOCK)
ON  mrlgl.merch_level_id = ml.merch_level_id
AND ml.default_ranking > 0
UNION ALL
SELECT ml.business_unit_id, ml.merch_level_id,
ml.default_ranking
FROM merch_level ml (NOLOCK)
WHERE ml.business_unit_id IN (SELECT business_unit_id FROM #business_unit) --= @BusinessUnitId 
AND default_ranking = -1

--SELECT DISTINCT * FROM @org_hierarchy_list ORDER by org_hierarchy_level
--SELECT distinct * FROM #retail_level AS rl
--JOIN Rad_Sys_Data_Accessor AS rsda
--ON  rl.business_unit_id = rsda.data_accessor_id
--ORDER BY business_unit_id

SELECT REPLACE(rsda.long_name,',','~') AS BUName,
'_' + rsda.name AS BUIdentifier,
REPLACE(i.name, ',','~') AS itemName,
i2.xref_code + '-' + CONVERT(NVARCHAR(15), CONVERT(INT, ridmuom.factor)) ASitemRetailPackXRefID,
mrc.retail_price AS retailPrice,
CASE WHEN mrc.start_date < @start_date THEN CONVERT(nvarchar(10), @start_date,120)
     ELSE CONVERT(nvarchar(10), mrc.start_date,120) END AS startDate,
ISNULL(CONVERT(nvarchar(10), mrc.end_date,120),'') AS endDate

FROM merch_retail_change AS mrc
JOIN #retail_level rl
ON  rl.merch_level_id = mrc.merch_level_id
AND  rl.ranking = ( SELECT MIN( rl2.ranking )      
           FROM #retail_level AS rl2
           JOIN merch_retail_change AS mrc2 (NOLOCK)
           ON  rl2.merch_level_id = mrc2.merch_level_id
           WHERE @start_date BETWEEN mrc2.start_date AND mrc2.end_date      
           AND  mrc2.change_type_code IN ('a', 'c')
           AND  mrc2.merch_retail_type_id = 1
           AND  mrc2.promo_flag = 'n'
           AND  mrc2.retail_modified_item_id = mrc.retail_modified_item_id
		   AND  rl.business_unit_id = rl2.business_unit_id)

JOIN retail_modified_item AS rmi
ON   mrc.retail_modified_item_id = rmi.retail_modified_item_id
JOIN bcssa_custom_integration..bc_extract_bu_price_change_item AS i
ON   rmi.retail_item_id = i.item_id
JOIN item AS i2 -- The right way to do this is to add the xref_code to the item extract table
ON i.item_id = i2.item_id
JOIN Rad_Sys_Data_Accessor AS rsda
ON   rl.business_unit_id = rsda.data_accessor_id

LEFT JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id

LEFT JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
LEFT JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id
        
WHERE @start_date BETWEEN mrc.start_date AND mrc.end_date      
AND  mrc.change_type_code IN ('a', 'c')
AND  mrc.merch_retail_type_id = 1
AND  mrc.promo_flag = 'n'
AND  NOT EXISTS (SELECT 1 FROM Merch_Retail_Change AS mrc2
                 WHERE mrc2.start_date = mrc.start_date
                 AND  mrc2.end_date = mrc.end_date
                 AND  mrc2.merch_level_id = mrc.merch_level_id
                 AND  mrc2.promo_flag = 'n'
                 AND  mrc2.retail_modified_item_id = mrc.retail_modified_item_id
                 AND  mrc2.merch_retail_change_id > mrc.merch_retail_change_id)
				 
AND EXISTS ( SELECT 1
             FROM   item_da_effective_date_list AS dalst
             JOIN   da_list_dro AS dro
             ON     dro.current_org_hierarchy_id = rl.business_unit_id
             JOIN   Org_Hierarchy AS oh 
             ON     oh.org_hierarchy_id = dro.current_org_hierarchy_id
             AND    dalst.data_accessor_id = dro.assigned_data_accessor_id 
             AND    dalst.item_id = i.item_id 
             AND    @start_date between dalst.start_date and dalst.end_date ) 


/* Drop all the temp tables */
IF OBJECT_ID('tempdb..#retail_level') IS NOT NULL
    DROP TABLE #retail_level

IF OBJECT_ID('tempdb..##business_unit') IS NOT NULL
    DROP TABLE #business_unit


GO

