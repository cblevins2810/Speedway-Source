IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO

IF OBJECT_ID('tempdb..#rmi_barcode_before') IS NOT NULL
    DROP TABLE #rmi_barcode_before
GO

SELECT bc.retail_modified_item_id, bc.barcode_number, bc.barcode_type_code, 'n' as compressible
INTO #rmi_barcode
FROM (SELECT rmi.retail_modified_item_id,
bc.complete_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.compressed_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.primitive_complete_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')
UNION
SELECT rmi.retail_modified_item_id,
bc.primitive_compressed_code AS barcode_number,
bc.barcode_type_code
FROM item AS i
JOIN retail_modified_item as rmi
ON   i.item_id = rmi.retail_item_id
JOIN Retail_Item As ri
ON   i.item_id = ri.retail_item_id
JOIN Retail_Modified_Item_BarCode_List AS rmibcl
ON rmi.retail_modified_item_id = rmibcl.retail_modified_item_id
JOIN Barcode AS bc
ON rmibcl.barcode_id = bc.barcode_id
WHERE i.purge_flag ='n'
AND i.item_type_code = 'i'
AND ri.retail_item_type_code in ('n','g')
AND NOT EXISTS(SELECT 1
               FROM Retail_Modified_Item_BarCode_List AS rmibcl2
               JOIN Barcode AS bc2
               ON rmibcl2.barcode_id = bc.barcode_id
               WHERE rmi.retail_modified_item_id = rmibcl2.retail_modified_item_id
               AND bc2.complete_code = bc.complete_code
               AND bc2.barcode_type_code = 'c'
               AND bc2.barcode_type_code = 'u')

) AS bc


SELECT * INTO #rmi_barcode_before FROM #rmi_barcode


/*
SELECT * 
FROM #rmi_barcode
WHERE retail_modified_item_id IN (1000827, 1006859) 
*/

SELECT COUNT(*) FROM #rmi_barcode

--SELECT * 
DELETE bc
FROM #rmi_barcode AS bc
WHERE EXISTS
	(SELECT 1
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND   bc.barcode_number = SUBSTRING(bc2.barcode_number,1,11)
	AND   bc.barcode_type_code =  bc2.barcode_type_code)
AND EXISTS 
	(SELECT 1 
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND LEN(bc2.barcode_number) = 10)   
AND LEN(bc.barcode_number) = 11	

DELETE bc
FROM #rmi_barcode AS bc
WHERE EXISTS
	(SELECT 1
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND   bc.barcode_number = SUBSTRING(bc2.barcode_number,1,7)
	AND   bc.barcode_type_code =  bc2.barcode_type_code)
AND EXISTS 
	(SELECT 1 
	FROM #rmi_barcode AS bc2
	WHERE bc.retail_modified_item_id = bc2.retail_modified_item_id
	AND LEN(bc2.barcode_number) = 6)   
AND LEN(bc.barcode_number) = 7	   

DELETE bc
FROM #rmi_barcode AS bc
WHERE LEN(bc.barcode_number) = 8
AND bc.barcode_type_code = 'u'

UPDATE #rmi_barcode
SET compressible = 'y'
WHERE barcode_type_code = 'u'
AND   LEN(barcode_number) = 12
AND (SUBSTRING(barcode_number,3,5) = '00000'
	OR SUBSTRING(barcode_number,3,5) = '10000'
	OR SUBSTRING(barcode_number,3,5) = '20000'
	OR SUBSTRING(barcode_number,4,5) = '00000'
	OR SUBSTRING(barcode_number,6,5) = '00000'
	OR SUBSTRING(barcode_number,6,5) = '00000'
	OR SUBSTRING(barcode_number,7,5) = '00005'
	OR SUBSTRING(barcode_number,7,5) = '00006'
	OR SUBSTRING(barcode_number,7,5) = '00007'
	OR SUBSTRING(barcode_number,7,5) = '00008'
	OR SUBSTRING(barcode_number,7,5) = '00009')

	
SELECT * FROM rmi_barcode 
WHERE compressible = 'y'	
	
/*
SELECT * 
FROM #rmi_barcode
WHERE retail_modified_item_id IN (1000827, 1006859) 
ORDER BY retail_modified_item_id
*/

/*
SELECT COUNT(*) FROM #rmi_barcode

SELECT rmi.name, bf.barcode_type_code, bf.barcode_number,
ISNULL(af.barcode_type_code,''), ISNULL(af.barcode_number,'Removed')
FROM #rmi_barcode_before bf
JOIN retail_modified_item AS rmi
ON  rmi.retail_modified_item_id = bf.retail_modified_item_id
LEFT JOIN #rmi_barcode af
ON  af.retail_modified_item_id = bf.retail_modified_item_id
AND af.barcode_number = bf.barcode_number
AND af.barcode_type_code = bf.barcode_type_code
WHERE bf.retail_modified_item_id IN (SELECT bf.retail_modified_item_id
	FROM #rmi_barcode_before bf
	JOIN retail_modified_item AS rmi
	ON  rmi.retail_modified_item_id = bf.retail_modified_item_id
	LEFT JOIN #rmi_barcode af
	ON  af.retail_modified_item_id = bf.retail_modified_item_id
	AND af.barcode_number = bf.barcode_number
	AND af.barcode_type_code = bf.barcode_type_code
	WHERE af.barcode_number IS NULL)

               
ORDER BY rmi.name, 5, bf.barcode_number
*/

IF OBJECT_ID('tempdb..#rmi_barcode') IS NOT NULL
    DROP TABLE #rmi_barcode
GO

IF OBJECT_ID('tempdb..#rmi_barcode_before') IS NOT NULL
    DROP TABLE #rmi_barcode_before
GO
