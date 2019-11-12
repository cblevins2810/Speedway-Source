--select * from rad_sys_user as rsu
--where rsu.client_id > 0



select u.user_id, u.first_name, u.last_name, u.login_name, COUNT(*)
from Rad_Sys_User_Role_List AS l
join rad_sys_user AS u
on l.user_id = u.user_id
join Rad_Sys_Role as r
on l.role_id = r.role_id 
where u.status_code <> 'i'
and r.name IN (
'BlueCube Admin',
'Client Admin',
--'Store Manager',
--'Worker',
--'Above Store Manager',
'Web Clock Attendant',
'Software Deployment Admin',
'CAT Operator',
'Web Pos Operator',
'Web Pos Manager',
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
'Speedway District Manager',
--'zSpeedway PW Reset',
--'zzz-SSA Fuel Item',
--'zzz-OLD-SSA CSR-DO NOT USE',
'Speedway Accounting',
--'zzz-OLD-SSA CSR2-DO NOT USE',
--'SSA Food Steward',
--'SSA Store Manager',
--'SSA Shift Leader',
'Speedway Field Auditor',
'Speedway Field Marketing Coordinator',
'Speedway Region Director',
'Speedway Region Manager',
'Speedway Employee Setup',
'SSA CSR',
'SSA CSR2',
'zSpeedway DMT (Cycle 1 ONLY)',
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
'SSA Store Co-Manager',
'Speedway Store Support Analyst',
'Speedway Field Auditor Supervisor',
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

group by u.user_id, u.first_name, u.last_name, u.login_name
order by 5 desc




select OBJECT_NAME(id), * from syscolumns where name = 'user_id'
/*
select * from sysobjects where name like '%role%' and type = 'u'

select * from rad_sys_role

select * from rad_sys_user

*/


/*
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

