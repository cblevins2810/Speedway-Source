/* Sets the seed values for tables that are integrated the the Speedway datamart at 10,000,001 */

DECLARE @TableName NVARCHAR(50)
DECLARE @NextTicket INT
DECLARE @CurrentTicket INT
DECLARE @NumberOfTickets INT


-- Attribute
SET @TableName = 'Retail_Modified_Item_Attribute'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Attribute Value
SET @NextTicket = NULL
SET @TableName = 'Retail_Modified_Item_Attribute_Value_List'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Supplier
SET @NextTicket = NULL
SET @TableName = 'Supplier'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Retail Modified Item
SET @NextTicket = NULL
SET @TableName = 'Retail_Modified_Item'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Item
SET @NextTicket = NULL
SET @TableName = 'Item'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Item Hierarchy 
SET @NextTicket = NULL
SET @TableName = 'Item_Hierarchy'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Coupon
SET @NextTicket = NULL
SET @TableName = 'Coupon'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Discount
SET @NextTicket = NULL
SET @TableName = 'Discount'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Special/Auto Combo
SET @NextTicket = NULL
SET @TableName = 'Retail_Auto_Combo'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Coupon Group
SET @NextTicket = NULL
SET @TableName = 'Coupon_Item_Group'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Discount Group
SET @NextTicket = NULL
SET @TableName = 'Discount_Item_Group'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Retail Item Group
SET @NextTicket = NULL
SET @TableName = 'Retail_Modified_Item_Group'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Item Group
SET @NextTicket = NULL
SET @TableName = 'Inventory_Item_Group'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Cost Level Change Event Id
SET @NextTicket = NULL
SET @TableName = 'Merch_Price_Event'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Cost Level Ranking Id
SET @NextTicket = NULL
SET @TableName = 'Merch_Cost_Level_Group'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Cost Level Id
SET @NextTicket = NULL
SET @TableName = 'Merch_Cost_Level'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Supplier Item Id
SET @NextTicket = NULL
SET @TableName = 'Supplier_Item'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Supplier Packaged Item Id
SET @NextTicket = NULL
SET @TableName = 'Supplier_Packaged_Item'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Method of payment Id
SET @NextTicket = NULL
SET @TableName = 'Tender'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Tax type id
SET @NextTicket = NULL
SET @TableName = 'Retail_Tax_Type'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'

-- Tax Hierarchy id
SET @NextTicket = NULL
SET @TableName = 'Retail_Tax_Hierarchy'
EXEC plt_get_next_named_ticket @TableName,'n', 0, @CurrentTicket OUTPUT
SET @NumberOfTickets = 10000000 - @CurrentTicket
IF @NumberOfTickets > 0 
   EXEC plt_get_next_named_ticket @TableName,'n', @NumberOfTickets, @NextTicket OUTPUT
SELECT @TableName AS 'Table Name', @CurrentTicket AS 'Current Ticket', @NumberOfTickets AS 'Number of Tickets to Seed', @NextTicket AS 'Next Ticket'


--select * from Retail_Tax_Hierarchy

select 'Discount' 'Table', discount_id 'id', name from discount
UNION ALL
select 'Coupon', coupon_id, name from coupon
UNION ALL
select 'Discount Item Group', discount_item_group_id, name from discount_item_group
UNION ALL
select 'Coupon Item Group', coupon_item_group_id, name from coupon_item_group
UNION ALL
select 'Item Group', item_group_id, name from inventory_item_group
UNION ALL
select 'Tender', tender_id, name from Tender
UNION ALL
select 'Tax Jurisdiction', retail_tax_Hierarchy_id, name from Retail_Tax_Hierarchy
UNION ALL
select 'Tax', retail_tax_type_id, name from retail_tax_type




