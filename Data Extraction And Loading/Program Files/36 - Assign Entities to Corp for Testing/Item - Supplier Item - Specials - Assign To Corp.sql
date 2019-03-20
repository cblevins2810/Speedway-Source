DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM rad_sys_client


/* Assign Supplier Items */
insert supplier_packaged_item_da_effective_date_list
(supplier_id,
supplier_item_id,
packaged_item_id,
data_accessor_id,
last_modified_user_id,
last_modified_timestamp,
implicit_reference_count,
explicit_flag,
client_id,
start_date,
end_date)
SELECT spi.supplier_id,
spi.supplier_item_id,
spi.packaged_item_id,
spi.client_id,
42,
GETDATE(),
0,
'y',
spi.client_id,
'2018-08-21',
'2075-12-31'
FROM supplier_packaged_item AS spi
WHERE NOT EXISTS (SELECT 1
                  FROM supplier_packaged_item_da_effective_date_list AS dalist
				  WHERE dalist.supplier_id = spi.supplier_id
				  AND   dalist.supplier_item_id = spi.supplier_item_id
				  AND   dalist.packaged_item_id = spi.packaged_item_id
				  AND   dalist.data_accessor_id = spi.client_id)
AND spi.client_id = @ClientId
				  
/* Assign Items */
insert item_da_effective_date_list
(item_id,
data_accessor_id,
last_modified_user_id,
last_modified_timestamp,
implicit_reference_count,
explicit_flag,
client_id,
start_date,
end_date)
SELECT i.item_id,
i.client_id,
42,
GETDATE(),
0,
'y',
i.client_id,
'2018-08-21',
'2075-12-31'
FROM item AS i
WHERE NOT EXISTS (SELECT 1
                  FROM item_da_effective_date_list AS dalist
				  WHERE dalist.item_id = i.item_id
				  AND   dalist.data_accessor_id = i.client_id)
AND i.client_id = @ClientId

/* Assign Auto Combos */				  
INSERT retail_auto_combo_da_list	  
(data_accessor_id,
retail_auto_combo_id,
last_modified_user_id,
last_modified_timestamp,
implicit_reference_count,
explicit_flag)
SELECT rac.client_id,
rac.retail_auto_combo_id,
42,
GETDATE(),
0,
'y'
FROM retail_auto_combo AS rac
WHERE NOT EXISTS (SELECT 1
                  FROM retail_auto_combo_da_list AS dalist
				  WHERE dalist.retail_auto_combo_id = rac.retail_auto_combo_id
				  AND   dalist.data_accessor_id = rac.client_id)
AND rac.client_id = @ClientId
				  
				  
				  



