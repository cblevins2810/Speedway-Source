ECHO OFF

REM Supplier Item Cost Refresh
SET ProcessName=Cost Refresh - Items
SET ProcessCode=CostRefreshItems
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"

SET Server=EMCWD1401
SET DB=VP60_eso
SET User=esodbo
SET PW=esodbopwd

ECHO %date% %time% Starting %ProcessName% > %LogFile%
ECHO %date% %time% .......... >> %LogFile%

REM Mark as Exported
ECHO %date% %time% Starting Mark as Exported >> %LogFile%

SQLCmd -S %Server% -d %DB% -U %User% -P %PW% -iSupplierItemCostMarkAsExported.sql >> %LogFile%

ECHO %date% %time% Starting Mark as Exported >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% >> %LogFile%

PAUSE