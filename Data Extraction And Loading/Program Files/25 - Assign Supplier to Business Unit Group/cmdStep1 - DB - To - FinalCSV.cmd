ECHO OFF

REM Process Supplier Assignment to Business Unit Groups
SET ProcessName=Assign Supplier to Business Unit Group
SET ProcessCode=SupplierAssignmentByBusinessUnitGroupExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET FinalCSVDir=..\..\Import Files\Assign Supplier to Business Unit Group\FinalCSV\
SET Server=EMCTS520
SET DB=bcssa_cert2

ECHO %date% %time% Starting %ProcessName% Export > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Generate Extract Files
ECHO %date% %time% Extracting Files >> %LogFile%

SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%FinalCSVDir%%ProcessName%-All Suppliers Business Unit Group Assignments.csv" -s"," -W -w 4000

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%FinalCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause
