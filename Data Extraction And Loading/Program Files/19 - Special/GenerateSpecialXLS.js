// Special
// Convert a comma delimited file into the JDA ESO Import XLS Template
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSpecialItemXLS.js";
var processName = "Special";

// Include Common Functions
var fso = new ActiveXObject ("Scripting.FileSystemObject");
var includePath = fso.GetAbsolutePathName(".");
includePath = includePath.substring(0,includePath.indexOf(processName,0)-5);  // Minus 5 removes the sequence number of the directory.  i.e., "01 - "
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
	processSourceCSVFiles(getSourceCSVFolderPath(jsfileName, processName));
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

function  importCSVtoXLS(folderPath, fileName)
{ 

	var csvfileName = folderPath + fileName;
	var strInput; 
	var vInputLine = []; 
 
	// Open the csv file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var tso = fso.OpenTextFile(csvfileName, 1); 
	EchoAndLog(logFile, "Found Input File: " + fileName);
   
	// Eat the header line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
	// Eat ---- line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
 
	// Set up Excel
	var app = new ActiveXObject("Excel.Application");
	app.Visible = false;
	app.DisplayAlerts = false;
	
	var wb = app.Workbooks.Open(getXLSTemplateFolderPath(folderPath, fileName, processName) + processName + " Import Template.xlsx",  false);
 
	var row = 3;
	var col = 1;

    var dict = new ActiveXObject('Scripting.Dictionary');
	
 	// Loop through the file
	while(!tso.AtEndOfStream)  
	{
		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 

		for (col = 1; col < 15; col++)   
		{
			dict.add(col, vInputLine[col-1]);
		}
 		wb.ActiveSheet.Cells(row,1).Resize(1,14).value = dict.items();
		dict.removeAll();
		row ++;
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Special Rows: " + row);
		}
	}

	wb.SaveAs(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\WorkingXLS\\" + fileName.substring(0,fileName.indexOf(".csv")) + ".xlsx");
	wb.Close();
	app.Quit();
	
	EchoAndLog(logFile, "Total Specials: " + (row-5));
	EchoAndLog(logFile, "File created in working xls folder: " + fileName.substring(0,fileName.indexOf(".csv")) + ".xlsx");
	EchoAndLog(logFile, "...");
	
}

