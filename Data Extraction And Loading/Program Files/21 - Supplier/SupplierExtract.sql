SET NOCOUNT ON
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
LEFT JOIN Address as a
ON s.address_id = a.address_id
WHERE status_code <> 'i'
GO

