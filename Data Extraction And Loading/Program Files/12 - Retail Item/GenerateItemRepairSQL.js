// Item Import
// Convert excel spreadsheets to csv files
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateItemCSV.js";
var processName = "Retail Item";

// Include Common Functions
var fso = new ActiveXObject ("Scripting.FileSystemObject");
var includePath = fso.GetAbsolutePathName(".");
includePath = includePath.substring(0,includePath.indexOf(processName,0)-5);   // Minus 5 removes the sequence number of the directory.  i.e., "01 - "
var fileStream = fso.openTextFile (includePath + "\Common\\ImportUtils.js");
var fileData = fileStream.readAll();
fileStream.Close();
eval(fileData);

// Create Log File
var logPath = fso.GetAbsolutePathName(".") + "\\Logs\\";
var logFile = fso.CreateTextFile(logPath + "\\" + processName + getFileTimestamp() + ".log", 1);
EchoAndLog(logFile, "Start Log");

// Main Processing
try
{
	processFinalXLSFiles(getFinalXLSFolderPath(jsfileName, processName));
}
catch(err)
{
	EchoAndLog(logFile, "Error --> " + err.message);
}

//Cleanup
EchoAndLog(logFile, "End Log");
logFile.Close();
fileStream = null;
fso = null;

function  saveXLStoCSV(folderPath, fileName)
{ 
 
	EchoAndLog(logFile, "Processing File: " + fileName);

	// Set up Excel
	var app = new ActiveXObject("Excel.Application");
	app.Visible = false;
	app.DisplayAlerts = false;
	
	var wb = app.Workbooks.Open(folderPath + fileName,  false);

	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var outputFile = fso.CreateTextFile(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\RepairSQL\\" + fileName.substring(0,fileName.length-5)  + ".sql", 6, true);
	
//--------------------

	var row = 4;
	var col = 1;
	// Added for count of elements in one line of the input CSV
	var n = 0;
	var itemXrefId = "";
	var priorItemXrefId = "";
	var itemStrategy = "";
	var rmiXrefId = "";
	var rmiMerchGroup = "";
	var rmiLine = "";
    
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	
 	// Loop through the file
	while (true) // && (row < 11))
	{

		if (wb.ActiveSheet.Cells(row,1).Text == "")
		{
			break;
		}

		if (wb.ActiveSheet.Cells(row,1).Text != priorItemXrefId) 
		{
			itemXrefId = wb.ActiveSheet.Cells(row,1).Text;
			itemStrategy = wb.ActiveSheet.Cells(row,31).Text;
			manufacturer = wb.ActiveSheet.Cells(row,9).Text;
			priorItemXrefId = itemXrefId;
		}
		
		if ((wb.ActiveSheet.Cells(row,40).Text != "") && (wb.ActiveSheet.Cells(row,39).Text != ""))
		{	
			rmiXrefId = wb.ActiveSheet.Cells(row,40).Text;
			rmiMerchGroup = wb.ActiveSheet.Cells(row,39).Text ;
			rmiLine = 	"INSERT bc_extract_repair_manufacturer_and_strategy (fileName, itemXrefId, manufacturer, itemStrategy, rmiXrefId, rmiMerchGroup) SELECT " +
						"'" + fileName + "'," +
			            "'" + itemXrefId + "',";
						if (manufacturer != "")
						{
							manufacturer = manufacturer.replace(/'/g,"\''");
							manufacturer = manufacturer.replace(/~/g,"\,");
							rmiLine += "'" + manufacturer + "'," ;
						}
						else
						{
							rmiLine += "NULL,";
						}
						rmiLine += "'" + itemStrategy + "'," +
						"'" + rmiXrefId + "'," + 
						"'" + rmiMerchGroup + "'";
			
			outputFile.WriteLine(rmiLine);
		}
		
		row ++;
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Item Rows: " + row + ", External Id: " + itemXrefId);
		}
	}
	
//--------------------

	outputFile.Close();
	
	wb.Close();
	app.Quit();
	
	EchoAndLog(logFile, "Finished File: " + fileName);
	EchoAndLog(logFile, "File created in final csv folder: " + fileName.substring(0,fileName.length-5)  + ".csv");
	EchoAndLog(logFile, "...");
	
}

