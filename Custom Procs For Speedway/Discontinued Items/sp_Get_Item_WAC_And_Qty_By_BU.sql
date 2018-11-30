/*
IF OBJECT_ID('discontinued_item') IS NOT NULL
	DROP TYPE discontinued_item 
GO

CREATE TYPE discontinued_item AS TABLE (
		xref_code NVARCHAR(100) NOT NULL,
		resolved_item_id INT NULL)
GO		
*/
DECLARE @current_business_date SMALLDATETIME
DECLARE @Business_Unit_Id INT
DECLARE @iDoc INT
DECLARE @discontinued_item discontinued_item 

/*TABLE (
		xref_code NVARCHAR(100) NOT NULL,
		resolved_item_id INT NULL)
*/
DECLARE @XMLInput AS NVARCHAR(MAX)

IF (OBJECT_ID('tempdb..#new_f_gen_inv_item_activity_bu_day') IS NOT NULL)   DROP TABLE #new_f_gen_inv_item_activity_bu_day
IF (OBJECT_ID('tempdb..#tmp_bu_day_count') IS NOT NULL)                     DROP TABLE #tmp_bu_day_count
IF (OBJECT_ID('tempdb..#f_gen_inv_count') IS NOT NULL)                      DROP TABLE #f_gen_inv_count
IF (OBJECT_ID('tempdb..#f_gen_inv_receive') IS NOT NULL)                    DROP TABLE #f_gen_inv_receive
IF (OBJECT_ID('tempdb..#f_gen_inv_adjustment') IS NOT NULL)                 DROP TABLE #f_gen_inv_adjustment
IF (OBJECT_ID('tempdb..#f_gen_inv_transfer') IS NOT NULL)                   DROP TABLE #f_gen_inv_transfer
IF (OBJECT_ID('tempdb..#f_gen_inv_return') IS NOT NULL)                     DROP TABLE #f_gen_inv_return
IF (OBJECT_ID('tempdb..#f_gen_inv_rebate_accrual_supplier_item_list') IS NOT NULL) DROP TABLE #f_gen_inv_rebate_accrual_supplier_item_list
IF (OBJECT_ID('tempdb..#f_gen_inv_rebate_accrual_rmi_list') IS NOT NULL)    DROP TABLE #f_gen_inv_rebate_accrual_rmi_list
IF (OBJECT_ID('tempdb..#f_gen_sales_item_dest_bu_day') IS NOT NULL)         DROP TABLE #f_gen_sales_item_dest_bu_day
IF (OBJECT_ID('tempdb..#Inventory_WAC_Adjustment_BU_List') IS NOT NULL)     DROP TABLE #Inventory_WAC_Adjustment_BU_List
IF (OBJECT_ID('tempdb..#Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC') IS NOT NULL) DROP TABLE #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC

CREATE TABLE #new_f_gen_inv_item_activity_bu_day
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

CREATE TABLE #tmp_bu_day_count
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
CREATE TABLE #f_gen_inv_count
(
        item_count_id                       INT,
        inventory_item_id                   INT,
        timestamp                           DATETIME,
        atomic_count_qty                    NUMERIC(28,10),
        frequency_code                      NCHAR(1),

        PRIMARY KEY (inventory_item_id, item_count_id)
)

CREATE TABLE #f_gen_inv_receive
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

CREATE TABLE #f_gen_inv_adjustment
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

CREATE TABLE #f_gen_inv_transfer
(
        inventory_transfer_id               INT,
        inventory_item_id                   INT,
        timestamp                           DATETIME,
        transfer_type_code                  NCHAR(1),
        atomic_transfer_qty                 NUMERIC(28,10),
        atomic_cost                         NUMERIC(28,10),

        PRIMARY KEY (inventory_item_id, inventory_transfer_id)
)

CREATE TABLE #f_gen_inv_return
(
        return_id                           INT,
        supplier_item_id                    INT,
        inventory_item_id                   INT,
        return_date                         DATETIME,
        atomic_qty                          NUMERIC(28,10),
  
        PRIMARY KEY (inventory_item_id, supplier_item_id, return_id)
)

CREATE TABLE #f_gen_inv_rebate_accrual_supplier_item_list
(
        item_id                                       INT,
        non_retroactive_non_withheld_rebate_amt       NUMERIC(28,10),
        retroactive_non_withheld_rebate_amt           NUMERIC(28,10),
        withheld_rebate_amt                           NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

CREATE TABLE #f_gen_inv_rebate_accrual_rmi_list
(
        item_id                                       INT,
        non_withheld_rebate_amt                       NUMERIC(28,10),
        withheld_rebate_amt                           NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

CREATE TABLE #f_gen_sales_item_dest_bu_day
(
        item_id                                       INT,
        net_sales_amt                                 NUMERIC(28,10),

        PRIMARY KEY (item_id)
)

CREATE TABLE #Inventory_WAC_Adjustment_BU_List
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

CREATE TABLE #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        received_id                         INT,
        supplier_item_id                    INT,
        inventory_item_id                   INT,
        discrepancy_adj_amt                 NUMERIC(28,10),
        reconciled_date                     datetime,

        PRIMARY KEY (inventory_item_id, received_id, supplier_item_id)
)

-- Test Data Only
SET @current_business_date = GETDATE()
SET @Business_Unit_Id = 1000397

SET @XMLInput = N'<DiscontinuedItemList>
       <Item ItemExternalID="114308"/>
	   <Item ItemExternalID="114314"/>
	   <Item ItemExternalID="114322"/>
</DiscontinuedItemList>'

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
JOIN Item As i
ON   i.xref_code = di.xref_code

-- Remove any invalid items
DELETE @discontinued_item
WHERE  resolved_item_id IS NULL

-- Get the counts for the current business date
INSERT INTO #f_gen_inv_count 
(
        item_count_id,
        inventory_item_id,
        timestamp,
        atomic_count_qty,
        frequency_code  
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Count @Business_Unit_Id, @current_business_date, @discontinued_item

-- Get the receivings for the current business date (non shipper)
INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Recv @Business_Unit_Id, @current_business_date, @discontinued_item

-- Receivings (shipper) which are received and reconciled on the same day
INSERT  #f_gen_inv_receive
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        recv_date,
        atomic_qty,
        atomic_free_quantity,
        atomic_cost
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Recv_Shipper @Business_Unit_Id, @current_business_date, @discontinued_item

-- Receivings (shipper, non-shipper) which are received and reconciled on different business date
INSERT  #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
(
        inventory_item_id,
        received_id,
        supplier_item_id,
        discrepancy_adj_amt,
        reconciled_date
) 
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Invc_Recon @Business_Unit_Id, @current_business_date, @discontinued_item

-- Adjustments
INSERT  #f_gen_inv_adjustment
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
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Adj @Business_Unit_Id, @current_business_date, @discontinued_item

-- Transfers
INSERT  #f_gen_inv_transfer
(
        inventory_transfer_id,
        inventory_item_id,
        timestamp,
        transfer_type_code,
        atomic_transfer_qty,
        atomic_cost
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Xfer @Business_Unit_Id, @current_business_date, @discontinued_item

-- Returns (non-shipper and shipper)
INSERT  #f_gen_inv_return
(
        return_id,
        supplier_item_id,
        inventory_item_id,
        return_date,
        atomic_qty
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Return @Business_Unit_Id, @current_business_date, @discontinued_item

-- Rebate amts from purchase based rebates
INSERT  #f_gen_inv_rebate_accrual_supplier_item_list
(
        item_id,
        non_retroactive_non_withheld_rebate_amt
)
EXEC sp_Get_Item_WAC_And_Qty_By_BU_Rebate @Business_Unit_Id, @current_business_date, @discontinued_item

INSERT #Inventory_WAC_Adjustment_BU_List (
       wac_adjustment_id,
       inventory_item_id,
       atomic_cost,
       active_flag,
       valuation_cat_id     
     )
EXEC sp_Get_Item_WAC_And_Qty_By_BU_WAC_Adj @Business_Unit_Id, @current_business_date, @discontinued_item


select * from @discontinued_item
select * from #f_gen_inv_count
select * from #f_gen_inv_receive
select * from #Inv_Reconciliation_Discrepancy_Adj_Amt_For_WAC
select * from #f_gen_inv_adjustment
select * from #f_gen_inv_transfer
select * from #f_gen_inv_return
select * from #f_gen_inv_rebate_accrual_supplier_item_list

 