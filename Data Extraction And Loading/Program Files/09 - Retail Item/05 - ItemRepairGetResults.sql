select distinct r.filename, i.xref_code, i.name, mgn.name, mgo.name
from item as i
join bc_extract_repair_manufacturer_and_strategy as r
on   i.item_id = r.item_id
join merch_group as mgn
on   mgn.merch_group_id = r.merch_group_id
join merch_group as mgo
on   mgo.merch_group_id = r.prior_merch_group_id
where r.merch_group_id <> r.prior_merch_group_id
AND  r.isSold = 'y'
order by r.filename

SELECT r.filename, rmi.xref_code, rmi.name, n.name new, o.name old
from bc_extract_repair_manufacturer_and_strategy as r
JOIN retail_modified_item as rmi
ON   r.retail_modified_item_id = rmi.retail_modified_item_id
JOIN merch_group_member AS n
ON   rmi.merch_group_member_id = n.merch_group_member_id
JOIN merch_group_member AS o
ON   r.prior_merch_group_member_id = o.merch_group_member_id
WHERE r.merch_group_member_id <> r.prior_merch_group_member_id
AND  r.isSold = 'y'
ORDER by r.filename

--select * from bc_extract_repair_manufacturer_and_strategy where merch_group_member_id <> prior_merch_group_member_id

select r.filename, i.xref_code, i.name, r.manufacturer 
from bc_extract_repair_manufacturer_and_strategy as r
join item as i
on   r.item_id = i.item_id
join inventory_item as ii
on   i.item_id = ii.inventory_item_id
where r.Manufacturer_id IS NOT NULL
and   r.prior_manufacturer_id IS NULL
order by r.filename

select i.xref_code, i.name, r.manufacturer AS New, m.name AS Old 
from bc_extract_repair_manufacturer_and_strategy as r
join item as i
on   r.item_id = i.item_id
join inventory_item as ii
on   i.item_id = ii.inventory_item_id
join Manufacturer AS m
ON   prior_manufacturer_id = m.manufacturer_id
where r.Manufacturer_id IS NOT NULL
and   r.prior_manufacturer_id IS NOT NULL
and   r.manufacturer_id <> r.prior_manufacturer_id

SELECT * FROM Manufacturer
WHERE last_modified_timestamp > GETDATE() - 1
ORDER BY last_modified_timestamp DESC

/*
SELECT i.name
FROM bc_extract_repair_manufacturer_and_strategy as r
JOIN item as i
ON i.item_id = r.item_id
WHERE isSOld = 'y'
*/