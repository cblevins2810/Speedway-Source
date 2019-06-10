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
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import EF7E16BF-7EEE-4279-A100-68CB7F6C3DBF.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import E8D1A5B9-5207-4CDB-9BC1-0041A85C5B77.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import D2E1FB48-6055-4E50-97EC-EEC423F437BD.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import CC3EB812-E548-4C3E-8112-DA26B1C50476.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import C9B0DEB0-29A2-4D40-8F95-3DE0C73E696E.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import C6F92D11-C736-467A-81D4-5187DA63F100.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import C4EFCBBB-AFE1-4A2E-A02F-58344F2DE706.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import B47B77FE-8254-4AE9-8F16-738B2EF3E0EA.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import B2A6996E-BB7F-48DF-AC93-64DD66473D56.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import B154D295-5CF7-49F3-007E-C1ED292B08D5.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import ABE6AA54-6779-4FB8-A446-DC5B93771271.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import A1E8E38E-811D-4895-855E-F8EB47A6BBCF.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 9C4EB6F3-C4E3-4C3C-91A1-6EF7FB69ED94.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 91A129F5-05F1-43E3-A1B8-CD20A8892206.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 7C2F2EF3-F4A4-4C34-AE58-CE9F66FFFB11.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 7022419C-69E0-4E22-9BB2-F821318285EB.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 5D782FB2-410B-40D1-8223-BB22DE503FE1.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 580272EE-423A-40DD-9800-CF82C461C99E.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 48C7427B-172E-4FBD-BAED-715EE8142958.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 4083610B-9151-42AB-B8E2-93D0BAB57E37.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 27B71471-2693-4559-80AE-3F2944CEC063.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 1BF1EA4A-A056-4ADF-AA88-AB7599BD08CA.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 12279324-B787-42FC-8098-C3E5FF1734F7.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import 0F97BB0C-2106-44EA-839C-F46052C5C7AC.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import  ACE01FE-78C2-C4A8-5B39-C04004FDF8D4.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import  882C03A-C806-541B-48B0-7AEDD7B52511.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import  6F484CF-1251-C41C-28B4-BE3BD8DF8FCD.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_Import  6D7A928-A162-2495-7BAA-F4EBBB70F62F.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_EODFinal EA7614BF-3122-43A4-8025-33E439677657.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_EODFinal E746C96F-D090-47E0-A389-3BB9F65C04DC.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_EODFinal E1B90CAD-E6DF-48B6-A943-60DCAF0764DA.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_EODFinal 3D276934-BAB5-448B-A04E-7968F5A802BB.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_Summary_EODFinal 1AF16837-4094-445E-B873-B6B05E8956E8.xml'
INSERT @TableList (BusinessUnitId, FileName) SELECT 10001577,'\\emcwt1452.mgroupnet.com\ESOShare\AsynchQueueStore\spwyeso\10000001\10001577\04-28-2019\DM_RadXML_BUStatus_Import CED11145-34E1-417E-B55B-B45D8024E553.xml'


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

