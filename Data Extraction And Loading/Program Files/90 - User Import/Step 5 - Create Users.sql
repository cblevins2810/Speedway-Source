BEGIN TRANSACTION

DECLARE @ClientId INT
DECLARE @TicketCount BIGINT
DECLARE @TableName NVARCHAR(100)
DECLARE @NextId INT
DECLARE @Counter INT
DECLARE @sql NVARCHAR(MAX)

-- Set client id value
SELECT @ClientId = MAX(client_id) FROM Rad_Sys_Client
SELECT @TicketCount = COUNT(*)
FROM bc_extract_user AS u
WHERE NOT EXISTS (SELECT 1
                  FROM rad_sys_user AS u2
				  WHERE u.login_name = u2.login_name)

SET @TableName = 'Rad_Sys_Security_Accessor'
EXEC plt_get_next_named_ticket @TableName,'n', @TicketCount, @NextId OUTPUT

INSERT Rad_Sys_Security_Accessor
(accessor_id,
last_modified_user_id,
last_modified_timestamp,
client_id)

SELECT @NextId - user_id + 1,
42,
GETDATE(),
@ClientId
FROM bc_extract_user AS u
WHERE NOT EXISTS (SELECT 1
                  FROM rad_sys_user AS u2
				  WHERE u.login_name = u2.login_name)
ORDER BY user_id


INSERT rad_sys_user (user_id,
first_name,
middle_name,
last_name,
password,
login_name,
status_code,
last_modified_user_id,
last_modified_timestamp,
date_created,
client_id,
date_status_code_last_changed,
title,
nickname,
auto_collapse_menu_flag,
receives_alerts,
alert_lifetime,
uppercase_password,
forwarding_email_address,
alert_forward_level,
force_password_change,
time_zone_id,
suffix,
report_format,
expand_menu_flag,
default_language_id,
--default_role_id,
--default_org_hierarchy_id,
date_password_last_changed)

SELECT @NextId - user_id + 1,
first_name,
middle_name,
last_name,
password,
login_name,
'a',
42,
GETDATE(),
date_created,
@ClientId,
date_status_code_last_changed,
title,
nickname,
auto_collapse_menu_flag,
receives_alerts,
alert_lifetime,
uppercase_password,
forwarding_email_address,
alert_forward_level,
'y', --force_password_change,
time_zone_id,
suffix,
report_format,
expand_menu_flag,
default_language_id,
--default_role_id,
--default_org_hierarchy_id,
date_password_last_changed

FROM bc_extract_user AS u
WHERE NOT EXISTS (SELECT 1
                  FROM rad_sys_user AS u2
				  WHERE u.login_name = u2.login_name)
ORDER BY user_id


SET @counter = 1

WHILE @counter <= 10
BEGIN

	SET @sql = 'INSERT Rad_Sys_User_Role_List (user_id, role_id, last_modified_user_id, last_modified_timestamp, client_id)
				SELECT u.user_id, u2.role_id' + CONVERT(NVARCHAR(2), @counter) + ',42,GETDATE(), ' + CONVERT(NVARCHAR(10), @ClientId) +
			   'FROM   Rad_Sys_User AS u
			    JOIN   bc_extract_user AS u2
				ON     u.login_name = u2.login_name
				WHERE  u2.role_id' + CONVERT(NVARCHAR(2), @counter) + ' IS NOT NULL ' +
			   'AND    NOT EXISTS (SELECT 1 FROM Rad_Sys_User_Role_List AS l
				                  WHERE  l.user_id = u.user_id
								  AND    l.role_id = u2.role_id' + CONVERT(NVARCHAR(2), @counter) + ')'

	EXECUTE(@sql)
	SET @counter += 1

END

SET @counter = 1


WHILE @counter <= 20
BEGIN

	SET @sql = 'INSERT Rad_Sys_User_Hier_List (user_id, org_hierarchy_id, limit_hierarchy_role_flag, last_modified_user_id, last_modified_timestamp, client_id)
				SELECT u.user_id, u2.org_id' + CONVERT(NVARCHAR(2), @counter) + ',''n'',42,GETDATE(), ' + CONVERT(NVARCHAR(10), @ClientId) +
			   'FROM   Rad_Sys_User AS u
			    JOIN   bc_extract_user AS u2
				ON     u.login_name = u2.login_name
				WHERE  u2.org_id' + CONVERT(NVARCHAR(2), @counter) + ' IS NOT NULL ' +
			   'AND    NOT EXISTS (SELECT 1 FROM Rad_Sys_User_Hier_List AS l
				                  WHERE  l.user_id = u.user_id
								  AND    l.org_hierarchy_id = u2.org_id' + CONVERT(NVARCHAR(2), @counter) + ')'

	EXECUTE(@sql)
	SET @counter += 1

END

UPDATE u
SET    u.default_role_id = u2.default_role_id
FROM   Rad_Sys_User AS u
JOIN   bc_extract_user AS u2
ON     u.login_name = u2.login_name
WHERE  u.default_role_id IS NULL

UPDATE u
SET    u.default_org_hierarchy_id = u2.default_org_hierarchy_id
FROM   Rad_Sys_User AS u
JOIN   bc_extract_user AS u2
ON     u.login_name = u2.login_name
WHERE  u.default_org_hierarchy_id IS NULL

SELECT * FROM Rad_Sys_User ORDER BY last_modified_timestamp DESC
SELECT * FROM Rad_Sys_User_Role_List ORDER BY last_modified_timestamp DESC
SELECT * FROM Rad_Sys_User_Hier_List ORDER BY last_modified_timestamp DESC

ROLLBACK TRANSACTION
