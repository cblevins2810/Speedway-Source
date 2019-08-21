/*-----------------------------------------*/
/* Update auto-ordered/e-invoice Suppliers */
/*-----------------------------------------*/
 
Begin Transaction
Update Supplier 
Set
-- General Tab
	  catalog_import_review_flag							    = 'y'				-- Review Imported Catalog Before Posting
-- Ordering Tab
	  ,gen_auto_orders_flag									    = 'y'				-- Generate Automated Orders
	  ,allow_bu_review_auto_orders_flag						    = 'y'				-- Allow BU to Review Automated Orders
	  ,max_bu_orders_review_hours								= 23				-- Maximum Review Hours for Automated Orders
	  ,use_default_forecast_group_flag							= 'y'				-- Use Default Forecast Group for Automated Orders
	  ,accepts_push_orders_flag									= 'y'				-- Allows Push Orders
	  ,suggested_order_qty_rounding_threshold					= 3					-- Order Quantity Rounding Threshold (%)
-- Receiving tab
      ,delivery_number_mask                                    = NULL              -- Receiving Number Format
      ,receive_balance_to_zero_tolerance                       = 0					-- Balance to Control Amount Tolerance
      ,rcv_using_inv_default_cost_target_code				   = 'i'              -- Receiving Against E-Invoice Defaults Costs to
      ,rcv_using_po_default_cost_target_code                   = 'c'              -- Receiving Against PO Defaults Costs to      
      ,inv_receive_require_invoice_flag                        = 'n'              -- Receive From Invoice Only
      ,default_recv_source_code                                = 'i'              -- Default Receiving Source 'i' = invoice
      ,inv_receive_invoice_date_required_flag                  = 'y'              -- Require Invoice Date
      ,inv_receive_invoice_num_required_flag                   = 'y'              -- Require Invoice Number
      ,inv_receive_invoice_num_invalid_chars                   = '!@#$%^&*()+=_`~\|/?{}[]<>'             -- Invalid Invoice Number Characters
      ,receive_check_number_for_cod_flag                       = 'y'              -- Require Check Number for COD Deliveries
      ,auto_manage_cost_discrep_flag                           = 'y'              -- Auto Manage Cost Discrepancies
      ,auto_post_inv_recv_flag                                 = 'n'              -- Auto Post Receiving
      ,require_delivery_date_flag                              = 'n'              -- Require Entry of Delivery Date and Time
      ,create_receive_from_invoice_flag                        = 'n'              -- Create Receiving from Imported Invoice
      ,receive_max_review_hours                                = NULL             -- Maximum Review Hours
      ,allow_totals_accept_receiving_flag                      = 'n'              -- Allow Total Accept Receiving
      ,blind_receiving_flag                                    = 'n'              -- Force Blind Receiving
      ,allow_totals_only_receiving_flag                        = 'n'              -- Allow Totals Only Receiving
      ,use_lowest_cost_flag                                    = 'n'              -- Use Lowest Cost
-- Returns tab
      ,inv_return_invoice_num_required_flag					   = 'y'              -- Require Invoice Number
      ,inv_return_invoice_num_invalid_chars					   = '!@#$%^&*()+=_`~\|/?{}[]<>'             -- Invalid Invoice Number Characters
      ,return_approval_required_flag                           = 'n'              -- Require Approval Code/Name
-- Interface tab
      ,duplicate_invoice_processing_type_code                   = 'o'              -- Duplicate Invoice 'r'=reject; 'o'=overwrite
      ,credit_request_export_method_type_code                   = 'n'              -- Credit Request Export Type 'n'=none; 'x'=xml
      ,export_type_code                                         = 'a'              -- Purchase Order Export Method 'n'=none; 'a'=archive xml
-- Payment tab
      ,billing_method_type_code                                = 0                -- Export Type to AP 0=invoice; 1=receiving
      ,consolidate_receiving_flag                              = 'n'              -- Allow Multiple Receivings per Invoice
	  ,allow_return_on_invoice_flag								='n'				--Allow Returns on Invoice
	  ,use_invoice_receiving_cost_for_authorization_flag		='y'				-- Restrict Invoice Reconciliation Values
      ,hold_ap_for_credit_memo_post_flag                       = 'n'              -- Hold Payment Until Invoice Reconciled
      ,discrep_max_tolerance                                    = 0.00             -- Balance Invoice to Control Amount Tolerance
      ,credit_approval_required_flag                           = 'n'              -- Require Approval Code and Name to Complete Credit
      ,req_total_credit_memo_tolerance                         = NULL             -- Balance Credit Memo to Control Amount Tolerance
      ,automatically_post_linked_credit_memo_flag              = 'n'              -- Automatically Post Linked Credit Memo
      ,auto_credit_for_qty_discrep_flag                        = 'n'              -- Auto Create Credit for Quantity Discrepancies
      ,auto_create_return_from_credit_memo_import_flag		   = 'n'              -- Auto-Create Returns for Credit Memos
      ,require_approval_before_payment_flag					   = 'n'              -- Require Approval Before Payment
      ,auto_approve_invoice_days                               = NULL             -- Auto-Approve Draft Invoices After
      ,auto_reject_disputed_invoice_days                       = NULL             -- Auto-Delete Disputed Invoices After
      ,estimated_vat_tolerance                                 = NULL             -- Tax Amount Tolerance
      ,ap_payment_type                                         = 'h'              -- Payment Type for AP 'h'=HQ; 's'=Standard
-- Invoice tab
      ,auto_create_invoice_from_recv_flag                      = 'n'              -- Automatically Create Invoice From Receiving
      ,automatically_post_linked_invoice_flag                  = 'y'              -- Automatically Post Linked Invoice
      ,invoice_cost_source_type_code                           = 's'              -- Obtain Cost From 's'=Supplier; 'd'=Default
      ,invoice_quantity_source_type_code                       = 's'              -- Obtain Quantity From 's'=Supplier; 'n'=Net
      ,invoice_export_type_code                                = 'n'              -- Invoice Document Export Type 'x'=XML; 'n'=None
      ,invoice_print_signature_flag                            = 'n'              -- Print Signature Line
 
--Select name, xref_code From Supplier
Where Supplier.xref_code in
(
'1322001',
'1337001')
 
-- Commit
-- Rollback
 
 
/*----------------------------------------*/
/* Identify Suppliers without external id */
/*----------------------------------------*/
 
Select name, xref_code, supplier_type_code 
From Supplier with (nolock)
Where Supplier.xref_code is NULL
      and supplier_type_code = 'm'
 


 
 
 
