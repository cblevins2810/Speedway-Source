SET NOCOUNT ON

IF OBJECT_ID('tempdb..#retail_modified_item_group') IS NOT NULL
    DROP TABLE #retail_modified_item_group
GO

IF OBJECT_ID('tempdb..#special_extract') IS NOT NULL
    DROP TABLE #special_extract
GO

IF OBJECT_ID('tempdb..#retail_auto_combo') IS NOT NULL
    DROP TABLE #retail_auto_combo
GO

SELECT retail_modified_item_group_id,
       REPLACE(REPLACE(RTRIM(name),',','~'), 'Chocolate', 'Choco') +
       CASE WHEN CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) = 1 THEN '' 
       ELSE ' (' + CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) + ')' END AS name, 
       REPLACE(RTRIM(description),',','~') AS description
INTO  #retail_modified_item_group     
FROM retail_modified_item_group

SELECT retail_auto_combo_id, rac.name + CASE WHEN CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by rac.name order by rac.name)) = 1 THEN '' 
ELSE ' (' + CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by rac.name order by rac.name)) + ')' END AS specialName 
INTO #retail_auto_combo
FROM Retail_Auto_Combo AS rac
WHERE EXISTS (SELECT 1 
              FROM  retail_auto_combo_item_group_list as racgl
              WHERE rac.retail_auto_combo_id = racgl.retail_auto_combo_id)

SELECT rac.retail_auto_combo_id,
ROW_NUMBER() over (partition by 'xref-' + CONVERT(NVARCHAR(15), rac.retail_auto_combo_id) order by 'xref-' + CONVERT(NVARCHAR(15), rac.retail_auto_combo_id)) AS RowNumber,
'xref-' + CONVERT(NVARCHAR(15), rac.retail_auto_combo_id) AS specialXRefID,
q.specialName,
REPLACE(rac.receipt_text,',','~') AS specialReceiptText,
CONVERT(NVARCHAR(100), rac.priority_ranking) AS priorityRanking,
rac.loyalty_flag AS requiresLoyalty,
CONVERT(nvarchar(10), rac.start_date,120) AS startDate,
CASE WHEN rac.end_date IS NULL THEN ''  
     WHEN rac.end_date > '2075-01-01' THEN ''
	 ELSE ISNULL(CONVERT(nvarchar(10), rac.end_date,120),'') END AS endDate,
rac.active_flag AS status,
REPLACE(REPLACE(rmig.name,',','~'),'Chocolate','CHOCO') AS retailItemGroupName,
CASE WHEN racigl.min_amount IS NULL THEN 'Quantity' ELSE 'Amount' END AS minimumIdentifier,
COALESCE(racigl.min_amount,racigl.min_quantity,0) AS minimumValue,
CASE d.discount_type_code
     WHEN 'e' THEN 'Percent Discount' 
     WHEN 'd' THEN 'Price Discount'
     WHEN 'r' THEN 'Set Retail'
     WHEN 'b' THEN 'Price Rollback'
END AS discountType,
ISNULL(d.discount_value,0) AS discountValue,
d.reduce_tax_flag AS taxReduced
INTO #special_extract
FROM retail_auto_combo AS rac
JOIN retail_auto_combo_item_group_list AS racigl
ON   rac.retail_auto_combo_id = racigl.retail_auto_combo_id
JOIN Retail_Modified_Item_Group AS rmig
ON   racigl.retail_modified_item_group_id = rmig.retail_modified_item_group_id
JOIN Discount AS d
ON   racigl.discount_id = d.discount_id
JOIN #retail_auto_combo AS q
ON   rac.retail_auto_combo_id = q.retail_auto_combo_id
ORDER BY 'xref-' + CONVERT(NVARCHAR(15), rac.retail_auto_combo_id)

SELECT --TOP 10
specialXRefID,
REPLACE(specialName,',','~') AS specialName,
CASE WHEN RowNumber = 1 THEN specialReceiptText ELSE '' END AS specialReceiptText,
CASE WHEN RowNumber = 1 THEN priorityRanking ELSE '' END AS priorityRanking,
CASE WHEN RowNumber = 1 THEN requiresLoyalty ELSE '' END AS requiresLoyalty,
CASE WHEN RowNumber = 1 THEN startDate ELSE '' END AS startDate,
CASE WHEN RowNumber = 1 THEN endDate ELSE '' END AS endDate,
CASE WHEN RowNumber = 1 THEN status ELSE '' END AS status,
retailItemGroupName,
minimumIdentifier,
minimumValue,
discountType,
discountValue,
taxReduced
FROM #special_extract 
ORDER BY specialName, RowNumber

IF OBJECT_ID('tempdb..#retail_modified_item_group') IS NOT NULL
    DROP TABLE #retail_modified_item_group
GO

IF OBJECT_ID('tempdb..#special_extract') IS NOT NULL
    DROP TABLE #special_extract
GO

IF OBJECT_ID('tempdb..#retail_auto_combo') IS NOT NULL
    DROP TABLE #retail_auto_combo
GO

