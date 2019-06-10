BEGIN TRANSACTION

SELECT	s.xref_code 'supplier xref',
		s.name 'supplier name',
		si.name 'item name',
		spi.supplier_item_code,
		si.xref_value
FROM	supplier_item as si
JOIN	supplier_packaged_item as spi
ON		si.supplier_id = spi.supplier_id
AND		si.supplier_item_id = spi.supplier_item_id
JOIN    supplier as s
ON		s.supplier_id = si.supplier_id
WHERE	item_id IS NULL
AND		EXISTS (SELECT 1
				FROM item AS i
                WHERE	i.xref_code = si.xref_value)
ORDER	BY s.name, si.name

UPDATE	si
SET		si.item_id = i.item_id
FROM	supplier_item AS si
JOIN    item AS i
ON		si.xref_value = i.xref_code
WHERE   si.item_id IS NULL

SELECT	s.xref_code 'supplier xref',
		s.name 'supplier name',
		si.name 'item name',
		spi.supplier_item_code,
		si.xref_value
FROM	supplier_item as si
JOIN	supplier_packaged_item as spi
ON		si.supplier_id = spi.supplier_id
AND		si.supplier_item_id = spi.supplier_item_id
JOIN    supplier as s
ON		s.supplier_id = si.supplier_id
WHERE	item_id IS NULL
AND		EXISTS (SELECT 1
				FROM item AS i
                WHERE	i.xref_code = si.xref_value)
ORDER	BY s.name, si.name

ROLLBACK TRANSACTION
