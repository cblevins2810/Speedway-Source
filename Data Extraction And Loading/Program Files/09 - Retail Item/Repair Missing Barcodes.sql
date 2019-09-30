BEGIN TRANSACTION

IF OBJECT_ID('tempdb..#Retail_Modified_Item_Barcode') IS NOT NULL
  DROP TABLE #Retail_Modified_Item_Barcode

CREATE TABLE #Retail_Modified_Item_Barcode(
retail_modified_item_id INT NOT NULL,
barcode_id INT IDENTITY(1,1) NOT NULL,
barcode_type_code NVARCHAR(1) NOT NULL,
barcode_number NVARCHAR(100) NOT NULL,
client_id INT NOT NULL,
last_modified_user_id TINYINT NOT NULL,
last_modified_timestamp SMALLDATETIME NOT NULL
) ON [PRIMARY]

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableId INT 
DECLARE @NextId INT

-- Set client id value
SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client

INSERT #Retail_Modified_Item_Barcode (
retail_modified_item_id,
--barcode_id,
barcode_type_code,
barcode_number,
client_id,
last_modified_user_id,
last_modified_timestamp)

SELECT DISTINCT rmi.retail_modified_item_id,
--bc.barcode_id,
bc.barcode_type_code,
bc.primitive_complete_code,
bc.client_id,
42,
getdate()
--SELECT rmi.name,  rmi.xref_code, '_' + bc.primitive_compressed_code 'Present', '_' + bc.primitive_complete_code 'Missing'
FROM retail_modified_item as rmi
JOIN Retail_Modified_Item_BarCode_List as l
ON   rmi.retail_modified_item_id = rmi.retail_modified_item_id
JOIN BarCode as bc
ON   l.barcode_id = bc.barcode_id
WHERE EXISTS (SELECT 1 
              FROM Retail_Modified_Item_Barcode AS rmibc
			  WHERE bc.primitive_compressed_code = rmibc.barcode_number
			  AND   bc.barcode_type_code = rmibc.barcode_type_code
			  AND   rmibc.retail_modified_item_id = rmi.retail_modified_item_id)
AND NOT EXISTS (SELECT 1 
              FROM Retail_Modified_Item_Barcode AS rmibc
			  WHERE bc.primitive_complete_code = rmibc.barcode_number
			  AND   bc.barcode_type_code = rmibc.barcode_type_code
			  AND   rmibc.retail_modified_item_id = rmi.retail_modified_item_id)

SET @TicketCount = @@RowCount

-- Return the starting value of the next ticket AND allocated an additiON amount based upON the number of manufacturers
exec @NextId = plt_get_next_named_ticket 'Retail_Modified_Item_Barcode','n',@TicketCount

INSERT Retail_Modified_Item_Barcode (
retail_modified_item_id,
barcode_id,
barcode_type_code,
barcode_number,
client_id,
last_modified_user_id,
last_modified_timestamp)

SELECT 
retail_modified_item_id,
@NextId - barcode_id + 1,
barcode_type_code,
barcode_number,
client_id,
last_modified_user_id,
last_modified_timestamp
FROM #Retail_Modified_Item_Barcode

IF OBJECT_ID('tempdb..#Retail_Modified_Item_Barcode') IS NOT NULL
  DROP TABLE #Retail_Modified_Item_Barcode

--select * from retail_modified_item_barcode where barcode_number = '018200000515'

--select * from retail_modified_item where retail_modified_item_id in (50000638,
--50000639)

--SELECT * FROM retail_modified_item_barcode order by barcode_id desc

COMMIT TRANSACTION


