SET NOCOUNT ON

IF OBJECT_ID('tempdb..#business_unit') IS NOT NULL
    DROP TABLE #business_unit

CREATE TABLE #business_unit
( RowNumber INT NOT NULL,
business_unit_id INT NOT NULL)

DECLARE @Modulus INT
SET @Modulus = 600

INSERT #business_unit
SELECT ROW_NUMBER() OVER (ORDER BY business_unit_id) + 600 AS RowNumber, --over (partition by business_unit_id order by business_unit_id) AS RowNumber,
business_unit_id AS business_unit_id
FROM business_unit
WHERE status_code <> 'c'

SELECT 600,RowNumber % 600
FROM #business_unit
GROUP BY RowNumber % 600
ORDER BY 2

IF OBJECT_ID('tempdb..#business_unit') IS NOT NULL
    DROP TABLE #business_unit
GO

/*SELECT TOP 1 rsda.name AS BUIdentifier, rsda.data_accessor_id AS BusinessUnitId
FROM Business_Unit AS bu
JOIN Rad_Sys_Data_Accessor AS rsda
ON   bu.business_unit_id = rsda.data_accessor_id
AND bu.status_code != 'c'
ORDER BY rsda.name*/
