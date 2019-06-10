ECHO OFF

REM Process Retail Items Repair
SET ProcessName=Retail Item Repair
SET ProcessCode=ItemRepair
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"

SET SourceRepairDir=..\..\Import Files\Retail Item\RepairSQL\
SET Server=EMCWD1401
SET DB=VP60_eso
SET User=esodbo
SET PW=esodbopwd


ECHO %date% %time% Starting %ProcessName% > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Execute Repair Files
ECHO %date% %time% Executing Repair Files >> %LogFile%
FOR /R %%A IN ("%SourceRepairDir%*.sql") DO (
ECHO %date% %time% Processing File: %%~nxA >> %LogFile%
SQLCmd -S %Server% -d %DB% -U %User% -P %PW% -i "%SourceRepairDir%%%~nxA" -o "%SourceRepairDir%%%~nA_Processed.txt" -s"," -W -w 4000 >> %LogFile%
ECHO %date% %time% Output File: %SourceRepairDir%%%~nA_Processed.txt >> %LogFile%
)

ECHO %date% %time% Completed Executing Repair Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% >> %LogFile%

PAUSE