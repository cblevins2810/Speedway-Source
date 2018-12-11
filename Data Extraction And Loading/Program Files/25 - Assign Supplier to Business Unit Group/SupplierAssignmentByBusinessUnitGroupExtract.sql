SET NOCOUNT ON

DECLARE @Modulus INT
DECLARE @Remainder INT

SELECT '_' + rsda.name AS 'Business Unit Group Code',
REPLACE(rsda.long_name,',','~') AS 'Business Unit Group Name',
REPLACE(s.name,',','~') AS 'Supplier Name',
s.xref_code AS XRefId,
'Assign' AS Action
FROM Rad_Sys_Data_Accessor AS rsda
JOIN supplier_da_effective_date_list AS sdal
ON rsda.data_accessor_id = sdal.data_accessor_id
JOIN business_unit_group as bug
ON bug.business_unit_group_id = rsda.data_accessor_id
JOIN supplier AS s
ON sdal.supplier_id = s.supplier_id	
WHERE s.xref_code IS NOT NULL
AND bug.cdm_owner_id = bug.client_id
AND rsda.name like 'zsBUG%'
AND sdal.end_date > GETDATE()-1
AND EXISTS (SELECT 1 
            FROM Business_Unit_Group_List AS bugl
			JOIN Business_Unit	AS bu
			ON   bugl.business_unit_id = bu.business_unit_id
			WHERE bugl.business_unit_group_id = bug.business_unit_group_id
			AND  bu.status_code != 'c')
ORDER BY rsda.name







