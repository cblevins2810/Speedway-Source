DECLARE @XMLInput AS NVARCHAR(MAX)
DECLARE @ClientId INTEGER
DECLARE @BUCode NVARCHAR(100)

SET @ClientId = 10000001
SET @BUCode = '0007610'

-- This sample contains one invalid item
SET @XMLInput = N'<DiscontinuedItemList>
       <Item ItemExternalID="114308"/>
	   <Item ItemExternalID="114314"/>
	   <Item ItemExternalID="114322x"/>
</DiscontinuedItemList>'

exec sp_Get_Qty_On_Hand_And_WAC_by_BU_and_ItemList @ClientId, @BUCode, @XMLInput

--select * from item where xref_code like '1143%'

