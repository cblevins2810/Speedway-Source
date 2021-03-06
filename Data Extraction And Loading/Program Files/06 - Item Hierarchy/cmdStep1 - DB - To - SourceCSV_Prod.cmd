ECHO OFF

REM Process Item Hierarchies
SET ProcessName=Item Hierarchy
SET ProcessCode=ItemHierarchyExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET SourceCSVDir=..\..\Import Files\Item Hierarchy\SourceCSV\
SET Server=MPC9504
SET DB=bcssa

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Generate Extract Files
ECHO %date% %time% Extracting Files >> %LogFile%

SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%SourceCSVDir%%ProcessName%-All Hierarchies.csv" -s"," -W -w 4000

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%SourceCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause

