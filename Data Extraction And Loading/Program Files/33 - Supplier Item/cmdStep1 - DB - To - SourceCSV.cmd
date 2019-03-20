ECHO OFF

REM Process Supplier Items
SET ProcessName=Supplier Item
SET ProcessCode=SupplierItemExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET SQLExtractParamFile=SupplierItemCountForExtract.sql
SET ExtractParamFile=SupplierItemCountForExtractParmams.txt
SET SourceCSVDir=..\..\Import Files\Supplier Item\SourceCSV\
SET Server=EMCTS520
SET DB=bcssa_cert2

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
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
FOR /F "tokens=1,2,3,4,5 delims=," %%A IN (%ExtractParamFile%) DO (
ECHO %date% %time% Processing File "%ProcessName%-%%C_%%D_%%E.csv" >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%SourceCSVDir%%ProcessName%-%%C_%%D_%%E.csv" -s"," -W -w 4000 -v Modulus = %%A Remainder = %%B SupplierXRef = "%%C" >> %LogFile%)

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%SourceCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause