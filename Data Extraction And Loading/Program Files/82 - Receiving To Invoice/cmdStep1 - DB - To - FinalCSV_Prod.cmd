ECHO OFF

REM Process Receiving Documents to Invoices
SET ProcessName=Receiving To Invoice
SET ProcessCode=ReceivingToInvoiceExtract
SET LogFile=.\Logs\"%ProcessCode%%date:~4,2%-%date:~7,2%-%date:~12,2%-%time:~0,2%-%time:~3,2%-%time:~6,2%.log"
SET SQLExtractFile=%ProcessCode%.sql
SET SQLExtractParamFile=ReceivingToInvoiceCountForExtract.sql
SET ExtractParamFile=ReceivingToInvoiceCountForExtractParams.txt
SET FinalCSVDir=..\..\Import Files\Receiving To Invoice\FinalCSV\
SET Server=MPC9504
SET DB=bcssa

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
FOR /F "tokens=1,2,3,4 delims=," %%A IN (%ExtractParamFile%) DO (
ECHO %date% %time% Processing File "%ProcessName%-%%A-%%B.csv" >> %LogFile%
SQLCmd -S %Server% -d %DB% -E -i %SQLExtractFile% -o "%FinalCSVDir%%ProcessName%-%%A-%%B.csv" -s"," -W -w 4000 -v BusinessUnitCode = %%A BusinessDate = %%B >> %LogFile%)

ECHO %date% %time% Completed Extracting Files >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%

ECHO %date% %time% Directory Contents >> %LogFile%
DIR "%FinalCSVDir%*.csv" >> %LogFile%
ECHO %date% %time% .......... >> %LogFile%
ECHO %date% %time% Completed %ProcessName% Export >> %LogFile%

pause