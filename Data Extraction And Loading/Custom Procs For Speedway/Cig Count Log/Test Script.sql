DECLARE @BU_Code nvarchar(20)
DECLARE @Item_Hierarchy_Name nvarchar(50) 
DECLARE @current_datetime DATETIME
DECLARE @Qty_On_Hand INT 

SET @BU_Code = '0001001'
SET @Item_Hierarchy_Name = '501 Cigarettes'

EXEC sp_Get_Qty_On_Hand_By_BU_And_Item_Hierarchy @BU_Code, @Item_Hierarchy_Name, @Qty_On_Hand OUTPUT

SELECT @Qty_On_Hand