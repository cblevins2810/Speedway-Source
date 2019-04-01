DECLARE @DaysBack INT

SET @DaysBack = -30

SELECT distinct rsda.name BUCode,
CONVERT(nvarchar(10),
rd.business_date,120) BusinessDate,
CONVERT(nvarchar(10), md.maxdate,120) MaximumDate,
COUNT(*) ReceivingCount
FROM received_document AS rd
JOIN supplier AS s
ON   s.supplier_id = rd.supplier_id
JOIN rad_sys_data_accessor AS rsda
ON   rd.business_unit_id = rsda.data_accessor_id
JOIN (SELECT MAX(business_date) AS maxdate, business_unit_id
      FROM received_document AS rd
	  GROUP BY business_unit_id) AS md
ON   rd.business_unit_id = md.business_unit_id
AND  rd.business_date <= DATEADD(day, @DaysBack, md.maxdate)	  
WHERE s.xref_code IN (
'EBYAUROR',
'EBYSAWIS',
'EBYSMOKE',
'MCLNCRLN',
'MCLNNTHE',
'MCLNSUNE',
'MCLNPENN',
'MCLNCONC',
'MCLNSTHE',
'MCLNDTHN',
'MCLNMIDA',
'MCLNSTHW',
'COKEFLOR',
'COKNEWRI',
'COKLBRTY',
'COKEIND',
'COKCCBCC',
'COKCOLOH',
'COKALSIL',
'COKDAYOH',
'COKGREAT',
'COKCINOH',
'COKABRTA',
'COKEFLNT',
'COKCCCNC',
'COKAKROH',
'COKMLWWI',
'COKTOLOH',
'COKCLAYT',
'COKECLEV',
'COKANCCC',
'COKCINKY',
'COKHLYWD',
'COKKALMI',
'COKSTCIL',
'COKLVRGN',
'COKBAYMI',
'COKFTWIN',
'COKGRNVL',
'COKNESYR',
'COKEMANS',
'COKSTHIN',
'COKEELYR',
'COKCTGTN',
'COKNBERN',
'COKECHIL',
'COKPRKIL',
'COKCHARL',
'COKAB3PA',
'COKZANOH',
'COKWILOH',
'COKNEROC',
'COKECARM',
'COKLIMOH',
'COKCONWY',
'COKTERIN',
'COKCCCVA',
'COKLELND',
'COKEYOUN',
'COKNEELM',
'COKLAFIN',
'COKCCCTN',
'COKCCRGA',
'COKETRAV',
'COKNECCD',
'COKEMDLB',
'COKBLOIN',
'COKNEBUF',
'COKHALFX',
'COKEHTN',
'COKPRKWI',
'COKFAYTV',
'COKFINOH',
'COKINDIN',
'COKDURNC',
'COKNELWL',
'COKCCCSC',
'COKNESCT', 
'COKNELDY',
'COKCCCIN',
'COKMADWI',
'COKCHCIL',
'COKRCKWI',
'COKNELSR', 
'COKNEWTD',
'COKSKYLD',
'COKINCC',
'COKCININ',
'COKNEALB',
'COKFTWOH',
'COKNORWI',
'COKPTMOH',
'COKCCCDE',
'COKUNTSC',
'COKSHEWI')
AND rsda.name IN (
'0001001')

GROUP BY rsda.name, rd.business_date, md.maxdate 
ORDER BY 1,2



