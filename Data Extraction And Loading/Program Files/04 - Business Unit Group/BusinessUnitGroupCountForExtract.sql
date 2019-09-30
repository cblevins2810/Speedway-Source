SET NOCOUNT ON

IF OBJECT_ID('tempdb..#business_unit_group_extract') IS NOT NULL
    DROP TABLE #business_unit_group_extract

CREATE TABLE #business_unit_group_extract
(batch_total int not null,
 batch_count int not null)

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley

CREATE TABLE #talley (batch_number int)

DECLARE @i INT
SET @i = 1

WHILE @i <= 500
BEGIN
   INSERT #talley SELECT @i
   SET @i = @i+1
END

INSERT #business_unit_group_extract
SELECT COUNT(*),
CEILING(COUNT(*)/10)+1 
FROM business_unit_group AS bug
JOIN rad_sys_data_accessor AS rsda
ON  rsda.data_accessor_id = bug.business_unit_group_id
AND ((rsda.name like 'zsBUG%') or (rsda.name in ('1 Location NY State Less NYC',
'1location All State All Stores Minus MI',
'1Location All State Minus PA',
'1Location All State NO MI, NO Colony',
'1Location CFL Sites',
'1Location North Carolina MLSPP',
'1Location PA East Less Philly',
'1Location PA MLSPP',
'1Location South Carolina MLSPP',
'1Location State AL ALL',
'1location State All Stores Less Philly',
'1Location State All Stores less SA',
'1Location State All Stores NO CAFE',
'1Location State All Stores w/o SFL',
'1Location State FL NO DISNEY',
'1Location State IL Chicagoland',
'1Location State IL Cook less 8309',
'1Location State IL Cook less Chicago',
'1Location State IL w/o Cook',
'1Location State IN w/o SFL',
'1Location State KY w/o SFL',
'1Location State MI ALL NO RICH',
'1Location State MI less MLPII Stores',
'1Location State MI MLPII Stores',
'1Location State MI MLSPP',
'1Location State OH SFL only (noCC)',
'1Location State OH w/o SFL',
'1Location State OH z-w/o Cuy or SFL',
'1Location State PA East Only',
'1Location State PA Less Philly',
'1Location State PA West',
'1Location State RI less Providence',
'1Location TEXAS MLSPP',
'1LocationDriverRewards',
'1LocationHessNoDisney',
'1LocationHessNORemodel',
'1LocationSunocoSC',
'3Location DD35 $2.69 Donut/Coffee',
'3Location DD35 $2.99 Fancy/Lrg Coffee',
'3Location DD35 $3.19 Fancy/Muffin/Med Coffee',
'3Location DD35 $3.39 2 Donuts/Med Coffee',
'3Location Made Fresh Now (MFN) ALL',
'3Location MFN FL All',
'3Location MFN FRYER STORES',
'3Location MFN FRYER/SUB STORES',
'3Location MFN GA ALL',
'3Location MFN IL ALL',
'3Location MFN IL COOK CO.',
'3Location MFN IN ALL',
'3Location MFN KY ALL',
'3Location MFN MI (NO 5543 & 8740)',
'3Location MFN MI ALL',
'3Location MFN NON TIERED SUBS',
'3Location MFN OH (NO 7330 & 5402)',
'3Location MFN OH ALL',
'3Location MFN PA ALL',
'3Location MFN SC ALL',
'3Location MFN TIERED SUBS',
'3Location MFN TN ALL',
'3Location MFN TX ALL',
'3Location MFN WV ALL',
'3Location Prem RG Test CLVLND',
'3Location Subway',
'3Location Transfer Group',
'4Location aCoup All Stores Less MA 8309 8317 8320',
'4Location aCoupon All Stores',
'4Location Coupon MAN Tax All no PA',
'5Location aLOY All Stores -NYC, Pro RI, MA, CHI',
'5Location aLoyalty All Stores Less 8309 8317 8320',
'5Location aLoyalty All Stores w/o Rich/SFL',
'5Location Loyalty All CT Stores w/o Rich/SFL',
'5Location Loyalty All DE Stores w/o Rich/SFL',
'5Location Loyalty All FL Stores w/o Rich/SFL',
'5Location Loyalty All GA Stores w/o Rich/SFL',
'5Location Loyalty All IL Stores w/o Rich/SFL',
'5Location Loyalty All IN Stores w/o Rich/SFL',
'5Location Loyalty All KY Stores w/o Rich/SFL',
'5Location Loyalty All MA Stores w/o Rich/SFL',
'5Location Loyalty All MI Stores w/o Rich/SFL',
'5Location Loyalty All MN Stores w/o Rich/SFL',
'5Location Loyalty All NC Stores w/o Rich/SFL',
'5Location Loyalty All NH Stores w/o Rich/SFL',
'5Location Loyalty All NJ Stores w/o Rich/SFL',
'5Location Loyalty All NY Stores w/o Rich/SFL',
'5Location Loyalty All OH Stores w/o Rich/SFL',
'5Location Loyalty All PA Stores w/o Rich/SFL',
'5Location Loyalty All RI Stores w/o Rich/SFL',
'5Location Loyalty All SC Stores w/o Rich/SFL',
'5Location Loyalty All SD Stores w/o Rich/SFL',
'5Location Loyalty All TN Stores w/o Rich/SFL',
'5Location Loyalty All TX Stores w/o Rich/SFL',
'5Location Loyalty All VA Stores w/o Rich/SFL',
'5Location Loyalty All WI Stores w/o Rich/SFL',
'5Location Loyalty All WV Stores w/o Rich/SFL',
'5LOCATION LOYALTY DE 2812 2813 2814 2815',
'5Location Loyalty Low Food Sales w/o Rich/SFL',
'6location All State NO 2510/Disney Stores',
'6location All Stores NO 2510',
'6Location All Stores NO 2510 Minus 19 Philly',
'6Location All Stores NO 2510 Minus PA',
'6LOCATION G&J PEPSI',
'6location_ ALL WEST (less TN)',
'6location_EAST ALL',
'6location_WEST ALL',
'8Location AT Systems-Garda ChgOrder',
'8location BOA Hess Change Fund',
'8Location Brink Change order ProgramMQ',
'8Location ITVM FL BU GROUP',
'8Location ITVM GA BU GROUP',
'8Location ITVM IL BU GROUP',
'8Location ITVM IN BU GROUP',
'8Location ITVM KY BU GROUP',
'8Location ITVM MI BU GROUP',
'8Location ITVM NC BU GROUP',
'8Location ITVM NH BU GROUP',
'8Location ITVM NJ BU GROUP',
'8Location ITVM NY BU GROUP',
'8Location ITVM OH BU GROUP',
'8Location ITVM PA BU GROUP',
'8Location ITVM RI BU GROUP',
'8Location ITVM TN BU GROUP',
'8Location ITVM TX BU GROUP',
'8Location ITVM VA BU GROUP',
'8Location ITVM WI BU GROUP',
'8Location ITVM WV BU GROUP',
'8Location Loomis Change Order ProgramMQ',
'8LocationCheck Fee UP TO $200',
'8LocationCheck Fee UP TO $300',
'9location ALL STATE EAST NO PHILLY',
'9Location Bag Tax',
'9Location NAOP .69 Disp Bev',
'9Location NAOP .99 DD Coffee/Cino',
'9Location NAOP 3F$3 20z Soda',
'9Location NAOP 6092 .49 Bev',
'9Location NAOP B1G1 Hot Food/$5 Pizza EAST',
'9Location NAOP Cafe Program Phase 1',
'9Location NAOP Cafe Program Phase 2',
'9Location NAOP Hot Food $1',
'9Location Suffolk Cnty Bag Tax',
'Location All Except AT Test Group',
'pb ~ Express Mart Only',
'PB ~ MRL MAINLINE MENTHOL GREEN BEF CHICAGO',
'PB ~ MRL MAINLINE MENTHOL GREEN BEF RI',
'PB ~ MRL MULTIPK RI ',
'pb~ 601 CVO Non Dairy East',
'pb~ 601 CVO Non Dairy West',
'pb~ 901 Consolidated',
'pb~ 901 East',
'pb~ 901 East minus Philly',
'pb~ 901 Non Consolidated',
'pb~ 901 Northeast',
'pb~ 901 West',
'pb~ All Locations Less G&J & Philly',
'pb~3Location EAST COFFEE $.89',
'PB~ADI FL FT MYERS-NAPLES',
'PB~ADI FL JACKSONVILLE',
'PB~ADI FL MIAMI-FT LAUDERDALE',
'PB~ADI FL ORLANDO-DAYTONA-MELBOURN',
'PB~ADI FL TAMPA-ST PETERSBURG',
'PB~ADI FL W PALM BEACH-FT PIERCE',
'PB~ADI GA ATLANTA',
'PB~ADI IN INDIANAPOLIS',
'PB~ADI IN LAFAYETTE',
'PB~ADI IN SOUTH BEND',
'PB~ADI IN TERRE HAUTE',
'PB~ADI IN-IL CHICAGO',
'PB~ADI IN-OH FT. WAYNE',
'PB~ADI KY BOWLING GREEN',
'PB~ADI KY LEXINGTON',
'PB~ADI KY-IN LOUISVILLE',
'PB~ADI MA SPRINGFIELD-HOLYOKE',
'PB~ADI MA-NH BOSTON (MANCHESTER)',
'PB~ADI MA-RI PROVIDENCE-NEW BEDFORD',
'PB~ADI MI DETROIT',
'PB~ADI MI FLINT-SAGINAW-BAY CITY',
'PB~ADI MI GRAND RAPIDS-BATTLE CREEK',
'PB~ADI MI LANSING',
'PB~ADI MI TRAVERSE CITY-CADILLAC',
'PB~ADI NC CHARLOTTE',
'PB~ADI NC GREENVILLE-WASHINGTON',
'PB~ADI NC RALEIGH-DURHAM',
'PB~ADI NC WILMINGTON',
'PB~ADI NC-SC GREENVILLE-SPARTANBURG',
'PB~ADI NC-VA GREENSBORO-WINSTON',
'PB~ADI NEW YORK, COLONY DIV',
'PB~ADI NY ALBANY-TROY',
'PB~ADI NY BINGHAMTON',
'PB~ADI NY BUFFALO',
'PB~ADI NY ELMIRA',
'PB~ADI NY ROCHESTER',
'PB~ADI NY SYRACUSE',
'PB~ADI NY UTICA',
'PB~ADI NY-CT-NJ NEW YORK',
'PB~ADI OH CLEVELAND',
'PB~ADI OH COLUMBUS',
'PB~ADI OH DAYTON',
'PB~ADI OH LIMA',
'PB~ADI OH YOUNGSTOWN',
'PB~ADI OH ZANESVILLE',
'PB~ADI OH-KY-IN CINCINNATI',
'PB~ADI OH-MI TOLEDO',
'PB~ADI OH-WV PARKERSBURG',
'PB~ADI OH-WV WHEELING-STEUBENVILLE',
'PB~ADI PA HARRISBURG-LEBANON',
'PB~ADI PA PITTSBURGH',
'PB~ADI PA WILKES BARRE-SCRANTON',
'PB~ADI PA-DE-NJ PHILADELPHIA',
'PB~ADI SC CHARLESTON',
'PB~ADI SC COLUMBIA',
'PB~ADI SC SAVANNAH',
'PB~ADI SC-NC FLORENCE-MYRTLE BEACH',
'PB~ADI TN CHATTANOOGA',
'PB~ADI TN JACKSON',
'PB~ADI TN NASHVILLE',
'PB~ADI TN-KY KNOXVILLE',
'PB~ADI VA CHARLOTTESVILLE',
'PB~ADI VA HARRISONBURG',
'PB~ADI VA RICHMOND-PETERSBURG',
'PB~ADI VA ROANOKE-LYNCHBURG',
'PB~ADI VA WASHINGTON DC',
'PB~ADI VA-NC NORFOLK-NEWPORT',
'PB~ADI WI GREEN BAY',
'PB~ADI WI MADISON',
'PB~ADI WI MILWAUKEE',
'PB~ADI WV BLUEFIELD BECKLEY OAK HILL',
'PB~ADI WV CLARKSBURG-WESTON',
'PB~ADI WV-OH-KY CHARLESTON-HUNTINGTON',
'pb~FLA non small scale',
'pb~FLA small scale',
'pb~Loyalty Marlboro MI less Mrlbro 2pk',
'PB~LOYALTY MRLBRO OH ',
'pb~Marlboro Loyalty IL LESS Chicago (3)',
'pb~Marlboro Loyalty KY',
'pb~Marlboro Loyalty MI Mrlbro 2pk',
'pb~Marlboro Loyalty WV',
'pb~SCALE INCOME',
'pb~SHOWER INCOME',
'PBANDV',
'zsbugDDCo-op Locations',
'zsbugDDFranchise Locations')))

SELECT b.batch_count,
t.batch_number-1,
CASE WHEN t.batch_number < 10 THEN '00' + CONVERT(NVARCHAR(1), t.batch_number)
WHEN t.batch_number < 100 THEN '0' + CONVERT(NVARCHAR(2), t.batch_number)
ELSE CONVERT(NVARCHAR(3), t.batch_number) END
FROM #business_unit_group_extract as b
JOIN #talley as t
ON   t.batch_number <= b.batch_count
ORDER BY b.batch_total DESC, t.batch_number


IF OBJECT_ID('tempdb..#business_unit_group_extract') IS NOT NULL
    DROP TABLE #business_unit_group_extract

IF OBJECT_ID('tempdb..#talley') IS NOT NULL
    DROP TABLE #talley
