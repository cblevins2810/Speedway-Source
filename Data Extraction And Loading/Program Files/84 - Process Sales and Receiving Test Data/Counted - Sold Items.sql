select DISTINCT rsda.name, i.xref_code, i.name
from inventory_count_item_list as icl
join item as i
on   i.item_id = icl.inventory_item_id
join Rad_Sys_Data_Accessor as rsda
on   icl.business_unit_id = rsda.data_accessor_id
join retail_modified_item as rmi
on   rmi.retail_item_id = icl.inventory_item_id
where icl.business_unit_id in  (10001715, 10001577, 10001206, 10001811)
and  exists (select 1 from VP60_eso_wh..f_gen_sales_item_dest_bu_day as s
             where s.bu_id = icl.business_unit_id
			 and   s.sales_item_id = rmi.retail_modified_item_id)
order by rsda.name, i.name