/****** Object:  StoredProcedure [dbo].[ape_insert_execution_object]    Script Date: 10/6/2018 3:18:44 PM ******/
DROP PROCEDURE [dbo].[ape_insert_execution_object]
GO

/****** Object:  StoredProcedure [dbo].[ape_insert_execution_object]    Script Date: 10/6/2018 3:18:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- this proceedure is used to insert new objects into the queue. 
-- It returns the row from APE_Execution_Queue_Working that was inserted. This primarily 
-- for reading back the execution_guid that keys the execution item but the rest of the 
-- rows columsn are useful in debugging and testing the procedure
CREATE PROCEDURE [dbo].[ape_insert_execution_object] 
 @moniker nvarchar(255),  -- moniker of the object being queued
 @exec_type nchar(1),  -- type of object being queued
     --  'a' Sequential Job 
     --  'b' Concurrent job
     --  'c' Sequentail Task
     --  'd' Concurrent Task
 @exec_status nchar(1),  -- Initial status of queued object 
     --  'q' in queue awaiting initial processing
     --  'w' (concurrent task only) wait for activation
 @job_exec_guid uniqueidentifier,-- Execution guid for associated job ( null if a no parent job is in effect )
 @task_sequence int,  -- Task sequence number for serial tasks
 @exec_doc ntext,  -- Document that goes with object
 @org_hierarchy_id int,  -- org id from context if present ( may be NULL )
 @client_id int,   -- client ID
 @named_lock nvarchar(50), -- specifies the named lock to use 
 @dev_mode_segment nvarchar(64), -- Used by developer mode only to hard code the queue segment to be used.
 @parent_child_incr int  -- denote how many children are being added to the parent job 

AS
SET NOCOUNT ON

-- declarations 
DECLARE @SegmentGuid uniqueidentifier
DECLARE @ExecutionGuid uniqueidentifier
DECLARE @LockId int

IF(@dev_mode_segment is null )
 BEGIN
  -- This path supports Standard modes of operation
  -- first we need to figure out which Queue Segment the object goes into 
  select  top 1
   @SegmentGuid = segment_guid
  from  dbo.APE_Execution_Queue_Segment_Config with (nolock)
  where  @moniker like moniker_selector
  order by sort_order
 
  -- make sure some segment is present
  IF ( @SegmentGuid is NULL ) 
   BEGIN
    IF (@moniker Like 'nAPE.%')
     BEGIN
      Set @SegmentGuid = 'F5944DD5-498F-4ADA-AC63-982DDA30BEA4'
     END
    ELSE
     BEGIN
      -- this is a red table data guid
      -- HACK: the current value was made up by ccook to provide a default record
      Set @SegmentGuid = '00000001-0000-0000-0000-000000000000'
     END
   END
 END
ELSE
 BEGIN
 -- This section is used during developer mode operation 
 -- in this case a developer machine name is being sent in to use as the 
 -- queue name 
 select  top 1
  @SegmentGuid = segment_guid
 from  dbo.APE_Execution_Queue_Segment with (nolock)
 where  segment_name = @dev_mode_segment
 
 -- if this is the first request, then a new segement will need 
 -- to be created for that machine name
 IF ( @SegmentGuid is NULL ) 
  BEGIN
  -- geenrate a new ID for the segment
  Set @SegmentGuid = NewID()
  insert into  dbo.APE_Execution_Queue_Segment
    (
    segment_guid,
    segment_name,
    active_flag,
    client_id,
    last_modified_user_id,
    last_modified_timestamp
    )
    values (
    @SegmentGuid,
    @dev_mode_segment,
    'y',
    1,
    42,
    CURRENT_TIMESTAMP
    )
  END
 END

set @LockId = null

IF (@named_lock IS NOT NULL)
BEGIN
  BEGIN TRAN
    SELECT @LockId = lock_id
    FROM ape_execution_queue_lock with (updlock, serializable)
    WHERE named_lock = @named_lock
      AND client_id = @client_id
    
    IF (@LockId IS NULL)
    BEGIN
      INSERT ape_execution_queue_lock
      (named_lock, client_id)
      VALUES (@named_lock, @client_id)
      SET @LockId = @@identity
    END
  COMMIT TRAN
END


-- default parent incr count to 1 if not provided
if( @parent_child_incr is null ) Set @parent_child_incr = 1;

-- now bump the child count for the parent object if any was specified.
if ( @job_exec_guid is not null and @parent_child_incr > 0 )
 BEGIN 
 update  APE_Execution_Queue
  set  child_count = child_count + @parent_child_incr
 where  execution_guid = @job_exec_guid
 END


-- create a new guid key for the execution 
--set @ExecutionGuid = NEWID()

declare @guidTable as table (execution_guid uniqueidentifier)

-- use tran to insure that nobody picks up the queue record without the associated document
BEGIN TRAN
-- now insert the object as specified 
INSERT INTO dbo.APE_Execution_Queue
    (
 job_execution_guid,
 execution_moniker,
 execution_type_code,
 execution_queued_timestamp,
 execution_start_timestamp,
 execution_end_timestamp,
 execution_status_code,
 task_sequence,
 execution_segment_guid,
 org_hierarchy_id,
 client_id,
 host_name,
 lock_id,
 child_count,
 in_process_status,
 is_job_bit,
 has_parent_bit
 )
output inserted.execution_guid into @guidTable
select      
 @job_exec_guid,  -- provided by caller
 @moniker,   -- provided by caller
 @exec_type,   -- provided by caller
 CURRENT_TIMESTAMP,  -- in queue time is now 
 NULL,    -- start of process time is unknown
 NULL,    -- end of process time is unknown
 @exec_status,   -- provided by caller
 @task_sequence,  -- provided by caller
 @SegmentGuid,  -- calculated from moniker 
 @org_hierarchy_id, -- provided by caller
 @client_id,  -- provided by caller
 HOST_NAME(),
 @LockId,
 0,  -- an object going into quque cannot yet have any children so 0 is defaulted
 'c',  -- preimptive assumption that the object will succeeed. Thsi helps resolve the final status
 case when (@exec_type <= 'b') then 1 else 0 end,
 case when @job_exec_guid is not null then 1 else 0 end

select @ExecutionGuid = execution_guid from @guidTable

-- only create a document row if it is needed
IF ( @exec_doc is not NULL ) 
 BEGIN 

 INSERT INTO dbo.APE_Execution_Document
      (
  execution_doc_guid,
  execution_doc 
  )
 select
  @ExecutionGuid,  -- new generated execution key 
  @exec_doc  -- provided by caller

 END

COMMIT TRAN


-- select back the new row in que to the caller 
-- this intentionally does not select back the execution doc (it could be large)
select      
 @ExecutionGuid as [execution_guid],  -- new generated execution key 
 @job_exec_guid as [job_execution_guid],  -- provided by caller
 @moniker as [execution_moniker],   -- provided by caller
 @exec_type as [execution_type_code],   -- provided by caller
 CURRENT_TIMESTAMP as [execution_queued_timestamp],  -- in queue time is now 
 NULL as [execution_start_timestamp],    -- start of process time is unknown
 NULL as [execution_end_timestamp],    -- end of process time is unknown
 @exec_status as [execution_status_code],   -- provided by caller
 @task_sequence as [task_sequence],  -- provided by caller
 @SegmentGuid as [execution_segment_guid],  -- calculated from moniker 
 @org_hierarchy_id as [org_hierarchy_id], -- provided by caller
 @client_id as [client_id],  -- provided by caller
 HOST_NAME()as [host_name],
 @named_lock as [named_lock],
 0 as [child_count],  -- an object going into quque cannot yet have any children so 0 is defaulted
 'c' as [in_process_status],  -- preimptive assumption that the object will succeeed. Thsi helps resolve the final status
 NULL as [app_status] 





GO

