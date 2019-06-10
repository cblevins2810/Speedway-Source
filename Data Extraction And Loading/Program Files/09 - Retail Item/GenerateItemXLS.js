// Item Import
// Import a comma delimited file into an Excel spreadsheet
// ROC Associates Jan 2019

// Global Vars
var jsfileName = "GenerateItemXLS.js";
var processName = "Retail Item";

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
	var csvFileName = folderPath + fileName;
	var strInput; 
	var vInputLine = []; 
	var department;
 
	// Open the csv file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var tso = fso.OpenTextFile(csvFileName, 1); 
	EchoAndLog(logFile, "Found Input File: " + fileName);
	
	// Get the Department Name
	department = fileName.substring(fileName.indexOf(processName + "-") + processName.length+1,999);
	department = department.substring(0, department.indexOf("_"));
	
	EchoAndLog(logFile, "Department: " + department);

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

	var row = 4;
	var col = 1;
	// Added for count of elements in one line of the input CSV
	var n = 0;

    var dict = new ActiveXObject('Scripting.Dictionary');
	
 	// Loop through the file
	while (!tso.AtEndOfStream) // && (row < 11))
	{
		strInput = tso.ReadLine();
		vInputLine = strInput.split(",");
		// Get count of elements
		n = vInputLine.length;

		// Added n as comparison which is set above
		for (col = 1; col < n+1; col++)   
		{
			dict.add(col, vInputLine[col-1]);
		}
 		wb.ActiveSheet.Cells(row,1).Resize(1,n).value = dict.items();
		dict.removeAll();

		row ++;
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Item Rows: " + row);
		}
	}
	
	tso.Close();
	
	//showMessage(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\WorkingXLS\\");
	//showMessage(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\WorkingXLS\\" + fileName.slice(fileName,-4) + ".xlsx");
	wb.SaveAs(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\WorkingXLS\\" + fileName.slice(fileName,-4) + ".xlsx");
	wb.Close();
	app.Quit();
	
	EchoAndLog(logFile, "Finished Department: " + department);
	EchoAndLog(logFile, "Total Items: " + (row-4));
	EchoAndLog(logFile, "File created in working xls folder: " + processName + "-" + fileName.slice(fileName,-4) + ".xlsx");
	EchoAndLog(logFile, "Moving file " + fileName + " to Archive ");
	
	//showMessage(folderPath + fileName);
	//showMessage(folderPath + "Archive\\" + fileName);
	
	//fso.MoveFile(folderPath + fileName, folderPath + "Archive\\" + fileName.slice(fileName,-4) + getFileTimestamp() + ".csv");	
    //EchoAndLog(logFile, "Moved file " + fileName + " to Archive ");	

	EchoAndLog(logFile, "...");
	
}

