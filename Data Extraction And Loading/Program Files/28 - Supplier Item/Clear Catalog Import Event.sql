begin transaction


delete Merch_Catalog_Import_Cost_Change
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd'
								  and last_modified_timestamp > '2019-10-26')

delete Merch_Catalog_Import_Cost_Level
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd'
								  and last_modified_timestamp > '2019-10-26')

delete merch_catalog_import_supplier_item_barcode_list
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd'
								  and last_modified_timestamp > '2019-10-26')

delete merch_catalog_import_supplier_item
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd'
								  and last_modified_timestamp > '2019-10-26')

delete merch_catalog_import_event
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd'
								  and last_modified_timestamp > '2019-10-26')
								  
rollback transaction								  