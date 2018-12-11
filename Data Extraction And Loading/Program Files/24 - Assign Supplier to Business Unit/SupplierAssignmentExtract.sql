SET NOCOUNT ON

SELECT '_' + rsda.name AS 'Business Unit Code',
REPLACE(rsda.long_name,',','~') AS 'Business Unit Name',
REPLACE(s.name,',','~') AS 'Supplier Name',
s.xref_code AS XRefId,
'Assign' AS Action
FROM Rad_Sys_Data_Accessor AS rsda
JOIN supplier_da_effective_date_list AS sdal
ON rsda.data_accessor_id = sdal.data_accessor_id
JOIN business_unit as bu
ON bu.business_unit_id = rsda.data_accessor_id
JOIN supplier AS s
ON sdal.supplier_id = s.supplier_id	
WHERE bu.status_code != 'c'
-- There should be no null xref based upon supplier import,
-- but it is possible that one exists via the UI.
AND s.xref_code IS NOT NULL
AND sdal.end_date > GETDATE()-1
AND s.status_code != 'i'
ORDER BY rsda.name
