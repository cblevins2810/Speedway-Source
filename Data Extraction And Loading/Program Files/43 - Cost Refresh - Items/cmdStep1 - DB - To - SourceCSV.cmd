ECHO OFF

REM Process Supplier Cost Update
SET ProcessName=Supplier Item Cost Refresh - Items
SET ProcessCode=SupplierItemExtractCostRefreshItems
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=SupplierItemExtract.sql
SET SQLExtractParamFile=SupplierItemCountForExtract.sql
SET ExtractParamFile=SupplierItemCountForExtractParmams.txt
SET SourceCSVDir=..\..\Import Files\Supplier Item Cost Refresh - Items\SourceCSV\
SET Server=EMCWD1401
SET DB=VP60_spwy
SET User=esodbo
SET PW=esodbopwd

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Build Extract Params
ECHO %date% %time% Generating Parameters for Extract >> %LogFile%

SQLCmd -S %Server% -d %DB% -U %User% -P %PW% -i %SQLExtractParamFile% -o %ExtractParamFile% -s"," -W -w 4000 >> %LogFile%
ECHO %date% %time% Param File Generated >> %LogFile%
ECHO %date% %time% Param File Contents >> %LogFile%
TYPE %ExtractParamFile% >> %LogFile%
ECHO %date% %time% Completed Extracting Params >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Generate Extract Files
ECHO %date% %time% Extracting Files >> %LogFile%
FOR /F "tokens=1,2 delims=," %%A IN (%ExtractParamFile%) DO (
ECHO %date% %time% Processing File "%ProcessName%-%%A_%%B.csv" >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%SourceCSVDir%%ProcessName%-%%A_%%B.csv" -s"," -W -w 4000 -v SupplierXRef = "%%A" BatchNumber = "%%B" >> %LogFile%)

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%SourceCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause