DECLARE @XMLInput AS NVARCHAR(MAX)
DECLARE @BusinessUnitCode NVARCHAR(50)

SET @XMLInput = N'<DiscontinuedItemList>
       <Item ItemExternalID="185295"/>
	   <Item ItemExternalID="186118"/>
       <Item ItemExternalID="1076988"/>
	   <Item ItemExternalID="1076989"/>
</DiscontinuedItemList>'

SET @BusinessUnitCode = '0001009'

EXEC uspGetItemWACAndQtyByBU @BusinessUnitCode, @XMLInput

