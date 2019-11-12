/*  
    Create unique names into a temp table for all discounts that have the same name.  Then update the name.
	This will allow the index to be re-applied.
*/
 
IF OBJECT_ID('tempdb..#Discount') IS NOT NULL
    DROP TABLE #Discount
GO

SELECT discount_id, name + CASE WHEN CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) = 1 THEN '' 
ELSE ' (' + CONVERT(NVARCHAR(10), ROW_NUMBER() over (partition by name order by name)) + ')' END AS DiscountName 
INTO #Discount
FROM Discount
WHERE name in (SELECT name FROM Discount GROUP BY Name HAVING COUNT(*) > 1)

UPDATE d
SET name = DiscountName
FROM Discount AS d
JOIN #Discount AS d2
ON d.discount_id = d2.discount_id

/****** Object:  Index [XAKdiscount_XREF_name]    Script Date: 8/27/2018 10:51:09 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [XAKdiscount_XREF_name] ON [dbo].[Discount]
(
	[name] ASC,
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
