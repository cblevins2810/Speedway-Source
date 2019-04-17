DECLARE @ClientId INT

SELECT @ClientId = MAX(client_id) FROM rad_sys_client

/* Clear Supplier Items */
DELETE supplier_packaged_item_da_effective_date_list
WHERE data_accessor_id = @ClientId
				  
/* Assign Items */
DELETE item_da_effective_date_list
WHERE data_accessor_id = @ClientId

/* Assign Auto Combos */				  
DELETE retail_auto_combo_da_list	  
WHERE data_accessor_id = @ClientId
				  
				  
				  



