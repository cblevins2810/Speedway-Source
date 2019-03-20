/*  
	Create Retail Strategies 
	August 2018
	
	This script will create retail strategies using a de-normalized import table.
	
*/

IF OBJECT_ID('tempdb..#mg_name') IS NOT NULL
  DROP TABLE #mg_name

IF OBJECT_ID('tempdb..#mgm_name') IS NOT NULL
  DROP TABLE #mgm_name

IF OBJECT_ID('tempdb..#ml_name') IS NOT NULL
  DROP TABLE #ml_name  

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT
DECLARE @IncludeStandard CHAR(1)

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

-- If the default merch_group/retail strategy already exists, remove it from the import table
-- so it will not be re-created.
IF EXISTS (SELECT 1 FROM merch_group WHERE standard_flag = 'y' AND client_id = @ClientId)
	DELETE bc_extract_retail_strategy WHERE mg_standard_flag = 'y'

-- Insert the group names into a temp table, so pk id values can be assigned
SELECT DISTINCT mg_name
INTO #mg_name
FROM bc_extract_retail_strategy

SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Merch_Group'
AND db_id = 1

-- Return the starting value of the next ticket and allocate an addition amount based upon the number of merch groups
EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

UPDATE e
SET resolved_merch_group_id = @NextId - RowNumber + 1
FROM bc_extract_retail_strategy AS e
JOIN (SELECT DISTINCT mg_name,
      ROW_NUMBER() OVER (ORDER BY mg_name) AS RowNumber
      FROM #mg_name) AS mg
ON e.mg_name = mg.mg_name

-- Insert the group member names into a temp table, so pk id values can be assigned
SELECT DISTINCT mg_name, mgm_name
INTO #mgm_name
FROM bc_extract_retail_strategy

SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Merch_Group_Member'
AND db_id = 1

-- Return the starting value of the next ticket and allocated an addition amount based upon the number of merch group members
EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

UPDATE e
SET resolved_merch_group_member_id = @NextId - RowNumber + 1
FROM bc_extract_retail_strategy AS e
JOIN (SELECT DISTINCT mg_name, mgm_name,
      ROW_NUMBER() OVER (ORDER BY mg_name, mgm_name) AS RowNumber
      FROM #mgm_name) AS mgm
ON e.mg_name = mgm.mg_name
AND e.mgm_name = mgm.mgm_name

-- Insert the group level names into a temp table, so pk id values can be assigned
SELECT DISTINCT mg_name, mgm_name, ml_name
INTO #ml_name
FROM bc_extract_retail_strategy

SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Merch_Level'
AND db_id = 1

-- Return the starting value of the next ticket and allocated an addition amount based upon the number of merch levels
EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

UPDATE e
SET resolved_merch_level_id = @NextId - RowNumber + 1
FROM bc_extract_retail_strategy AS e
JOIN (SELECT DISTINCT mg_name, mgm_name, ml_name,
      ROW_NUMBER() OVER (ORDER BY mg_name, mgm_name, ml_name) AS RowNumber
      FROM #ml_name) AS ml
ON e.mg_name = ml.mg_name
AND e.mgm_name = ml.mgm_name
AND e.ml_name = ml.ml_name

-- Insert the merch groups
INSERT merch_group
(merch_group_id,
 name,
 retail_item_type_code,
 standard_flag,
 client_id,
 last_modified_user_id,
 last_modified_timestamp)
SELECT DISTINCT
resolved_merch_group_id,
mg_name,
mg_retail_item_type_code,
mg_standard_flag,
@ClientId,
42,
GETUTCDATE()
FROM bc_extract_retail_strategy 

-- Insert the merch group members
INSERT merch_group_member
(merch_group_id,
 merch_group_member_id,
 name,
 client_id,
 last_modified_user_id,
 last_modified_timestamp)

SELECT DISTINCT
resolved_merch_group_id,
resolved_merch_group_member_id,
mgm_name,
@ClientId,
42,
GETUTCDATE()
FROM bc_extract_retail_strategy 

-- Insert merch/retail levels
INSERT merch_level
(merch_group_id,
 merch_group_member_id,
 merch_level_id,
 name,
 default_ranking,
 client_id,
 high_margin,
 low_margin,
 target_margin,
 last_modified_user_id,
 last_modified_timestamp) 

SELECT DISTINCT
resolved_merch_group_id,
resolved_merch_group_member_id,
resolved_merch_level_id,
ml_name,
ml_default_ranking,
@ClientId,
ml_high_margin,
ml_low_margin,
ml_target_margin,
42,
GETUTCDATE()
FROM bc_extract_retail_strategy    

IF OBJECT_ID('tempdb..#mg_name') IS NOT NULL
  DROP TABLE #mg_name

IF OBJECT_ID('tempdb..#mgm_name') IS NOT NULL
  DROP TABLE #mgm_name

IF OBJECT_ID('tempdb..#ml_name') IS NOT NULL
  DROP TABLE #ml_name
