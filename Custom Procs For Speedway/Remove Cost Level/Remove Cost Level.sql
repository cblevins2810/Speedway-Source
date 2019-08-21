-- Cost Level Delete

BEGIN TRANSACTION

DECLARE @supplier_id INT
DECLARE @merch_cost_level_id INT

SELECT @supplier_id = supplier_id
FROM   supplier
WHERE  xref_code = 'PEPSNITR'

SELECT @merch_cost_level_id = merch_cost_level_id
FROM   merch_cost_level
WHERE  supplier_id = @supplier_id
AND    name = 'Consolidated WV/KY'

SELECT @supplier_id, @merch_cost_level_id

SELECT * FROM Merch_Cost_Level
WHERE  supplier_id = @supplier_id

--SELECT * FROM merch_cost_level where merch_cost_level_id = @merch_cost_level_id
--SELECT * FROM Merch_Catalog_Import_Cost_Level where resolved_merch_cost_level_id = @merch_cost_level_id

/*
SELECT *
FROM   Merch_Catalog_Import_Cost_Change AS cc
JOIN   Merch_Catalog_Import_Cost_Level AS cl
ON     cc.supplier_id = cl.supplier_id
AND    cl.merch_cost_level_id = cc.merch_cost_level_id
WHERE  cl.supplier_id = @supplier_id
AND    cl.resolved_merch_cost_level_id = @merch_cost_level_id
*/

DELETE cc
FROM   Merch_Catalog_Import_Cost_Change AS cc
JOIN   Merch_Catalog_Import_Cost_Level AS cl
ON     cc.supplier_id = cl.supplier_id
AND    cl.merch_cost_level_id = cc.merch_cost_level_id
WHERE  cl.supplier_id = @supplier_id
AND    cl.resolved_merch_cost_level_id = @merch_cost_level_id

DELETE Merch_Catalog_Import_Cost_Level
WHERE  supplier_id = @supplier_id
AND    resolved_merch_cost_level_id = @merch_cost_level_id
 
DELETE merch_cost_change
WHERE  supplier_id = @supplier_id
AND    merch_cost_level_id = @merch_cost_level_id

DELETE Merch_Cost_Level_Group_List
WHERE  supplier_id = @supplier_id
AND    merch_cost_level_id = @merch_cost_level_id

DELETE Merch_Cost_Level
WHERE  supplier_id = @supplier_id
AND    merch_cost_level_id = @merch_cost_level_id

SELECT * FROM Merch_Cost_Level
WHERE  supplier_id = @supplier_id

COMMIT TRANSACTION