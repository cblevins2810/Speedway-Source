-- Mark the resolved batches as exported
UPDATE VP60_Spwy..bc_extract_cost_import
SET    StatusCode = 'e'
WHERE  StatusCode = 'r'
