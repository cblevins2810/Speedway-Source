update ape_execution_timeout_overrides
set override_to = 4000
where override_moniker =  'pe.platformforms.Purge.PurgeTask';

insert ape_execution_timeout_overrides select 'APE.Tasks.CleanMidTierData', 480;
insert ape_execution_timeout_overrides select 'APE.Tasks.Maintenance.FailOrphans', 120;
insert ape_execution_timeout_overrides select 'applications.framework.ape.tasks.DM_Execute_Publications', 150;
insert ape_execution_timeout_overrides select 'applications.fuel.ape.tasks.import_fuel_pricing', 120;
insert ape_execution_timeout_overrides select 'applications.Interfaces.Imports.APE.Tasks.POSUserImport', 480;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.ISS_Request', 180;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.ISS_Transaction', 120;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_AddAdjustmentItemsFromPricebook', 120;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_AutoOrderGeneration', 120;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_Consolidate_On_Hand_Sales', 240;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_Import_OnHand', 230;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_Import_PurchaseOrder', 120;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_Import_Receiving', 120;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_POST_AND_AGG', 1200;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_POST_AND_AGG_Phase2', 1300;
insert ape_execution_timeout_overrides select 'Applications.Inventory.ape.tasks.SCM_IM_Process_BU_Transactions', 360;
insert ape_execution_timeout_overrides select 'Applications.Inventory.DataReagg.ape.tasks.SCM_IM_BU_Data_Reagg', 1200;
insert ape_execution_timeout_overrides select 'Applications.Inventory.DataReagg.ape.tasks.SCM_IM_Data_Reagg', 600;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MM_BU_CostAndRetailChanges_Alert', 360;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MM_Catalog_Import_XML', 240;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MM_PO_Export', 1500;
insert ape_execution_timeout_overrides select 'Applications.MerchandiseManagement.Ape.Tasks.MM_Process_Depletion', 1200;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMAssignInnerPack', 960;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMCostsAddBUtoBUGroup', 2000;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGenBUCostPricing', 1000;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGenBUCostPricing_Phase2', 1000;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGenBURetailPricing', 1000;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGenBURetailPricing_Phase2', 1000;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGetConflictsBySupplier', 200;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMGetNewConflicts', 240;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMItemBUGroupListImport', 1200;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMPopulateInitialBUCosts', 600;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMPopulateInitialBURetails', 420;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMPostCatalogImport', 420;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.ape.tasks.MMRemoveConflicts', 400;
insert ape_execution_timeout_overrides select 'applications.MerchandiseManagement.Interfaces.Import.Item2.APE.ImportTask', 10800;
insert ape_execution_timeout_overrides select 'Applications.PerfMgmt.APE.Tasks.Fcst_Private_ForecastOneBU', 120;
insert ape_execution_timeout_overrides select 'Applications.PerfMgmt.APE.Tasks.Fcst_Private_IndexEventByBU', 150;
insert ape_execution_timeout_overrides select 'Applications.PerfMgmt.APE.Tasks.PM_Update_Row_Counts', 360;
insert ape_execution_timeout_overrides select 'applications.supplier.ape.tasks.SSAInvoiceImport', 2000;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.ConfigAssignment', 5400;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.ConfigAssignmentSingle', 1200;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.CopyDSPAssignmentData', 25000;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.ManageSpecialsExport', 9600;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.SalesForecastAccuracyExport', 900;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.SSA_SCM_Pre_Auto_EOD', 1800;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.SupplierInvoiceExport', 7000;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.TransactionDriveOff', 2400;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.TransactionEOD', 600;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.TransactionReceivingReturn', 240;
insert ape_execution_timeout_overrides select 'extensions.interfaces.ape.tasks.TransactionTransaction', 120;
insert ape_execution_timeout_overrides select 'Platform.Export.ExportTask', 900;
insert ape_execution_timeout_overrides select 'portal.operations.BusinessUnit.ImportBUTask', 7200;
insert ape_execution_timeout_overrides select 'portal.operations.BusinessUnit.RebuildOrgTree', 15000;
insert ape_execution_timeout_overrides select 'portal.operations.BusinessUnitGroup.importtask', 3600;
insert ape_execution_timeout_overrides select 'Reports.APE.RunReportTask', 7000;