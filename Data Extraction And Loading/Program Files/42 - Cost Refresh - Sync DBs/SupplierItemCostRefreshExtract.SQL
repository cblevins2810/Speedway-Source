SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#output') IS NOT NULL
    DROP TABLE #output

IF OBJECT_ID('tempdb..#merch_cost_change') IS NOT NULL
    DROP TABLE #merch_cost_change
    
IF OBJECT_ID('bcssa_custom_integration..linked_supplier_item_map') IS NOT NULL
    DROP TABLE bcssa_custom_integration..linked_supplier_item_map

CREATE TABLE bcssa_custom_integration..linked_supplier_item_map
(supplier_id INT NULL,
supplier_item_id INT NULL,
packaged_item_id INT NULL,
supplier_item_code nvarchar(100) NULL,
linked_supplier_id INT NULL,
linked_supplier_item_id INT NULL,
linked_packaged_item_id INT NULL,
linked_supplier_item_code nvarchar(100) NULL,
merged_supplier_item_code nvarchar(100) NULL)
 
CREATE TABLE #merch_cost_change
(supplier_item_code nvarchar(50) not null,
 merch_cost_level_id INT NOT NULL,
 start_date smalldatetime NOT NULL,
 end_date smalldatetime NULL,
 supplier_price smallmoney NOT NULL,
 supplier_allowance smallmoney NOT NULL,
 promo_flag char(1) NOT NULL)

DECLARE @ExecutionDate smalldatetime
DECLARE @ExportId INT
DECLARE @MerchCostChangeEffectiveDate AS smalldatetime
DECLARE @supplier_id INT
DECLARE @SupplierXRef nvarchar(255)
DECLARE @cost_level TABLE (supplier_id INT, merch_cost_level_id INT, cost_level_name nvarchar(100), sort_order INT)
DECLARE @linked_supplier_id INT

DECLARE @Today nvarchar(10)
SET @Today = CONVERT(nvarchar(10), GETDATE(),120)

--:SETVAR Modulus 1
--:SETVAR Remainder 0
--:SETVAR SupplierXRef "XXX"

SET @MerchCostChangeEffectiveDate = '2019-04-01'

SELECT @ExecutionDate = CONVERT(nvarchar(10), GETDATE(),120)

SET @SupplierXRef = 'EBYAUROR'
SET @SupplierXRef = 'EBYSAWIS'

--SET @SupplierXRef = '$(SupplierXRef)'

SELECT @supplier_id = supplier_id
FROM supplier
WHERE xref_code = @SupplierXRef

SELECT @linked_supplier_id = ISNULL(s.supplier_id, 0)
FROM supplier AS s
JOIN bcssa_custom_integration..bc_extract_supplier_merge AS m
ON   m.merge_to_supplier_xref = @SupplierXRef
AND  m.merge_from_supplier_xref = s.xref_code

--SELECT @supplier_id, @linked_supplier_id, @SupplierXRef

INSERT @cost_level
SELECT @supplier_id, 0,
'Master',
-1
WHERE @linked_supplier_id > 0
UNION
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id, 
CASE WHEN (default_ranking = 999 AND @linked_supplier_id > 0) THEN 'Corporate' ELSE mcl.name END,
CASE WHEN default_ranking = 999 THEN 0 ELSE default_ranking END
FROM   supplier AS s
JOIN   Merch_Cost_Level as mcl
ON     s.supplier_id = mcl.merch_cost_level_id
JOIN   supplier_audit AS sa
ON     sa.supplier_Id = s.supplier_Id
AND    sa.audit_type_code = 'i'
AND    sa.last_modified_timestamp > '2019-04-01'
WHERE  s.supplier_id = @supplier_id
/*
UNION
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id, 
CASE WHEN (default_ranking = 999 AND @linked_supplier_id > 0) THEN 'Corporate' ELSE mcl.name END,
CASE WHEN default_ranking = 999 THEN 0 ELSE default_ranking END
FROM   supplier AS s
JOIN   Merch_Cost_Level as mcl
ON     s.supplier_id = mcl.supplier_id
WHERE  s.supplier_id = @supplier_id 
-- Hack to remove PEPSNITR - 'Consolidated WV/KY' Cost Level
AND    mcl.merch_cost_level_id <> 1007394

*/
UNION
SELECT DISTINCT s.supplier_id, l.merch_cost_level_id, 
CASE WHEN (default_ranking = 999 AND @linked_supplier_id > 0) THEN 'Corporate' ELSE mcl.name END,
CASE WHEN default_ranking = 999 THEN 0 ELSE default_ranking END
FROM   Merch_bu_spi_cost_list AS l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   business_unit AS bu
ON     l.business_unit_id = bu.business_unit_id
JOIN   Merch_Cost_Level as mcl
ON     l.merch_cost_level_id = mcl.merch_cost_level_id
WHERE  s.supplier_id = @supplier_id 
AND    bu.status_code != 'c'
-- Hack to remove PEPSNITR - 'Consolidated WV/KY' Cost Level
AND    l.merch_cost_level_id <> 1007394

UNION
-- This is an override to include these levels even if they are not in use
-- If they are not applicable to a supplier, they will not be used later in 
-- the sql.
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id,
CASE WHEN (default_ranking = 999 AND @linked_supplier_id > 0) THEN 'Corporate' ELSE mcl.name END,
CASE WHEN default_ranking = 999 THEN 0 ELSE default_ranking END
FROM   supplier AS s
JOIN   Merch_Cost_Level AS mcl
ON     mcl.supplier_Id = s.supplier_id
WHERE (s.name = 'EBYAUROR-EBY-BROWN' AND mcl.name = 'Hostess Reg 44')
OR (s.name = 'EBYAUROR-EBY-BROWN' AND mcl.name = 'Hostess Reg 49')
OR (s.name = 'EBYAUROR-EBY-BROWN' AND mcl.name = 'Jerky Reg 50 Test')
OR (s.name = 'IB009CKY-IBS  IB009CKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IB022CKY-IBS  IB022CKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IB070ATN-IB070ATN-NASHVILLE' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IB070BTN-IB070BTN-CHATTANOOGA' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IB084AKY-IBS  IB084AKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IB084CKY-IBS  IB084CKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IBR16CKY-IBS  IBR16CKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'IBS16CKY-IBS  IBS16CKY' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PEPCVAVA-PEPSI BOTTLING OF CENTRAL VA (VA)' AND mcl.name = 'PEPCVAVA-CCC PEPSI BOTTLING OF CENTRAL')
OR (s.name = 'PEPFLORN-PEPSI COLA OF FLORENCE (SC)' AND mcl.name = 'PEPFLORN-CCC PEPSI COLA OF FLORENCE (SC)')
OR (s.name = 'PEPGREEN-PEPSI COLA OF GREENVILLE (SC)' AND mcl.name = 'PEPGREEN-CCC PEPSI COLA OF GREENVILLE (SC)')
OR (s.name = 'PEPHICNC-PEPSI COLA OF HICKORY (NC)' AND mcl.name = 'PEPHICNC-CCC PEPSI COLA OF HICKORY (NC)')
OR (s.name = 'PEPMCPNC-PEPSI BOTTLING aka MCPHERSON (NC)' AND mcl.name = 'PEPMCPNC-CCC PEPSI BOTTLING aka MCPHERSON (NC)')
OR (s.name = 'PEPMNGNC-PEPSI-MINGES BTLG CO (NC)' AND mcl.name = 'PEPMNGNC-CCC PEPSI-MINGES BTLG CO (NC)')
OR (s.name = 'PEPSCIN2-PEPSI CINCINNATI (KY)-asn' AND mcl.name = 'PEPSCIN2-CCC PEPSI CINCINNATI (KY)-asn')
OR (s.name = 'PEPSICBS-PEPSI CORBIN SOMERSET (KY)' AND mcl.name = 'PEPSICBS-CCC PEPSI CORBIN SOMERSET (KY)')
OR (s.name = 'PEPSICOR-PEPSI CORBIN LOWR WHITLEY (KY)' AND mcl.name = 'PEPSICOR-CCC PEPSI CORBIN LOWR WHITLEY (KY)')
OR (s.name = 'PEPSINT2-PEPSI NITRO [2] (WV)' AND mcl.name = 'PEPSINT2- CCC PEPSI NITRO [2] (WV)')
OR (s.name = 'PEPSIPKV-PEPSI NITRO/ PHILIPPI (KY)-asn' AND mcl.name = 'PEPSIPKV-CCC PEPSI NITRO/ PHILIPPI (KY)-asn')
OR (s.name = 'PEPSIPRC-PEPSI PRINCETON (WV)' AND mcl.name = 'PEPSIPRC-CCC PEPSI PRINCETON (WV)')
OR (s.name = 'PEPSIWV-PEPSI OHIO/WV (OH)-asn' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PEPSLEXI-PEPSI LEXINGTON G&J (KY)-asn' AND mcl.name = 'PEPSLEXI-CCC PEPSI LEXINGTON (KY)')
OR (s.name = 'PEPSLOUI-PEPSI LOUISVILLE (KY)-asn' AND mcl.name = 'PEPSLOUI-CCC PEPSI LOUISVILLE (KY)-ASN')
OR (s.name = 'PEPSNIT2-PEPSI NITRO[2] SOUTH (WV)' AND mcl.name = 'PEPSNIT2-CCC PEPSI NITRO[2] SOUTH (WV)')
--OR (s.name = 'PEPSNITR-PEPSI NITRO SOUTH (WV)' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PEPSPHIL-PEPSI NITRO/ PHILIPPI (WV)' AND mcl.name = 'PEPSPHIL-CCC PEPSI NITRO/ PHILIPPI (WV)')
OR (s.name = 'PEPSTASC-PBC SOUTHEAST REGION (SC), (NC)-asn' AND mcl.name = 'PEPSTASC- CCC PBC SOUTHEAST REGION (SC), (NC)-asn')
OR (s.name = 'PEPSTAVA-PBC MID-ATLANTIC (VA)(asn)' AND mcl.name = 'PEPSTAVA- CCC PBC MID-ATLANTIC (VA)(asn)')
OR (s.name = 'PEPVENDE-PEPSI BOTTLING VENTURES (PA)' AND mcl.name = 'PEPVENDE- CCC PEPSI BOTTLING VENTURES (PA)')
OR (s.name = 'PEPVENNC-PEPSI BOTTLING VENTURES (NC),(SC)' AND mcl.name = 'PEPVENNC- CCC PEPSI BOTTLING VENTURES (NC),(SC)')
OR (s.name = 'PRESCOTT-SUNDROP/PRESCOTT BOTTLING CO, TN' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PUREBEVKY-PURE BEVERAGE CO (KY)' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'RIVERCIT-RIVER CITY (MLR/CRS)(KY) asn' AND mcl.name = 'KY CRAFT TEST')

UNION
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id, 
CASE WHEN default_ranking = 999 THEN 'Franchise' ELSE mcl.name END, -- + mcl.name,
CASE WHEN default_ranking = 999 THEN 1000 ELSE default_ranking + 1000 END
FROM   supplier AS s
JOIN   Merch_Cost_Level as mcl
ON     s.supplier_id = mcl.merch_cost_level_id
JOIN   supplier_audit AS sa
ON     sa.supplier_Id = s.supplier_Id
AND    sa.audit_type_code = 'i'
AND    sa.last_modified_timestamp > '2019-04-01'
WHERE  s.supplier_id = @linked_supplier_id
/*
UNION
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id, 
CASE WHEN default_ranking = 999 THEN 'Franchise' ELSE mcl.name END, -- + mcl.name,
CASE WHEN default_ranking = 999 THEN 1000 ELSE default_ranking + 1000 END
FROM   supplier AS s
JOIN   Merch_Cost_Level as mcl
ON     s.supplier_id = mcl.supplier_id
WHERE  s.supplier_id = @linked_supplier_id 
-- Hack to remove PEPSNITR - 'Consolidated WV/KY' Cost Level
AND    mcl.merch_cost_level_id <> 1007394
*/
UNION
SELECT DISTINCT s.supplier_id, l.merch_cost_level_id, 
CASE WHEN default_ranking = 999 THEN 'Franchise' ELSE mcl.name END, -- + mcl.name,
CASE WHEN default_ranking = 999 THEN 1000 ELSE default_ranking + 1000 END
FROM   Merch_bu_spi_cost_list AS l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   business_unit AS bu
ON     l.business_unit_id = bu.business_unit_id
JOIN   Merch_Cost_Level as mcl
ON     l.merch_cost_level_id = mcl.merch_cost_level_id
WHERE  s.supplier_id = @linked_supplier_id
AND    bu.status_code != 'c'

UNION  
SELECT DISTINCT supplier_id, merch_cost_level_id, 
'Franchise',
1000
FROM   Merch_Cost_Level as mcl
WHERE  supplier_id = @linked_supplier_id
AND    default_ranking = 999

DELETE @cost_level
WHERE  supplier_id = @linked_supplier_id
AND    sort_order = 1000
AND    cost_level_name != 'Franchise'

DELETE @cost_level
WHERE  (supplier_id = @linked_supplier_id OR supplier_id = @supplier_id)
AND    sort_order IN (-3, 997)

IF @linked_supplier_id = 0
   DELETE @cost_level
   WHERE  supplier_Id <> @supplier_id 
ELSE   
   DELETE @cost_level
   WHERE  supplier_Id <> @supplier_id 
   AND    supplier_id <> @linked_supplier_id

-- Insert matched supplier items taking into account the leading zero
INSERT bcssa_custom_integration..linked_supplier_item_map
(supplier_id,
supplier_item_id,
packaged_item_id,
supplier_item_code,
linked_supplier_id,
linked_supplier_item_id,
linked_packaged_item_id,
linked_supplier_item_code,
merged_supplier_item_code)

SELECT st.supplier_id,
spit.supplier_item_id,
spit.packaged_item_id,
'_' + spit.supplier_item_code supplier_item_code,
sf.supplier_id linked_supplier_id,
spif.supplier_item_id linked_supplier_item_id,
spif.packaged_item_id linked_packaged_item_id,
'_' + spif.supplier_item_code linked_supplier_item_code,
CASE WHEN LEN(spit.supplier_item_code) > LEN(spif.supplier_item_code)
THEN '_' + spit.supplier_item_code ELSE '_' + spif.supplier_item_code END AS merged_supplier_item_code

FROM supplier as st
CROSS JOIN supplier as sf
JOIN Supplier_Item AS sit (NOLOCK)
ON   st.supplier_id = sit.supplier_id
JOIN Supplier_Item AS sif (NOLOCK)
ON   sf.supplier_id = sif.supplier_id
JOIN Supplier_Packaged_Item AS spit (NOLOCK)
ON   st.supplier_id = spit.supplier_id
AND  sit.supplier_item_id = spit.supplier_item_id
JOIN Supplier_Packaged_Item AS spif (NOLOCK)
ON   sf.supplier_id = spif.supplier_id
AND  sif.supplier_item_id = spif.supplier_item_id
WHERE sif.status_code in ('a','u')
AND   sif.exception_status_code = 'n'
AND   sit.status_code in ('a','u')
AND   sit.exception_status_code = 'n'
AND   ((RTRIM(SUBSTRING(spit.supplier_item_code,2,50)) = spif.supplier_item_code
AND   SUBSTRING(spit.supplier_item_code,1,1) = '0')
		OR (RTRIM(SUBSTRING(spif.supplier_item_code,2,50)) = spit.supplier_item_code
AND   SUBSTRING(spif.supplier_item_code,1,1) = '0'))
AND   st.supplier_id = @supplier_id
AND   sf.supplier_id = @linked_supplier_id

-- Insert matched supplier items taking into account the leading zero
INSERT  bcssa_custom_integration..linked_supplier_item_map
(supplier_id,
supplier_item_id,
packaged_item_id,
supplier_item_code,
linked_supplier_id,
linked_supplier_item_id,
linked_packaged_item_id,
linked_supplier_item_code,
merged_supplier_item_code)

SELECT st.supplier_id,
spit.supplier_item_id,
spit.packaged_item_id,
'_' + spit.supplier_item_code supplier_item_code,
sf.supplier_id linked_supplier_id,
spif.supplier_item_id linked_supplier_item_id,
spif.packaged_item_id linked_packaged_item_id,
'_' + spif.supplier_item_code linked_supplier_item_code,
CASE WHEN LEN(spit.supplier_item_code) > LEN(spif.supplier_item_code)
THEN '_' + spit.supplier_item_code ELSE '_' + spif.supplier_item_code END AS merged_supplier_item_code
FROM supplier as st
CROSS JOIN supplier as sf

JOIN Supplier_Item AS sit (NOLOCK)
ON   st.supplier_id = sit.supplier_id

JOIN Supplier_Item AS sif (NOLOCK)
ON   sf.supplier_id = sif.supplier_id

JOIN Supplier_Packaged_Item AS spit (NOLOCK)
ON   st.supplier_id = spit.supplier_id
AND  sit.supplier_item_id = spit.supplier_item_id

JOIN Supplier_Packaged_Item AS spif (NOLOCK)
ON   sf.supplier_id = spif.supplier_id
AND  sif.supplier_item_id = spif.supplier_item_id

WHERE sit.status_code in ('a','u')
AND   sit.exception_status_code = 'n'
AND   st.supplier_id = @supplier_id
AND   sif.status_code in ('a','u')
AND   sif.exception_status_code = 'n'
AND   spit.supplier_item_code = spif.supplier_item_code
AND   sf.supplier_id = @linked_supplier_id

-- Insert where the item only exists  in the primary supplier
INSERT  bcssa_custom_integration..linked_supplier_item_map
(supplier_id,
supplier_item_id,
packaged_item_id,
supplier_item_code,
merged_supplier_item_code)

SELECT st.supplier_id AS supplier_id,
spit.supplier_item_id AS supplier_item_id,
spit.packaged_item_id AS packaged_item_id,
'_' + spit.supplier_item_code AS supplier_item_code,
'_' + spit.supplier_item_code AS merged_supplier_item_code
FROM supplier as st

JOIN Supplier_Item AS sit (NOLOCK)
ON   st.supplier_id = sit.supplier_id

JOIN Supplier_Packaged_Item AS spit (NOLOCK)
ON   st.supplier_id = spit.supplier_id
AND  sit.supplier_item_id = spit.supplier_item_id

WHERE sit.status_code in ('a','u')
AND   sit.exception_status_code = 'n'
AND   st.supplier_id = @supplier_id

AND   NOT EXISTS (SELECT 1 FROM  bcssa_custom_integration..linked_supplier_item_map AS m
                  WHERE m.supplier_id = spit.supplier_id
                  AND   m.supplier_item_id = spit.supplier_item_id
                  AND   m.packaged_item_id = spit.packaged_item_id)

-- Insert supplier items that exist only in the linked supplier
INSERT  bcssa_custom_integration..linked_supplier_item_map
(linked_supplier_id,
linked_supplier_item_id,
linked_packaged_item_id,
linked_supplier_item_code,
merged_supplier_item_code)
SELECT sf.supplier_id,
spif.supplier_item_id,
spif.packaged_item_id,
'_' + spif.supplier_item_code,
'_' + spif.supplier_item_code
FROM supplier as sf

JOIN Supplier_Item AS sif (NOLOCK)
ON   sf.supplier_id = sif.supplier_id

JOIN Supplier_Packaged_Item AS spif (NOLOCK)
ON   sf.supplier_id = spif.supplier_id
AND  sif.supplier_item_id = spif.supplier_item_id

WHERE sif.status_code in ('a','u')
AND   sif.exception_status_code = 'n'
AND   sf.supplier_id = @linked_supplier_id

AND   NOT EXISTS (SELECT 1 FROM  bcssa_custom_integration..linked_supplier_item_map AS m
                  WHERE m.linked_supplier_id = spif.supplier_id
                  AND   m.linked_supplier_item_id = spif.supplier_item_id
                  AND   m.linked_packaged_item_id = spif.packaged_item_id)


-- Pull all future normal cost changes that are still in effect
-- These were not part of initial load.
INSERT #merch_cost_change
(supplier_item_code,
merch_cost_level_id,
start_date,
end_date,
supplier_price,
supplier_allowance,
promo_flag)

SELECT DISTINCT merged_supplier_item_code,
mcc1.merch_cost_level_id,
mcc1.start_date,
mcc1.end_date,
mcc1.supplier_price,
mcc1.supplier_allowance,
mcc1.promo_flag

FROM  bcssa_custom_integration..linked_supplier_item_map AS m
JOIN merch_cost_change AS mcc1 (NOLOCK)
ON   m.supplier_Id = mcc1.supplier_Id
AND  m.supplier_Item_Id = mcc1.supplier_Item_Id
JOIN @cost_level as cl
ON    mcc1.merch_cost_level_id = cl.merch_cost_level_id
AND   mcc1.supplier_Id = cl.supplier_Id
WHERE start_date >= @MerchCostChangeEffectiveDate
AND   end_date >= @Today
AND   promo_flag = 'n'
AND change_type_code IN ('a','c')

UNION

-- Pull all promos for main supplier that are still in effect
SELECT DISTINCT merged_supplier_item_code,
mcc1.merch_cost_level_id,
mcc1.start_date,
mcc1.end_date,
mcc1.supplier_price,
mcc1.supplier_allowance,
mcc1.promo_flag

FROM  bcssa_custom_integration..linked_supplier_item_map AS m
JOIN merch_cost_change AS mcc1 (NOLOCK)
ON   m.supplier_Id = mcc1.supplier_Id
AND  m.supplier_Item_Id = mcc1.supplier_Item_Id
JOIN @cost_level as cl
ON    mcc1.merch_cost_level_id = cl.merch_cost_level_id
ANd   mcc1.supplier_Id = cl.supplier_Id
WHERE end_date >= @MerchCostChangeEffectiveDate
AND promo_flag IN ('y')
AND change_type_code IN ('a','c')

-- Pull all future normal cost changes that are still in effect
-- These were not part of initial load.
INSERT #merch_cost_change
(supplier_item_code,
merch_cost_level_id,
start_date,
end_date,
supplier_price,
supplier_allowance,
promo_flag)

SELECT DISTINCT merged_supplier_item_code,
mcc1.merch_cost_level_id,
mcc1.start_date,
mcc1.end_date,
mcc1.supplier_price,
mcc1.supplier_allowance,
mcc1.promo_flag

FROM  bcssa_custom_integration..linked_supplier_item_map AS m
JOIN merch_cost_change AS mcc1 (NOLOCK)
ON   m.linked_supplier_id = mcc1.supplier_Id
AND  m.linked_supplier_Item_Id = mcc1.supplier_Item_Id
JOIN @cost_level as cl
ON    mcc1.merch_cost_level_id = cl.merch_cost_level_id
AND   mcc1.supplier_Id = cl.supplier_Id
WHERE start_date >= @MerchCostChangeEffectiveDate
AND   end_date >= @Today
AND   promo_flag = 'n'
AND change_type_code IN ('a','c')

UNION

-- Pull all promos for linked supplier that are still in effect
SELECT DISTINCT merged_supplier_item_code,
mcc1.merch_cost_level_id,
mcc1.start_date,
mcc1.end_date,
mcc1.supplier_price,
mcc1.supplier_allowance,
mcc1.promo_flag

FROM  bcssa_custom_integration..linked_supplier_item_map AS m
JOIN merch_cost_change AS mcc1 (NOLOCK)
ON   m.linked_supplier_Id = mcc1.supplier_Id
AND  m.linked_supplier_Item_Id = mcc1.supplier_Item_Id
JOIN @cost_level as cl
ON    mcc1.merch_cost_level_id = cl.merch_cost_level_id
ANd   mcc1.supplier_Id = cl.supplier_Id
WHERE end_date >= @MerchCostChangeEffectiveDate
AND promo_flag IN ('y')
AND change_type_code IN ('a','c')


/*

INSERT #merch_cost_change
(supplier_item_code,
merch_cost_level_id,
start_date,
end_date,
supplier_price,
supplier_allowance,
promo_flag)
SELECT DISTINCT 
merged_supplier_item_code,
0,
'1900-01-01',
'2075-12-31',
0,
0,
'n'
FROM  bcssa_custom_integration..linked_supplier_item_map AS m

INSERT #merch_cost_change
(supplier_item_code,
merch_cost_level_id,
start_date,
end_date,
supplier_price,
supplier_allowance,
promo_flag)
SELECT DISTINCT 
merged_supplier_item_code,
cl.merch_cost_level_id,
'1900-01-01',
'2075-12-31',
0,
0,
'n'
FROM  bcssa_custom_integration..linked_supplier_item_map AS m
CROSS JOIN @cost_level AS cl
WHERE NOT EXISTS (SELECT 1
                  FROM #merch_cost_change AS mcc
                  WHERE mcc.supplier_item_code = m.merged_supplier_item_code
                  AND   mcc.merch_cost_level_id = cl.merch_cost_level_id)
AND cl.sort_order =  1000

*/

--SELECT * FROM @cost_level

DELETE bcssa_custom_integration..bc_extract_cost_export

INSERT bcssa_custom_integration..bc_extract_cost_export
(SupplierId,
SupplierXrefCode,
EffectiveDate,
ExecutionDate,
ExportedTimeStamp)
VALUES
(@Supplier_Id,
@SupplierXref,
@MerchCostChangeEffectiveDate,
@ExecutionDate,
GETDATE())

SELECT @ExportId = @@IDENTITY

SELECT @ExportId ExportId,
m.merged_supplier_item_code,
mcl.cost_level_name cost_level_name,
supplier_price,
supplier_allowance,
start_date,
end_date,
promo_flag,
sort_order
INTO #Output
FROM  #merch_cost_change AS mcc
JOIN   bcssa_custom_integration..linked_supplier_item_map AS m
ON    mcc.supplier_item_code = m.merged_supplier_item_code
JOIN  @cost_level AS mcl
ON    mcc.merch_cost_level_id = mcl.merch_cost_level_id

IF NOT EXISTS (SELECT 1 
               FROM bcssa_custom_integration..bc_extract_cost_export
			   WHERE SupplierId = @Supplier_id)
BEGIN
	SET @MerchCostChangeEffectiveDate = '2019-04-01'
END
ELSE
BEGIN
	SELECT @MerchCostChangeEffectiveDate = DATEADD(day,1,MAX(ExecutionDate))
	FROM   bcssa_custom_integration..bc_extract_cost_export
	
END

IF @@ROWCOUNT > 0 
BEGIN

	SELECT ExportId,
	SupplierXrefCode,
	EffectiveDate,
	ExecutionDate,
	ExportedTimeStamp
	FROM bcssa_custom_integration..bc_extract_cost_export
	WHERE ExportId = @ExportId
	
	SELECT ExportId,
	merged_supplier_item_code AS supplier_item_code,
	cost_level_name,
	supplier_price,
	supplier_allowance,
	start_date,
	end_date,
	promo_flag
	FROM #Output
	ORDER  by supplier_item_code, start_date, sort_order DESC
	
END

--SELECT * FROM #linked_supplier_item_map AS m

IF OBJECT_ID('tempdb..#output') IS NOT NULL
    DROP TABLE #output

IF OBJECT_ID(' bcssa_custom_integration..linked_supplier_item_map') IS NOT NULL
    DROP TABLE  bcssa_custom_integration..linked_supplier_item_map
    
IF OBJECT_ID('tempdb..#merch_cost_change') IS NOT NULL
    DROP TABLE #merch_cost_change
