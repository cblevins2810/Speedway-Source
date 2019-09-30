select * from merch_catalog_import_cost_change

delete Merch_Catalog_Import_Cost_Change
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd')

delete Merch_Catalog_Import_Cost_Level
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd')

delete merch_catalog_import_supplier_item_barcode_list
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd')

delete merch_catalog_import_supplier_item
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd')

delete merch_catalog_import_event
where catalog_import_event_id in (select catalog_import_event_id
                                  from Merch_Catalog_Import_Event 
                                  where status_code = 'd')