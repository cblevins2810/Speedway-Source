/*
   Discontinued Item Type.  This type is created to match the XML parameter sent into the stored procedures
   that retrieve Item WAC and On-Hand by Business Unit.  Creating a type is the only way to pass a table
   variable into a stored procedure.
*/
USE VP60_Spwy
GO

IF OBJECT_ID('discontinued_item') IS NOT NULL
	DROP TYPE discontinued_item 
GO

CREATE TYPE discontinued_item AS TABLE (
		xref_code NVARCHAR(100) NOT NULL,
		resolved_item_id INT NULL)
GO		
