SET NOCOUNT ON 

DECLARE @SupplierXRefCode NVARCHAR(50)
DECLARE @SupplierID INT
DECLARE @EffectiveDate smalldatetime
DECLARE @ExecutionDate smalldatetime
DECLARE @ExportId INT
DECLARE @cost_level TABLE (supplier_id INT, merch_cost_level_id INT)

IF OBJECT_ID('tempdb..#output') IS NOT NULL
    DROP TABLE #output
    
SET @SupplierXRefCode = '$(SupplierXRefCode)'

--SET @SupplierXRefCode = 'EBYAUROR'
--SELECT @SupplierXRefCode, @SupplierID

SELECT @SupplierId = supplier_id
FROM   supplier
WHERE  xref_code = @SupplierXRefCode

SELECT @ExecutionDate = CONVERT(nvarchar(10), GETDATE(),120)

IF NOT EXISTS (SELECT 1 
               FROM bcssa_custom_integration..bc_extract_cost_export
			   WHERE SupplierId = @SupplierId)
BEGIN
	SET @EffectiveDate = '2018-10-01'
END
ELSE
BEGIN
	SELECT @EffectiveDate = DATEADD(day,1,MAX(ExecutionDate))
	FROM   bcssa_custom_integration..bc_extract_cost_export
			   WHERE SupplierId = @SupplierId
	
END

INSERT bcssa_custom_integration..bc_extract_cost_export
(SupplierId,
SupplierXrefCode,
EffectiveDate,
ExecutionDate,
ExportedTimeStamp)
VALUES
(@SupplierId,
@SupplierXrefCode,
@EffectiveDate,
@ExecutionDate,
GETDATE())

SELECT @ExportId = @@IDENTITY

INSERT @cost_level
SELECT DISTINCT s.supplier_id, l.merch_cost_level_id
FROM   Merch_bu_spi_cost_list AS l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   business_unit AS bu
ON     l.business_unit_id = bu.business_unit_id
WHERE  s.supplier_id = @SupplierId
AND    bu.status_code != 'c'
UNION
SELECT DISTINCT s.supplier_id, mcl.merch_cost_level_id
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
OR (s.name = 'PEPSNITR-PEPSI NITRO SOUTH (WV)' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PEPSPHIL-PEPSI NITRO/ PHILIPPI (WV)' AND mcl.name = 'PEPSPHIL-CCC PEPSI NITRO/ PHILIPPI (WV)')
OR (s.name = 'PEPSTASC-PBC SOUTHEAST REGION (SC), (NC)-asn' AND mcl.name = 'PEPSTASC- CCC PBC SOUTHEAST REGION (SC), (NC)-asn')
OR (s.name = 'PEPSTAVA-PBC MID-ATLANTIC (VA)(asn)' AND mcl.name = 'PEPSTAVA- CCC PBC MID-ATLANTIC (VA)(asn)')
OR (s.name = 'PEPVENDE-PEPSI BOTTLING VENTURES (PA)' AND mcl.name = 'PEPVENDE- CCC PEPSI BOTTLING VENTURES (PA)')
OR (s.name = 'PEPVENNC-PEPSI BOTTLING VENTURES (NC),(SC)' AND mcl.name = 'PEPVENNC- CCC PEPSI BOTTLING VENTURES (NC),(SC)')
OR (s.name = 'PRESCOTT-SUNDROP/PRESCOTT BOTTLING CO, TN' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'PUREBEVKY-PURE BEVERAGE CO (KY)' AND mcl.name = 'Consolidated WV/KY')
OR (s.name = 'RIVERCIT-RIVER CITY (MLR/CRS)(KY) asn' AND mcl.name = 'KY CRAFT TEST')
AND s.supplier_id = @SupplierID

SELECT @ExportId ExportId,
spi.supplier_item_code,
mcl.name cost_level_name,
supplier_price,
supplier_allowance,
start_date,
end_date,
promo_flag,
default_ranking
INTO #Output
FROM   merch_cost_change AS mcc
JOIN   supplier_packaged_item AS spi
ON     mcc.supplier_id = spi.supplier_id
AND    mcc.supplier_item_id = spi.supplier_item_id
AND    mcc.packaged_item_id = spi.packaged_item_id
JOIN   merch_cost_level AS mcl
ON     mcc.supplier_id = mcl.supplier_id
AND    mcc.merch_cost_level_id = mcl.merch_cost_level_id
WHERE  mcc.supplier_id = @supplierId
AND    mcc.start_date >= @EffectiveDate
AND    mcc.end_date >= @EffectiveDate
AND    change_type_code IN ('a','c')
AND    mcl.default_ranking > 0

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
	'_' + supplier_item_code supplier_item_code,
	cost_level_name,
	supplier_price,
	supplier_allowance,
	start_date,
	end_date,
	promo_flag
	FROM #Output
	ORDER  by supplier_item_code, start_date, default_ranking DESC
	
END





