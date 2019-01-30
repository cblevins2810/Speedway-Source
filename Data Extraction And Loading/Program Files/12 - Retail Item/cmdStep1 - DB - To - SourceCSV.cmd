ECHO OFF

REM Process Retail Items
SET ProcessName=Retail Item
SET ProcessCode=ItemExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET SQLExtractParamFile=ItemCountForExtract.sql
SET SQLItemExtractAttributeCreateTable=ItemExtractAttributeCreateTable.sql
SET SQLItemExtractAttribute=ItemExtractAttribute.sql
SET SQLItemExtractGroupCreateTable=ItemExtractGroupCreateTable.sql
SET SQLItemExtractGroup=ItemExtractGroup.sql
SET ExtractParamFile=ItemCountForExtractParmams.txt
SET SourceCSVDir=..\..\Import Files\Retail Item\SourceCSV\
SET Server=EMCTS520
SET DB=bcssa_cert2

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Build Attribute Work Table
ECHO %date% %time% Generating Attribute Work Table >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLItemExtractAttributeCreateTable%  >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLItemExtractAttribute%  >> %LogFile%

REM Build Item Group Work Table
ECHO %date% %time% Generating Attribute Work Table >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLItemExtractGroupCreateTable%  >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLItemExtractGroup%  >> %LogFile%

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
FOR /F "tokens=1,2,3,4 delims=," %%A IN (%ExtractParamFile%) DO (
ECHO %date% %time% Processing File "%ProcessName%-%%C_%%D.csv" >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%SourceCSVDir%%ProcessName%-%%C_%%D.csv" -s"," -W -w 4000 -v Modulus = %%A Remainder = %%B DepartmentName = "%%C" >> %LogFile%)

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%SourceCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause

