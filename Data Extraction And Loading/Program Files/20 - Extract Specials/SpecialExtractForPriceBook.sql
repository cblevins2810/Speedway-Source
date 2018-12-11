SET NOCOUNT ON

SELECT rac.name AS 'Name',
rac.receipt_text AS 'Receipt Text',
rac.priority_ranking 'Priority Ranking',
rac.loyalty_flag AS requiresLoyalty,
CONVERT(nvarchar(10), rac.start_date,120) AS startDate,
CASE WHEN rac.end_date IS NULL THEN ''  
     WHEN rac.end_date > '2075-01-01' THEN ''
	 ELSE ISNULL(CONVERT(nvarchar(10), rac.end_date,120),'') END AS endDate,
rac.active_flag AS status
FROM retail_auto_combo AS rac
ORDER by rac.name
