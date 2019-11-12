
SET NOCOUNT ON

/*
-----------------------------------------------------------------------
--- Declare Variables
-----------------------------------------------------------------------
*/

-- Temp Table variable to hold BU/Item list
DECLARE @gcsItemList table
(
	log_seq						INT IDENTITY(1,1) NOT NULL,	-- Sequence number
	retail_item_id				INT NOT NULL,				-- Gift Card item ID
	retail_item_name			NVARCHAR(100) NOT NULL,		-- Gift Card item name
	retail_modified_item_id		INT NOT NULL,				-- Gift Card RMI ID
	item_id						INT NOT NULL,				-- Tracked Inventory item ID
	item_name					NVARCHAR(100) NOT NULL,		-- Tracked Inventory item name
	depletion_id				INT NOT NULL DEFAULT 0		-- Depletion ID
)

 
-- Other Variables
DECLARE	@ClientId			INT
DECLARE	@NumberOfTickets	INT
DECLARE	@NextTicket			INT

/*
-----------------------------------------------------------------------
--- Initialize Variables
-----------------------------------------------------------------------
*/
SELECT	@ClientId			= MAX(client_id) FROM VP60_eso.dbo.RAD_SYS_Client
SET		@NumberOfTickets	= 0
SET		@NextTicket			= 0

/*
-----------------------------------------------------------------------
--- Determine List of Items
-----------------------------------------------------------------------
*/

INSERT INTO	@gcsItemList
			(
				retail_item_id,
				retail_item_name,
				retail_modified_item_id,
				item_id,
				item_name
			)
SELECT		i2.item_id, i2.name, rmi.retail_modified_item_id, i1.item_id, i1.name
FROM		VP60_eso.dbo.item AS i1
JOIN		VP60_eso.dbo.item AS i2
ON			i1.xref_code = CAST(i2.item_id AS NVARCHAR)
JOIN		VP60_eso.dbo.retail_item AS ri
ON			i2.item_id = ri.retail_item_id
-- Only include Gift Card Activation 
AND			ri.retail_item_type_code IN ('s')
JOIN		VP60_eso.dbo.retail_modified_item AS rmi
ON			ri.retail_item_id = rmi.retail_item_id
WHERE		i1.xref_code != CAST(i1.item_id AS NVARCHAR)
-- Only include if no entry in table: retail_item_depletion_list
AND			NOT EXISTS
			(
				SELECT	1
				FROM	VP60_eso.dbo.retail_item_depletion_list AS ridl
				WHERE	ridl.retail_item_id	= i2.item_id
				AND		ridl.item_id		= i1.item_id
				AND		ridl.client_id		= @ClientId
			)
-- Only include if no entry in table: rmi_depletion_item_list
AND			NOT EXISTS
			(
				SELECT	1
				FROM	VP60_eso.dbo.rmi_depletion_item_list AS rmidil
				WHERE	rmidil.retail_item_id			= i2.item_id
				AND		rmidil.retail_modified_item_id	= rmi.retail_modified_item_id
				AND		rmidil.item_id					= i1.item_id
				AND		rmidil.client_id				= @ClientId
			)
-- Only include if no entry in table: sales_item_inventory_depletion_list
AND			NOT EXISTS
			(
				SELECT	1
				FROM	VP60_eso_wh.dbo.sales_item_inventory_depletion_list AS siidl
				WHERE	siidl.sales_item_id		= rmi.retail_modified_item_id
				AND		siidl.inventory_item_id	= i1.item_id
				AND		siidl.data_accessor_id	= @ClientId
			)

-- Set number of tickets needed
SET	@NumberOfTickets = @@ROWCOUNT

/*
-----------------------------------------------------------------------
--- START: Item config for Gift Cards
-----------------------------------------------------------------------
*/

IF (@NumberOfTickets) > 0
BEGIN
	--Return the starting value of the next ticket and allocated an additional amount based upon the number of records
	EXEC VP60_eso.dbo.plt_get_next_named_ticket 'rmi_depletion_item_list','n', @NumberOfTickets, @NextTicket OUTPUT
	-- Add depletion ID to records
	UPDATE	@gcsItemList
	SET		depletion_id = @NextTicket - @NumberOfTickets + log_seq
	/*
	-----------------------------------------------------------------------
	--- START: Insert rows for table: retail_item_depletion_list
	-----------------------------------------------------------------------
	*/
	INSERT	VP60_eso.dbo.Retail_Item_Depletion_List
		(
			retail_item_id,
			item_id,
			unit_of_measure_id,
			client_id,
			last_modified_user_id,
			last_modified_timestamp
		)
	SELECT	
			retail_item_id,
			item_id,
			3,
			@ClientId,
			42,
			GETDATE()
	FROM	@gcsItemList
	/*
	-----------------------------------------------------------------------
	--- END: Insert rows for table: retail_item_depletion_list
	-----------------------------------------------------------------------
	*/
	/*
	-----------------------------------------------------------------------
	--- START: Insert rows for table: rmi_depletion_item_list
	-----------------------------------------------------------------------
	*/
	INSERT	VP60_eso.dbo.rmi_depletion_item_list
		(
			retail_item_id,
			item_id,
			retail_modified_item_id,
			depletion_id,
			quantity,
			client_id,
			last_modified_user_id,
			last_modified_timestamp
		)
	SELECT	
			retail_item_id,
			item_id,
			retail_modified_item_id,
			depletion_id,
			1,
			@ClientId,
			42,
			GETDATE()
	FROM	@gcsItemList
	/*
	-----------------------------------------------------------------------
	--- END: Insert rows for table: rmi_depletion_item_list
	-----------------------------------------------------------------------
	*/
	/*
	-----------------------------------------------------------------------
	--- START: Insert rows for table: sales_item_inventory_depletion_list
	-----------------------------------------------------------------------
	*/
	INSERT	VP60_eso_wh.dbo.sales_item_inventory_depletion_list
		(
			sales_item_id,
			inventory_item_id,
			data_accessor_id,
			sales_dest_id,
			atomic_depletion_quantity,
			depletion_id,
			start_date,
			end_date
		)
	SELECT
			rmidil.retail_modified_item_id,
			rmidil.item_id,
			rmidil.client_id,
			0,
			rmidil.quantity,
			rmidil.depletion_id,
			'1900-01-01',
			'2075-12-31'
	FROM	VP60_eso.dbo.rmi_depletion_item_list	AS	rmidil
	JOIN	@gcsItemList							AS	itmList
	ON		rmidil.retail_item_id			= itmList.retail_item_id
	AND		rmidil.item_id					= itmList.item_id
	AND		rmidil.retail_modified_item_id	= itmList.retail_modified_item_id
	/*
	-----------------------------------------------------------------------
	--- END: Insert rows for table: sales_item_inventory_depletion_list
	-----------------------------------------------------------------------
	*/
END
/*
-----------------------------------------------------------------------
--- END: Item config for Gift Cards
-----------------------------------------------------------------------
*/


