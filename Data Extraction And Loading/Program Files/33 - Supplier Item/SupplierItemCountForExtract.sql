SET NOCOUNT ON

DECLARE @MerchCostChangeEffectiveDate AS smalldatetime
SET		@MerchCostChangeEffectiveDate = CONVERT(smalldatetime, SYSDATETIME())

DECLARE @supplier TABLE (supplier_id INT, name nvarchar(128))

-- Added for support of incremental extract
DECLARE	@last_max_id	INT
-- Set this to the max Item Id from the last extract
SET		@last_max_id	= 0
-- END for additional changes


INSERT @supplier (supplier_id, name)
SELECT s.supplier_id, s.name
FROM   supplier_da_effective_date_list as l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   rad_sys_data_accessor as rsda
ON     l.data_accessor_id = rsda.data_accessor_id
JOIN   business_unit_group as bug
ON     bug.business_unit_group_id = rsda.data_accessor_id
WHERE  EXISTS (SELECT 1
              FROM Business_Unit_Group_List as bugl
              JOIN Business_Unit AS bu
              ON   bug.business_unit_group_id = bugl.business_unit_group_id
			  AND  bugl.business_unit_id = bu.business_unit_id
			  WHERE bu.status_code != 'c')
AND    s.status_code <> 'i'			  
UNION 			  
SELECT s.supplier_id, s.name
FROM   supplier_da_effective_date_list as l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   rad_sys_data_accessor as rsda
ON     l.data_accessor_id = rsda.data_accessor_id
JOIN   business_unit as bu
ON     bu.business_unit_id = rsda.data_accessor_id
WHERE  bu.status_code != 'c'
AND    s.status_code <> 'i'			  

IF OBJECT_ID('tempdb..#supplier_item_counts') IS NOT NULL
    DROP TABLE #supplier_item_counts
CREATE TABLE #supplier_item_counts
(supplier_id int,
 supplier_item_id int,
 cost_level_count int,
 barcode_count int)
 
IF OBJECT_ID('tempdb..#supplier_item_extract') IS NOT NULL
    DROP TABLE #supplier_item_extract
CREATE TABLE #supplier_item_extract
(supplier_id int not null,
 supplier_item_id int not null,
 supplier_item_row_number int not null,
 supplier_item_code nvarchar(50) not null,
 barcode_type nvarchar(1) null,
 barcode_number nvarchar(255) null,
 cost_level_name nvarchar(50) null,
 package_cost smallmoney null,
 package_allowance smallmoney null,
 start_date smalldatetime null,
 end_date smalldatetime null)
 
CREATE INDEX IX1 ON #supplier_item_extract (supplier_id, supplier_item_id, supplier_item_row_number)

IF OBJECT_ID('tempdb..#supplier_item_count_batch') IS NOT NULL
    DROP TABLE #supplier_item_count_batch
CREATE TABLE #supplier_item_count_batch
(supplier_xref nvarchar(50),
 supplier_name nvarchar(50),
 batch_total int,
 batch_count int)

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley

CREATE TABLE #talley (batch_number int)
INSERT #talley SELECT 1
INSERT #talley SELECT 2    
INSERT #talley SELECT 3
INSERT #talley SELECT 4
INSERT #talley SELECT 5
INSERT #talley SELECT 6
INSERT #talley SELECT 7
INSERT #talley SELECT 8
INSERT #talley SELECT 9
INSERT #talley SELECT 10
INSERT #talley SELECT 11
INSERT #talley SELECT 12
INSERT #talley SELECT 13
INSERT #talley SELECT 14
INSERT #talley SELECT 15
INSERT #talley SELECT 16
INSERT #talley SELECT 17
INSERT #talley SELECT 18
INSERT #talley SELECT 19
INSERT #talley SELECT 20
INSERT #talley SELECT 21
INSERT #talley SELECT 22
INSERT #talley SELECT 23
INSERT #talley SELECT 24
INSERT #talley SELECT 25
INSERT #talley SELECT 26
INSERT #talley SELECT 27
INSERT #talley SELECT 28
INSERT #talley SELECT 29
INSERT #talley SELECT 30
INSERT #talley SELECT 31
INSERT #talley SELECT 32
INSERT #talley SELECT 33
INSERT #talley SELECT 34
INSERT #talley SELECT 35
INSERT #talley SELECT 36
INSERT #talley SELECT 37
INSERT #talley SELECT 38
INSERT #talley SELECT 39
INSERT #talley SELECT 40
INSERT #talley SELECT 41
INSERT #talley SELECT 42
INSERT #talley SELECT 43
INSERT #talley SELECT 44
INSERT #talley SELECT 45
INSERT #talley SELECT 46
INSERT #talley SELECT 47
INSERT #talley SELECT 48
INSERT #talley SELECT 49
INSERT #talley SELECT 50

INSERT #Supplier_Item_Counts(Supplier_Id, Supplier_Item_Id, Cost_Level_Count, Barcode_Count)  
SELECT si.supplier_Id, si.supplier_item_id, clc.cost_level_count, barcode_count
FROM supplier_item AS si (NOLOCK)

JOIN @supplier AS s
ON  si.supplier_id = s.supplier_Id

LEFT JOIN (SELECT supplier_Id, supplier_Item_Id, COUNT(*) AS cost_level_count
      FROM merch_cost_change AS mcc (NOLOCK)
      WHERE mcc.promo_flag IN ('n')
      AND mcc.change_type_code IN ('a','c') 
      AND mcc.start_date <= @MerchCostChangeEffectiveDate
      AND	(mcc.end_date > @MerchCostChangeEffectiveDate
      OR	mcc.end_date IS NULL)
      GROUP BY supplier_id, supplier_item_id) AS clc
ON  si.supplier_id = clc.supplier_id
AND si.supplier_item_id = clc.supplier_item_id
LEFT JOIN (SELECT supplier_Id, supplier_Item_Id, COUNT(*) AS barcode_count
      FROM supplier_item_barcode AS sib (NOLOCK)
      WHERE barcode_type_code IN ('e','g','u')
      GROUP BY supplier_id, supplier_item_id) AS bcc
ON  si.supplier_id = bcc.supplier_id
AND si.supplier_item_id = bcc.supplier_item_id

INSERT #supplier_item_extract
(supplier_id,
 supplier_item_id,
 supplier_item_row_number,
 supplier_item_code,
 cost_level_name,
 package_cost,
 package_allowance,
 start_date,
 end_date)

SELECT sics.supplier_id,
sics.supplier_item_id,
ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, mcl.merch_cost_level_id) AS supplier_item_row_number, 
spi.supplier_item_code,
mcl.name,
mcc.supplier_price,
mcc.supplier_allowance,
mcc.start_date,
mcc.end_date
FROM #supplier_item_counts AS sics (NOLOCK)
JOIN Supplier_Packaged_Item AS spi (NOLOCK)
ON   spi.supplier_id = sics.supplier_id
AND  spi.supplier_item_id = sics.supplier_item_id
JOIN merch_cost_change AS mcc (NOLOCK)
ON   spi.supplier_id = mcc.supplier_id
AND  spi.supplier_item_id = mcc.supplier_item_id
JOIN Merch_Cost_Level as mcl (NOLOCK)
ON   mcl.supplier_id = mcc.supplier_id
AND  mcl.merch_cost_level_id = mcc.merch_cost_level_id
WHERE mcc.promo_flag IN ('n')
AND mcc.change_type_code IN ('a','c') 
AND mcc.start_date <= @MerchCostChangeEffectiveDate
AND	(mcc.end_date > @MerchCostChangeEffectiveDate
OR	mcc.end_date IS NULL)
AND sics.barcode_count < sics.cost_level_count

INSERT #supplier_item_extract
(supplier_id,
 supplier_item_id,
 supplier_item_row_number,
 supplier_item_code,
 barcode_type,
 barcode_number)

SELECT sics.supplier_id,
sics.supplier_item_id,
ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, sib.barcode_type_code, sib.barcode_number) AS supplier_item_row_number, 
spi.supplier_item_code,
sib.barcode_type_code,
sib.barcode_number
FROM #supplier_item_counts AS sics
JOIN Supplier_Packaged_Item AS spi
ON   spi.supplier_id = sics.supplier_id
AND  spi.supplier_item_id = sics.supplier_item_id
JOIN supplier_item_barcode AS sib
ON sics.supplier_id = sib.supplier_id
AND sics.supplier_item_id = sib.supplier_item_id
WHERE barcode_type_code IN ('e','g','u')
AND sics.barcode_count >= sics.cost_level_count

UPDATE sie
SET sie.barcode_type = bc.barcode_type_code,
sie.barcode_number = bc.barcode_number
FROM #supplier_item_extract AS sie
JOIN (SELECT sics.supplier_id,
      sics.supplier_item_id,
      ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, sib.barcode_type_code, sib.barcode_number) AS supplier_item_row_number, 
      spi.supplier_item_code,
      sib.barcode_type_code,
      sib.barcode_number
      FROM #supplier_item_counts AS sics
      JOIN Supplier_Packaged_Item AS spi
      ON   spi.supplier_id = sics.supplier_id
      AND  spi.supplier_item_id = sics.supplier_item_id
      JOIN supplier_item_barcode AS sib
      ON sics.supplier_id = sib.supplier_id
      AND sics.supplier_item_id = sib.supplier_item_id
      WHERE barcode_type_code IN ('e','g','u')
      AND sics.barcode_count < sics.cost_level_count ) AS bc
ON sie.supplier_Id = bc.supplier_Id
AND sie.supplier_Item_Id = bc.supplier_Item_Id
AND sie.supplier_item_row_number = bc.supplier_item_row_number

UPDATE sie
SET sie.cost_level_name = mcc.name,
    sie.package_cost = mcc.supplier_price,
    sie.package_allowance = mcc.supplier_allowance,
    sie.start_date = mcc.start_date,
    sie.end_date = mcc.end_date
FROM #supplier_item_extract AS sie
JOIN (SELECT sics.supplier_id,
      sics.supplier_item_id,
      ROW_NUMBER() over (partition by spi.supplier_item_code order by spi.supplier_item_code, mcl.merch_cost_level_id) AS supplier_item_row_number, 
      spi.supplier_item_code,
      mcl.name,
      mcc.supplier_price,
      mcc.supplier_allowance,
      mcc.start_date,
      mcc.end_date
      FROM #supplier_item_counts AS sics (NOLOCK)
      JOIN Supplier_Packaged_Item AS spi (NOLOCK)
      ON   spi.supplier_id = sics.supplier_id
      AND  spi.supplier_item_id = sics.supplier_item_id
      JOIN merch_cost_change AS mcc (NOLOCK)
      ON   spi.supplier_id = mcc.supplier_id
      AND  spi.supplier_item_id = mcc.supplier_item_id
      JOIN Merch_Cost_Level as mcl (NOLOCK)
      ON   mcl.supplier_id = mcc.supplier_id
      AND  mcl.merch_cost_level_id = mcc.merch_cost_level_id
      WHERE mcc.promo_flag IN ('n')
      AND mcc.change_type_code IN ('a','c') 
      AND mcc.start_date <= @MerchCostChangeEffectiveDate
      AND	(mcc.end_date > @MerchCostChangeEffectiveDate
      OR	mcc.end_date IS NULL)
      AND sics.barcode_count >= sics.cost_level_count) AS mcc
ON sie.supplier_Id = mcc.supplier_Id
AND sie.supplier_Item_Id = mcc.supplier_Item_Id
AND sie.supplier_item_row_number = mcc.supplier_item_row_number

INSERT #supplier_item_count_batch
SELECT  ISNULL(s.xref_code, 'xref-' + CONVERT(NVARCHAR(15),s.supplier_id)) AS XRefCode,
s.name,
COUNT(*),
CEILING(COUNT(*)/10000)+1 
FROM  #supplier_item_extract AS sie
INNER JOIN Supplier_Item AS si 
ON    sie.supplier_id = si.supplier_id
AND   sie.supplier_item_id = si.supplier_item_id
INNER JOIN Supplier AS s
ON    si.supplier_id = s.supplier_id
INNER JOIN Supplier_Item_Category AS sic
ON    si.supplier_item_category_id = sic.supplier_item_category_id
AND   si.supplier_id = sic.supplier_id
INNER JOIN Supplier_Packaged_Item AS spi
ON    si.supplier_item_id = spi.supplier_item_id
AND   si.supplier_id = spi.supplier_id
INNER JOIN Unit_of_Measure AS uom
ON    spi.packaged_in_uom_id = uom.unit_of_measure_id
INNER JOIN Rad_Sys_Client AS rsc
ON s.client_id = rsc.client_id
INNER JOIN Rad_Sys_Data_Accessor AS rsda 
ON rsc.client_id = rsda.data_accessor_id
LEFT JOIN Item AS i
ON si.item_id = i.item_id
WHERE	s.status_code IN ('a')
AND s.supplier_type_code IN ('m') 
AND si.status_code in ('a','u')
-- Added for support of incremental extract
AND si.supplier_item_id > @last_max_id
-- END for additional changes
AND i.purge_flag IN ('n')
AND (CASE 
	WHEN	(ISNUMERIC(i.xref_code) = 1 
			AND LEN(i.xref_code) < 9
     		AND LEFT(i.xref_code, 1) NOT IN ('0')
			AND i.xref_code NOT LIKE '%[^0-9]%' 
			)	THEN CONVERT(int, i.xref_code)
			WHEN i.xref_code IS NULL THEN 0
			ELSE	-1
			END	) >= 0
--AND s.xref_code = 'ABBEVRGE'
--AND s.xref_code IN ('PEPSINT3')
		
GROUP BY ISNULL(s.xref_code, 'xref-' + CONVERT(NVARCHAR(15),s.supplier_id)), s.name
ORDER BY 3 DESC

SELECT b.batch_count,
t.batch_number-1,
b.supplier_xref,
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(b.supplier_name,'/',' '),',',' '),'_',' '),'[',' '), ']',' '),
CASE WHEN t.batch_number < 10 THEN '0' + CONVERT(NVARCHAR(1), t.batch_number) ELSE CONVERT(NVARCHAR(2), t.batch_number) END
FROM #supplier_item_count_batch as b
JOIN #talley as t
ON   t.batch_number <= b.batch_count
ORDER BY b.batch_total DESC, t.batch_number

IF OBJECT_ID('tempdb..#supplier_item_counts') IS NOT NULL
    DROP TABLE #supplier_item_counts
    
IF OBJECT_ID('tempdb..#supplier_item_extract') IS NOT NULL
    DROP TABLE #supplier_item_extract

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley
    
IF OBJECT_ID('tempdb..#supplier_item_count_batch') IS NOT NULL
    DROP TABLE #supplier_item_count_batch
    
