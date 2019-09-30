SET NOCOUNT ON
IF OBJECT_ID('tempdb..#Merch_Retail_Change') IS NOT NULL
    DROP TABLE #Merch_Retail_Change
GO

IF OBJECT_ID('tempdb..#Merch_Retail_Change_Batch') IS NOT NULL
    DROP TABLE #Merch_Retail_Change_Batch
GO

IF OBJECT_ID('tempdb..#Talley') IS NOT NULL
    DROP TABLE #Talley
GO

CREATE TABLE #talley (batch_number int)

-- The base date reflects the date that the last export was made
DECLARE @BaseDate nvarchar(10)
SET @BaseDate = '2019-04-11'

DECLARE @Today nvarchar(10)
SET @Today = CONVERT(nvarchar(10), GETDATE(),120)

DECLARE @i INT
SET @i = 1

WHILE @i <= 1000
BEGIN
   INSERT #talley SELECT @i
   SET @i = @i+1
END

-- Condition 1.  Permanent changes for the Default Level that start after the last extract date
SELECT merch_retail_change_id,
CASE WHEN mrc.start_date < @Today THEN @Today ELSE mrc.start_date END AS start_date,
mrc.end_date,
mrc.promo_flag,
mrc.retail_modified_item_id,
mrc.merch_level_id,
retail_price
INTO #Merch_Retail_Change
FROM Merch_Retail_Change AS mrc
JOIN Merch_Price_Event AS mpe
ON   mrc.merch_price_event_id = mpe.merch_price_event_id
JOIN Merch_Level AS ml
ON   mrc.merch_level_id = ml.merch_level_id
JOIN retail_modified_item AS rmi
ON   mrc.retail_modified_item_id = rmi.retail_modified_item_id
JOIN bcssa_custom_integration..bc_extract_price_event_item AS i
ON   i.item_id = rmi.retail_item_id 
WHERE mrc.start_date >= @BaseDate
AND   change_type_code IN ('a','c')
AND   mpe.status_code = 'p'
AND   mrc.promo_flag = 'n'
AND   ml.business_unit_id IS NULL
AND   ml.supplier_id IS NULL
AND   ml.default_ranking = 999
UNION

-- Condition 2.  Permanent & temporary changes for the non Default Levels that are in effect
-- This logic is only applicable for the first execution after the initial load because the
-- initial load only supports a permanent change for the default level.
SELECT merch_retail_change_id,
CASE WHEN mrc.start_date < @Today THEN @Today ELSE mrc.start_date END AS start_date,
mrc.end_date,
mrc.promo_flag,
mrc.retail_modified_item_id,
mrc.merch_level_id,
retail_price
FROM Merch_Retail_Change AS mrc
JOIN Merch_Price_Event AS mpe
ON   mrc.merch_price_event_id = mpe.merch_price_event_id
JOIN Merch_Level AS ml
ON   mrc.merch_level_id = ml.merch_level_id
JOIN retail_modified_item AS rmi
ON   mrc.retail_modified_item_id = rmi.retail_modified_item_id
JOIN bcssa_custom_integration..bc_extract_price_event_item AS i
ON   i.item_id = rmi.retail_item_id 
WHERE mrc.end_date >= @today
AND   change_type_code IN ('a','c')
AND   mpe.status_code = 'p'
AND   ml.business_unit_id IS NULL
AND   ml.supplier_id IS NULL
AND   ml.default_ranking > 0
AND   ml.default_ranking < 999
UNION

-- Condition 3.  Temporary changes for the Default Level that are in effect.
-- This logic is only applicable for the first execution after the initial load
-- because the initial load only supports a permanent change for the default level.
SELECT merch_retail_change_id,
CASE WHEN mrc.start_date < @Today THEN @Today ELSE mrc.start_date END AS start_date,
mrc.end_date,
mrc.promo_flag,
mrc.retail_modified_item_id,
mrc.merch_level_id,
retail_price
FROM Merch_Retail_Change AS mrc
JOIN Merch_Price_Event AS mpe
ON   mrc.merch_price_event_id = mpe.merch_price_event_id
JOIN Merch_Level AS ml
ON   mrc.merch_level_id = ml.merch_level_id
JOIN retail_modified_item AS rmi
ON   mrc.retail_modified_item_id = rmi.retail_modified_item_id
JOIN bcssa_custom_integration..bc_extract_price_event_item AS i
ON   i.item_id = rmi.retail_item_id 
WHERE mrc.end_date >= @today
AND   change_type_code IN ('a','c')
AND   mpe.status_code = 'p'
AND   mrc.promo_flag = 'y'
AND   ml.business_unit_id IS NULL
AND   ml.supplier_id IS NULL
AND   ml.default_ranking = 999

SELECT COUNT(*) AS batch_total,
CEILING(COUNT(*)/2500)+1 AS batch_count,
start_date,
end_date,
promo_flag
INTO #Merch_Retail_Change_Batch
FROM #merch_retail_change
GROUP BY start_date, end_date, promo_flag
ORDER BY start_date, end_date, promo_flag

SELECT b.batch_count,
t.batch_number-1,
CONVERT(nvarchar(10),start_date,120),
CONVERT(nvarchar(10),end_date,120),
promo_flag,
CASE WHEN t.batch_number < 10 THEN '00' + CONVERT(NVARCHAR(1), t.batch_number)
WHEN t.batch_number < 100 THEN '0' + CONVERT(NVARCHAR(2), t.batch_number)
ELSE CONVERT(NVARCHAR(3), t.batch_number) END
FROM #Merch_Retail_Change_Batch as b
JOIN #talley as t
ON   t.batch_number <= b.batch_count
ORDER BY promo_flag, start_date, end_date, t.batch_number 

IF OBJECT_ID('tempdb..#Merch_Retail_Change_Batch') IS NOT NULL
    DROP TABLE #Merch_Retail_Change_Batch
GO

IF OBJECT_ID('tempdb..#Merch_Retail_Change') IS NOT NULL
    DROP TABLE #Merch_Retail_Change
GO

