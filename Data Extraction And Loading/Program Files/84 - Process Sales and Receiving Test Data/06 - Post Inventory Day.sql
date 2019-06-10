BEGIN TRANSACTION

DECLARE @XMLDoc VARCHAR(8000)
DECLARE @ClientId INT
DECLARE @NumberOfBusinessUnits INT
DECLARE @CurrentBusinessUnit INT
DECLARE @BusinessUnitId INT
DECLARE @BusinessUnitCode VARCHAR(20)
DECLARE @LockName VARCHAR(50)
DECLARE @JobMoniker VARCHAR(255)
DECLARe @DayToClose DATETIME

SET @ClientId = 10000001

SELECT @DayToClose = MAX(day_to_close) + 1 FROM bc_extract_replenishment

--SELECT @DayToClose = '2019-04-27'

SET @JobMoniker = 'Applications.Common.APE.Jobs.EndofDayPost'

DECLARE @BusinessUnitList TABLE (
SequenceNumber INT IDENTITY (1,1),
BusinessUnitCode VARCHAR(20),
BusinessUnitId INT)

INSERT @BusinessUnitList (
BusinessUnitCode,
BusinessUnitId)
SELECT name,
data_accessor_id
FROM   rad_sys_data_accessor
WHERE  name IN (
'0006472')

INSERT INTO VP60_eso.dbo.Day_Status
	(org_hierarchy_id
	,status_code
	,business_date
	,last_modified_user_id
	,client_id
	,last_modified_timestamp
	,GL_has_been_aggd_flag
	,bu_date_posted_timestamp
	,publication_status_code
	,inventory_locked_flag
	,fuel_locked_flag)
SELECT
	b.BusinessUnitId
	,'i'
	,@DayToClose
	,42
	,@ClientId
	,getdate()
	,'n'
	,NULL
	,NULL
	,'n'
	,'n'
FROM @BusinessUnitList AS b
WHERE NOT EXISTS (SELECT 1
				 FROM	VP60_eso.dbo.day_status AS ds
				 WHERE 	ds.org_hierarchy_id 	= b.BusinessUnitId
				 AND 	business_date 			= @DayToClose)


-- Submit SCM Post & Agg
SELECT @CurrentBusinessUnit = 1
SELECT @NumberOfBusinessUnits = COUNT(*) FROM @BusinessUnitList

WHILE @CurrentBusinessUnit <= @NumberOfBusinessUnits
BEGIN

	SELECT 	@BusinessUnitId 	= BusinessUnitId,
			@BusinessUnitCode 	= BusinessUnitCode
	FROM    @BusinessUnitList
	WHERE	@CurrentBusinessUnit = SequenceNumber  

	--exec	mm_update_costs @BusinessUnitId, @ClientId, NULL, @DayToClose, 10000000, 100000000, 42
	--exec    mm_post_to_datamart_sales_item_costs  @BusinessUnitId, @ClientId, NULL, @DayToClose, 10000000, 100000000

	SET @XMLDoc = 	'<ExecutionDocument>' + 
					'<ParameterValue name="current_hier_id">' + CONVERT(NVARCHAR(15), @BusinessUnitId) + '</ParameterValue>' +
					'<ParameterValue name="business_date">' + CONVERT(VARCHAR(15), @DayToClose, 1) + '</ParameterValue>' +
					'<ParameterValue name="eod">y</ParameterValue>' +
					'<Context current_client_id="' + CONVERT(VARCHAR(10), @ClientId) + '1" __macaddress="''8c-dc-d4-51-c9-d7-00-00''" ' + 
					'current_user_name="ForecastTest" current_user_id="42" current_language_id="1" ' + 
					'current_hier_id="' + CONVERT(NVARCHAR(15), @BusinessUnitId) + '" ' +
					'current_hier_iddisplay="' + @BusinessUnitCode + '" current_hier_level="2" ' +
					'current_hier="' + CONVERT(NVARCHAR(15), @BusinessUnitId) + '" ' + 

					'__cachedaccessfeatureids="" '  +
					'current_hierdisplay="' + @BusinessUnitCode + '" current_role_id="201" user_prefer_report_format="h" expand_menu_flag="y" hide_instore_role="y" limit_assigned_bu="n" cal_start_day_of_week="1" template_client_flag="n" ' +
					'workflow_schedule_id="{A0E4849D-F43B-4DC3-AA4F-CA1387B4819E}" execution_id="1000125" ' +
					'workflow_task_name="Fuel EOD Post" ' +
					'client_id=" ' + CONVERT(NVARCHAR(15), @ClientId) + '" ' +
					'business_date="' + CONVERT(VARCHAR(15), @DayToClose, 1) + '" ' +
					'formmoniker="PE.platformForms.Workflow.TaskList" modename="View" ' +
					'logged_in_hier_id="' +  CONVERT(NVARCHAR(15), @BusinessUnitId) + '" logged_in_hier_level="2" __current_language_id="1" ' +
					'pdfserverplatform="java" _bodogwavesetpagenum="0" _bodogwavesetpagesize="-1" ' +
					'/>' +
					'<WaveJob sequential="y">' + 
						'<QueueTask moniker="Applications.Inventory.ape.tasks.SCM_IM_POST_AND_AGG"/>' +
						'<QueueTask moniker="applications.MerchandiseManagement.ape.jobs.MMEODPost">    </QueueTask>' +
						'<QueueTask moniker="Platform.EODWaveTask">    </QueueTask>' +
						'<InputParameters>' +
						'<Parameter name="current_hier_id" required="y" description="Business Unit ID"/>' +
						'<Parameter name="business_date" required="y" description="Business Date"/>' +
						'<Parameter name="retail_date" required="n" description="When retails were last posted for BU"/>' +
						'<Parameter name="eod" required="n" description="are we in eod workflow?" enumValues="y n"/>' +
						'</InputParameters>' +
					'</WaveJob>' +
					'</ExecutionDocument>' 
					
	SELECT @XMLDoc
	
    EXEC	ape_insert_execution_object @moniker = @JobMoniker, 
           @exec_type = N'a', @exec_status = N'q', @job_exec_guid = NULL, @task_sequence = NULL, 
           @exec_doc = @XMLDoc, 
           @org_hierarchy_id = NULL, @client_id = @ClientId, @named_lock = NULL, 
           @dev_mode_segment = NULL, @parent_child_incr = NULL
	
	SET @CurrentBusinessUnit += 1
	
END

/*
-- Mark day as closed
UPDATE  ds
SET 	status_code = 'p'
FROM	VP60_eso.dbo.day_status AS ds
JOIN 	@BusinessUnitList AS b
ON	 	org_hierarchy_id 	= b.BusinessUnitId
AND 	business_date 		= @DayToClose

-- Insert row for next day
INSERT INTO VP60_eso.dbo.Day_Status
	(org_hierarchy_id
	,status_code
	,business_date
	,last_modified_user_id
	,client_id
	,last_modified_timestamp
	,GL_has_been_aggd_flag
	,bu_date_posted_timestamp
	,publication_status_code
	,inventory_locked_flag
	,fuel_locked_flag)
SELECT
	b.BusinessUnitId
	,'i'
	,@DayToClose+1
	,42
	,@ClientId
	,getdate()
	,'n'
	,NULL
	,NULL
	,'n'
	,'n'
FROM @BusinessUnitList AS b
WHERE NOT EXISTS (SELECT 1
				 FROM	VP60_eso.dbo.day_status AS ds
				 WHERE 	ds.org_hierarchy_id 	= b.BusinessUnitId
				 AND 	business_date 		= @DayToClose + 1)

-- Update the org hierarchy date
UPDATE	oh 
SET	 	oh.current_business_date = @DayToClose + 1
FROM	Org_Hierarchy AS oh
JOIN 	@BusinessUnitList AS b
ON		org_hierarchy_id 	= b.BusinessUnitId

SELECT  *
FROM	VP60_eso.dbo.day_status AS ds
JOIN 	@BusinessUnitList AS b
ON	 	org_hierarchy_id 	= b.BusinessUnitId
*/

/*
update inventory_client_parameters 
set inv_restrict_items_without_costs_flag = 'n'
*/

COMMIT TRANSACTION














