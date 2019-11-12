DECLARE @TicketCount INT
DECLARE @TableId INT
DECLARE @Counter INT
DECLARE @sql NVARCHAR(MAX)

BEGIN TRANSACTION

/*
IF OBJECT_ID('bc_extract_user_address') IS NOT NULL
  DROP TABLE bc_extract_user_address
  
CREATE TABLE bc_extract_user_address (
address_id int NOT NULL,
client_id int NOT NULL,
name nvarchar(50) NULL,
address_mnemonic nvarchar(20) NULL,
address_line_1 nvarchar(50) NULL,
address_line_2 nvarchar(50) NULL,
city nvarchar(50) NULL,
state_code nvarchar(2) NULL,
country_code nvarchar(2) NULL,
postal_code nvarchar(10) NULL,
last_modified_user_id int NOT NULL,
last_modified_timestamp datetime NOT NULL,
home_phone nvarchar(25) NULL,
work_phone nvarchar(25) NULL,
cell_phone nvarchar(25) NULL,
pager nvarchar(25) NULL,
e_mail nvarchar(255) NULL,
fax_number nvarchar(25) NULL,
data_guid uniqueidentifier NULL,
auto_po_fax_number nvarchar(25) NULL,
county nvarchar(50) NULL,
state_id int NULL,
country_id int NULL)
*/

/* 
Not supporting addresses at this time
SET @TicketCount = @@RowCount

SELECT @TableId = table_id
FROM Rad_Sys_Table
WHERE name = 'Address'
AND db_id = 1
*/

/*
Just pull id's from BC
UPDATE u
SET time_zone_id = tz.time_zone_id
FROM bc_extract_user AS u
JOIN time_zone AS tz
ON  u.time_zone_name = tz.MS_name
*/

-- Resolve the org and role id values
SET @counter = 1

WHILE @counter <= 10
BEGIN

	SET @sql = 'UPDATE u
				SET u.role_id' + CONVERT(NVARCHAR(2), @counter) + '= r.role_id
				FROM bc_extract_user AS u
				JOIN rad_sys_role AS r
				ON   u.role_name' + CONVERT(NVARCHAR(2), @counter) + '= r.name'

	EXECUTE(@sql)
	SET @counter += 1
END

SET @counter = 1

WHILE @counter <= 20
BEGIN

	SET @sql = 'UPDATE u
				SET u.org_id' + CONVERT(NVARCHAR(2), @counter) + '= rsda.data_accessor_id
				FROM bc_extract_user AS u
				JOIN rad_sys_data_accessor AS rsda
				ON   u.org_code' + CONVERT(NVARCHAR(2), @counter) + '= rsda.name'

	EXECUTE(@sql)
	SET @counter += 1
END

/*
IF OBJECT_ID('bc_extract_user_address') IS NOT NULL
  DROP TABLE bc_extract_user_address
*/
  
SELECT * FROM bc_extract_user

COMMIT TRANSACTION
  