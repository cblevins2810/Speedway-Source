SELECT 'BC' System, i.xref_code + '-' + CONVERT(NVARCHAR(15),CONVERT(INT, ridmuom.factor)) AS PackExternalId,
--CASE WHEN i.unit_of_measure_class_id = 3 THEN
--     CASE WHEN ridmuom.factor = 1 THEN 'Each'
--     ELSE CONVERT(NVARCHAR(20),CONVERT(INT,ridmuom.factor)) + '-Each' END,
     mrc.merch_price_event_id,
     rmi.name rmi_name, 
     ml.name level_name,
     mrc.promo_flag,
     mrc.start_date,
     mrc.end_date,
     mrc.retail_price 
INTO bc_extract_price_event_data_bccert1
FROM Merch_Retail_Change AS mrc
JOIN Merch_Level AS ml
ON   mrc.merch_level_id = ml.merch_level_id
JOIN Retail_Modified_Item AS rmi
ON   mrc.retail_modified_item_id = rmi.retail_modified_item_id
JOIN bc_extract_price_event_item AS rmi2
ON   rmi.retail_item_id = rmi2.item_id 
JOIN item AS i
ON   i.item_id = rmi.retail_item_id
LEFT JOIN Retail_Modified_Item_Dimension_List AS rmidl
ON rmi.retail_modified_Item_id = rmidl.retail_modified_Item_id
LEFT JOIN retail_item_dimension_member AS ridm
ON rmidl.dimension_member_id = ridm.dimension_member_id
LEFT JOIN unit_of_measure as ridmuom
ON ridm.unit_of_measure_id = ridmuom.unit_of_measure_id

WHERE default_ranking > 1
AND  GETDATE() BETWEEN mrc.start_date AND mrc.end_date


 


