SELECT s.xref_code,
s.name,
''																AS meaningless_space,
ISNULL(accepts_combined_push_orders_flag,'') 					AS accepts_combined_push_orders_flag,
ISNULL(accepts_push_orders_flag,'') 							AS accepts_push_orders_flag,
''																AS allow_bu_override_customer_number_flag,  -- Not in BC, Default NULL
ISNULL(allow_bu_review_auto_orders_flag,'') 					AS allow_bu_review_auto_orders_flag,
ISNULL(allow_fractional_quantity_flag,'') 						AS allow_fractional_quantity_flag,
ISNULL(allow_return_on_invoice_flag,'') 						AS allow_return_on_invoice_flag,
'n'																AS allow_totals_accept_receiving_flag,  -- Not in BC, Default n
'n'																AS allow_totals_only_receiving_flag,  -- Not in BC, Default n
's' 															AS ap_payment_type,  -- Not in BC, Default s
ISNULL(auto_approve_invoice_days,'') 							AS auto_approve_invoice_days,
'n' 															AS auto_create_cm_from_cr_flag,  -- Not in BC, Default 'n'
ISNULL(auto_create_invoice_from_recv_flag,'') 					AS auto_create_invoice_from_recv_flag,
'n' 															AS auto_create_return_from_credit_memo_import_flag,   -- Not in BC, Default 'n'
ISNULL(auto_credit_for_qty_discrep_flag,'') 					AS auto_credit_for_qty_discrep_flag,
ISNULL(auto_manage_cost_discrep_flag,'') 						AS auto_manage_cost_discrep_flag,
ISNULL(auto_post_inv_recv_flag,'')								AS auto_post_inv_recv_flag,
ISNULL(auto_reject_disputed_invoice_days,'')					AS auto_reject_disputed_invoice_days,
ISNULL(autoassign_item_flag,'') 								AS autoassign_item_flag,
ISNULL(automated_order_review_type_code,'') 					AS automated_order_review_type_code,
'n' 															AS automatically_post_linked_credit_memo_flag,  -- Not in BC, Default 'n'
'n' 															AS automatically_post_linked_invoice_flag,   -- Not in BC, Default 'n'
'' 																AS balance_unit_cost_control_amt_tolerance,  -- Not in BC, Default NULL
ISNULL(billing_method_type_code,'')								AS billing_method_type_code,
'y' 															AS blind_receiving_flag,
ISNULL(bu_control_costs_code,'') 								AS bu_control_costs_code,
ISNULL(catalog_import_review_flag,'') 							AS catalog_import_review_flag,
'e' 															AS company_operated_business_unit_can_create_code,  -- Not in BC, Default 'e'
ISNULL(consolidate_receiving_flag,'')							AS consolidate_receiving_flag,
'n' 															AS create_receive_from_invoice_flag,  -- Not in BC, Default 'n'
ISNULL(credit_approval_required_flag,'') 						AS credit_approval_required_flag,
ISNULL(credit_request_export_method_type_code,'') 				AS credit_request_export_method_type_code,
'' 																AS customer_number,  -- Not in BC, Default NULL
'l' 															AS dealer_operated_business_unit_can_create_code,  -- Not in BC, Default 'l'
''  															AS default_forecast_group_id,  -- Exists in BC but must pull over as NULL do to key conflict
''					 											AS default_gl_account_id,  -- Exists in BC but must pull over as NULL do to key conflict
ISNULL(default_recv_souce_code,'') 								AS default_recv_souce_code,  -- Not in ESO
ISNULL(default_recv_source_code,'') 							AS default_recv_source_code,
ISNULL(delivery_number_mask,'')									AS delivery_number_mask,
ISNULL(discontinued_item_preference_type_code,'')				AS discontinued_item_preference_type_code,  -- Not is ESO
ISNULL(discrep_max_tolerance,'') 								AS discrep_max_tolerance,
ISNULL(duplicate_invoice_processing_type_code,'')				AS duplicate_invoice_processing_type_code,
''							 									AS end_of_week_day_id,  -- Not in ESO
--ISNULL(end_of_week_day_id,'') 									AS end_of_week_day_id,  -- Not in ESO
ISNULL(estimated_vat_tolerance,'')								AS estimated_vat_tolerance,
ISNULL(export_draft_po_flag,'')									AS export_draft_po_flag,  -- Not in ESO
ISNULL(export_host_password,'')									AS export_host_password,
ISNULL(export_host_username,'') 								AS export_host_username,
ISNULL(export_hostname,'') 										AS export_hostname,
ISNULL(export_schema_type_code,'')								AS export_schema_type_code,
ISNULL(export_target_directory,'') 								AS export_target_directory,
ISNULL(export_type_code,'') 									AS export_type_code,
ISNULL(external_vendor_ap_code,'') 								AS external_vendor_ap_code,
'' 																AS first_alert_due_time,  -- Not in BC, Default NULL
ISNULL(fiscal_code,'')											AS fiscal_code,
'e' 															AS fuel_invoice_entry_method_type_code,  -- Not in BC, Default 'e'
ISNULL(gen_auto_orders_flag,'') 								AS gen_auto_orders_flag,
'n'																AS gst_cost_includes_tax_flag,  -- Not in BC, Default 'n'
'n'																AS gst_supplier_provides_item_tax_amount_flag ,   -- Not in BC, Default 'n'
ISNULL(hide_costs_for_bu_flag,'')								AS hide_costs_for_bu_flag,
ISNULL(hold_ap_for_cost_approval_flag,'')						AS hold_ap_for_cost_approval_flag,
ISNULL(hold_ap_for_credit_memo_post_flag,'') 					AS hold_ap_for_credit_memo_post_flag,
ISNULL(holiday_config_flag,'') 									AS holiday_config_flag,  -- Not in ESO
ISNULL(holiday_delivery_code,'') 								AS holiday_delivery_code,
ISNULL(holiday_delivery_delay_one_day_flag,'')					AS holiday_delivery_delay_one_day_flag,  -- Not in ESO
ISNULL(holiday_order_code,'') 									AS holiday_order_code,
ISNULL(holiday_order_delay_one_day_flag,'') 					AS holiday_order_delay_one_day_flag,  -- Not in ESO
ISNULL(inv_receive_invoice_date_required_flag,'')				AS inv_receive_invoice_date_required_flag,
ISNULL(inv_receive_invoice_num_invalid_chars,'') 				AS inv_receive_invoice_num_invalid_chars,
ISNULL(inv_receive_invoice_num_required_flag,'') 				AS inv_receive_invoice_num_required_flag,
ISNULL(inv_receive_require_invoice_flag,'') 					AS inv_receive_require_invoice_flag,
ISNULL(inv_return_invoice_num_invalid_chars,'') 				AS inv_return_invoice_num_invalid_chars,
ISNULL(inv_return_invoice_num_required_flag,'') 				AS inv_return_invoice_num_required_flag,
ISNULL(invoice_cost_source_type_code,'') 						AS invoice_cost_source_type_code,
ISNULL(invoice_export_type_code,'') 							AS invoice_export_type_code,
ISNULL(invoice_print_signature_flag,'') 						AS invoice_print_signature_flag,
ISNULL(invoice_quantity_source_type_code,'') 					AS invoice_quantity_source_type_code ,
ISNULL(maintain_bu_catalog_flag,'') 							AS maintain_bu_catalog_flag,
ISNULL(max_bu_orders_review_hours,'') 							AS max_bu_orders_review_hours,
ISNULL(minimum_order_amount,'') 								AS minimum_order_amount,
ISNULL(minimum_order_quantity,0) 								AS minimum_order_quantity,
ISNULL(po_alert_day_number,'') 									AS po_alert_day_number,  -- Not in ESO
'n' 															AS open_to_buy_flag,  -- Not in BC, Default 'n'
's'																AS order_ack_due_by_code,  -- Not in BC, Default 's'
'' 																AS Order_ack_due_by_time,  -- Not in BC, Default NULL
ISNULL(po_email_address,'')										AS po_email_address,
'' 																AS po_override_directory,  -- Not in BC, Default NULL
ISNULL(primary_payment_method_type_code,'')						AS primary_payment_method_type_code,
ISNULL(prohibit_packaging_updates_flag,'') 						AS prohibit_packaging_updates_flag,
ISNULL(prohibit_supplier_item_group_updates_flag,'')			AS prohibit_supplier_item_group_updates_flag,  -- Not in ESO
ISNULL(prohibit_supplier_item_name_updates_flag,'') 			AS prohibit_supplier_item_name_updates_flag,
'n'																AS rcv_allow_unrestricted_cost_changes_flag,  -- Not in BC, Default 'n'
ISNULL(rcv_using_inv_default_cost_target_code,'') 				AS rcv_using_inv_default_cost_target_code,
ISNULL(rcv_using_po_default_cost_target_code,'') 				AS rcv_using_po_default_cost_target_code,
ISNULL(receive_balance_to_zero_tolerance,0) 					AS receive_balance_to_zero_tolerance,
ISNULL(receive_check_number_for_cod_flag,'') 					AS receive_check_number_for_cod_flag,
'' 																AS receive_max_review_hours,  -- Not in BC, Default NULL
ISNULL(req_total_credit_memo_tolerance,'')						AS req_total_credit_memo_tolerance,
ISNULL(req_total_invoice_entry_flag,'') 						AS req_total_invoice_entry_flag,
ISNULL(require_approval_before_payment_flag,'')					AS require_approval_before_payment_flag,
'n'																AS require_delivery_date_flag,  -- Not in BC, Default 'n'
ISNULL(return_approval_required_flag,'') 						AS return_approval_required_flag,
'n'																AS return_ref_num_req_flag,  -- Not in BC, Default 'n'
''																AS second_alert_due_time,  -- Not in BC, Default 'n'
'' 																AS suggested_order_qty_rounding_threshold,  -- Not in BC, Default 'n'
''																AS svc_receiving_method_id,  -- Not in ESO
--ISNULL(svc_receiving_method_id,'') 								AS svc_receiving_method_id,  -- Not in ESO
'' 																AS tax_rounding_threshold_amount,  -- Not in BC, Default NULL
'' 																AS totals_only_supplier_item_id,  -- Not in BC, Default NULL
'n'																AS treat_wknd_holidays_as_closed_in_lead_time_calc_flag,  -- Not in BC, Default 'n'
'y'																AS use_default_forecast_group_flag,  -- Not in BC, Default 'y'
'n'																AS use_invoice_receiving_cost_for_authorization_flag,  -- Not in BC, Default 'n'
'n'																AS use_lowest_cost_flag -- Not in BC, Default 'n'

FROM Supplier AS s
WHERE status_code = 'a'
AND   xref_code IS NOT NULL
AND   s.name NOT like 'F_%'
ORDER BY xref_code
