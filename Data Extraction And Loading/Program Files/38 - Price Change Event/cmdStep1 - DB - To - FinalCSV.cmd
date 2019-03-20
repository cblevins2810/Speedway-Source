ECHO OFF

REM Process Price Change Events
SET ProcessName=Price Change Event
SET ProcessCode=PriceChangeEventExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET SQLExtractParamFile=PriceChangeEventCountForExtract.sql
SET SQLWorkTableCreateTable=PriceChangeEventItemCreateTable.sql
SET SQLWorkTable=PriceChangeEventExtractItem.sql
SET ExtractParamFile=PriceChangeEventCountForExtractParams.txt
SET FinalCSVDir=..\..\Import Files\Price Change Event\FinalCSV\
SET Server=EMCTS520
SET DB=bcssa_cert2

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Build Work Table (added/modified for creation of table)
ECHO %date% %time% Creating Work Table for Extract >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLWorkTableCreateTable%  >> %LogFile%
ECHO %date% %time% Work Table Generated >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Populate Work Table (added/modified to populate table)
ECHO %date% %time% Populating Work Table for Extract >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLWorkTable%  >> %LogFile%
ECHO %date% %time% Work Table Populated >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Build Extract Params
ECHO %date% %time% Generating Parameters for Extract >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractParamFile% -o %ExtractParamFile% -s"," -h-1 -W -w 4000 >> %LogFile%
ECHO %date% %time% Param File Generated >> %LogFile%
ECHO %date% %time% Param File Contents >> %LogFile%
TYPE %ExtractParamFile% >> %LogFile%
ECHO %date% %time% Completed Extracting Params >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Generate Extract Files
ECHO %date% %time% Extracting Files >> %LogFile%
FOR /F "tokens=1,2,3,4,5,6 delims=," %%A IN (%ExtractParamFile%) DO (
ECHO %date% %time% Processing File "%ProcessName%-%%C-%%D-%%E-%%F.csv" >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%FinalCSVDir%%ProcessName%-%%C-%%D-%%E-%%F.csv" -s"," -W -w 4000 -v Modulus = %%A Remainder = %%B StartDate = %%C EndDate = %%D PromoFlag = %%E BatchNumber = %%F>> %LogFile%)

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%FinalCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause