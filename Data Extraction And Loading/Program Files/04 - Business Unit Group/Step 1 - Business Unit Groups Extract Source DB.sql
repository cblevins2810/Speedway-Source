/* After completing this script, extract the data from the tables using SQL Server Management Studio */

IF OBJECT_ID('bcssa_custom_integration..bc_extract_bu_group') IS NOT NULL
   DROP TABLE bcssa_custom_integration..bc_extract_bu_group

IF OBJECT_ID('bcssa_custom_integration..bc_extract_bu_group_bu_list') IS NOT NULL
    DROP TABLE bcssa_custom_integration..bc_extract_bu_group_bu_list
GO

CREATE TABLE bcssa_custom_integration..bc_extract_bu_group
(group_xref_code nvarchar(255),
name NVARCHAR(50),
long_name NVARCHAR(255),
description nvarchar(255) null,
last_modified_user_id int not null,
client_id int not null, 
last_modified_timestamp datetime not null,
transfer_group_flag nvarchar(1) not null,
business_unit_group_type_code nvarchar(1) not null,
sort_order int not null,
cdm_owner_id int not null
resolved_bu_group_id int null)

CREATE TABLE bcssa_custom_integration..bc_extract_bu_group_bu_list
(group_xref_code nvarchar(255),
 resolved_bu_group_id INT NULL,
 bu_xref_code nvarchar(255),
 resolved_bu_id INT NULL)
GO

INSERT bcssa_custom_integration..bc_extract_bu_group 
(group_xref_code,
name,
long_name,
description,
last_modified_user_id,
client_id, 
last_modified_timestamp,
transfer_group_flag,
business_unit_group_type_code,
sort_order,
cdm_owner_id)
SELECT 'xref-' + CONVERT(NVARCHAR(15),business_unit_group_id),
rsda.name,
rsda.long_name,
bug.description,
bug.last_modified_user_id,
bug.client_id, 
bug.last_modified_timestamp,
bug.transfer_group_flag,
bug.business_unit_group_type_code,
bug.sort_order,
bug.cdm_owner_id
FROM business_unit_group AND bug
JOIN rad_sys_data_accessor AS rsda
ON   bug.business_unit_group_id = rsda.data_accessor_id

INSERT bcssa_custom_integration..bc_extract_bu_group_list 
(group_xref_code,
 bu_xref_code)
SELECT 'xref-' + CONVERT(NVARCHAR(15),bugl.business_unit_group_id),
FROM business_unit_group_list AS bugl
JOIN rad_sys_data_accessor AS rsda
ON   bugl.business_unit_id = rsda.data_accessor_id


