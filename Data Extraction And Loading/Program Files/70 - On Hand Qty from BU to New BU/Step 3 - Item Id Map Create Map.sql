UPDATE m 
SET		m.dest_item_id = i.item_id
FROM	bc_extract_item_map AS m
JOIN	item AS i
ON      i.xref_code = m.xref_code
WHERE	i.purge_flag				=	'n'
AND		i.item_type_code			=	'i'
AND		CASE
			WHEN	ISNUMERIC(i.xref_code) = 1
			AND		LEN(i.xref_code) < 9
			AND		LEFT(i.xref_code, 1) NOT IN ('0')
			AND		i.xref_code NOT LIKE '%[^0-9]%' 
			THEN	CONVERT(INT, i.xref_code)
			ELSE	0
		END
		BETWEEN 10000 AND 99999999
