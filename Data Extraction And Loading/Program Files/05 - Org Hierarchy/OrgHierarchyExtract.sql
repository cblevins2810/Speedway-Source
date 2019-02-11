SET NOCOUNT ON

IF OBJECT_ID('tempdb..#checkOrgHierNames') IS NOT NULL
    DROP TABLE #checkOrgHierNames
GO

IF OBJECT_ID('tempdb..#checkDistrict') IS NOT NULL
    DROP TABLE #checkDistrict
GO


-- Get Org Hierarchy Level Names into temp table
SELECT
	(ROW_NUMBER() OVER (ORDER BY Org_Hierarchy_Level.sort_order)) as rownum,
	name
INTO #checkOrgHierNames
FROM Org_Hierarchy_Level

--select * from #checkOrgHierNames


-- Get District names into temp table
SELECT
	(ROW_NUMBER() OVER (ORDER BY rsdac.name)) as rownum,
	rsdac.name AS dist_name,
	rsdap.name AS parent_name,
	ohlvlc.name AS dist_level_name,
	ohlvlp.name AS parent_level_name,
	ohlvlc.sort_order AS sort_order
INTO #checkDistrict
FROM 
Org_Hierarchy_List as ohl
join Rad_Sys_Data_Accessor as rsdac
on ohl.org_hierarchy_id = rsdac.data_accessor_id
join Rad_Sys_Data_Accessor as rsdap
on ohl.parent_org_hierarchy_id = rsdap.data_accessor_id
join Org_Hierarchy_Level as ohlvlc
on ohl.org_hierarchy_level_id = ohlvlc.org_hierarchy_level_id
join Org_Hierarchy_Level as ohlvlp
on ohl.parent_org_hierarchy_level_id = ohlvlp.org_hierarchy_level_id
-- Changed to remove hard coded values
-- District and Region
where ohlvlc.name = (select name from #checkOrgHierNames where rownum = 4)
and ohlvlp.name = (select name from #checkOrgHierNames where rownum = 3)
-- End code change
and exists (select 1
            from Org_Hierarchy_List as ohlbu
			join Business_Unit as bu
			ON bu.business_unit_id = ohlbu.org_hierarchy_id
            where rsdac.data_accessor_id = ohlbu.parent_org_hierarchy_id
            and  ohlbu.org_hierarchy_level = 999
			and  bu.status_code != 'c')
-- End District

--select * from #checkDistrict


-- Main SQL to pull all necessary org hierarchy records for import
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
-- Changed to remove hard coded values
-- Division and Enterprise
where ohlvlc.name = (select name from #checkOrgHierNames where rownum = 2)
and ohlvlp.name = (select name from #checkOrgHierNames where rownum = 1)
-- End code change
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
-- Changed to remove hard coded values
-- Region and Division
where ohlvlc.name = (select name from #checkOrgHierNames where rownum = 3)
and ohlvlp.name = (select name from #checkOrgHierNames where rownum = 2)
-- End code change
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
-- Changed to remove hard coded values
-- District and Region
where ohlvlc.name = (select name from #checkOrgHierNames where rownum = 4)
and ohlvlp.name = (select name from #checkOrgHierNames where rownum = 3)
-- End code change
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
-- Changed to remove hard coded values
-- BU and District
where ohlvlc.name = (select name from #checkOrgHierNames where rownum = 5)
and ohlvlp.name = (select name from #checkOrgHierNames where rownum = 4)
-- End code change
and bu.status_code != 'c'
and rsdap.name in (select dist_name from #checkDistrict)
order by ohlvlc.sort_order, ohlvlc.name, 3
--order by 6


-- Cleanup temp tables
IF OBJECT_ID('tempdb..#checkDistrict') IS NOT NULL
    DROP TABLE #checkDistrict
GO

IF OBJECT_ID('tempdb..#checkOrgHierNames') IS NOT NULL
    DROP TABLE #checkOrgHierNames
GO
