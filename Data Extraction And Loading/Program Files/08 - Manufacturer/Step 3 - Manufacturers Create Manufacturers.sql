/*  
	Create Manufacturers 
	Nov 2018
	
	This script will create manufacturers using a de-normalized import table.
	
*/

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

SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

INSERT #Manufacturer (name,manufacturer_number) 
SELECT name, manufacturer_number
FROM bc_extract_Manufacturer

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
manufacturer_number,
42,
GETDATE(),
@ClientId,
@ClientId
FROM #Manufacturer

IF OBJECT_ID('tempdb..#Manufacturer') IS NOT NULL
  DROP TABLE #Manufacturer

