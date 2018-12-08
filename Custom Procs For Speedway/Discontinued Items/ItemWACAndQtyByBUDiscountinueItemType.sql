USE VP60_Spwy
GO

IF OBJECT_ID('discontinued_item') IS NOT NULL
	DROP TYPE discontinued_item 
GO

CREATE TYPE discontinued_item AS TABLE (
		xref_code NVARCHAR(100) NOT NULL,
		resolved_item_id INT NULL)
GO		
