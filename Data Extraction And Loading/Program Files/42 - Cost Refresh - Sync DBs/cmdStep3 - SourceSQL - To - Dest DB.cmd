ECHO OFF

REM Supplier Item Cost Refresh
SET ProcessName=Supplier Item Cost Refresh
SET ProcessCode=SupplierItemCostRefresh
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"

SET SourceSQLDir=..\..\Import Files\Supplier Item Cost Refresh\SourceSQL\
SET Server=EMCWD1401
SET DB=VP60_spwy
SET User=esodbo
SET PW=esodbopwd

ECHO %date% %time% Starting %ProcessName% > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Import Cost Files
ECHO %date% %time% Importing Cost Files >> %LogFile%
FOR /R %%A IN ("%SourceSQLDir%*.sql") DO (
ECHO %date% %time% Processing File: %%~nxA >> %LogFile%
SQLCmd -S %Server% -d %DB% -U %User% -P %PW% -i "%SourceSQLDir%%%~nxA" -o "%SourceSQLDir%%%~nA_Processed.txt" -s"," -W -w 4000 >> %LogFile%
ECHO %date% %time% Output File: %SourceSQLDir%%%~nA_Processed.txt >> %LogFile%
)

ECHO %date% %time% Completed Executing SQL Import >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% >> %LogFile%

PAUSE