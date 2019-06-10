BEGIN TRANSACTION

IF OBJECT_ID('tempdb..#Manufacturer') IS NOT NULL
  DROP TABLE #Manufacturer

CREATE TABLE #Manufacturer(
	manufacturer_id int IDENTITY(1,1) NOT NULL,
	name nvarchar(50) NOT NULL,
	manufacturer_number nvarchar(50) NULL
) ON [PRIMARY]
GO

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT

-- Set client id value
SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

-- Save prior values
UPDATE 	repair
SET    	repair.prior_manufacturer_id = ii.manufacturer_id
FROM   	bc_extract_repair_manufacturer_and_strategy AS repair
JOIN 	inventory_item AS ii
ON   	ii.inventory_item_id = repair.item_id

-- This is a complete reset of manufacturer data for any item in the repair table
UPDATE ii
SET Manufacturer_id = NULL
FROM inventory_item AS ii
JOIN bc_extract_repair_manufacturer_and_strategy AS r
ON   ii.inventory_item_id = r.item_id
WHERE client_id = @ClientId

SELECT @@ROWCOUNT, 'Manuafacturers reset to null'

-- Resolve manufacturer_id values based upon imported repair values
UPDATE repair
SET    repair.manufacturer_id = m.manufacturer_id
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   manufacturer AS m
ON     repair.manufacturer = m.name

SELECT @@ROWCOUNT, 'Manuafacturers resolved (First Pass)'

-- If there are any unknown manufacturers in the data, create them
IF (SELECT COUNT(*)
	FROM bc_extract_repair_manufacturer_and_strategy
	WHERE Manufacturer_id IS NULL AND Manufacturer IS NOT NULL) > 0

BEGIN
	
	SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

	INSERT #Manufacturer (name) 
	SELECT DISTINCT Manufacturer
	FROM   bc_extract_repair_manufacturer_and_strategy
	WHERE  Manufacturer_id IS NULL
	AND    Manufacturer IS NOT NULL

	SET @TicketCount = @@RowCount

	SELECT @TableId = table_id
	FROM Rad_Sys_Table
	WHERE name = 'Manufacturer'
	AND db_id = 1

	-- Return the starting value of the next ticket and allocated an addition amount based upon the number of manufacturers
	EXEC sp_get_next_ticket @TableId, 'n',  @TicketCount, @NextId OUTPUT

	INSERT manufacturer (manufacturer_id,
	name,
	manufacturer_number,
	last_modified_user_id,
	last_modified_timestamp,
	cdm_owner_id,
	client_id)
	SELECT @NextId - manufacturer_id + 1,
	name,
	NULL,
	42,
	GETDATE(),
	@ClientId,
	@ClientId
	FROM #Manufacturer

	SELECT @@ROWCOUNT, 'New Manufacturers Created'

END

-- Resolve again after creating new manufacturers
UPDATE repair	
SET    repair.manufacturer_id = m.manufacturer_id
FROM   bc_extract_repair_manufacturer_and_strategy AS repair
JOIN   manufacturer AS m
ON     repair.manufacturer = m.name
WHERE  repair.manufacturer_id IS NULL 
AND    repair.manufacturer IS NOT NULL

SELECT @@ROWCOUNT, 'Manuafacturers resolved (Second Pass)'

-- This should resolve all manufacturers based upon repair values
UPDATE ii
SET  ii.manufacturer_id = repair.manufacturer_id
FROM inventory_item AS ii
JOIN item AS i
ON   ii.inventory_item_id = i.item_id
JOIN bc_extract_repair_manufacturer_and_strategy AS repair
ON   repair.item_id = i.item_id
WHERE repair.manufacturer_id IS NOT NULL 
AND   ii.manufacturer_id IS NULL 

SELECT @@ROWCOUNT, 'Items assigned manufacturer'

SELECT * FROM bc_extract_repair_manufacturer_and_strategy

IF OBJECT_ID('tempdb..#Manufacturer') IS NOT NULL
  DROP TABLE #Manufacturer 

ROLLBACK TRANSACTION

  
