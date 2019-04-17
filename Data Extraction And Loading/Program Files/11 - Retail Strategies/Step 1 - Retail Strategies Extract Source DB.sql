/*  
	Extract Retail Strategies from a Source DB 
	August 2018
	
	This script will create a de-normalized extract table and copy the strategy rows into it.
	The table can be scripted out and used to load the data into a destination system.
	
	January 2019 - Amended code to remove retail strategies related to unused levels
*/


IF OBJECT_ID('bcssa_custom_integration..bc_extract_retail_strategy') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_retail_strategy
GO

IF OBJECT_ID('bcssa_custom_integration..bc_extract_retail_strategy_exclude_list') IS NOT NULL
  DROP TABLE bcssa_custom_integration..bc_extract_retail_strategy_exclude_list
GO

CREATE TABLE bcssa_custom_integration..bc_extract_retail_strategy_exclude_list
(mg_name NVARCHAR(50) NOT NULL,
 mgm_name NVARCHAR(50) NOT NULL,
 ml_name NVARCHAR(50) NOT NULL)
 GO

INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Beverages','601 Beverages Other','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Beverages','601 Beverages Water','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Bag Candy','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Gum/Mints','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Kids','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy King Size','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Regular','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Candy','Candy Theater Size','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','Dairy Gallon','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','Dairy Half Gallon','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','Dairy Ice Cream Half Gallon','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','Dairy Ice Cream Novelty Single','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','Dairy Ice Cream Pint','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Juice Gallon','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Juice Half Gallon','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Juice Pint','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Juice Quart','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Misc Drinks','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Pint','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Dairy','601 Dairy Quart','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Automotive','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Batteries','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Cigarette Lighters','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Film','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Frozen Foods','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Grocery','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch HBA','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch HBA Condoms','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch HBA Oral Convenience','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch HBA Oral Other','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Household','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Non-Foods','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Novelty','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Oil','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Outside Items','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Packaged Deli','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Pep & Energy','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Periodicals','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Pet Goods','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Phone Accessories','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Postage Stamps','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch School Supplies','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Seasonal','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Simeks','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 General Merch','601 General Merch Clothing','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Bread','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Chips','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Cookie-Cracker Single Serve','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Cookie-Cracker Take Home','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Meat Snacks','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Pastry Premium','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Pastry Other','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Salty','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Snack Food','601 Snack Food Snacks','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Oral Premium','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Pipe Tobacco','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Roll Your Own','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Rolling Papers','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '601 Tobacco','601 Tobacco Specialty Cigarettes','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Cigarettes','Cigarette Discount','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Cigarettes','Cigarette Premium','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 201 Ice','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 201 Ice','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 201 Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 201 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 212 Hot Drinks','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 212 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 215 Fountain Drinks','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 215 Frozen Drinks','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 215 Milkshakes/Smoothies','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 215 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 215 Mugs','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 218 Fried Chicken','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 218 Hot Dogs','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 218 Hot Dogs','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 218 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Breakfast Sandwiches','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Breakfast Sandwiches','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Burritos','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Burritos','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Commissary Items','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Commissary Items','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Hot Pockets','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Hot Pockets','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Neptune Sandwiches','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Neptune Sandwiches','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Pizza','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Salads','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Salads','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Sandwiches','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Sandwiches','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 SuperMom''s Sandwiches','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 SuperMom''s Sandwiches','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Bread','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Bread','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Buns','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Cakes','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Cakes','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Cookies','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Cookies','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Misc','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Misc','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Muffins','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Muffins','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Pasteries/Donuts','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Pasteries/Donuts','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Pies','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Pies','Foodservice Ice'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 201 Packaged Bakery','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 212 Mugs','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Lunch Sandwiches','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Lunch Sandwiches','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Packaged Pastry','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 231 Packaged Pastry','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Snack Attack','Foodservice Ice '
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice Ice','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Packaged Deli','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 7th Street Deli','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Snacking Cheese','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Meats','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Lunchables','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 Misc Deli','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 221 7th Street CTG','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Foodservice','Foodservice 206 Branded','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Miscellaneous','Miscellaneous Loyalty Items','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Miscellaneous','Miscellaneous Non-Retail Items','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Miscellaneous','Miscellaneous Retail Items','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Soft Drinks','Soft Drinks 1 Liter','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Soft Drinks','Soft Drinks 20oz','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 4-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 6-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 8-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 12-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 15-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 18-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 20-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 24-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 30-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer Single Serve','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 28-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 3-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 5-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 10-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 2-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Beer','401 Beer 36-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Misc','401 Misc Wine Single','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Misc','401 Misc Wine 4-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Misc','401 Misc Wine 6-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Misc','401 Misc Liquor','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT '401 Misc','401 Misc Wine 12-Pack','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Lottery','Lottery','Default'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'z-Test eneral Merchandise','Test- Organizational Hierarchy','wDist. 267'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'z-Test eneral Merchandise','Test- Organizational Hierarchy','wDist. 282'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'z-Test eneral Merchandise','Test- Organizational Hierarchy','xReg. 48'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'z-Test eneral Merchandise','Test- Organizational Hierarchy','yDiv. 21'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'z-Test eneral Merchandise','Test- Organizational Hierarchy','zSpdwy West'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','0901 CVO','zConsolidated WV/KY'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','0901 CVO','zEast'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','0901 CVO','zNortheast'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','0901 CVO','zWest'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','0901 CVO','xLocal Oil Distributing Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','601 CVO Non Dairy','xLocal Oil Distributing Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','601 CVO Dairy','zzzMN'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'CVO','601 CVO Dairy','xLocal Oil Distributing Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 102'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 103'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 104'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 105'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 106'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 107'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 108'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 109'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 122'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 123'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 124'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 125'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 126'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 127'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 128'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 129'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 130'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 142'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 143'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 144'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 145'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 146'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 147'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 148'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 149'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 150'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 162'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 163'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 164'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 165'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 166'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 167'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 168'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 169'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 170'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 171'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 182'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 183'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 184'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 185'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 186'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 187'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 188'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 189'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 190'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 202'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 203'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 204'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 205'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 206'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 207'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 208'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 209'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 210'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 222'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 223'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 224'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 225'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 226'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 227'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 228'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 229'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 230'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 231'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 232'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 234'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 235'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 242'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 243'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 244'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 245'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 246'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 247'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 248'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 249'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 250'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 262'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 263'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 264'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 265'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 266'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 267'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 268'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 269'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 270'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 271'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 282'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 283'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 284'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 285'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 286'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 287'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 288'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 289'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 290'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 291'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 302'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 303'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 304'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 305'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 306'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 307'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 308'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 309'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 310'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 311'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 312'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 322'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 323'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 324'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 325'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 326'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 327'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 328'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 329'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 330'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 342'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 343'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 344'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 345'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 346'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 347'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 348'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 349'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 350'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 402'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 403'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 404'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 405'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 406'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 407'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 408'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 409'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 422'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 423'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 424'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 425'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 426'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 427'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 428'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 429'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 430'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 431'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 442'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 443'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 444'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 445'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 446'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 447'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 448'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 462'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 463'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 464'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 465'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 466'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 467'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 468'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 482'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 483'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 484'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 485'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 486'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 487'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 488'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 502'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 503'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 504'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 505'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 506'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 507'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 508'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 509'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 510'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 511'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 512'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 522'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 523'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 524'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 525'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 526'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 527'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 528'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 529'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 530'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 531'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 542'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 544'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 545'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 546'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 547'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 548'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 549'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 550'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 551'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 552'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 553'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 554'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 555'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 563'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 564'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 565'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 566'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 567'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 568'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 569'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 570'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 571'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 582'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 583'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 584'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 585'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 586'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 587'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 588'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 589'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 590'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 592'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 593'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 594'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','wDist 850'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 41'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 42'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 43'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 44'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 45'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 46'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 47'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 48'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 49'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 51'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 52'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 53'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 71'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 72'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 73'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 74'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 75'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 76'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 77'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 78'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 79'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 80'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','xReg 85'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 21'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 22'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 23'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 24'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 25'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 31'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 32'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 33'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','yDiv 34'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','zSpwy East'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Organizational Hierarchy','zSpwy West'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','xPhiladelphia (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yBronx county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yCuyahoga'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yKings county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','xMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','vMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','wMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yMn zone 2 pierz'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yNew york county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yPhiladelphia county (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yQueens county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yRichmond county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','ySouth dakota zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','xPhiladelphia (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yPhiladelphia county (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','zFranchise Zone 2'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','zFranchise Zone 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB E-Cigs','zFranchise State Min'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xChicago'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 1 minneapolis'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 bloomington'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 brooklyn'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 maplewood'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 minneapolis'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 ritchfield'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 2 st paul'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 4 maplewood'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 5 st paul'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMn zone 6 st paul'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xNew york city'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xPhiladelphia (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yBronx county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yCook'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yCuyahoga'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yKings county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMassachusetts high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 02'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 03'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 04'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 05'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 06'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMinnesota zone 07 st min'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMn zone 2 pierz'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yNew york county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yPhiladelphia county (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yQueens county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yRichmond county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','ySouth dakota zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 1.20'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 1.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 11.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 2.00'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 2.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 3.00'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 3.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 4.00'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 4.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 5.00'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 5.40'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 7.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 8.50'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yVa - 9.00'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yWisconsin zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zAlabama'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zConnecticut'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zDelaware'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zFlorida'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zGeorgia'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zIllinois'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zIndiana'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zKentucky'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zMassachusetts'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zMichigan'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zMinnesota'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zNew hampshire'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zNew jersey'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zNew york'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zNorth carolina'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zOhio'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zPennsylvania (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zRhode island'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zSouth carolina'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zSouth dakota'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zTennessee'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zTexas'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zVirginia'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zWest virginia'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zWisconsin'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','vMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','wMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','xPhiladelphia (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yPhiladelphia county (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zPennsylvania (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zFranchise Zone 2'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zFranchise WI TOB'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zFranchise Zone 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','zFranchise Zone State Min'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yDooley'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yMcMahon+'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Roll Your Own and Misc','yAmys Mini Mart'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','xPhiladelphia (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yBronx county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yCuyahoga'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yKings county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yMassachusetts high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yNew york county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yPhiladelphia county (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yQueens county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yRichmond county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','ySouth dakota zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','vMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','wMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','xMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','xPhiladelphia (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yPhiladelphia county (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Zone 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise State Min'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Vets MN'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Vets WI'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Vets SD'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Erickson'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB Moist','zFranchise Donner'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','xPhiladelphia (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yBronx county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yCuyahoga'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yKings county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yMa filtered cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yMa orleans high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yNew york county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yPhiladelphia county (West)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yQueens county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yRichmond county'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','ySouth dakota zone 01'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','wMa peabody high cigar'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','xPhiladelphia (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yPhiladelphia county (East)'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise Zone 2'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise WI TOB'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise Minneapolis'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise Ritchfield'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise St Paul'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise Vets MN'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','zFranchise Vets SD'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','yDooley'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB aCigars','YMcMahon'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Tobacco and Services','TOB zCigars','zFranchise Zone 2'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Dispensed Beverages','yColony'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Dispensed Beverages','ySouth Carolina'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Dispensed Beverages','zFranchise'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Prepared Foods','zCompany 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Deli Case','yCompany 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Deli Case','yNeptune'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Deli Case','zAtlantic'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Deli Case','zMidwest'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zArctic Company 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zArctic Holiday Copacker'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zArctic Legacy'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zArctic Long Island Copacker'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zArctic Reddy Copacker'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zCorbin Ice'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zHome City East'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Ice','zSomerset Ice'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Bakery','yNOCompany 1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Bakery','yNONeptune'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Bakery','zNOAtlantic'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Food Service and Technology','Bakery','zNOMidwest'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Confections','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Confections','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Novelty','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Novelty','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Grocery','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Auto','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Auto','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Non-Food','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Non-Food','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','aOutside','ySkoglund Oil Co'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','aOutside','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','aOutside','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','DSD Salty/Meat Snacks','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','DSD Salty/Meat Snacks','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Salty','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Salty','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Pastry','ySkoglund Oil Co'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Pastry','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Pastry','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','DSD Cookie/Cracker/Pastry','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','DSD Cookie/Cracker/Pastry','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Cookie/Cracker','ySkoglund Oil Co'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Cookie/Cracker','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Cookie/Cracker','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Bait','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Bait','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Flowers','ySkoglund Oil Co'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Flowers','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Flowers','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','HBA','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','HBA','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Meat Snacks','zCompany1'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Meat Snacks','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Meat Snacks','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Newspapers','yHasbrouck of Rosemount Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'General Merchandise','Newspapers','yLocal Oil Distributing, Inc'
INSERT bcssa_custom_integration..bc_extract_retail_strategy_exclude_list SELECT 'Delete in ESO','Delete','Default'

 
CREATE TABLE bcssa_custom_integration..bc_extract_retail_strategy
(mg_name NVARCHAR(50) NOT NULL,
 mg_retail_item_type_code NVARCHAR(1) NOT NULL,
 mg_standard_flag NVARCHAR(1) NOT NULL,
 mgm_name NVARCHAR(50) NOT NULL,
 ml_name NVARCHAR(50) NOT NULL,
 ml_default_ranking int NOT NULL,
 ml_high_margin smallmoney NOT NULL,
 ml_low_margin smallmoney NOT NULL,
 ml_target_margin smallmoney NOT NULL,
-- Added these 3 columns (will be used for price events)
 orig_merch_group_id INT NULL,
 orig_merch_group_member_id INT NULL,
 orig_merch_level_id INT NULL,
-- End additional columns
 resolved_merch_group_id INT NULL,
 resolved_merch_group_member_id INT NULL,
 resolved_merch_level_id INT NULL)

-- Added to support check for valid (used) levels
DECLARE @ValidLevels TABLE (Merch_Level_Id INT)

INSERT @ValidLevels (Merch_Level_id)
SELECT DISTINCT	Merch_Level_Id 
FROM merch_bu_rmi_retail_list AS l (NOLOCK)
JOIN business_unit AS bu (NOLOCK)
ON l.business_unit_id = bu.business_unit_id
WHERE bu.status_code != 'c'
-- End additional code
 
 
-- Insert the rows for the default ranking (999) if the merch group and merch group member are in use by a retail modified item
-- We must always have at least the default ranking if the merch group and merch group member are in use
INSERT bcssa_custom_integration..bc_extract_retail_strategy
(mg_name,
mg_retail_item_type_code,
mg_standard_flag,
mgm_name,
ml_name,
ml_default_ranking,
ml_high_margin,
ml_low_margin,
ml_target_margin,
-- Added these 3 columns (will be used for price events)
orig_merch_group_id,
orig_merch_group_member_id,
orig_merch_level_id
-- End additional columns
)
SELECT 
mg.name,
mg.retail_item_type_code,
mg.standard_flag,
mgm.name,
ml.name,
ml.default_ranking,
ml.high_margin,
ml.low_margin,
ml.target_margin,
-- Added these 3 columns (will be used for price events)
mg.merch_group_id,
mgm.merch_group_member_id,
ml.merch_level_id
-- End additional columns
FROM Merch_Group as mg (NOLOCK)
JOIN Merch_Group_Member as mgm (NOLOCK)
ON mg.merch_group_id = mgm.merch_group_id
JOIN Merch_Level as ml (NOLOCK)
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
WHERE EXISTS (SELECT 1
			  FROM	retail_modified_item as rmi(NOLOCK)
			  WHERE	rmi.merch_group_id = mg.merch_group_id
			  AND	rmi.merch_group_member_id = mgm.merch_group_member_id)
AND ml.default_ranking = 999

-- Insert the Levels that are in use by an open business unit that are not the default (between 1 and 998)
INSERT bcssa_custom_integration..bc_extract_retail_strategy
(mg_name,
mg_retail_item_type_code,
mg_standard_flag,
mgm_name,
ml_name,
ml_default_ranking,
ml_high_margin,
ml_low_margin,
ml_target_margin,
-- Added these 3 columns (will be used for price events)
orig_merch_group_id,
orig_merch_group_member_id,
orig_merch_level_id
-- End additional columns
)
SELECT 
mg.name,
mg.retail_item_type_code,
mg.standard_flag,
mgm.name,
ml.name,
ml.default_ranking,
ml.high_margin,
ml.low_margin,
ml.target_margin,
-- Added these 3 columns (will be used for price events)
mg.merch_group_id,
mgm.merch_group_member_id,
ml.merch_level_id
-- End additional columns
FROM Merch_Group as mg (NOLOCK)
JOIN Merch_Group_Member as mgm (NOLOCK)
ON mg.merch_group_id = mgm.merch_group_id
JOIN Merch_Level as ml (NOLOCK)
ON ml.merch_group_id = mgm.merch_group_id
AND ml.merch_group_member_id = mgm.merch_group_member_id
-- Added this check for valid levels
JOIN @ValidLevels AS vl
ON   ml.merch_level_id = vl.merch_level_id
-- End additional code
WHERE ml.default_ranking > 0
AND   ml.default_Ranking < 999
AND   ml.supplier_id IS NULL


DELETE s
FROM   bcssa_custom_integration..bc_extract_retail_strategy AS s
WHERE EXISTS (SELECT 1 FROM bcssa_custom_integration..bc_extract_retail_strategy_exclude_list AS e
              WHERE s.mg_name = e.mg_name
			  AND   s.mgm_name = e.mgm_name
			  AND   s.ml_name = e.ml_name)
			  
DELETE s
FROM   bcssa_custom_integration..bc_extract_retail_strategy AS s
WHERE mg_name NOT IN ('Default Strategy','CVO','Food Service and Technology','General Merchandise','Tobacco and Services','Alcohol','Miscellaneous Sales')


			  









