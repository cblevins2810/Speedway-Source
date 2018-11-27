SET NOCOUNT ON

select '_' + rsdac.name, replace(rsdac.long_name,',','~'), '_Speedway', ohlvlc.name, ohlvlp.name, ohlvlc.sort_order
from Org_Hierarchy_List as ohl
join Rad_Sys_Data_Accessor as rsdac
on ohl.org_hierarchy_id = rsdac.data_accessor_id
join Rad_Sys_Data_Accessor as rsdap
on ohl.parent_org_hierarchy_id = rsdap.data_accessor_id
join Org_Hierarchy_Level as ohlvlc
on ohl.org_hierarchy_level_id = ohlvlc.org_hierarchy_level_id
join Org_Hierarchy_Level as ohlvlp
on ohl.parent_org_hierarchy_level_id = ohlvlp.org_hierarchy_level_id
where ohlvlc.name = 'Division'
and ohlvlp.name = 'Enterprise'
and exists (select 1
            from Org_Hierarchy_List as ohlbu
			join Business_Unit as bu
			ON bu.business_unit_id = ohlbu.org_hierarchy_id
            where rsdac.data_accessor_id = ohlbu.parent_org_hierarchy_id
            and  ohlbu.org_hierarchy_level = 999
			and  bu.status_code != 'c')
union
select '_' + rsdac.name, replace(rsdac.long_name,',','~'), '_' + rsdap.name, ohlvlc.name, ohlvlp.name, ohlvlc.sort_order
from Org_Hierarchy_List as ohl
join Rad_Sys_Data_Accessor as rsdac
on ohl.org_hierarchy_id = rsdac.data_accessor_id
join Rad_Sys_Data_Accessor as rsdap
on ohl.parent_org_hierarchy_id = rsdap.data_accessor_id
join Org_Hierarchy_Level as ohlvlc
on ohl.org_hierarchy_level_id = ohlvlc.org_hierarchy_level_id
join Org_Hierarchy_Level as ohlvlp
on ohl.parent_org_hierarchy_level_id = ohlvlp.org_hierarchy_level_id
where ohlvlc.name = 'Region'
and ohlvlp.name = 'Division'
and exists (select 1
            from Org_Hierarchy_List as ohlbu
			join Business_Unit as bu
			ON bu.business_unit_id = ohlbu.org_hierarchy_id
            where rsdac.data_accessor_id = ohlbu.parent_org_hierarchy_id
            and  ohlbu.org_hierarchy_level = 999
			and  bu.status_code != 'c')
union
select '_' + rsdac.name, replace(rsdac.long_name,',','~'), '_' + rsdap.name, ohlvlc.name, ohlvlp.name, ohlvlc.sort_order
from Org_Hierarchy_List as ohl
join Rad_Sys_Data_Accessor as rsdac
on ohl.org_hierarchy_id = rsdac.data_accessor_id
join Rad_Sys_Data_Accessor as rsdap
on ohl.parent_org_hierarchy_id = rsdap.data_accessor_id
join Org_Hierarchy_Level as ohlvlc
on ohl.org_hierarchy_level_id = ohlvlc.org_hierarchy_level_id
join Org_Hierarchy_Level as ohlvlp
on ohl.parent_org_hierarchy_level_id = ohlvlp.org_hierarchy_level_id
where ohlvlc.name = 'District'
and ohlvlp.name = 'Region'
and exists (select 1
            from Org_Hierarchy_List as ohlbu
			join Business_Unit as bu
			ON bu.business_unit_id = ohlbu.org_hierarchy_id
            where rsdac.data_accessor_id = ohlbu.parent_org_hierarchy_id
            and  ohlbu.org_hierarchy_level = 999
			and  bu.status_code != 'c')
union 
select '_' + rsdac.name, replace(rsdac.long_name,',','~'), '_' + rsdap.name, ohlvlc.name, ohlvlp.name, ohlvlc.sort_order
from Org_Hierarchy_List as ohl
join Rad_Sys_Data_Accessor as rsdac
on ohl.org_hierarchy_id = rsdac.data_accessor_id
join Business_Unit as bu
on ohl.org_hierarchy_id = bu.business_unit_id
join Rad_Sys_Data_Accessor as rsdap
on ohl.parent_org_hierarchy_id = rsdap.data_accessor_id
join Org_Hierarchy_Level as ohlvlc
on ohl.org_hierarchy_level_id = ohlvlc.org_hierarchy_level_id
join Org_Hierarchy_Level as ohlvlp
on ohl.parent_org_hierarchy_level_id = ohlvlp.org_hierarchy_level_id
where ohlvlc.name = 'BU'
and ohlvlp.name = 'District'
and bu.status_code != 'c'
order by 6

