DECLARE @original_bu_id INT
DECLARE @new_bu_id INT
DECLARE @bu_day DATETIME
DECLARE @worksheet_id INT
DECLARE @count_timestamp NVARCHAR(20)

-- Set the bu code for the original bu
SELECT @original_bu_id = data_accessor_id
FROM Rad_Sys_Data_Accessor where name = '0001001'

-- Set the id value for the new bu (it may not be in the same database)
SELECT @new_bu_id = 999

-- Set the id of the audit worksheet in the destination db
SET @worksheet_id = 999

-- Set the timestamp of the count - this should match an open bu day for the destination bu
SET @count_timestamp = '2019-04-24 00:00:01'

IF @original_bu_id IS NULL
	PRINT 'Invalid Original BU Code'

IF @new_bu_id = -999
	PRINT 'Invalid New BU Id'

IF @worksheet_id = -999
	PRINT 'Enter a valid worksheet id in the destination system'

IF @new_bu_id IS NOT NULL AND @original_bu_id IS NOT NULL AND @worksheet_id IS NOT NULL

BEGIN

	SELECT @bu_day = DATEADD(day,-1, current_business_date)
	FROM org_hierarchy 
	WHERE org_hierarchy_id = @original_bu_id

	DECLARE @local_bu_time DATETIME
	DECLARE @sales_updates_exist NCHAR(1)
	DECLARE @tot_sales TABLE    (    inventory_item_id INT PRIMARY KEY,    sales_qty NUMERIC(19,6)   )
	DECLARE @sales TABLE  (  inventory_item_id  INT,  business_date   DATETIME,  sales_qty   NUMERIC(28,10)  )

	SELECT @sales_updates_exist  = 'n'

	IF (OBJECT_ID('tempdb..#on_hand_export_tmp') IS NOT NULL)
		DROP TABLE #on_hand_export_tmp

	IF (OBJECT_ID('tempdb..#on_hand_export_type') IS NOT NULL)
		DROP TABLE #on_hand_export_type

	CREATE TABLE #on_hand_export_tmp (
	inventory_item_id INT NOT NULL PRIMARY KEY, 		bu_id int not NULL,
	last_recv_date DATETIME NULL,
	last_sold_date DATETIME NULL,
	average_daily_sales_usage NUMERIC(19,6) NULL,
	last_modified_timestamp DATETIME,
	last_activity_start_date DATETIME /*** Added ***/  )

	SELECT @local_bu_time = v.current_bu_local_time
	FROM bcssa_cert2..PLT_Get_BU_Local_Time_View v
	WHERE v.business_unit_id = @original_bu_id

	INSERT INTO #on_hand_export_tmp
	SELECT si.item_id,
	@original_bu_id,
	NULL, 
	NULL, 
	NULL,
	MAX(si.last_modified_timestamp),
	@bu_day /*** Added @bu_day for new column ***/ 
	FROM bcssa_cert2_wh..sales_item si
	WHERE exists  ( SELECT 1 FROM bcssa_cert2_wh..f_gen_inv_item_activity_bu_day iabd 
					WHERE iabd.inventory_item_id=si.item_id
					AND iabd.bu_id=@original_bu_id
					AND @bu_day between iabd.start_business_date
					AND COALESCE(iabd.start_business_date, GetDate()+1)  ) 
	GROUP BY si.item_id

	SELECT DISTINCT item_id, item_type_code
	INTO #on_hand_export_type
	FROM bcssa_cert2_wh..sales_item si 
	WHERE EXISTS ( 	SELECT 1 FROM #on_hand_export_tmp tmp
					WHERE tmp.inventory_item_id=si.item_id
					AND tmp.last_modified_timestamp=si.last_modified_timestamp   )

	INSERT INTO #on_hand_export_tmp
	SELECT si.item_id,
	@original_bu_id,
	NULL,
	NULL,
	NULL,
	MAX(si.last_modified_timestamp),
	MAX(iabd.start_business_date)
	FROM bcssa_cert2_wh..sales_item si
	JOIN bcssa_cert2_wh..f_gen_inv_item_activity_bu_day iabd
	ON iabd.bu_id = @original_bu_id
	AND iabd.inventory_item_id = si.item_id
	WHERE iabd.start_business_date < @bu_day
	AND si.item_id not in (SELECT inventory_item_id FROM #on_hand_export_tmp)
	GROUP BY si.item_id

	-- Retrieve last receive date
	UPDATE dates  SET last_recv_date = t.last_recv_date 
	FROM #on_hand_export_tmp dates
	JOIN (	SELECT ohl.inventory_item_id AS inventory_item_id,   MAX(ohl.begin_date) AS last_recv_date
			FROM bcssa_cert2..inventory_item_bu_on_hand_list ohl
			WHERE ohl.business_unit_id = @original_bu_id 
			AND ohl.on_hand_source_code = 'r'
			AND ohl.begin_date <= @local_bu_time
			GROUP BY ohl.inventory_item_id   ) t
	ON t.inventory_item_id = dates.inventory_item_id

	-- Retrieve last sales date 
	UPDATE dates
	SET last_sold_date = t.last_sold_date
	FROM #on_hand_export_tmp dates
	JOIN (	SELECT ohl.inventory_item_id AS inventory_item_id,
			MAX(ohl.begin_date) AS last_sold_date
			FROM bcssa_cert2..inventory_item_bu_on_hand_list ohl
			WHERE ohl.business_unit_id = @original_bu_id
			AND ohl.business_date = @bu_day
			AND ohl.on_hand_source_code = 's'
			AND ohl.begin_date <= @local_bu_time
			GROUP BY ohl.inventory_item_id   ) t
	ON dates.inventory_item_id = t.inventory_item_id

	INSERT @sales  (    inventory_item_id,    business_date,    sales_qty  ) 
	SELECT inventory_item_id,    start_business_date,    sales_qty 
	FROM (	SELECT TOP 7 CAST(business_date AS DATETIME) AS business_date
			FROM bcssa_cert2..day_status
			WHERE org_hierarchy_id = @original_bu_id
			AND status_code IN ('p', 'i', 'g')
			AND business_date <= @bu_day
			ORDER BY business_date DESC  ) AS d
	JOIN bcssa_cert2_wh..f_gen_inv_item_activity_bu_day act
	ON act.bu_id = @original_bu_id
	AND act.start_business_date = d.business_date
	INSERT  @tot_sales
	SELECT  inventory_item_id,
	COALESCE( SUM(s.sales_qty), 0) / 7
	FROM  @sales     s
	GROUP BY inventory_item_id 

	IF (@@ROWCOUNT > 0) 
		SELECT @sales_updates_exist = 'y'

	-- Retrieve avg_sales_per_day
	IF (@sales_updates_exist = 'y')
	BEGIN
		UPDATE dates
		SET   average_daily_sales_usage  = s.sales_qty
		FROM  #on_hand_export_tmp dates
		JOIN  @tot_sales      s
		ON  s.inventory_item_id    = dates.inventory_item_id
		WHERE  dates.bu_id        = @original_bu_id
		AND ( (dates.average_daily_sales_usage IS NULL AND s.sales_qty IS NOT NULL)
		OR (s.sales_qty    IS NULL AND dates.average_daily_sales_usage IS NOT NULL)
		OR dates.average_daily_sales_usage <> s.sales_qty    )
	END

	SELECT    @new_bu_id AS bu_id, 
	@worksheet_id worksheet_id,
    si.item_id,
    CONVERT(INT, CASE WHEN iabd.end_onhand_qty < 0 THEN 0.00 ELSE iabd.end_onhand_qty END) AS units_on_hand,
    @count_timestamp
    FROM bcssa_cert2_wh..f_gen_inv_item_activity_bu_day iabd WITH (NOLOCK)
    JOIN bcssa_cert2_wh..loc_bu bu WITH (NOLOCK)
	ON bu.bu_id = iabd.bu_id
    JOIN #on_hand_export_tmp iad /* change to inner JOIN */
	ON iabd.bu_id=iad.bu_id
	AND iabd.inventory_item_id=iad.inventory_item_id  /*** Added ***/
	AND iabd.start_business_date = iad.last_activity_start_date
    LEFT OUTER JOIN item si WITH (NOLOCK)
	ON si.item_id = iabd.inventory_item_id
    LEFT JOIN unit_of_measure uom 
	ON iabd.atomic_uom_id=uom.unit_of_measure_id
	JOIN bcssa_cert2_wh..item_hierarchy_list ihl
	ON si.item_hierarchy_id= ihl.item_hierarchy_id
	AND ihl.parent_item_hierarchy_level=2
    LEFT JOIN   ( SELECT MAX(timestamp) AS last_audit_date, valuation_cat_id 
	              FROM bcssa_cert2_wh..f_gen_inv_count_cat iccat
				  WHERE bu_id=@original_bu_id
				  AND business_date=@bu_day
				  GROUP BY valuation_cat_id  ) audit
    ON audit.valuation_cat_id=ihl.parent_item_hierarchy_id
    LEFT JOIN   ( SELECT MAX(timestamp) AS last_count_date, inventory_item_id
                  FROM bcssa_cert2_wh..f_gen_inv_count fgic
				  WHERE bu_id=@original_bu_id AND business_date=@bu_day 
				  GROUP BY inventory_item_id  ) cnt_date 
				  ON cnt_date.inventory_item_id=iabd.inventory_item_id 
				  LEFT JOIN #on_hand_export_type itype
				  ON itype.item_id=si.item_id
				  WHERE iabd.bu_id=@original_bu_id 
				  AND EXISTS ( SELECT 1 FROM bcssa_cert2..inventory_item ii   WITH (NOLOCK) 
				  WHERE ii.inventory_item_id = iabd.inventory_item_id 
				  AND ii.active_flag = 'y' )
				  AND EXISTS ( SELECT 1 FROM bcssa_cert2..Item_DA_Effective_Date_List iddl  WITH (NOLOCK) 
				  JOIN bcssa_cert2..da_list_dro dro   WITH (NOLOCK) 
				  ON iddl.data_accessor_id = dro.assigned_data_accessor_id
				  AND dro.current_org_hierarchy_id = @original_bu_id
				  WHERE GETDATE() BETWEEN iddl.start_date AND iddl.end_date
				  AND iddl.item_id = iabd.inventory_item_id )
				  ORDER BY si.item_id 

	IF (OBJECT_ID('tempdb..#on_hand_export_tmp') IS NOT NULL)
		DROP TABLE #on_hand_export_tmp

	IF (OBJECT_ID('tempdb..#on_hand_export_type') IS NOT NULL)
		DROP TABLE #on_hand_export_type 

END
ELSE
	SELECT 'Invalid Setting, Check SQL Messages'