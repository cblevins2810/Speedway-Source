IF OBJECT_ID('tempdb..#bc_extract_receipt') IS NOT NULL
  DROP TABLE #bc_extract_receipt
GO

IF OBJECT_ID('tempdb..#bc_extract_receipt_section') IS NOT NULL
  DROP TABLE #bc_extract_receipt_section
GO

IF OBJECT_ID('tempdb..#bc_extract_receipt_section_detail') IS NOT NULL
  DROP TABLE #bc_extract_receipt_section_detail
GO

CREATE TABLE #bc_extract_receipt(
    new_id INT IDENTITY (1,1) NOT NULL,
	receipt_id int NOT NULL
) 
GO

CREATE TABLE #bc_extract_receipt_section(
    new_id INT IDENTITY (1,1) NOT NULL,
	receipt_section_id int NOT NULL,
)
GO

CREATE TABLE #bc_extract_receipt_section_detail(
    new_id INT IDENTITY (1,1) NOT NULL,
	receipt_section_id int NOT NULL,
	receipt_section_detail_id int NOT NULL)
GO

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

-- Receipts
INSERT #bc_extract_receipt (receipt_id)
SELECT receipt_id
FROM  bc_extract_receipt

SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Receipt'
AND db_id = 1

-- Return the starting value of the next ticket and allocated an addition amount based upon the number of receipts
--EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT
EXEC plt_get_next_named_ticket @table_name=N'Receipt',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output

INSERT Receipt (
receipt_id,
name,
description,
receipt_type_id,
client_id,
last_modified_user_id,
last_modified_timestamp)
SELECT @NextId - new_id + 1,
name,
description,
receipt_type_id,
@ClientId,
42,
GETDATE()
FROM #bc_extract_receipt AS t
JOIN bc_extract_receipt AS r
ON   t.receipt_id = r.receipt_id

-- Receipt Section
INSERT #bc_extract_receipt_section (receipt_section_id)
SELECT receipt_section_id
FROM   bc_extract_receipt_section

SET @TicketCount = @@RowCount

EXEC plt_get_next_named_ticket @table_name=N'Receipt_Section',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output


INSERT Receipt_Section (
receipt_section_id,
name,
section_type_code,
display_item_flag,
separate_line_flag,
status_code,
editable_flag,
client_id,
last_modified_user_id,
last_modified_timestamp)
SELECT @NextId - new_id + 1,
name,
section_type_code,
display_item_flag,
separate_line_flag,
status_code,
editable_flag,
@Clientid,
42,
GETDATE()
FROM #bc_extract_receipt_section rst
JOIN bc_extract_receipt_section rs
ON   rst.receipt_section_id = rs.receipt_section_id

-- Receipt Section List
INSERT receipt_section_list (
receipt_section_id,
receipt_id,
sort_order,
client_id,
last_modified_user_id,
last_modified_timestamp )
SELECT rs.receipt_section_id,
r.receipt_id,
sle.sort_order,
@ClientId,
42,
GETDATE()
FROM bc_extract_receipt_section_list AS sle
JOIN receipt AS r
ON   sle.receipt_name = r.name
JOIN receipt_section AS rs
ON   sle.receipt_section_name = rs.name

-- Receipt Section Detail
INSERT #bc_extract_receipt_section (receipt_section_id)
SELECT receipt_section_id
FROM   bc_extract_receipt_section

INSERT #bc_extract_receipt_section_detail(
receipt_section_id,
receipt_section_detail_id)
SELECT 
receipt_section_id,
receipt_section_detail_id
FROM bc_extract_receipt_section_detail

SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Receipt_Section_Detail'
AND db_id = 1

-- Return the starting value of the next ticket and allocated an addition amount based upon the number of receipt section details
--EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

EXEC plt_get_next_named_ticket @table_name=N'Receipt_Section_Detail',@isred=N'N',@numtickets=@TicketCount,@next_ticket=@NextId output

INSERT receipt_section_detail(
receipt_section_id,
receipt_section_detail_id,
print_variable_code,
text_message,
line_number,
sequence_number,
leading_space,
width,
alignment_type_code,
bold_flag,
double_width_flag,
double_height_flag,
reverse_flag,
hide_single_qty_flag,
receipt_condition_id,
status_code,
client_id,
last_modified_user_id,
last_modified_timestamp)

SELECT rs.receipt_section_id,
@NextId - new_id + 1,
print_variable_code,
text_message,
line_number,
sequence_number,
leading_space,
width,
alignment_type_code,
bold_flag,
double_width_flag,
double_height_flag,
reverse_flag,
hide_single_qty_flag,
receipt_condition_id,
rsd.status_code,
@ClientId,
42,
GETDATE()
FROM #bc_extract_receipt_section_detail as rsdt
JOIN bc_extract_receipt_section_detail AS rsd
ON   rsdt.receipt_section_id = rsd.receipt_section_id
AND  rsdt.receipt_section_detail_id = rsd.receipt_section_detail_id
JOIN Receipt_Section AS rs
ON   rsd.receipt_section_name = rs.name
