IF OBJECT_ID('bcssa_custom_integration..bc_extract_receipt') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_receipt
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_receipt_section') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_receipt_section
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_receipt_section_detail') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_receipt_section_detail
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_receipt_section_list') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_receipt_section_list
GO

SELECT  * INTO bcssa_custom_integration..bc_extract_receipt
FROM     Receipt
WHERE    client_id > 0

SELECT  * INTO bcssa_custom_integration..bc_extract_receipt_section 
FROM    Receipt_Section
WHERE   client_id > 0

SELECT  d.*, s.name as receipt_section_name INTO bcssa_custom_integration..bc_extract_receipt_section_detail
FROM    Receipt_Section_Detail as d
JOIN    Receipt_Section as s
ON      d.receipt_section_id = s.receipt_section_id
WHERE   d.client_id > 0

SELECT  l.*, r.name as receipt_name, rs.name as receipt_section_name INTO bcssa_custom_integration..bc_extract_receipt_section_list
FROM    Receipt_Section_List as l
JOIN    Receipt as r
ON      l.receipt_id = r.receipt_id
JOIN    Receipt_Section as rs
ON      l.receipt_section_id = rs.receipt_section_id
WHERE   l.client_id > 0
