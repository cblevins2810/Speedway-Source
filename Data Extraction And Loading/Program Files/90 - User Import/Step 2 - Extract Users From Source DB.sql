DECLARE @counter INT
DECLARE @sql NVARCHAR(MAX)

IF OBJECT_ID('tempdb..#user_role_distinct') IS NOT NULL
  DROP TABLE #user_role_distinct

IF OBJECT_ID('tempdb..#user_role') IS NOT NULL
  DROP TABLE #user_role
  
IF OBJECT_ID('tempdb..#user_org') IS NOT NULL
  DROP TABLE #user_org

IF OBJECT_ID('bcssa_custom_integration..bc_extract_user') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_user

CREATE TABLE #user_role_distinct
(user_id INT NOT NULL,
 role_name NVARCHAR(100) NOT NULL)
  
CREATE TABLE #user_role
(sequence INT,
 user_id INT NOT NULL,
 role_name NVARCHAR(100) NOT NULL)

CREATE TABLE #user_org
(sequence INT,
 user_id INT NOT NULL,
 org_id INT NOT NULL,
 org_code NVARCHAR(100) NOT NULL)
 
CREATE TABLE bcssa_custom_integration..bc_extract_user (
user_id INT NOT NULL IDENTITY (1,1),
internal_user_id INT NOT NULL,
first_name NVARCHAR(30) NOT NULL,
middle_name NVARCHAR(30) NULL,
last_name NVARCHAR(30) NOT NULL,
password NCHAR(11) NOT NULL,
login_name NVARCHAR(50) NOT NULL,
--status_code NCHAR(1) NOT NULL,
--last_modified_user_id INT NOT NULL,
--last_modified_timestamp DATETIME NOT NULL,
date_created DATETIME NOT NULL,
--client_id INT NOT NULL,
date_status_code_last_changed DATETIME NOT NULL,
title NVARCHAR(255) NULL,
nickname NVARCHAR(30) NULL,
auto_collapse_menu_flag NCHAR(1) NULL,
receives_alerts NCHAR(1) NULL,
alert_lifetime INT NULL,
uppercase_password NCHAR(11) NULL,
forwarding_email_address NVARCHAR(255) NULL,
alert_forward_level NCHAR(1) NULL,
force_password_change NCHAR(1) NULL,
time_zone_id INT NULL,
time_zone_name NVARCHAR(100) NULL,
suffix NCHAR(10) NULL,
report_format NCHAR(1) NULL,
expand_menu_flag NCHAR(1) NULL,
default_language_id INT NULL,
default_role_id INT NULL,
default_role_name NVARCHAR(100),
default_org_hierarchy_id INT NULL,
default_org_hiearchhy_name NVARCHAR(100),
date_password_last_changed DATETIME NOT NULL,
address_id INT NULL,
address_name nvarchar(50) NULL,
address_mnemonic nvarchar(20) NULL,
address_line_1 nvarchar(50) NULL,
address_line_2 nvarchar(50) NULL,
city nvarchar(50) NULL,
state_code nvarchar(2) NULL,
country_code nvarchar(2) NULL,
postal_code nvarchar(10) NULL,
home_phone nvarchar(25) NULL,
work_phone nvarchar(25) NULL,
cell_phone nvarchar(25) NULL,
pager nvarchar(25) NULL,
e_mail nvarchar(255) NULL,
fax_number nvarchar(25) NULL,
state_id int NULL,
country_id int NULL,
role_name1 NVARCHAR(100) NULL,
role_id1 INT NULL,
role_name2 NVARCHAR(100) NULL,
role_id2 INT NULL,
role_name3 NVARCHAR(100) NULL,
role_id3 INT NULL,
role_name4 NVARCHAR(100) NULL,
role_id4 INT NULL,
role_name5 NVARCHAR(100) NULL,
role_id5 INT NULL,
role_name6 NVARCHAR(100) NULL,
role_id6 INT NULL, 
role_name7 NVARCHAR(100) NULL,
role_id7 INT NULL,
role_name8 NVARCHAR(100) NULL,
role_id8 INT NULL,
role_name9 NVARCHAR(100) NULL,
role_id9 INT NULL,
role_name10 NVARCHAR(100) NULL,
role_id10 INT NULL,
org_code1 NVARCHAR(100) NULL,
org_id1 INT NULL,
org_code2 NVARCHAR(100) NULL,
org_id2 INT NULL,
org_code3 NVARCHAR(100) NULL,
org_id3 INT NULL,
org_code4 NVARCHAR(100) NULL,
org_id4 INT NULL,
org_code5 NVARCHAR(100) NULL,
org_id5 INT NULL,
org_code6 NVARCHAR(100) NULL,
org_id6 INT NULL, 
org_code7 NVARCHAR(100) NULL,
org_id7 INT NULL,
org_code8 NVARCHAR(100) NULL,
org_id8 INT NULL,
org_code9 NVARCHAR(100) NULL,
org_id9 INT NULL,
org_code10 NVARCHAR(100) NULL,
org_id10 INT NULL,
org_code11 NVARCHAR(100) NULL,
org_id11 INT NULL,
org_code12 NVARCHAR(100) NULL,
org_id12 INT NULL,
org_code13 NVARCHAR(100) NULL,
org_id13 INT NULL,
org_code14 NVARCHAR(100) NULL,
org_id14 INT NULL,
org_code15 NVARCHAR(100) NULL,
org_id15 INT NULL,
org_code16 NVARCHAR(100) NULL,
org_id16 INT NULL, 
org_code17 NVARCHAR(100) NULL,
org_id17 INT NULL,
org_code18 NVARCHAR(100) NULL,
org_id18 INT NULL,
org_code19 NVARCHAR(100) NULL,
org_id19 INT NULL,
org_code20 NVARCHAR(100) NULL,
org_id20 INT NULL)

/* The distinct table exists because more that one bc role can map to a single eso role */
INSERT #user_role_distinct (user_id, role_name)
SELECT DISTINCT
u.user_id,
m.eso_role
FROM   Rad_Sys_User_Role_List AS l
JOIN   rad_sys_user AS u
ON     l.user_id = u.user_id
JOIN   Rad_Sys_Role as r
ON     l.role_id = r.role_id 
LEFT JOIN bcssa_custom_integration.dbo.bc_extract_user_role_mapping AS m
ON     r.name = m.bc_role
WHERE  u.status_code <> 'i'
AND    u.user_id >= 1000000
AND    r.name IN (SELECT bc_role 
                  FROM   bcssa_custom_integration.dbo.bc_extract_user_role_mapping AS m
				  WHERE  r.name = m.bc_role)
-- List of users from Shawn
AND    u.login_name IN ('639013',
'397391',
'200104',
'856754',
'882150',
'889078',
'897351',
'925159',
'939246',
'946136',
'947662',
'957455',
'967017',
'968985',
'967889',
'5040927',
'996509',
'1029933',
'1031725',
'1061432',
'1072636',
'1074381',
'1081664',
'1084162',
'1105365',
'1118404',
'1119760',
'1149012',
'1149011',
'1150486',
'1150981',
'1150735',
'1152968',
'1035027',
'1168642',
'KI91',
'1173885',
'1173673')

INSERT #user_role (sequence, user_id, role_name)
SELECT  DISTINCT ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY u.user_id, u.role_name), 
u.user_id,
u.role_name
FROM   #user_role_distinct AS u

/*  This list was manually created by me, but has been superceeded by a list provided by the pricebook team
'BlueCube Admin',
'Client Admin',
--'Store Manager',
--'Worker',
--'Above Store Manager',
'Web Clock Attendant',
'Software Deployment Admin',
'CAT Operator',
--'Web Pos Operator',
--'Web Pos Manager',
'Radiant SIG',
'Radiant Client Management',
--'Cashier',
'BlueCube Admin Support',
'BlueCube Admin User Setup',
'BlueCube Admin Support 2',
--'ZZZ Old role',
--'zzz-OLD-Supply Chain Manager-DO NOT USE',
--'zzz-OLD-Supply Chain Analyst C3(inactive)-D/N USE',
'Speedway Admin',
--'zzz-OLD-Supply Chain Analyst-DO NOT USE',
--'zzz-OLD-Pricebook Manager C3 (inactive)-DO NOT USE',
'Speedway Pricebook Manager',
'Speedway Pricebook Analyst',
--'zzz-OLD-Supply Chain (Validation)-DO NOT USE',
'Speedway Pricebook Supreme',
'Speedway System Monitoring',
'Speedway Store Support Team Lead',
'Speedway Supply Chain Manager',
'Speedway Supply Chain Analyst',
--'zzzSSA F I M S',
--'zzz-OLD-RPP2-DO NOT USE',
--'Speedway District Manager',
--'zSpeedway PW Reset',
--'zzz-SSA Fuel Item',
--'zzz-OLD-SSA CSR-DO NOT USE',
'Speedway Accounting',
--'zzz-OLD-SSA CSR2-DO NOT USE',
--'SSA Food Steward',
--'SSA Store Manager',
--'SSA Shift Leader',
--'Speedway Field Auditor',
--'Speedway Field Marketing Coordinator',
--'Speedway Region Director',
--'Speedway Region Manager',
'Speedway Employee Setup',
'SSA CSR',
'SSA CSR2',
--'zSpeedway DMT (Cycle 1 ONLY)',
'Speedway Planning & Analysis',
'Speedway Operations Project Manager',
'Speedway Accounting Corrections',
'Speedway Category Manager',
--'Inactive',
'Speedway Region Sales Coordinator',
'Speedway ADMIN READ ONLY',
'Speedway Store Support',
'Speedway Safety & Security',
'Speedway Environmental',
--'SSA Store Co-Manager',
'Speedway Store Support Analyst',
--'Speedway Field Auditor Supervisor',
'Speedway Deploy Team',
'Speedway Inventory Manager',
'Speedway Credit',
'Speedway Fuel Pricing Analyst',
'Speedway Downloads',
'Speedway Supply Chain Management',
'Speedway Marketing Read Only',
'Speedway FIMS',
'Speedway Planogram Analyst',
'Speedway Corporate Auditor',
--'Franchise General Manager',
--'Franchise Co-Manager',
--'Franchise CSR',
--'Franchise Owner',
--'Franchise District Manager',
'Speedway Purchasing Manager')
*/

INSERT #user_org (sequence, user_id, org_id, org_code)
SELECT  ROW_NUMBER() OVER (PARTITION BY l.user_id ORDER BY l.user_id, rsda.name), 
l.user_id,
l.org_hierarchy_id,
CASE WHEN rsda.name = 'SSA' THEN 'Speedway' ELSE rsda.name END
FROM   Rad_Sys_User_Hier_List AS l
JOIN   Rad_Sys_Data_Accessor AS rsda
ON     l.org_hierarchy_id = rsda.data_accessor_id
WHERE NOT EXISTS (SELECT 1
                  FROM business_unit AS bu
                  WHERE l.org_hierarchy_id = bu.business_unit_id)
AND   EXISTS      (SELECT 1
                   FROM  #user_role AS u
                   WHERE l.user_id = u.user_id )  

/*
SELECT * FROM #user_role
ORDER by user_id desc

SELECT COUNT(*), user_id
FROM #user_org 
GROUP BY user_id
ORDER BY 1 DESC
*/
--SELECT * FROM Rad_Sys_User_Hier_List where user_id = 1000009

--SELECT MAX(sequence) FROM #user_role
--SELECT MAX(sequence) FROM #user_org

--SELECT * FROM #user_org

INSERT bcssa_custom_integration..bc_extract_user (
internal_user_id,
first_name,
middle_name,
last_name,
password,
login_name,
date_created,
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
time_zone_name,
suffix,
report_format,
expand_menu_flag,
default_language_id,
default_role_name,
default_org_hiearchhy_name,
date_password_last_changed,
address_name,
address_mnemonic,
address_line_1,
address_line_2,
city,
state_code,
country_code,
postal_code,
home_phone,
work_phone,
cell_phone,
pager,
e_mail,
fax_number,
state_id,
country_id)

SELECT --TOP 1000
u.user_id,
u.first_name,
u.middle_name,
u.last_name,
u.password,
u.login_name,
u.date_created,
u.date_status_code_last_changed,
u.title,
u.nickname,
u.auto_collapse_menu_flag,
u.receives_alerts,
u.alert_lifetime,
u.uppercase_password,
u.forwarding_email_address,
u.alert_forward_level,
u.force_password_change,
tz.time_zone_id,
tz.ms_name,
u.suffix,
u.report_format,
u.expand_menu_flag,
u.default_language_id,
m.eso_role,
CASE WHEN o.name = 'SSA' THEN 'Speedway' ELSE o.name END,
u.date_password_last_changed,
a.name,
a.address_mnemonic,
a.address_line_1,
a.address_line_2,
a.city,
a.state_code,
a.country_code,
a.postal_code,
a.home_phone,
a.work_phone,
a.cell_phone,
a.pager,
a.e_mail,
a.fax_number,
a.state_id,
a.country_id
FROM Rad_Sys_User AS u
LEFT JOIN Rad_Sys_Role AS r
ON   u.default_role_id = r.role_id
LEFT JOIN bcssa_custom_integration.dbo.bc_extract_user_role_mapping AS m
ON   r.name = m.bc_role
LEFT JOIN Rad_Sys_Data_Accessor AS o
ON   u.default_org_hierarchy_id = o.data_accessor_id
LEFT JOIN Address AS a
ON   u.address_id = a.address_id
LEFT JOIN Time_Zone AS tz
ON   u.time_zone_id = tz.time_zone_id
WHERE EXISTS (SELECT 1
              FROM #user_role AS ur
              WHERE  ur.user_id = u.user_id)
AND   EXISTS (SELECT 1
              FROM #user_org AS uo
              WHERE  uo.user_id = u.user_id)
ORDER BY user_id

/*
select * from rad_sys_user where user_id IN (1000734,
1000738,
1000732,
1090764,
1028634)
*/

SET @counter = 1

WHILE @counter <= 10
BEGIN

	SET @sql = 'UPDATE u
				SET u.role_name' + CONVERT(NVARCHAR(2), @counter) + '= r.role_name
				FROM bcssa_custom_integration..bc_extract_user AS u
				JOIN #user_role AS r
				ON u.internal_user_id = r.user_id
				WHERE r.sequence = ' + CONVERT(NVARCHAR(2), @counter)

	EXECUTE(@sql)
	SET @counter += 1
END

SET @counter = 1

WHILE @counter <= 20
BEGIN

	SET @sql = 'UPDATE u
				SET u.org_code' + CONVERT(NVARCHAR(2), @counter) + '= o.org_code
				FROM bcssa_custom_integration..bc_extract_user AS u
				JOIN #user_org AS o
				ON u.internal_user_id = o.user_id
				WHERE o.sequence = ' + CONVERT(NVARCHAR(2), @counter)

	EXECUTE(@sql)
	SET @counter += 1
END

/*  Just for debugging
select u.user_id, COUNT(*)
from Rad_Sys_User_Role_List AS l
join rad_sys_user AS u
on l.user_id = u.user_id
group by u.user_id
order by 2 desc

select u.first_name, u.last_name, COUNT(*)
from rad_sys_user AS u
group by u.first_name, u.last_name
order by 3 desc

*/

SELECT 
internal_user_id,
first_name,
middle_name,
last_name,
password,
login_name,
date_created,
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
time_zone_name,
suffix,
report_format,
expand_menu_flag,
default_role_name,
default_org_hiearchhy_name,
date_password_last_changed,
address_name,
address_mnemonic,
address_line_1,
address_line_2,
city,
state_code,
country_code,
postal_code,
home_phone,
work_phone,
cell_phone,
pager,
e_mail,
fax_number,
state_id,
country_id,
role_name1,
role_name2,
role_name3,
role_name4,
role_name5,
role_name6,
role_name7,
role_name8,
role_name9,
role_name10,
org_code1,
org_code2,
org_code3,
org_code4,
org_code5,
org_code6,
org_code7,
org_code8,
org_code9,
org_code10,
org_code11,
org_code12,
org_code13,
org_code14,
org_code15,
org_code16,
org_code17,
org_code18,
org_code19,
org_code20

FROM bcssa_custom_integration..bc_extract_user
--WHERE internal_user_id = 1191688
ORDER BY user_id

IF OBJECT_ID('tempdb..#user_role_distinct') IS NOT NULL
  DROP TABLE #user_role_distinct

IF OBJECT_ID('tempdb..#user_role') IS NOT NULL
  DROP TABLE #user_role
  
IF OBJECT_ID('tempdb..#user_org') IS NOT NULL
  DROP TABLE #user_org
  
--IF OBJECT_ID('bcssa_custom_integration..bc_extract_user') IS NOT NULL
--DROP TABLE bcssa_custom_INTegration..bc_extract_user  

