--BEGIN TRANSACTION

DECLARE @ImportId INT

WHILE EXISTS (SELECT 1 FROM VP60_Spwy..bc_extract_cost_import
              WHERE StatusCode = 'i')
BEGIN			  

	-- i = Imported, r = ready for export, e = exported

	SELECT  @ImportId = MAX(ImportId) FROM VP60_Spwy..bc_extract_cost_import
	WHERE   StatusCode = 'i'

	UPDATE	i
	SET		ResolvedSupplierId = supplier_id
	FROM	VP60_Spwy..bc_extract_cost_import AS i
	JOIN	supplier AS s
	ON      i.SupplierXrefCode = s.xref_code
	WHERE   i.ImportId = @ImportId

	UPDATE  si
	SET		ResolvedSupplierItemId = spi.supplier_item_id
	FROM	VP60_Spwy..bc_extract_cost_import_supplier_item as si
	JOIN    VP60_Spwy..bc_extract_cost_import AS i
	ON      si.ImportId = i.ImportId
	JOIN	supplier_packaged_item AS spi
	ON      i.ResolvedSupplierId = spi.supplier_id
	AND     si.SupplierItemCode = spi.supplier_item_code
	WHERE   i.ImportId = @ImportId

	UPDATE  si
	SET		ResolvedCostLevelId = mcl.merch_cost_level_id
	FROM	VP60_Spwy..bc_extract_cost_import_supplier_item as si
	JOIN    VP60_Spwy..bc_extract_cost_import AS i
	ON      si.ImportId = i.ImportId
	JOIN	merch_cost_level AS mcl
	ON      i.ResolvedSupplierId = mcl.supplier_id
	AND     REPLACE(si.CostLevelName,'~',',') = mcl.name
	WHERE   i.ImportId = @ImportId

	UPDATE 	si
	SET		IsValid = 'n'
	FROM	VP60_Spwy..bc_extract_cost_import_supplier_item AS si
	JOIN    VP60_Spwy..bc_extract_cost_import AS i
	ON      si.ImportId = i.ImportId
	JOIN	merch_cost_change AS mcc
	ON      i.ResolvedSupplierId = mcc.supplier_id
	AND     si.ResolvedSupplierItemId = mcc.supplier_item_id
	AND     si.ResolvedCostLevelId = mcc.merch_cost_level_id
	WHERE   mcc.change_type_code IN ('a','c')
	AND     mcc.end_date = si.EndDate
	AND     mcc.start_date >= si.StartDate
	AND     mcc.supplier_price = si.SupplierPrice
	AND     mcc.supplier_allowance = si.SupplierAllowance
	AND 	i.ImportId = @ImportId

    UPDATE 	si
    SET		IsValid = 'n'
    FROM	VP60_Spwy..bc_extract_cost_import_supplier_item AS si
    JOIN    VP60_Spwy..bc_extract_cost_import AS i
    ON      si.ImportId = i.ImportId
    WHERE  	i.ImportId = @ImportId
    AND     (ResolvedSupplierItemId IS NULL OR ResolvedCostLevelId IS NULL)

	UPDATE si
	SET SequenceNumber = Seq.SequenceNumber
	FROM VP60_Spwy..bc_extract_cost_import_supplier_item AS si
	JOIN (SELECT ImportId, ResolvedSupplierItemId, ResolvedCostLevelId, StartDate, PromoFlag,
		ROW_NUMBER() OVER (PARTITION BY ImportId, ResolvedSupplierItemId, ResolvedCostLevelId
		ORDER BY ImportId, ResolvedSupplierItemId, ResolvedCostLevelId, StartDate) AS SequenceNumber
		FROM VP60_Spwy..bc_extract_cost_import_supplier_item ) AS seq
	ON 		si.ImportId = seq.ImportId
	AND 	si.ResolvedSupplierItemId = seq.ResolvedSupplierItemId
	AND 	si.ResolvedCostLevelId    = seq.ResolvedCostLevelId
	AND 	si.StartDate = seq.StartDate
	AND 	si.PromoFlag = seq.PromoFlag
	WHERE 	si.ImportId = @ImportId
	AND   	si.IsValid = 'y'
	
	UPDATE	VP60_Spwy..bc_extract_cost_import
	SET    	StatusCode = 'r'
	WHERE 	ImportId = @ImportId
	
END	

--COMMIT TRANSACTION