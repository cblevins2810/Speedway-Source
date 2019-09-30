DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

SELECT i.xref_code, i.name, uom1.name, iuomc.from_display_quantity, uom2.name, iuomc.to_display_quantity,
CONVERT(nvarchar(10),ia.last_modified_timestamp,120) date_added
FROM item_uom_conversiON as iuomc
JOIN item as i
ON iuomc.item_id = i.item_id
JOIN unit_of_measure as uom1
ON iuomc.FROM_uom_id = uom1.unit_of_measure_id
JOIN unit_of_measure as uom2
ON iuomc.to_uom_id = uom2.unit_of_measure_id
JOIN Item_Audit AS ia
ON  i.item_id = ia.item_id
WHERE i.purge_flag = 'n'
AND i.client_id = @ClientId
AND ia.audit_type_code = 'I'
ORDER BY date_added