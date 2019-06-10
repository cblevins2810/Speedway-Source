BEGIN TRANSACTION

DECLARE @ClientId INT
DECLARE @NumberOfBusinessUnits INT
DECLARE @CurrentBusinessUnit INT
DECLARE @BusinessUnitId INT
DECLARe @BusinessDate DATETIME

SET @ClientId = 10000001
--SET @BusinessDate = '2019-05-01'

SELECT @BusinessDate = MAX(day_to_close) + 1 FROM bc_extract_replenishment

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

-- Mark draft documents created via the invoice import with the appropriate business_date
UPDATE	rd
SET		business_date = @BusinessDate,
		received_date = @BusinessDate
FROM	received_document AS rd
JOIN 	@BusinessUnitList AS b
ON	 	rd.business_unit_id 	= b.BusinessUnitId
WHERE   status_code = 'd'

SELECT @CurrentBusinessUnit = 1
SELECT @NumberOfBusinessUnits = COUNT(*) FROM @BusinessUnitList

WHILE @CurrentBusinessUnit <= @NumberOfBusinessUnits
BEGIN

	SELECT 	@BusinessUnitId 	= BusinessUnitId
	FROM    @BusinessUnitList
	WHERE	@CurrentBusinessUnit = SequenceNumber  

	INSERT INTO Inventory_Transaction_Queue (
	business_unit_id,
    business_date,
    transaction_type_code, 
	received_id,
    action_code,
    client_id,
    queued_timestamp)
	SELECT
    @BusinessUnitId,
    @BusinessDate,
    'r',  
	received_id,
	'p',
	@ClientId,
    GETDATE()
	FROM received_document AS rd
	WHERE rd.business_unit_id = @BusinessUnitId
	AND   rd.business_date = @BusinessDate
	AND   rd.status_code = 'd'

	-- place the receive document into the processing state
	UPDATE  received_document
	SET     status_code = 'k' 
    WHERE   business_unit_id 	= @BusinessUnitId
	AND     business_date 		= @BusinessDate   

	SET		@CurrentBusinessUnit += 1
	
END

COMMIT TRANSACTION


SELECT *
FROM Received_Document AS rd
JOIN @BusinessUnitList AS l
ON   rd.business_unit_id = l.BusinessUnitId
AND  rd.business_date = @BusinessDate

--select * from Received_Document order by received_id desc

/*
UPDATE rd
SET status_code = 'p'
FROM Received_Document AS rd
WHERE rd.business_unit_id = 10001073
AND status_code <> 'p'

SELECT *
FROM Received_Document AS rd
where business_unit_id = 10001715

ORDER by last_modified_timestamp DESC

SELECT * FROM Inventory_Transaction_Queue
WHERE business_unit_id = 10001073
AND   received_id IS NOT NULL
*/

/*
UPDATE rd
set status_code = 'p'
FROM Received_Document AS rd
WHERE rd.business_unit_id = 10001073
AND status_code <> 'p'
*/


