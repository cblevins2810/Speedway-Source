SET NOCOUNT ON

IF OBJECT_ID('tempdb..#business_unit_group_extract') IS NOT NULL
    DROP TABLE #business_unit_group_extract

CREATE TABLE #business_unit_group_extract
(batch_total int not null,
 batch_count int not null)

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley

CREATE TABLE #talley (batch_number int)
INSERT #talley SELECT 1
INSERT #talley SELECT 2    
INSERT #talley SELECT 3
INSERT #talley SELECT 4
INSERT #talley SELECT 5
INSERT #talley SELECT 6
INSERT #talley SELECT 7
INSERT #talley SELECT 8
INSERT #talley SELECT 9
INSERT #talley SELECT 10
INSERT #talley SELECT 11
INSERT #talley SELECT 12
INSERT #talley SELECT 13
INSERT #talley SELECT 14
INSERT #talley SELECT 15
INSERT #talley SELECT 16
INSERT #talley SELECT 17
INSERT #talley SELECT 18
INSERT #talley SELECT 19
INSERT #talley SELECT 20
INSERT #talley SELECT 21
INSERT #talley SELECT 22
INSERT #talley SELECT 23
INSERT #talley SELECT 24
INSERT #talley SELECT 25
INSERT #talley SELECT 26
INSERT #talley SELECT 27
INSERT #talley SELECT 28
INSERT #talley SELECT 29
INSERT #talley SELECT 30
INSERT #talley SELECT 31
INSERT #talley SELECT 32
INSERT #talley SELECT 33
INSERT #talley SELECT 34
INSERT #talley SELECT 35
INSERT #talley SELECT 36
INSERT #talley SELECT 37
INSERT #talley SELECT 38
INSERT #talley SELECT 39
INSERT #talley SELECT 40
INSERT #talley SELECT 41
INSERT #talley SELECT 42
INSERT #talley SELECT 43
INSERT #talley SELECT 44
INSERT #talley SELECT 45
INSERT #talley SELECT 46
INSERT #talley SELECT 47
INSERT #talley SELECT 48
INSERT #talley SELECT 49
INSERT #talley SELECT 50

INSERT #business_unit_group_extract
SELECT COUNT(*),
CEILING(COUNT(*)/50)+1 
FROM business_unit_group AS bug
JOIN rad_sys_data_accessor AS rsda
ON  rsda.data_accessor_id = bug.business_unit_group_id
AND rsda.name like 'zsBUG%'

SELECT b.batch_count,
t.batch_number-1,
CASE WHEN t.batch_number < 10 THEN '0' + CONVERT(NVARCHAR(1), t.batch_number) ELSE CONVERT(NVARCHAR(2), t.batch_number) END
FROM #business_unit_group_extract as b
JOIN #talley as t
ON   t.batch_number <= b.batch_count
ORDER BY b.batch_total DESC, t.batch_number


IF OBJECT_ID('tempdb..#business_unit_group_extract') IS NOT NULL
    DROP TABLE #business_unit_group_extract

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley
