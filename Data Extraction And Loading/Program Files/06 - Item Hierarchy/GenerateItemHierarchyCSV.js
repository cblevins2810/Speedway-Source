// Item Import
// Convert excel spreadsheets to csv files
// ROC Associates Dec 2018

// Global Vars
var jsfileName = "GenerateItemHierarchyCSV.js";
var processName = "Item Hierarchy";

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
	wb.SaveAs(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\FinalCSV\\" + fileName.substring(0,fileName.length-5)  + ".csv", 6);
	wb.Close();
	app.Quit();
	
	EchoAndLog(logFile, "Finished File: " + fileName);
	EchoAndLog(logFile, "File created in final csv folder: " + fileName.substring(0,fileName.length-5)  + ".csv");
	EchoAndLog(logFile, "...");
	
}

