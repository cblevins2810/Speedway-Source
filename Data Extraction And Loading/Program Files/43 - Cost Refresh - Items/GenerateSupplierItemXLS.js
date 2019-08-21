// Supplier Item Import
// Convert a comma delimited file into the JDA ESO Import XLS Template
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSupplierItemXLS.js";
var processName = "Cost Refresh - Items";

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
//try
//{
	processSourceCSVFiles(getSourceCSVFolderPath(jsfileName, processName));
//}
//catch(err)
//{
//	EchoAndLog(logFile, "Error --> " + err.message);
//}

//Cleanup
EchoAndLog(logFile, "End Log");
logFile.Close();
fileStream = null;
fso = null;

function  importCSVtoXLS(folderPath, fileName)
{ 
	var supplier = "";
	var supplierXref = "";
	var extractBatchNumber = "";
	var csvfileName = folderPath + fileName;
	var strInput; 
	var vInputLine = []; 
 
	// Open the csv file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var tso = fso.OpenTextFile(csvfileName, 1); 
	EchoAndLog(logFile, "Found Input File: " + fileName);
   
	// Get the Supplier Xref
	supplierXref = fileName.substring(fileName.indexOf(processName + "-") + processName.length+1,999);
	supplierXref = supplierXref.substring(0, supplierXref.indexOf("_"));
	
	// Get the Supplier
	supplier = fileName.substring(fileName.indexOf(supplierXref + "_") + supplierXref.length + 1);
	supplier = supplier.substring(0, supplier.indexOf("_"));
	
	// Get the Supplier Batch Number
	extractBatchNumber = fileName.substring(fileName.indexOf(supplier + "_") + supplier.length + 1);
	extractBatchNumber = extractBatchNumber.substring(0, extractBatchNumber.indexOf("."));

	EchoAndLog(logFile, "Processing Supplier: " + supplier + " Xref: " + supplierXref);

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
 
	var currentCell = wb.ActiveSheet.Cells(1,2);
	currentCell.Value = supplier;
	currentCell = wb.ActiveSheet.Cells(2,2);
	currentCell.Value = supplierXref;
	
	var row = 5;
	var col = 1;

    var dict = new ActiveXObject('Scripting.Dictionary');
	
 	// Loop through the file
	while(!tso.AtEndOfStream)  
	{
		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 

		for (col = 1; col < 21; col++)   
		{
			dict.add(col, vInputLine[col-1]);
		}
 		wb.ActiveSheet.Cells(row,1).Resize(1,20).value = dict.items();
		dict.removeAll();
		row ++;
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Supplier Item Rows: " + row);
		}
	}

	wb.SaveAs(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\WorkingXLS\\" + processName + "-" + supplierXref + "_" + supplier + "_" + extractBatchNumber + ".xlsx");
	wb.Close();
	app.Quit();
	
	EchoAndLog(logFile, "Finished Supplier: " + supplier + " Xref: " + supplierXref);
	EchoAndLog(logFile, "Total Items: " + (row-5));
	EchoAndLog(logFile, "File created in working xls folder: " + processName + "-" + supplier + "_" + supplierXref + "_" + extractBatchNumber + ".xlsx");
	EchoAndLog(logFile, "...");
	
}

