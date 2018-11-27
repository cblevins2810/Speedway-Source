SET NOCOUNT ON
select '_' + rsda.name as Name,
REPLACE(rsda.long_name,',','~') as 'Long Name',
bu.status_code as 'Satus Code',
bu.time_zone_id as 'Time Zone Id',
CASE WHEN bu.date_opened IS NULL THEN CAST (GETDATE() AS DATE) 
   ELSE CAST(bu.date_opened AS DATE) END as 'Start Date',
'_' + rsda.name as 'EDI Number',
REPLACE(wp.name,',','~') as 'Workday Profile Name',
REPLACE(a.address_line_1,',','~') as 'Mailing Address1',
REPLACE(ISNULL(a.address_line_2,''),',','~') as 'Mailing Address2',
a.city as 'Mailing City',
a.state_code as 'Mailing State',
a.postal_code as 'Mailing Postal Code',
a.country_code as 'Mailing Country Code',
ISNULL(a.home_phone,'') as 'Mailing Home Phone',
ISNULL(a.work_phone,'') as 'Mailing Work Phone',
ISNULL(a.fax_number,'') as 'Mailing Fax Number',
ISNULL(a.e_mail,'') as 'Mailing EMail',
ISNULL(ba.address_line_1,'') as 'Billing Address1',
ISNULL(ba.address_line_2,'') as 'Billing Address2',
ISNULL(ba.city,'') as 'Billing City',
ISNULL(ba.state_code,'') as 'Billing State',
ISNULL(ba.postal_code,'') as 'Billing Postal Code',
ISNULL(ba.country_code,'') as 'Billing Country Code',
ISNULL(ba.home_phone,'') as 'Billing Home Phone',
ISNULL(ba.work_phone,'') as 'Billing Work Phone',
ISNULL(ba.fax_number,'') as 'Billing Fax Number',
ISNULL(ba.e_mail,'') as 'Billing EMail'
from business_unit as bu
join Rad_Sys_Data_Accessor as rsda
on bu.business_unit_id = rsda.data_accessor_id
join Rad_Sys_Business_Unit_Settings as rsbus
on bu.business_unit_id = rsbus.business_unit_id
join Rad_Sys_Workday_Profile as wp
on rsbus.workday_profile_id = wp.workday_profile_id
join Address as a
on bu.address_id = a.address_id
left join Address as ba
on bu.billing_address_id = ba.address_id
where status_code != 'c'
order by rsda.name
