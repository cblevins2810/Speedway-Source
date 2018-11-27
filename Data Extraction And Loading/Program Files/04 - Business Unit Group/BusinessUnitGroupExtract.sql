SET NOCOUNT ON

DECLARE @Modulus INT
DECLARE @Remainder INT

/*
:SETVAR Modulus -1
:SETVAR Remainder -1
*/

SET @Modulus = $(Modulus)
SET @Remainder = $(Remainder)

SELECT rsda_bug.name AS 'Business Unit Group Code',
REPLACE(rsda_bug.long_name,',','^') AS 'Business Unit Group Name',
REPLACE(ISNULL(bug.Description,''),',','~') AS 'Description',
bug.business_unit_group_type_code AS 'Group Type Code',
bug.transfer_group_flag AS 'Transfer Group',
'_' + rsda_bu.name AS 'Business Unit Code',
REPLACE(rsda_bu.long_name,',','~') AS 'Business Unit Name',
'Assign' AS Action
FROM Rad_Sys_Data_Accessor AS rsda_bug
JOIN business_unit_group as bug
ON bug.business_unit_group_id = rsda_bug.data_accessor_id
JOIN Business_Unit_Group_List as bugl
ON bug.business_unit_group_id = bugl.business_unit_group_id
JOIN Rad_Sys_Data_Accessor AS rsda_bu
ON rsda_bu.data_accessor_id = bugl.business_unit_id
JOIN business_unit AS bu
ON bu.business_unit_id = rsda_bu.data_accessor_id
WHERE bu.status_code != 'c'
AND bug.business_unit_group_id % @Modulus = @Remainder
AND bug.cdm_owner_id = bug.client_id
AND rsda_bug.name like 'zsBUG%'
--AND (rsda_bug.name COLLATE Latin1_General_CS_AS) not like 'z%'
AND bu.status_code != 'c'
ORDER BY rsda_bug.name, rsda_bu.name
