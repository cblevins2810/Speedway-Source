SET NOCOUNT ON

DECLARE @XMLDoc VARCHAR(4000)
DECLARE @ClientId INT
DECLARE @NumberOfFiles INT
DECLARE @CurrentFile INT
DECLARE @FileName VARCHAR(255)
DECLARE @BusinessUnitId INT
DECLARE @LockName VARCHAR(50)
DECLARE @JobMoniker VARCHAR(255)

SET @ClientId = 10000001

DECLARE @TableList TABLE (
SequenceNumber INT IDENTITY(1,1),
BusinessUnitId INT,
FileName NVARCHAR(255) NOT NULL)

INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  2DE7E74-0FBA-D427-6911-E5E00CA0763F.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  4B30CF3-D91C-7415-5AE7-7A6AC1ED3FA9.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  50B8FB4-7534-34BF-8B96-D00B57569B6B.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  859C75B-DD26-04BF-78DA-9EF105F96D7D.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  9CC383E-CF38-8424-781B-9CB00AE5CA35.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import  F801CBF-3497-4497-4A44-D9238DA48E00.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 19174EFB-6DE3-4D45-86AD-D2C48E2980A0.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 21E6D7AA-EC6B-469F-BEAA-7733B137A461.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 27F63FAB-2768-4314-B87E-B3B84C0398EC.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 2E3566C0-58ED-495D-B63E-46E9CA17E13B.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 36FFC3C5-BC9A-4970-9238-F508146CBF83.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 409CC0A4-0C6D-46F2-8E13-7775CE4D2970.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 538AF0B0-F60D-49F3-BFE6-003408FED7E2.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 82FD956C-5ABB-45C3-857D-FA7DE3DD1B94.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 8CE87568-5FDE-41BC-B516-80FF61272515.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import 904E4BC0-A2F4-4FA4-A68F-796630005E08.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import BBD7DC07-039A-42AB-882E-D61CD1CA006C.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import CA698DAC-AE8D-4B68-A92F-3880A407AD06.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import D1630418-B187-4E1F-8D3D-19FDD8BAA5D1.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import D8BFE5AA-199F-4164-A4E4-68BAD5B314B8.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_Import E332D7EA-7D13-4CD3-A31D-3754120006C4.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_EODFinal 0F0A44FC-D45A-414E-BF74-D6E100A81632.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_EODFinal 704FE591-8DC1-4C35-A5B7-F0BAA72CC124.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_Summary_EODFinal 94656B96-BB3C-4DAF-A683-77EFC991B4FC.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001164,'\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_BUStatus_Import E5F00F3F-4092-40FD-B26C-C60365E6DE3C.xml'


SELECT @CurrentFile = 1
SELECT @NumberOfFiles = COUNT(*) FROM @TableList

WHILE @CurrentFile <= @NumberOfFiles
BEGIN

	SELECT 	@BusinessUnitId = BusinessUnitId,
	@FileName = FileName
	FROM	@TableList
	WHERE	@CurrentFile = SequenceNumber  

	SET @LockName = 'Sum' + CONVERT(VARCHAR(10), @BusinessUnitId)
	
	IF CHARINDEX('DM_RadXML_Summary_Import', @FileName) > 0 
		SET @JobMoniker = 'applications.framework.ape.jobs.DM_RadXML_Summary_Import'

	IF CHARINDEX('DM_RadXML_BUStatus_Import', @FileName) > 0 
		SET @JobMoniker = 'applications.framework.ape.jobs.DM_RadXML_BUStatus_Import'

	IF CHARINDEX('DM_RadXML_Summary_EODFinal', @FileName) > 0 
		SET @JobMoniker = 'applications.framework.ape.jobs.DM_RadXML_Summary_EODFinal'

	SET @XMLDoc = 	'<ExecutionDocument>' + 
					'<ParameterValue name="working_file_name" >' + 
						+ @FileName +
					'</ParameterValue>'  +
					'<Context current_client_id="' + CONVERT(NVARCHAR(15), @ClientId) + '"' +
						' current_hier_id="' + CONVERT(NVARCHAR(15), @BusinessUnitId) + '" current_user_id="0" _bodogwavesetpagenum="0"' +
						' _bodogwavesetpagesize="-1" import_exec_id="1000101" />' +
					'</ExecutionDocument>'
	
	SELECT @XMLDoc
	
    EXEC	ape_insert_execution_object @moniker = @JobMoniker, 
            @exec_type = N'a', @exec_status = N'q', @job_exec_guid = NULL, @task_sequence = NULL, 
            @exec_doc = @XMLDoc, 
            @org_hierarchy_id = NULL, @client_id = @ClientId, @named_lock = @LockName, 
            @dev_mode_segment = NULL, @parent_child_incr = NULL

	SET @CurrentFile += 1

END

/*

/*
UPDATE  ds
SET 	publication_status_code='r'
FROM	VP60_eso.dbo.day_status AS ds
JOIN 	@BuList AS b
ON	 	org_hierarchy_id 	= b.BusinessUnitId
AND 	business_date 		= @DayToClose
*/


<ExecutionDocument>
	<ParameterValue name="working_file_name">
	\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_BUStatus_Import E5F00F3F-4092-40FD-B26C-C60365E6DE3C.xml</ParameterValue>
	
	<Context template_client_id="0" current_client_id="1000001" current_hier_id="10001164" current_user_id="0" _bodogwavesetpagenum="0" _bodogwavesetpagesize="-1" 
	import_exec_id="1000101" __current_job_execution_guid="{F4196A68-1969-E911-A2E7-005056978E61}" __current_job_moniker="applications.framework.ape.jobs.DM_RadXML_BUStatus_Import"/>
	<WaveJob sequential="y" lockName="Sum@[current_hier_id]">
		<InputParameters>
			<Parameter name="working_file_name" required="y" description="file name of the file to import"/>
		</InputParameters>
		<QueueTask moniker="applications.framework.ape.tasks.DM_RadXML_BUStatus_Import"/>
		<QueueTask moniker="applications.framework.ape.jobs.DM_Execute_Publications"/>
		<QueueTask moniker="applications.framework.ape.jobs.DM_Validate_Day"/>
	</WaveJob>
</ExecutionDocument>

\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001164\04-20-2019\DM_RadXML_BUStatus_Import E5F00F3F-4092-40FD-B26C-C60365E6DE3C.xml</ParameterValue>
\\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10000581\04-26-2019\DM_RadXML_Summary_Import C4158080-85B9-449E-A306-AF004889D5D3.xml 



<ExecutionDocument >
  <ParameterValue name="working_file_name" >
    \\emcwd1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10000581\04-26-2019\DM_RadXML_Summary_Import 
    C4158080-85B9-449E-A306-AF004889D5D3.xml 
  </ParameterValue>
  <Context current_client_id="10000001" current_hier_id="10000581" current_user_id="0" _bodogwavesetpagenum="0" 
           _bodogwavesetpagesize="-1" import_exec_id="1000101" />
</ExecutionDocument>

<ExecutionDocument >
  <ParameterValue name="working_file_name" >
    \\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10000581\04-26-2019\DM_RadXML_Summary_EODFinal 
    8D87995-DB02-64B1-E94C-00515998E4A9.xml 
  </ParameterValue>
  <Context current_client_id="10000001" current_hier_id="10000581" current_user_id="0" _bodogwavesetpagenum="0" 
           _bodogwavesetpagesize="-1" import_exec_id="1000103" />
</ExecutionDocument>

<ExecutionDocument >
  <ParameterValue name="working_file_name" >
    \\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10000581\04-19-2019\DM_RadXML_BUStatus_Import 
    4B978854-D9B2-43E7-986D-3BC888E7C340.xml 
  </ParameterValue>
  <Context current_client_id="10000001" current_hier_id="10000581" current_user_id="0" _bodogwavesetpagenum="0" 
           _bodogwavesetpagesize="-1" import_exec_id="1000105" />
</ExecutionDocument>

*/