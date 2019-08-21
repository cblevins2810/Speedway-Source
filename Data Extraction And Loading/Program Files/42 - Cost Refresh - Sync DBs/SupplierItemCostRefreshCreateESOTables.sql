IF OBJECT_ID('bc_extract_cost_import') IS NOT NULL
   DROP TABLE bc_extract_cost_import

CREATE TABLE bc_extract_cost_import (
ImportId INT NOT NULL,
SupplierXrefCode NVARCHAR(100) NOT NULL,
ResolvedSupplierId INT NULL,
StatusCode NVARCHAR(1) NOT NULL DEFAULT 'i',   -- i = Imported, r = ready for export, e = exported
EffectiveDate smalldatetime NOT NULL,
ExecutionDate smalldatetime NOT NULL,
ExportedTimeStamp smalldatetime NOT NULL,
ImportedTimeStamp smalldatetime NOT NULL)   
   
IF OBJECT_ID('bc_extract_cost_import_supplier_item') IS NOT NULL
   DROP TABLE bc_extract_cost_import_supplier_item
   
CREATE TABLE bc_extract_cost_import_supplier_item (
ImportId INT NOT NULL,
SequenceNumber INT NULL,
SupplierItemCode NVARCHAR(100) NOT NULL,
ResolvedSupplierItemId INT NULL,
CostLevelName NVARCHAR(50) NOT NULL,
ResolvedCostLevelId INT NULL,
SupplierPrice SMALLMONEY NOT NULL,
SupplierAllowance SMALLMONEY NOT NULL,
StartDate smalldatetime NOT NULL,
EndDate smalldatetime NOT NULL,
PromoFlag NVARCHAR(1),
IsValid NVARCHAR(1) DEFAULT 'y')  -- y = Is valid for export (Cost not in ESO), n = Cost already in ESO



