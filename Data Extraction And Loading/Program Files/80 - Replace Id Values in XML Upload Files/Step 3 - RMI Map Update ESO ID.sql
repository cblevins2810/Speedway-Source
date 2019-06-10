

IF OBJECT_ID('bc_extract_rmi_bc_eso_map') IS NOT NULL
   UPDATE bc_extract_rmi_bc_eso_map
   SET rmi_id_eso = 0

GO

-- Temp Table variable to hold item/group list
DECLARE @tXrefESOId table
(
	log_seq			INT IDENTITY(1,1),
	rmi_xref_code	NVARCHAR(255),
	rmi_id_eso		INT NOT NULL
 )


INSERT INTO @tXrefESOId
		(
			rmi_xref_code,
			rmi_id_eso
		)
SELECT DISTINCT 
		rmi.xref_code					AS rmi_xref_code,
		rmi.retail_modified_Item_id		AS rmi_id_eso
FROM	retail_modified_item			AS rmi


UPDATE		bc_extract_rmi_bc_eso_map
SET			rmi_id_eso = tt.rmi_id_eso
FROM		bc_extract_rmi_bc_eso_map			AS bcrbem
INNER JOIN	@tXrefESOId							AS tt
ON			(bcrbem.rmi_xref_code = tt.rmi_xref_code)

