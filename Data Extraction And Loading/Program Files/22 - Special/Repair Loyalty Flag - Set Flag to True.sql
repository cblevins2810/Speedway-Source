SELECT * 
FROM retail_auto_combo AS rac
JOIN bc_extract_special_loyalty_flag AS lf
ON   rac.xref_code = 'xref-' + lf.specialXRefID  -- may need to remove "xref-" when using in prod
WHERE lf.requiresLoyalty != rac.loyalty_flag

BEGIN TRANSACTION

UPDATE rac
SET loyalty_flag = 'y'
FROM retail_auto_combo AS rac
JOIN bc_extract_special_loyalty_flag AS lf
ON   rac.xref_code = 'xref-' + lf.specialXRefID  -- may need to remove "xref-" when using in prod
WHERE lf.requiresLoyalty != rac.loyalty_flag

COMMIT TRANSACTION