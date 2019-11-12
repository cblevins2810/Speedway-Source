/* This stored procedure accepts a business unit code and a list of items.
   It returns a list of items with the following columns:
   
        ItemID - The internal item id value 
        UnitOfMeasure - The atomic unit of measure 
        BeginningOnHandAmount - The Qty on Hand as of the last closed business day
		BeginningWac - The WAC as of the last closed business day
        CurrentOnHandAmount - The Qty on Hand at the current date & time
        CurrentWac - The WAC at the current date & time
		
        This procedure calls these additional procedures.  Each of the called procedures
        returns a result set that is inserted into a table variable within the main procedure.
		
		uspGetItemWACAndQtyByBUAdj                                        
		uspGetItemWACAndQtyByBUCount                                      
		uspGetItemWACAndQtyByBUInvcRecon                                  
		uspGetItemWACAndQtyByBURebate                                     
		uspGetItemWACAndQtyByBURecv                                       
		uspGetItemWACAndQtyByBURecvShipper                                
		uspGetItemWACAndQtyByBUReturn                                     
		uspGetItemWACAndQtyByBUWACAdj                                     
		uspGetItemWACAndQtyByBUXfer 

		This procedure requires the a sql type be defined.  The SQL to create the type is:
		utypeDiscountinueItem.sql
		
		Note:  This procedure and the procedures it calls is based upon 
		a SQL trace of the ESO WAC Calculation Report.  It populates accepts
		result table that contains more values that are returned by the 
		Procedure, however these have been commented out.  The code to
		populate the commented out values has been left in place for the
	    purpose of debugging relatively to the WAC Calculation report as
		well as to allow the procedure to be used for other values if
		needed in the future.
*/   
USE VP60_Spwy
GO

IF OBJECT_ID('uspGetItemWACAndQtyByBU') IS NOT NULL
    DROP PROCEDURE uspGetItemWACAndQtyByBU
GO

CREATE PROCEDURE uspGetItemWACAndQtyByBU
@BusinessUnitCode NVARCHAR(50),
@XMLInput NVARCHAR(MAX)
AS

SET NOCOUNT ON

BEGIN

DECLARE @business_date SMALLDATETIME
DECLARE @Business_Unit_Id INT
DECLARE @Client_Id INT
DECLARE @iDoc INT
DECLARE @discontinued_item discontinued_item 
DECLARE @data_source_code NCHAR(1)
DECLARE @item_hierarchy_level_id    INT
DECLARE @default_valuation_method_code      NCHAR(1)

DECLARE @new_f_gen_inv_item_activity_bu_day TABLE
(
        bu_id                               INT NOT NULL,
        start_business_date                 SMALLDATETIME NOT NULL,
        inventory_item_id                   INT NOT NULL,
        valuation_cat_id                    INT NOT NULL,
        atomic_uom_id                       INT NOT NULL,
        recv_qty                            NUMERIC(28,10) NULL,
        negative_recv_qty                   NUMERIC(28,10) NULL,
        return_qty                          NUMERIC(28,10) NULL,
        adjust_qty                          NUMERIC(28,10) NULL,
        negative_adjust_qty                 NUMERIC(28,10) NULL, 
        xfer_qty                            NUMERIC(28,10) NULL,
        waste_qty                           NUMERIC(28,10) NULL,
        sales_qty                           NUMERIC(28,10) NULL,
        begin_onhand_qty                    NUMERIC(28,10) NULL,
        end_onhand_qty                      NUMERIC(28,10) NULL,
        count_variance_qty                  NUMERIC(28,10) NULL,
        production_qty                      NUMERIC(28,10) NULL,
        sales_original_qty                  NUMERIC(28,10) NULL,
        xfer_out_qty                        NUMERIC(28,10) NULL,
        onorder_qty                         NUMERIC(28,10) NULL,
        exclude_on_hand_tracking_flag       NCHAR(1) NULL,
        last_activity_cost                  NUMERIC(28,10) NULL,
        last_received_cost_amt              NUMERIC(28,10) NULL,
        min_supplier_cost                   NUMERIC(28,10) NULL,
        max_supplier_cost                   NUMERIC(28,10) NULL,
        avg_supplier_cost                   NUMERIC(28,10) NULL,
        standard_cost                       NUMERIC(28,10) NULL,
        retail_valuation_amt                NUMERIC(28,10) NULL,
        vat_amt                             NUMERIC(28,10) NULL,
        opening_weighted_average_cost       NUMERIC(28,10) NULL,
        closing_weighted_average_cost       NUMERIC(28,10) NULL,
        last_modified_timestamp             DATETIME,  
        begin_wac_backout_qty               NUMERIC(28,10),
        purchase_rebate_cost_amt            NUMERIC(28,10),
        end_wac_qty                         NUMERIC(28,10),
        end_wac_amt                         NUMERIC(28,10),
        previous_last_activity_cost         NUMERIC(28,10),
        previous_last_received_cost_amt     NUMERIC(28,10),
        production_usage_qty                NUMERIC(19,6),
        non_withheld_rebate_amt             NUMERIC(28,10),
        withheld_rebate_amt                 NUMERIC(28,10),
        net_sales_amt                       NUMERIC(28,10),
        gross_margin_report_with_rebates_adjust_qty NUMERIC(28,10) NULL,
        gross_margin_report_with_rebates_adjust_amt NUMERIC(28,10) NULL,
        wac_adjustment                      NUMERIC(28,10),

        PRIMARY KEY (inventory_item_id, bu_id)
)

DECLARE @tmp_bu_day_count TABLE
(
        bu_id                               INT,
        business_date                       SMALLDATETIME,
        inventory_item_id                   INT,
        bu_date_last_count_timestamp        DATETIME,
        atomic_count_qty                    NUMERIC(19,6),
        frequency_code                      NCHAR(1),
        PRIMARY KEY (bu_id, business_date, inventory_item_id)
)

-- Transactional tables
DECLARE @f_gen_inv_count TABLE
(
        item_count_id                       INT,
        inventory_item_id                   INT,
        timestamp                           DATETIME,
        atomic_count_qty                    NUMERIC(28,10),
        frequency_code                      NCHAR(1),

        PRIMARY KEY (inventory_item_id, item_count_id)
)

DECLARE @f_gen_inv_receive TABLE
(
        received_id                         INT,
        supplier_item_id                    INT,
        inventory_item_id                   INT,
        recv_date                           DATETIME,
        atomic_qty                          NUMERIC(28,10),
        atomic_free_quantity                NUMERIC(28,10),
        atomic_cost                         NUMERIC(28,10),

        PRIMARY KEY (inventory_item_id, received_id, supplier_item_id)
)

DECLARE @f_gen_inv_adjustment TABLE
(
        inventory_event_id                  INT,
        inventory_event_list_id             INT,
        inventory_item_id                   INT,
        row_num                             INT IDENTITY(1,1),
        timestamp                           DATETIME,
        adjustment_type_code                NCHAR(1),
        atomic_event_qty                    NUMERIC(28,10),
        atomic_cost                         NUMERIC(28,10),
        production_usage_qty                NUMERIC(19,6),
        include_in_gross_margin_report_with_rebates_flag NCHAR(1),

        PRIMARY KEY (inventory_item_id, inventory_event_id, inventory_event_list_id, row_num)
)

DECLARE @f_gen_inv_transfer TABLE
(
        inventory_transfer_id               INT,
        inventory_item_id                   INT,
        timestamp                           DATETIME,
        transfer_type_code                  NCHAR(1),
        atomic_transfer_qty                 NUMERIC(28,10),
        atomic_cost                         NUMERIC(28,10),

        PRIMARY KEY (inventory_item_id, inventory_transfer_id)
)

DECLARE @f_gen_inv_return TABLE
(
        return_id                           INT,
        supplier_item_id                    INT,
        inventory_item_id                   INT,
        return_date                         DATETIME,
        atomic_qty                          NUMERIC(28,10),
  
        PRIMARY KEY (inventory_item_id, supplier_item_id, return_id)
)

DECLARE @f_gen_inv_rebate_accrual_supplier_item_list TABLE
(
        item_id                                       INT,
        non_retroactive_non_withheld_rebate_amt       NUMERIC(28,10),
        retroactive_non_withheld_rebate_amt           NUMERIC(28,10),
        withheld_rebate_amt                           NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

DECLARE @f_gen_inv_rebate_accrual_rmi_list TABLE
(
        item_id                                       INT,
        non_withheld_rebate_amt                       NUMERIC(28,10),
        withheld_rebate_amt                           NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

DECLARE @f_gen_sales_item_dest_bu_day TABLE
(
        item_id                                       INT,
        net_sales_amt                                 NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

DECLARE @Inventory_WAC_Adjustment_BU_List TABLE
(
        wac_adjustment_id int NOT NULL,
        inventory_item_id  INT NOT NULL,
        atomic_cost numeric(28, 10),
        valuation_cat_id int NULL,
        closing_weighted_average_cost numeric(28, 10) NULL,
        end_onhand_qty numeric(28, 10) NULL,
        adjustment_amt numeric(28, 10) NULL,
        active_flag nchar(1),
        business_date datetime NULL,
      
        PRIMARY KEY (wac_adjustment_id, inventory_item_id)
)

DECLARE @Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC TABLE
(
        received_id                         INT,
        supplier_item_id                    INT,
        inventory_item_id                   INT,
        discrepancy_adj_amt                 NUMERIC(28,10),
        reconciled_date                     datetime,

        PRIMARY KEY (inventory_item_id, received_id, supplier_item_id)
)

DECLARE @tmp_agg_sum TABLE
(
        bu_id                           INT,
        business_date                   SMALLDATETIME,
        prev_start_date                 SMALLDATETIME,        
        inventory_item_id               INT,
        item_hierarchy_id               INT,
        atomic_uom_id                   INT,
        bu_date_last_count_timestamp    DATETIME,
        last_count_qty                  NUMERIC(28,10),
        last_count_frequency            NCHAR(1),
        receive_qty                     NUMERIC(28,10),
        negative_receive_qty            NUMERIC(28,10),
        receive_qty_after_cnt           NUMERIC(28,10),
        return_qty                      NUMERIC(28,10),
        return_qty_after_cnt            NUMERIC(28,10),
        adjust_qty                      NUMERIC(28,10),
        negative_adjust_qty             NUMERIC(28,10),
        adjust_qty_after_cnt            NUMERIC(28,10),
        gross_margin_report_with_rebates_adjust_qty  NUMERIC(28,10),
        gross_margin_report_with_rebates_adjust_amt  NUMERIC(28,10),
        production_qty                  NUMERIC(28,10),
        production_qty_after_cnt        NUMERIC(28,10),
        xfer_qty                        NUMERIC(28,10),
        xfer_qty_after_cnt              NUMERIC(28,10),
        xfer_out_qty                    NUMERIC(28,10),
        waste_qty                       NUMERIC(28,10),
        waste_qty_after_cnt             NUMERIC(28,10),
        sales_qty                       NUMERIC(28,10),
        sales_qty_after_cnt             NUMERIC(28,10),
        begin_onhand_qty                NUMERIC(28,10),
        onorder_qty                     NUMERIC(28,10),
        exclude_on_hand_tracking_flag   NCHAR(1),
        set_variance_to_zero_flag       NCHAR(1),
        opening_weighted_average_cost   NUMERIC(28,10),

        begin_wac_backout_qty           NUMERIC(28,10),
        purchase_rebate_cost_amt        NUMERIC(28,10),
        end_wac_qty                     NUMERIC(28,10),
        end_wac_amt                     NUMERIC(28,10),
        previous_last_activity_cost     NUMERIC(28,10),
        previous_last_received_cost_amt NUMERIC(28,10),
        previous_min_supplier_cost      NUMERIC(28,10),
        previous_max_supplier_cost      NUMERIC(28,10),
        previous_avg_supplier_cost      NUMERIC(28,10),
        previous_standard_cost          NUMERIC(28,10),
        previous_retail_valuation_amt   NUMERIC(28,10),
        previous_vat_amt                NUMERIC(28,10),
        act_count_variance_qty          NUMERIC(23,10),
        act_count_variance_cost_amt     NUMERIC(23,10),
        production_usage_qty            NUMERIC(19,6),
        non_withheld_rebate_amt         NUMERIC(28,10),
        withheld_rebate_amt             NUMERIC(28,10),
        net_sales_amt                   NUMERIC(28,10),
        wac_adjustment                  NUMERIC(28,10),
        PRIMARY KEY (inventory_iteM_id)
)

-- Set Initial Variables
SELECT 	@business_unit_id = org_hierarchy_id,
		@Client_Id = oh.client_id,
		@business_date = oh.current_business_date
FROM   	VP60_Spwy..Org_Hierarchy oh
JOIN   	VP60_Spwy..Rad_Sys_Data_Accessor rsda
ON     	oh.org_hierarchy_id = rsda.data_accessor_id
WHERE  	rsda.name = @BusinessUnitCode

SELECT  @item_hierarchy_level_id    = item_hierarchy_level_id
FROM    VP60_Spwy..item_hierarchy_level
WHERE   valuation_level_flag        = 'y'
AND     client_id                   = @client_id

SELECT  @default_valuation_method_code      = valuation_method_code
FROM    VP60_Spwy..inventory_client_parameters
WHERE   client_id                           = @client_id

SET     @data_source_code = 'c'

-- Get the xml pointer
EXEC sp_xml_preparedocument @idoc OUTPUT, @XMLInput

-- Load the item external id's into a table var
INSERT 	@discontinued_item (
		xref_code)
SELECT 	xref_code
FROM OPENXML (@iDoc, '/DiscontinuedItemList/Item',2)  
WITH  	(xref_code    NVARCHAR(30)	'@ItemExternalID')

-- Free the xml pointer
EXEC sp_xml_removedocument @iDoc  

-- Set the actual item id
UPDATE di
SET  resolved_item_id = i.item_id
FROM @discontinued_item AS di
JOIN VP60_Spwy..Item As i
ON   i.xref_code = di.xref_code

-- Remove any invalid items
DELETE @discontinued_item
WHERE  resolved_item_id IS NULL

/*  Populate work table variables with open day activity */

-- Get the counts for the current business date
INSERT INTO @f_gen_inv_count 
(
        item_count_id,
        inventory_item_id,
        timestamp,
        atomic_count_qty,
        frequency_code  
)
EXEC uspGetItemWACAndQtyByBUCount @Business_Unit_Id, @business_date, @discontinued_item

-- Get last counts of the day
INSERT  @tmp_bu_day_count 
(
        bu_id,
        business_date,
        inventory_item_id,
        bu_date_last_count_timestamp,
        atomic_count_qty,
        frequency_code
)
SELECT  @business_unit_id, 
        @business_date, 
        cnt.inventory_item_id,
        cnt.timestamp,
        COALESCE(atomic_count_qty, 0),
        cnt.frequency_code

FROM    @f_gen_inv_count          cnt 
WHERE   cnt.timestamp             = ( SELECT  MAX(cnt2.timestamp)
                                      FROM    @f_gen_inv_count        cnt2 
                                      WHERE   cnt.inventory_item_id   = cnt2.inventory_item_id )

-- Get the receiving for the current business date (non shipper)
INSERT  @f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
EXEC uspGetItemWACAndQtyByBURecv @Business_Unit_Id, @business_date, @discontinued_item

-- Receiving (shipper) which are received and reconciled on the same day
INSERT  @f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
EXEC uspGetItemWACAndQtyByBURecvShipper @Business_Unit_Id, @business_date, @discontinued_item

-- Receiving (shipper, non-shipper) which are received and reconciled on different business date
INSERT  @Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 
EXEC uspGetItemWACAndQtyByBUInvcRecon @Business_Unit_Id, @business_date, @discontinued_item

-- Adjustments
INSERT  @f_gen_inv_adjustment
(
        inventory_event_id,
        inventory_event_list_id,
        inventory_item_id,
        timestamp,
        adjustment_type_code,
        atomic_event_qty,
        atomic_cost,
        production_usage_qty,
        include_in_gross_margin_report_with_rebates_flag
)
EXEC uspGetItemWACAndQtyByBUAdj @Business_Unit_Id, @business_date, @discontinued_item

-- Transfers
INSERT  @f_gen_inv_transfer
(
        inventory_transfer_id,
        inventory_item_id,
        timestamp,
        transfer_type_code,
        atomic_transfer_qty,
        atomic_cost
)
EXEC uspGetItemWACAndQtyByBUXfer @Business_Unit_Id, @business_date, @discontinued_item

-- Returns (non-shipper and shipper)
INSERT  @f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)
EXEC uspGetItemWACAndQtyByBUReturn @Business_Unit_Id, @business_date, @discontinued_item

-- Rebate amts from purchase based rebates
INSERT  @f_gen_inv_rebate_accrual_supplier_item_list
(
        item_id,
        non_retroactive_non_withheld_rebate_amt
)
EXEC uspGetItemWACAndQtyByBURebate @Business_Unit_Id, @business_date, @discontinued_item

INSERT @Inventory_WAC_Adjustment_BU_List
(
       wac_adjustment_id,
       inventory_item_id,
       atomic_cost,
       active_flag,
       valuation_cat_id     
)
EXEC uspGetItemWACAndQtyByBUWACAdj @Business_Unit_Id, @business_date, @discontinued_item

INSERT @Inventory_WAC_Adjustment_BU_List
(
       wac_adjustment_id,
       inventory_item_id,
       atomic_cost,
       active_flag,
       valuation_cat_id     
)
EXEC uspGetItemWACAndQtyByBUWACAdj @Business_Unit_Id, @business_date, @discontinued_item

/*---------------------------------------------------------
Union all of the open day activities into a table variable.
-----------------------------------------------------------*/

INSERT @tmp_agg_sum 
(
        bu_id,
        business_date,
        inventory_item_id,
        item_hierarchy_id,
        prev_start_date,
        begin_onhand_qty,
        receive_qty,
        negative_receive_qty,
        receive_qty_after_cnt,
        return_qty,
        return_qty_after_cnt,
        adjust_qty,
        negative_adjust_qty,
        adjust_qty_after_cnt,
        production_qty,
        production_qty_after_cnt,
        xfer_qty,
        xfer_qty_after_cnt,
        xfer_out_qty,
        waste_qty,
        waste_qty_after_cnt,
        sales_qty,
        sales_qty_after_cnt,
        onorder_qty,
        last_count_qty,
        last_count_frequency,
        exclude_on_hand_tracking_flag,
        set_variance_to_zero_flag,
        atomic_uom_id,
        opening_weighted_average_cost,

        begin_wac_backout_qty,
        purchase_rebate_cost_amt,
        end_wac_qty,
        end_wac_amt,

        previous_last_activity_cost,
        previous_last_received_cost_amt,
        production_usage_qty,
        non_withheld_rebate_amt,
        withheld_rebate_amt,
        net_sales_amt,
        gross_margin_report_with_rebates_adjust_qty,
        gross_margin_report_with_rebates_adjust_amt,
        wac_adjustment
)

SELECT  @business_unit_id,
--t.bu_id,
--        t.business_date,
@business_date,
        di.resolved_item_id,
        itm.item_hierarchy_id,
        act.start_business_date,
        COALESCE(act.end_onhand_qty, 0),
        t.receive_qty,
        t.negative_receive_qty,
        t.receive_qty_after_cnt,
        t.return_qty,
        t.return_qty_after_cnt,
        t.adjust_qty,
        t.negative_adjust_qty,
        t.adjust_qty_after_cnt,
        t.production_qty,
        t.production_qty_after_cnt,
        t.xfer_qty,
        t.xfer_qty_after_cnt,
        t.xfer_out_qty,
        t.waste_qty,
        t.waste_qty_after_cnt,
        t.sales_qty,
        t.sales_qty_after_cnt,
        t.onorder_qty,
        t.last_count_qty,
        t.last_count_frequency,
        invitm.exclude_on_hand_tracking_flag,
        invitm.set_variance_to_zero_flag,
        itm.atomic_uom_id,
        act.closing_weighted_average_cost,
        t.begin_wac_backout_qty,
        t.purchase_rebate_cost_amt,
        t.end_wac_qty,
        t.end_wac_amt,
        act.last_activity_cost,
        act.last_received_cost_amt,
        t.production_usage_qty,
        t.non_withheld_rebate_amt,
        t.withheld_rebate_amt,
        t.net_sales_amt,
        t.gross_margin_report_with_rebates_adjust_qty,
        t.gross_margin_report_with_rebates_adjust_amt,
        t.wac_adjustment

FROM  	@Discontinued_Item di

JOIN    VP60_Spwy_wh..item             	itm
ON      itm.item_id  				= di.resolved_item_id

JOIN    VP60_Spwy..inventory_item    invitm
ON      invitm.inventory_item_id    = di.resolved_item_id

/* Open day Activity */
LEFT JOIN (     SELECT  @business_unit_id                       AS bu_id,
                @business_date             				        AS business_date,
                t.inventory_item_id                             AS inventory_item_id, 
                SUM(COALESCE(t.receive_qty,0))                  AS receive_qty,
                SUM(COALESCE(t.negative_receive_qty,0))         AS negative_receive_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.receive_qty END, 0)) AS receive_qty_after_cnt,
                SUM(COALESCE(t.return_qty,0))                   AS return_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.return_qty END, 0)) AS return_qty_after_cnt,
                SUM(COALESCE(t.adjust_qty,0))                   AS adjust_qty,
                SUM(COALESCE(t.negative_adjust_qty,0))          AS negative_adjust_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.adjust_qty END, 0)) AS adjust_qty_after_cnt,
                SUM(COALESCE(t.production_qty,0))               AS production_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.production_qty END, 0)) AS production_qty_after_cnt,
                SUM(COALESCE(t.xfer_qty,0))                     AS xfer_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.xfer_qty END, 0)) AS xfer_qty_after_cnt,
                SUM(COALESCE(t.xfer_out_qty,0))                 AS xfer_out_qty,
                SUM(COALESCE(t.waste_qty,0))                    AS waste_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.waste_qty END, 0)) AS waste_qty_after_cnt,
                SUM(COALESCE(t.sales_qty,0))                    AS sales_qty,
                SUM(COALESCE(CASE WHEN t.timestamp >= lastcnt.bu_date_last_count_timestamp THEN t.sales_qty END, 0)) AS sales_qty_after_cnt,
                SUM(COALESCE(t.onorder_qty,0))                  AS onorder_qty,
                MIN(COALESCE(lastcnt.atomic_count_qty, -999))   AS last_count_qty,
                MIN(COALESCE(lastcnt.frequency_code, 'd'))      AS last_count_frequency,
                SUM(COALESCE(t.begin_wac_backout_qty, 0))       AS begin_wac_backout_qty,
                -MIN(COALESCE(rasil.non_retroactive_non_withheld_rebate_amt, 0))  AS purchase_rebate_cost_amt, -- store as a negative since it decreases received/inventory cost
                SUM(COALESCE(t.end_wac_qty, 0))                 AS end_wac_qty,
                SUM(COALESCE(t.end_wac_amt, 0))                 AS end_wac_amt,
                SUM(COALESCE(t.production_usage_qty,0))         AS production_usage_qty,
                MIN(COALESCE(rasil.non_retroactive_non_withheld_rebate_amt, 0) + 
                    COALESCE(rasil.retroactive_non_withheld_rebate_amt, 0) +
                    COALESCE(rarl.non_withheld_rebate_amt, 0))     AS non_withheld_rebate_amt,
                MIN(COALESCE(rasil.withheld_rebate_amt, 0) +
                    COALESCE(rarl.withheld_rebate_amt, 0))         AS withheld_rebate_amt,
                MIN(COALESCE(sidbd.net_sales_amt, 0))              AS net_sales_amt,
                SUM(COALESCE(t.gross_margin_report_with_rebates_adjust_qty, 0)) AS gross_margin_report_with_rebates_adjust_qty,
                SUM(COALESCE(t.gross_margin_report_with_rebates_adjust_amt, 0)) AS gross_margin_report_with_rebates_adjust_amt,
                MAX(ISNULL(t.wac_adjustment,0))                                 AS wac_adjustment

        FROM
        (
                -- Counts
                SELECT  cnt.inventory_item_id           AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt,
                        NULL                            As Production_Usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_inv_count                cnt 
                
                UNION ALL
                
                -- Receivings
                SELECT  rcv.inventory_item_id           AS inventory_item_id,
                        rcv.recv_date                   AS timestamp,
                        COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)
                                                        AS receive_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) < 0 
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) < 0 
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS begin_wac_backout_qty,
                        CASE WHEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0)) >= 0
                             THEN (COALESCE(rcv.atomic_qty, 0) + COALESCE(rcv.atomic_free_quantity, 0))
                             ELSE 0
                        END                             AS end_wac_qty,
                        CASE WHEN COALESCE(rcv.atomic_qty, 0) >= 0
                             THEN COALESCE(rcv.atomic_qty, 0) * COALESCE(rcv.atomic_cost, 0)
                             ELSE 0
                        END                             AS end_wac_amt,
                        NULL                            AS prodcution_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_inv_receive              rcv
                
                UNION ALL 

                -- Recevings reconciled on different business date

                SELECT  inventory_item_id               AS inventory_item_id,
                        reconciled_date                 AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        discrepancy_adj_amt             AS end_wac_amt,
                        NULL                            AS prodcution_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC                


                UNION ALL
                
                --Adjustments
                SELECT  adj.inventory_item_id           AS inventory_item_id,
                        adj.timestamp                   AS timestamp,
                        CASE WHEN adj.adjustment_type_code = 'r' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        CASE WHEN adj.adjustment_type_code = 'a' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS adjust_qty,
                        CASE WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty < 0 THEN
                          COALESCE(adj.atomic_event_qty, 0)
                        WHEN adj.adjustment_type_code = 'w' THEN
                          -COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS negative_adjust_qty,
                        -- flag will only be set for adjustments of type adjustment, only need to check flag
                        CASE WHEN adj.include_in_gross_margin_report_with_rebates_flag = 'y' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS gross_margin_report_with_rebates_adjust_qty,
                        -- flag will only be set for adjustments of type adjustment, only need to check flag
                        CASE WHEN adj.include_in_gross_margin_report_with_rebates_flag = 'y' THEN 
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                        ELSE 
                          0
                        END                             AS gross_margin_report_with_rebates_adjust_amt,
                        CASE WHEN adj.adjustment_type_code = 'p' THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE 
                          0
                        END                             AS production_qty,
                        
                                                
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        CASE WHEN adj.adjustment_type_code = 'w' THEN 
                          COALESCE(adj.atomic_event_qty, 0)

                        ELSE 
                          0
                        END                             AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                         --picks the negative adjustments quantities that are manually created
                        CASE WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)<>coalesce(ie.invoice_id,1)THEN
                          COALESCE(adj.atomic_event_qty, 0)
                             WHEN adj.adjustment_type_code = 'w' THEN
                          -COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS begin_wac_backout_qty,
                        --picks all the positive adjustments quantities 
                        CASE WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty >= 0 THEN
                          COALESCE(adj.atomic_event_qty, 0)
                             --for case when adjustment quantities are less than zero and are created from invoice reconciliation
                             WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)=coalesce(ie.invoice_id,1)  THEN 
                          COALESCE(adj.atomic_event_qty, 0)
                        ELSE
                          0
                        END                             AS end_wac_qty,
                        --picks the amounts for all positive adjustments
                        CASE WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty >= 0 THEN
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                          --picks the amounts for -ve adjustments that are created from invoice reconciliation
                             WHEN adj.adjustment_type_code IN ('r', 'p', 'a') AND adj.atomic_event_qty < 0 AND coalesce(ir.invoice_id,0)=coalesce(ie.invoice_id,1)  THEN 
                          COALESCE(adj.atomic_event_qty, 0) * COALESCE(adj.atomic_cost, 0)
                        ELSE
                          0
                        END                             AS end_wac_amt ,
                        CASE WHEN adj.adjustment_type_Code = 'p' THEN 
                              COALESCE(adj.production_usage_qty, 0) ELSE 0 
                        END                             as production_usage_qty,
                        NULL                            As wac_adjustment
                      
                
                FROM            @f_gen_inv_adjustment           adj 
                JOIN VP60_Spwy..inventory_event_list  iel WITH (NOLOCK)
                ON adj.inventory_event_id                       =iel.inventory_event_id
                AND iel.inventory_item_id                       =adj.inventory_item_id
                AND iel.inventory_event_list_id                 =adj.inventory_event_list_id
                JOIN VP60_Spwy..inventory_event       ie WITH (NOLOCK)
                ON ie.inventory_event_id                        =iel.inventory_event_id
                LEFT OUTER JOIN VP60_Spwy..invoice_reconciliation  ir WITH (NOLOCK)
                ON ir.invoice_id                                =ie.invoice_id
                
                UNION ALL
                
                SELECT  xfer.inventory_item_id          AS inventory_item_id,
                        xfer.timestamp                  AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        CASE WHEN xfer.transfer_type_code IN ('t', 'o') THEN 
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE 
                          0
                        END                             AS xfer_qty,
                        CASE WHEN xfer.transfer_type_code IN ('t', 'o') AND xfer.atomic_transfer_qty < 0 THEN 
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE 
                          0
                        END                             AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,

                        CASE WHEN xfer.transfer_type_code IN ('t', 'o') AND COALESCE(xfer.atomic_transfer_qty, 0) < 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE
                          0
                        END                             AS begin_wac_backout_qty,
                        CASE WHEN xfer.transfer_type_code IN ('t', 'o') AND COALESCE(xfer.atomic_transfer_qty, 0) > 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0)
                        ELSE
                          0
                        END                             AS end_wac_qty,
                        CASE WHEN xfer.transfer_type_code IN ('t', 'o') AND COALESCE(xfer.atomic_transfer_qty, 0) > 0 THEN
                          COALESCE(xfer.atomic_transfer_qty, 0) * COALESCE(xfer.atomic_cost, 0)
                        ELSE
                          0
                        END                             AS end_wac_amt ,
                        NULL                            AS production_usage_qty ,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_inv_transfer             xfer 
                
                UNION ALL 
                
                -- Returns
                
                SELECT  ret.inventory_item_id           AS inventory_item_id,
                        ret.return_date                 AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        COALESCE(ret.atomic_qty, 0)     AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        -COALESCE(ret.atomic_qty, 0)    AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                                
                FROM    @f_gen_inv_return               ret
                                
                UNION ALL 
                -- on order qty
                
                SELECT  poi.item_id AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        poi.atomic_inventory_item_quantity       
                                                        AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt, 
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM 
                ( 
                        SELECT  po.business_unit_id, 
                                po.purchase_order_id 
                        FROM    VP60_Spwy..purchase_order po
                        WHERE   po.business_unit_id     = @business_unit_id
                        AND     po.order_date           <= @business_date
                        AND     po.hq_order_id          IS NULL
                        AND     po.purge_flag           = 'n'
                        AND     po.status_code          = 's'
                ) po
                
                JOIN    VP60_Spwy..purchase_order_item   poi 
                ON      poi.business_unit_id            = po.business_unit_id
                AND     poi.purchase_order_id           = po.purchase_order_id
                AND     poi.item_id                     IS NOT NULL
                
                UNION ALL 
                
                -- sales_qty
                SELECT  usg.inventory_item_id           AS inventory_item_id,
                        usg.trans_timestamp             AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        COALESCE(usg.atomic_sales_usage_qty,0)      
                                                        AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM     VP60_Spwy_wh..f_gen_inv_sales_usage   usg
                
                WHERE   usg.bu_id                       = @business_unit_id
                AND     usg.business_date               = @business_date

                UNION ALL 

                SELECT  rasil.item_id                   AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_inv_rebate_accrual_supplier_item_list rasil

                UNION ALL 

                SELECT  rarl.item_id                    AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_inv_rebate_accrual_rmi_list rarl

                UNION ALL 

                SELECT  sidbd.item_id                   AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        NULL                            As wac_adjustment
                
                FROM    @f_gen_sales_item_dest_bu_day sidbd

                UNION ALL 

                SELECT  inventory_item_id               AS inventory_item_id,
                        NULL                            AS timestamp,
                        NULL                            AS receive_qty,
                        NULL                            AS negative_receive_qty,
                        NULL                            AS return_qty,
                        NULL                            AS adjust_qty,
                        NULL                            AS negative_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_qty,
                        NULL                            AS gross_margin_report_with_rebates_adjust_amt,
                        NULL                            AS production_qty,
                        NULL                            AS xfer_qty,
                        NULL                            AS xfer_out_qty,
                        NULL                            AS waste_qty,
                        NULL                            AS sales_qty,
                        NULL                            AS begin_onhand_qty,
                        NULL                            AS onorder_qty,
                        NULL                            AS begin_wac_backout_qty,
                        NULL                            AS end_wac_qty,
                        NULL                            AS end_wac_amt ,
                        NULL                            AS production_usage_qty,
                        atomic_cost                     As wac_adjustment                        
                
                FROM    @Inventory_WAC_Adjustment_BU_List  wac
               WHERE    business_date IS NOT NULL

        ) t

        LEFT OUTER JOIN @tmp_bu_day_count               lastcnt
        ON      lastcnt.inventory_item_id               = t.inventory_item_id

        LEFT OUTER JOIN @f_gen_inv_rebate_accrual_supplier_item_list rasil
        ON      rasil.item_id                           = t.inventory_item_id
        
        LEFT OUTER JOIN @f_gen_inv_rebate_accrual_rmi_list rarl
        ON      rarl.item_id                            = t.inventory_item_id

        LEFT OUTER JOIN @f_gen_sales_item_dest_bu_day   sidbd
        ON      sidbd.item_id                           = t.inventory_item_id
 
        GROUP BY t.inventory_item_id
) t

ON      di.resolved_item_id                             = t.inventory_item_id

/* Most Recently Closed Day Activity */
LEFT OUTER JOIN  VP60_Spwy_wh..f_gen_inv_item_activity_bu_day act
ON      act.bu_id                                       = @business_unit_id --t.bu_id
AND     act.inventory_item_id                           = di.resolved_item_id
AND     DATEADD(dd, -1, @business_date)   BETWEEN act.start_business_date AND COALESCE(act.end_business_date, '12/31/2075')


/*  Creates rows that merge open day and most recently closed day activity into a single row */
INSERT @new_f_gen_inv_item_activity_bu_day 
(
        bu_id,
        start_business_date,
        inventory_item_id,
        valuation_cat_id,
        atomic_uom_id,
        recv_qty,
        negative_recv_qty,
        return_qty,
        adjust_qty,
        production_qty,
        xfer_qty,
        xfer_out_qty,
        waste_qty,
        sales_qty,
        onorder_qty,
        end_onhand_qty,
        begin_onhand_qty,
        count_variance_qty,
        exclude_on_hand_tracking_flag,
        opening_weighted_average_cost,

        begin_wac_backout_qty,
        purchase_rebate_cost_amt,
        end_wac_qty,
        end_wac_amt,
        previous_last_activity_cost,
        previous_last_received_cost_amt,
        negative_adjust_qty, 
        production_usage_qty,
        non_withheld_rebate_amt,
        withheld_rebate_amt,
        net_sales_amt,
        gross_margin_report_with_rebates_adjust_qty,
        gross_margin_report_with_rebates_adjust_amt,
        wac_adjustment
        

)
SELECT  t.bu_id,
        t.start_business_date,
        t.inventory_item_id,
        t.valuation_cat_id,
        t.atomic_uom_id,
        t.recv_qty,
        t.negative_recv_qty,
        t.return_qty,
        t.adjust_qty,
        t.production_qty,
        t.xfer_qty,
        t.xfer_out_qty,
        t.waste_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = 'y' THEN -- exclude on hand tracking necessitates set variance to zero (through the UI) 
                                                             --   so check it first (and account for set variance to zero when it is on by including variance)
          COALESCE(t.sales_qty, 0) - COALESCE(t.count_variance_qty, 0) + COALESCE(t.end_onhand_qty, 0)
        WHEN t.set_variance_to_zero_flag = 'y' THEN
          COALESCE(t.sales_qty, 0) - COALESCE(t.count_variance_qty, 0)
        ELSE
          COALESCE(t.sales_qty, 0)
        END AS sales_qty,

        t.onorder_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = 'y' THEN
          0
        ELSE
          t.end_onhand_qty
        END AS end_onhand_qty,


        t.begin_onhand_qty AS begin_onhand_qty,

        CASE WHEN t.exclude_on_hand_tracking_flag = 'y' OR t.set_variance_to_zero_flag = 'y' THEN
          0
        ELSE
          t.count_variance_qty
        END,

        t.exclude_on_hand_tracking_flag,
        t.opening_weighted_average_cost,

        t.begin_wac_backout_qty + 
          CASE WHEN t.exclude_on_hand_tracking_flag = 'y' OR t.set_variance_to_zero_flag = 'y' THEN
            0
          ELSE
            t.count_variance_qty 
          END AS begin_wac_backout_qty,
        t.purchase_rebate_cost_amt,
        t.end_wac_qty,
        t.end_wac_amt + t.purchase_rebate_cost_amt AS end_wac_amt,
        t.previous_last_activity_cost,
        t.previous_last_received_cost_amt,
        t.negative_adjust_qty,
        t.production_usage_qty,
        t.non_withheld_rebate_amt,
        t.withheld_rebate_amt,
        t.net_sales_amt,
        t.gross_margin_report_with_rebates_adjust_qty,
        t.gross_margin_report_with_rebates_adjust_amt,
        t.wac_adjustment


FROM
(
        SELECT  agg.bu_id                 AS bu_id,
                agg.business_date         AS start_business_date,
                agg.inventory_item_id     AS inventory_item_id,
                pih.item_hierarchy_id     AS valuation_cat_id,
                agg.atomic_uom_id         AS atomic_uom_id,
                agg.receive_qty           AS recv_qty,
                agg.negative_receive_qty  AS negative_recv_qty,
                agg.return_qty            AS return_qty,
                agg.adjust_qty            AS adjust_qty,
                agg.production_qty        AS production_qty,
                agg.xfer_qty              AS xfer_qty,
                agg.xfer_out_qty          AS xfer_out_qty,
                agg.waste_qty             AS waste_qty,
                -- sales
                agg.sales_qty             AS sales_qty, 
                -- end sales
                agg.onorder_qty           AS onorder_qty,
        
                -- end onhand
                CASE WHEN COALESCE(last_count_qty, -999) = -999 THEN 
                  agg.begin_onhand_qty + agg.receive_qty - agg.return_qty + agg.adjust_qty + agg.production_qty + agg.xfer_qty - agg.waste_qty - 
                      agg.sales_qty                      
                ELSE 
                  COALESCE(last_count_qty, 0) + agg.receive_qty_after_cnt - agg.return_qty_after_cnt + 
                    agg.adjust_qty_after_cnt + agg.production_qty_after_cnt + agg.xfer_qty_after_cnt - agg.waste_qty_after_cnt - 
                      agg.sales_qty_after_cnt                                          
                END                       AS end_onhand_qty,
                -- end end onhand
        
                -- begin onhand qty
                agg.begin_onhand_qty AS begin_onhand_qty,
                -- end begin onhand qty

                -- variance
                CASE WHEN COALESCE(last_count_qty, -999) = -999 THEN 
                  0
                WHEN last_count_frequency = 'i' THEN 
                  0        
                ELSE 
                  ( COALESCE(last_count_qty, 0) + agg.receive_qty_after_cnt - agg.return_qty_after_cnt + 
                      agg.adjust_qty_after_cnt + agg.production_qty_after_cnt + agg.xfer_qty_after_cnt - 
                        agg.waste_qty_after_cnt - agg.sales_qty_after_cnt                    
                  ) - 
                    ( agg.begin_onhand_qty + agg.receive_qty - agg.return_qty + agg.adjust_qty + agg.production_qty +
                        agg.xfer_qty - agg.waste_qty - agg.sales_qty
                    ) 
                END                             AS count_variance_qty,
                -- end variance
                agg.set_variance_to_zero_flag AS set_variance_to_zero_flag,
                agg.exclude_on_hand_tracking_flag AS exclude_on_hand_tracking_flag,
                agg.opening_weighted_average_cost,
                agg.begin_wac_backout_qty,
               CASE WHEN agg.purchase_rebate_cost_amt IS NOT NULL AND  agg.purchase_rebate_cost_amt < 0
                    THEN agg.purchase_rebate_cost_amt
                    ELSE 0
               END AS purchase_rebate_cost_amt,
                agg.end_wac_qty,
                agg.end_wac_amt,
                agg.previous_last_activity_cost,
                agg.previous_last_received_cost_amt,
                agg.negative_adjust_qty,
                agg.act_count_variance_qty,
                agg.act_count_variance_cost_amt,
                Coalesce(agg.production_usage_qty,0) as production_usage_qty,
                agg.non_withheld_rebate_amt,
                agg.withheld_rebate_amt,
                agg.net_sales_amt,
                agg.gross_margin_report_with_rebates_adjust_qty,
                agg.gross_margin_report_with_rebates_adjust_amt,
                agg.wac_adjustment
        
        FROM    @tmp_agg_sum                    agg 
        
        JOIN    VP60_Spwy..item_hierarchy        ih
        ON      ih.item_hierarchy_id            = agg.item_hierarchy_id
        
        JOIN    VP60_Spwy..item_hierarchy        pih
        ON      ih.setstring                    LIKE pih.setstring + '%'
        AND     pih.item_hierarchy_level_id     = @item_hierarchy_level_id) t


/* -------------------- */

UPDATE  act
SET     last_activity_cost            = ( SELECT  atomic_cost
                                          FROM    VP60_Spwy..inventory_item_bu_cost_list cl1
                                          WHERE   cl1.business_unit_id              = act.bu_id
                                          AND     cl1.inventory_item_id             = act.inventory_item_id
                                          AND     cl1.business_date                 = act.start_business_date
                                          AND     cl1.business_unit_id              = @business_unit_id
                                          AND     cl1.business_date                 = @business_date
                                          AND NOT EXISTS 
                                          ( 
                                                  SELECT  1
                                                  FROM    VP60_Spwy..inventory_item_bu_cost_list cl2 WITH (NOLOCK)
                                                  WHERE   cl1.business_unit_id      = cl2.business_unit_id
                                                  AND     cl1.inventory_item_id     = cl2.inventory_item_id 
                                                  AND     cl2.business_date         = cl1.business_date
                                                  AND     cl2.end_date              > cl1.end_date 
                                          )
                                        )
FROM    @new_f_gen_inv_item_activity_bu_day act

UPDATE  act
SET     last_received_cost_amt        = ( SELECT  atomic_cost
                                          FROM    VP60_Spwy..inventory_item_bu_cost_list cl1
                                          WHERE   cl1.business_unit_id              = act.bu_id
                                          AND     cl1.inventory_item_id             = act.inventory_item_id
                                          AND     cl1.business_date                 = act.start_business_date
                                          AND     cl1.business_unit_id              = @business_unit_id
                                          AND     cl1.business_date                 = @business_date
                                          AND     cl1.cost_source_code              = 'r'
                                          AND NOT EXISTS 
                                          ( 
                                                  SELECT  1
                                                  FROM    VP60_Spwy..inventory_item_bu_cost_list cl2 WITH (NOLOCK)
                                                  WHERE   cl1.business_unit_id      = cl2.business_unit_id
                                                  AND     cl1.inventory_item_id     = cl2.inventory_item_id 
                                                  AND     cl2.business_date         = cl1.business_date
                                                  AND     cl2.end_date              > cl1.end_date 
                                                  AND     cl2.cost_source_code      = 'r'
                                          )
                                        )
FROM    @new_f_gen_inv_item_activity_bu_day act

UPDATE  act
SET     min_supplier_cost               = cost.min_supplier_cost,
        max_supplier_cost               = cost.max_supplier_cost,
        avg_supplier_cost               = cost.avg_supplier_cost
FROM    @new_f_gen_inv_item_activity_bu_day act
JOIN 
(
        SELECT  x.item_id, 
                MIN(x.item_cost) AS min_supplier_cost,
                MAX(x.item_cost) AS max_supplier_cost,
                AVG(x.item_cost) AS avg_supplier_cost
        FROM 
        (
                SELECT  i.item_id,
                        cost.net_supplier_cost / 
                          COALESCE( CASE WHEN spi.catch_weight_flag = 'y' THEN 
                            pricedinUOM.factor * COALESCE(iuomcpricedin.atomic_conversion_factor,1)
                          ELSE
                            packagedinUOM.factor * COALESCE(iuomcpackagedin.atomic_conversion_factor,1)
                          END,1) as item_cost 
                
                FROM     VP60_Spwy_wh..f_gen_supplier_item_unit_cost     cost 
                JOIN    VP60_Spwy..supplier_item                   si
                ON      si.supplier_id                            = cost.supplier_id
                AND     si.supplier_item_id                       = cost.supplier_item_id
                JOIN    VP60_Spwy..supplier_packaged_item          spi
                ON      spi.supplier_id                           = cost.supplier_id
                AND     spi.supplier_item_id                      = cost.supplier_item_id
                AND     spi.packaged_item_id                      = cost.packaged_item_id
                JOIN    VP60_Spwy..item                            i 
                ON      i.item_id                                 = si.item_id
                JOIN    VP60_Spwy..Unit_of_Measure                 packagedinUOM
                ON      packagedinUOM.unit_of_measure_id          = SPI.packaged_in_uom_id 
                LEFT OUTER JOIN VP60_Spwy..unit_of_measure         pricedinUOM
                ON      pricedinUOM.unit_of_measure_id            = SPI.priced_in_uom_id 
                LEFT OUTER JOIN VP60_Spwy..item_uom_conversion     iuomcpricedin
                ON      iuomcpricedin.item_id                     = i.item_id
                AND     iuomcpricedin.unit_of_measure_class_id    = pricedinUOM.unit_of_measure_class_id
                LEFT OUTER JOIN VP60_Spwy..item_uom_conversion     iuomcpackagedin
                ON      iuomcpackagedin.item_id                   = i.item_id
                AND     iuomcpackagedin.unit_of_measure_class_id  = packagedinUOM.unit_of_measure_class_id
                WHERE   cost.bu_id                                = @business_unit_id
                AND     @business_date              BETWEEN cost.start_date AND COALESCE(cost.end_date, '12/31/2075')
        ) as x
        GROUP BY x.item_id
) cost 
ON      cost.item_id = act.inventory_item_id

UPDATE  act
SET     standard_cost                               = cstdcost.standard_cost / 
                                                        COALESCE(uom.factor * uomcv.atomic_conversion_factor, uom.factor)
FROM    @new_f_gen_inv_item_activity_bu_day         act
JOIN    VP60_Spwy..inventory_item                    ii
ON      ii.inventory_item_id                        = act.inventory_item_id
JOIN    VP60_Spwy..unit_of_measure                   uom
ON      uom.unit_of_measure_id                      = ii.valuation_uom_id
LEFT OUTER JOIN VP60_Spwy..item_uom_conversion       uomcv
ON      uomcv.unit_of_measure_class_id              = uom.unit_of_measure_class_id
AND     uomcv.item_id                               = act.inventory_item_id
LEFT OUTER JOIN VP60_Spwy..inventory_item_org_hier_std_cost cstdcost
ON      cstdcost.inventory_item_id                  = act.inventory_item_id
AND     cstdcost.org_hierarchy_id                   = @client_id
--LEFT OUTER JOIN inventory_item_org_hier_std_cost tstdcost
--ON      tstdcost.inventory_item_id                  = act.inventory_item_id
--AND     tstdcost.org_hierarchy_id                   = @template_client_id

UPDATE  act
SET     retail_valuation_amt                        = 
                                                        price.retail_price / rmi.unit_of_measure_quantity / 
                                                          COALESCE(uomrmi.factor * uomcvrmi.atomic_conversion_factor, uomrmi.factor)
                                                      
        , vat_amt                                  =  
                                                        round((retail_price - (retail_price / (1+tax_percentage/100))),2)
                                                      
FROM    @new_f_gen_inv_item_activity_bu_day         act
JOIN    VP60_Spwy..retail_modified_item              rmi
ON      rmi.retail_item_id                          = act.inventory_item_id
AND     rmi.retail_valuation_flag                   = 'y'

JOIN    VP60_Spwy..merch_bu_rmi_retail_list          price
ON      price.business_unit_id                      = @business_unit_id
AND     price.retail_modified_item_id               = rmi.retail_modified_item_id

JOIN    VP60_Spwy..unit_of_measure                   uomrmi
ON      uomrmi.unit_of_measure_id                   = rmi.unit_of_measure_id
LEFT OUTER JOIN VP60_Spwy..item_uom_conversion       uomcvrmi
ON      uomcvrmi.unit_of_measure_class_id           = uomrmi.unit_of_measure_class_id
AND     uomcvrmi.item_id                            = act.inventory_item_id

UPDATE act
SET closing_weighted_average_cost = CASE 
    WHEN (CASE WHEN COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) <= 0 AND COALESCE(act.end_wac_qty, 0) > 0 THEN 
                    CAST(COALESCE(act.end_wac_amt, 0) AS NUMERIC(28, 10)) / CAST(COALESCE(act.end_wac_qty, 0) AS NUMERIC(28, 10))

               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)

               -- handle the special case of no incoming goods but return based rebates exist by increasing WAC through the purchase based rebates
               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.purchase_rebate_cost_amt, 0) <> 0
                    AND (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) <> 0 THEN 
                    CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.purchase_rebate_cost_amt, 0)) AS NUMERIC(28, 10)) /  
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10))

               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.end_wac_amt, 0) = 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
               
               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)
         
          ELSE CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.end_wac_amt, 0)) AS NUMERIC(28, 10)) / 
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10))

          END) <= 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
    ELSE (CASE WHEN COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) <= 0 AND COALESCE(act.end_wac_qty, 0) > 0 THEN 
                    CAST(COALESCE(act.end_wac_amt, 0) AS NUMERIC(28, 10)) / CAST(COALESCE(act.end_wac_qty, 0) AS NUMERIC(28, 10))

               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10)) < 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)

                    -- handle the special case of no incoming goods but return based rebates exist by increasing WAC through the purchase based rebates
               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.purchase_rebate_cost_amt, 0) <> 0
                    AND (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) <> 0 THEN 
                    CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.purchase_rebate_cost_amt, 0)) AS NUMERIC(28, 10)) /  
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) AS NUMERIC(28, 10))

               WHEN COALESCE(act.end_wac_qty, 0) <= 0 AND COALESCE(act.end_wac_amt, 0) = 0 THEN 
                    COALESCE(act.opening_weighted_average_cost, 0)
               
               WHEN CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10)) <= 0 THEN
                    COALESCE(act.opening_weighted_average_cost, 0)
         
          ELSE CAST((COALESCE(act.opening_weighted_average_cost, 0) * (COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0)) + 
                    COALESCE(act.end_wac_amt, 0)) AS NUMERIC(28, 10)) / 
                    CAST((COALESCE(act.begin_onhand_qty, 0) + COALESCE(act.begin_wac_backout_qty, 0) + COALESCE(act.end_wac_qty, 0)) AS NUMERIC(28, 10))
          END)
    END
FROM 				@new_f_gen_inv_item_activity_bu_day act
JOIN  				VP60_Spwy..item_hierarchy ih
ON 					ih.item_hierarchy_id = act.valuation_cat_id
LEFT OUTER JOIN  	VP60_Spwy..inventory_client_parameters icp
ON 					icp.client_id = @client_id
LEFT OUTER JOIN  	VP60_Spwy..item_hierarchy_bu_override_list ihbol
ON 					ihbol.item_hierarchy_id = ih.item_hierarchy_id
AND 				ihbol.business_unit_id = @business_unit_id
WHERE 				COALESCE(ihbol.valuation_method_code, ih.valuation_method_code, icp.valuation_method_code, 'i') = 'w' -- calculate weighted average costs
 
UPDATE  w
SET  	closing_weighted_average_cost = a.closing_weighted_average_cost,
        end_onhand_qty = a.end_onhand_qty,
        adjustment_amt = (w.atomic_cost - a.closing_weighted_average_cost) * a.end_onhand_qty
FROM  	@new_f_gen_inv_item_activity_bu_day a
JOIN  	@Inventory_WAC_Adjustment_BU_List w
ON  	w.inventory_item_id = a.inventory_item_id
AND  	w.business_date IS NOT NULL

UPDATE	@new_f_gen_inv_item_activity_bu_day 
SET  	closing_weighted_average_cost = wac_adjustment
WHERE  	wac_adjustment > 0

/*----------------------------------------------------------------------------------*/

SELECT  --da.name                                                       AS display_org_hierarchy_name, 
--        t.display_org_hierarchy_id                                    AS display_org_hierarchy_id, 
--        t.item_hierarchy_name                                         AS item_hierarchy_name,
--        t.item_hierarchy_id                                           AS item_hierarchy_id,
--        t.business_date                                               AS business_date,
        t.item_id                                                     AS ItemID,
--        t.item_name                                                   AS item_name,
        t.uom                                                         AS UnitOfMeasure,
        t.boh                                                         AS BeginningOnHandAmount,
		t.open_wac                                                    AS BeginningWac,
--        t.purch                                                       AS purch,
--        t.trans                                                       AS trans,
--        t.adj                                                         AS adj,
--        t.variance                                                    AS variance,
--        t.usage                                                       AS usage,
        t.eoh                                                         AS CurrentOnHandAmount,
        t.wac                                                         AS CurrentWac --,
--        t.eoh_amt                                                     AS eoh_amt,
--        t.eoh_amt                                                     AS total_eoh_amt,
--        t.sales_cost                                                  AS sales_cost,
--        @data_source_code                                             AS data_source_code


FROM
(
        SELECT  fgen.bu_id                                            AS display_org_hierarchy_id,
                ih.name                                               AS item_hierarchy_name,
                fgen.valuation_cat_id                                 AS item_hierarchy_id,
                @business_date                          AS business_date,
                i.name + CASE WHEN ISNULL(fgen.wac_adjustment,0)>0 
                              THEN ' **'
                              ELSE ''
                         END                                          AS item_name,
                i.item_id                                             AS item_id,
                uom.name                                              AS uom,

                CASE      @business_date
                  WHEN    fgen.start_business_date 
                    THEN  fgen.begin_onhand_qty
                  ELSE    fgen.end_onhand_qty 
                END / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS boh,
                ---------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  (fgen.recv_qty - fgen.return_qty) / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS purch,
                ---------------------------------------------------------------|  

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.xfer_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS trans,
                ---------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  (fgen.adjust_qty - fgen.waste_qty + fgen.production_qty)
                            / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS adj,
                ----------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.count_variance_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0
                END                                                   AS variance,
                -----------------------------------------------------------------|

                CASE      @business_date
                  WHEN    fgen.start_business_date
                    THEN  fgen.sales_qty / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                  ELSE    0                                           
                END                                                   AS usage,
                -----------------------------------------------------------------|

                COALESCE(fgen.end_onhand_qty, 0)
                  / COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)          
                                                                      AS eoh,

                COALESCE(fgen.closing_weighted_average_cost, 0)
                  * COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS wac,

                COALESCE(fgen.opening_weighted_average_cost, 0)
                  * COALESCE(iuc.atomic_conversion_factor * uom.factor, uom.factor)
                                                                      AS open_wac,

                COALESCE(fgen.end_onhand_qty, 0) * COALESCE(fgen.closing_weighted_average_cost, 0)
                                                                      AS eoh_amt,

                COALESCE(fgen.sales_qty, 0) * COALESCE(fgen.closing_weighted_average_cost, 0)
                                                                      AS sales_cost
    
        FROM
        (
                SELECT  fgen.bu_id                                    AS bu_id,
                        fgen.inventory_item_id                        AS inventory_item_id,
                        fgen.valuation_cat_id                         AS valuation_cat_id,
                        fgen.start_business_date                      AS start_business_date,
                        '12/31/2075'                                  AS end_business_date,
                        fgen.begin_onhand_qty                         AS begin_onhand_qty,
                        fgen.end_onhand_qty                           AS end_onhand_qty,
                        fgen.recv_qty                                 AS recv_qty,
                        fgen.return_qty                               AS return_qty,
                        fgen.xfer_qty                                 AS xfer_qty,
                        fgen.adjust_qty                               AS adjust_qty,
                        fgen.waste_qty                                AS waste_qty,
                        fgen.production_qty                           AS production_qty,
                        fgen.count_variance_qty                       AS count_variance_qty,
                        fgen.sales_qty                                AS sales_qty,
                        fgen.closing_weighted_average_cost            AS closing_weighted_average_cost,
                        fgen.opening_weighted_average_cost            AS opening_weighted_average_cost,
                        fgen.wac_adjustment                           AS wac_adjustment

                FROM    @new_f_gen_inv_item_activity_bu_day               fgen    
                
                UNION ALL

                SELECT  fgen.bu_id                                    AS bu_id,
                        fgen.inventory_item_id                        AS inventory_item_id,
                        fgen.valuation_cat_id                         AS valuation_cat_id,
                        fgen.start_business_date                      AS start_business_date,
                        fgen.end_business_date                        AS end_business_date,
                        fgen.end_onhand_qty                           AS begin_onhand_qty,
                        fgen.end_onhand_qty                           AS end_onhand_qty,
                        0                                             AS recv_qty,
                        0                                             AS return_qty,
                        0                                             AS xfer_qty,
                        0                                             AS adjust_qty,
                        0                                             AS waste_qty,
                        0                                             AS production_qty,
                        0                                             AS count_variance_qty,
                        0                                             AS sales_qty,
                        fgen.closing_weighted_average_cost            AS closing_weighted_average_cost,
                        fgen.closing_weighted_average_cost            AS opening_weighted_average_cost,
                        0                                             AS wac_adjustment
        
                FROM    VP60_Spwy..dm_f_gen_inv_item_activity_bu_day             fgen
                WHERE   fgen.bu_id                                    = @business_unit_id     
                AND     @business_date                  BETWEEN fgen.start_business_date AND COALESCE(fgen.end_business_date, '12/31/2075')
                AND     @business_date                  <> fgen.start_business_date
                AND NOT EXISTS
                (
                        SELECT  1
                        FROM    @new_f_gen_inv_item_activity_bu_day   nfgen
                        WHERE   nfgen.inventory_item_id               = fgen.inventory_item_id
                )
        ) fgen

        JOIN    VP60_Spwy..item_hierarchy                                        ih
        ON      ih.item_hierarchy_id                                  = fgen.valuation_cat_id

        JOIN    VP60_Spwy..item                                                  i
        ON      i.item_id                                             = fgen.inventory_item_id

		JOIN    @Discontinued_Item                                    di
		ON      i.item_id                                             = di.resolved_item_id

        JOIN    VP60_Spwy..inventory_item                                        ii
        ON      ii.inventory_item_id                                  = fgen.inventory_item_id
        
        LEFT OUTER JOIN VP60_Spwy..inventory_item_bu_list                        iibl
        ON      iibl.inventory_item_id                                = ii.inventory_item_id
        AND     iibl.business_unit_id                                 = fgen.bu_id

        JOIN    VP60_Spwy..unit_of_measure                                       uom
        ON      COALESCE(iibl.default_reporting_uom_id, ii.valuation_uom_id)
                                                                      = uom.unit_of_measure_id

        LEFT OUTER JOIN VP60_Spwy..item_hierarchy_bu_override_list               ihbol
        ON      ihbol.item_hierarchy_id                               = ih.item_hierarchy_id
        AND     ihbol.business_unit_id                                = fgen.bu_id

        LEFT OUTER JOIN VP60_Spwy..item_uom_conversion                           iuc
        ON      iuc.item_id                                           = fgen.inventory_item_id
        AND     iuc.unit_of_measure_class_id                          = uom.unit_of_measure_class_id

        WHERE   COALESCE(ihbol.valuation_method_code, ih.valuation_method_code, @default_valuation_method_code, 'i') 
                                                                      = 'w'
        AND
        (
                        COALESCE(fgen.begin_onhand_qty, 0)            <> 0
                OR      COALESCE(fgen.end_onhand_qty, 0)              <> 0
                OR      fgen.start_business_date                      = @business_date
        )
        
) t

LEFT OUTER JOIN VP60_Spwy..rad_sys_data_accessor                       da
ON      da.data_accessor_id                                           = t.display_org_hierarchy_id

/*  Only applicable to the visible report     
WHERE

(
        COALESCE(t.purch + t.trans, 0)                                <> 0
OR      COALESCE(t.adj, 0)                                            <> 0
OR      COALESCE(t.variance, 0)                                       <> 0
OR      COALESCE(t.usage, 0)                                          <> 0
OR      COALESCE(t.eoh, 0)                                            <> 0
OR      COALESCE(t.wac, 0) - COALESCE(t.open_wac, 0)                  <> 0
OR      COALESCE(t.sales_cost, 0)                                     <> 0
)
*/
ORDER BY t.item_name, t.business_date

------------------------------------------------------------------------------									  
/*  Just for debugging
select @BusinessUnitCode, @Business_Unit_Id, @business_date									  
select * from @discontinued_item
select * from @f_gen_inv_count
select * from @f_gen_inv_receive
select * from @Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
select * from @f_gen_inv_adjustment
select * from @f_gen_inv_transfer
select * from @f_gen_inv_return
select * from @f_gen_inv_rebate_accrual_supplier_item_list
select * from @Inventory_WAC_Adjustment_BU_List
select * from @new_f_gen_inv_item_activity_bu_day
select * from @tmp_agg_sum
*/

END
	