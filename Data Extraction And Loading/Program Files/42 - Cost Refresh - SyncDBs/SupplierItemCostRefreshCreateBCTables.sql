IF OBJECT_ID('bcssa_custom_integration..bc_extract_cost_export') IS NOT NULL
   DROP TABLE bcssa_custom_integration..bc_extract_cost_export

CREATE TABLE bcssa_custom_integration..bc_extract_cost_export (
ExportId INT NOT NULL IDENTITY (1,1),
SupplierId INT NOT NULL,
SupplierXrefCode NVARCHAR(50) NOT NULL,
EffectiveDate smalldatetime NOT NULL,
ExecutionDate smalldatetime NOT NULL,
ExportedTimeStamp smalldatetime NOT NULL)


