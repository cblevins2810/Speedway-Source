// Special Import
// Convert excel spreadsheets to csv files
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSpecialCSV.js";
var processName = "Special";

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

	// Set up Excel
	var app = new ActiveXObject("Excel.Application");
	app.Visible = false;
	app.DisplayAlerts = false;
	
	var csvFileName = getXLSTemplateFolderPath(folderPath, fileName, processName) + "\FinalCSV\\" + fileName.substring(0,fileName.length-5)  + ".csv";
	var wb = app.Workbooks.Open(folderPath + fileName,  false);
	wb.SaveAs(csvFileName, 6);
	wb.Close();
	app.Quit();
	
    var tso = fso.OpenTextFile(csvFileName, 1); 
	var vInputLine;
	var currentSpecialExternalId; 
	var strFirstLine;
	var strSecondLive;
	var row;
	var i = 0;
	var bFirstTime = true ;
	var priorSpecialExternalId = "~99";
	var vSpecialLine = []; 
 
	// Read the first line
	if(!tso.AtEndOfStream)  
	{ 
		strFirstLine = tso.ReadLine();
	}
	// Read the second line
	if(!tso.AtEndOfStream)  
	{ 
		strSecondLine = tso.ReadLine();
	}
	
	var row = 0;
	// Loop through the file 
	while(!tso.AtEndOfStream)  
	{ 
		vInputLine = tso.ReadLine();
		currentSpecialExternalId = vInputLine.split(",")[0]; 
		
		if (bFirstTime) 
		{
			priorSpecialExternalId = currentSpecialExternalId;
		}
		
		if (priorSpecialExternalId != currentSpecialExternalId) 
		{
			row +=1;
			var tsoNewCSV = fso.CreateTextFile(csvFileName.slice(csvFileName,-4) + "_" + priorSpecialExternalId + ".csv");
			EchoAndLog(logFile, "File created in final csv folder: " + processName + "_" + priorSpecialExternalId + ".csv");		
			tsoNewCSV.WriteLine(strFirstLine);
			tsoNewCSV.WriteLine(strSecondLine);
			for (i = 0; i < vSpecialLine.length; i++)   
			{			
				tsoNewCSV.WriteLine(vSpecialLine[i]);
			}
			tsoNewCSV.Close();
			priorSpecialExternalId = currentSpecialExternalId;
			var vSpecialLine = []; 
		}

		vSpecialLine.push(vInputLine);
		bFirstTime = false;
	
	}

	row +=1;
	var tsoNewCSV = fso.CreateTextFile(csvFileName.slice(csvFileName,-4) + "_" + priorSpecialExternalId + ".csv");
	EchoAndLog(logFile, "File created in final csv folder: " + processName + "_" + priorSpecialExternalId + ".csv");		
	tsoNewCSV.WriteLine(strFirstLine);
	tsoNewCSV.WriteLine(strSecondLine);
	for (i = 0; i < vSpecialLine.length; i++)   
	{			
		tsoNewCSV.WriteLine(vSpecialLine[i]);
	}
	tsoNewCSV.Close();
	
	EchoAndLog(logFile, "Deleting File: " + csvFileName);
    tso.Close();
    fso.DeleteFile(csvFileName); 

	EchoAndLog(logFile, "...");
	
}

