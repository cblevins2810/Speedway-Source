SET NOCOUNT ON

DECLARE @supplier TABLE (supplier_id INT, name nvarchar(128))

INSERT @supplier (supplier_id, name)
SELECT s.supplier_id, s.name
FROM   supplier_da_effective_date_list as l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   rad_sys_data_accessor as rsda
ON     l.data_accessor_id = rsda.data_accessor_id
JOIN   business_unit_group as bug
ON     bug.business_unit_group_id = rsda.data_accessor_id
WHERE  EXISTS (SELECT 1
              FROM Business_Unit_Group_List as bugl
              JOIN Business_Unit AS bu
              ON   bug.business_unit_group_id = bugl.business_unit_group_id
			  AND  bugl.business_unit_id = bu.business_unit_id
			  WHERE bu.status_code != 'c')
AND    s.status_code <> 'i'			  
UNION 			  
SELECT s.supplier_id, s.name
FROM   supplier_da_effective_date_list as l
JOIN   supplier AS s
ON     l.supplier_id = s.supplier_id
JOIN   rad_sys_data_accessor as rsda
ON     l.data_accessor_id = rsda.data_accessor_id
JOIN   business_unit as bu
ON     bu.business_unit_id = rsda.data_accessor_id
WHERE  bu.status_code != 'c'
AND    s.status_code <> 'i'			  

SELECT ISNULL(xref_code, 'xref-' + CONVERT(NVARCHAR(15),s.supplier_id)) AS XRefCode,
REPLACe(s.name,',','~') AS Name,
REPLACE(ISNULL(description,''),',','~') AS Description,
status_code AS StatusCode,
supplier_type_code AS SupplierType,
ISNULL(external_vendor_ap_code,'') AS VendorAPCode,
RTRIM(ISNULL(edi_number,'')) AS EDINumber,
catalog_import_review_flag AS CatalogReviewFlag,
REPLACE(ISNULL(a.address_line_1,'?'),',','~') AS AddressLine1,
REPLACE(ISNULL(a.address_line_2,''),',','~') AS AddressLine2,
ISNULL(a.city,'?') AS City,
ISNULL(a.state_code,'?') AS State,
ISNULL(a.postal_code,'?') AS PostalCode,
ISNULL(a.country_code,'') AS CountryCode,
ISNULL(a.work_phone,'') AS Phone,
ISNULL(a.cell_phone,'') AS CellPhone,
ISNULL(a.pager,'') AS Page,
ISNULL(a.fax_number,'') AS FAX,
ISNULL(a.e_mail,'') AS Email,
REPLACE(ISNULL(terms_and_conditions,''),',','~') AS TermsAndConditions
FROM Supplier as s
JOIN @Supplier AS s2
ON   s.supplier_id = s2.supplier_id
LEFT JOIN Address as a
ON s.address_id = a.address_id
--WHERE status_code <> 'i'
GO

