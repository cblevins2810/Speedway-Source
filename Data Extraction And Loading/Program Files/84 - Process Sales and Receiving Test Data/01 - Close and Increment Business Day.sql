BEGIN TRANSACTION

DECLARE @ClientId INT
DECLARe @DayToClose DATETIME

SET @ClientId = 10000001

--UPDATE bc_extract_replenishment
--set Day_To_Close = '2019-04-22'

--select * from Day_Status where org_hierarchy_id = 10001577

UPDATE bc_extract_replenishment
SET day_to_close = day_to_close + 1

--UPDATE Day_Status
--set status_code = 'p'
--WHERE org_hierarchy_id = 10001577
--AND business_date = '2019-04-22'

--select * from day_status where org_hierarchy_id = 10001577
--select * from bc_extract_replenishment

SELECT @DayToClose = MAX(day_to_close) FROM bc_extract_replenishment


--SET @DaytoClose = '2019-05-07'

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

/*
  Close the business date and open a new one
*/
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

COMMIT TRANSACTION

SELECT *
FROM Day_Status AS ds
JOIN @BusinessUnitList AS bu
ON ds.org_hierarchy_id = bu.BusinessUnitId











