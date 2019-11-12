// Supplier Item Cost Refresh
// Read and comma delimited file and convert it to SQL statements
// ROC Associates Jan 2019

// Global Vars
var jsfileName = "GenerateCostSQL.js";
var processName = "Cost Refresh - SyncDBs";

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

        showMessage(getSourceCSVFolderPath(jsfileName, processName));

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
	var csvFileName = folderPath + fileName;
	var strInput; 
	var vInputLine = [];
    var row = 0; 
	var costLine = "";
	var eventLine = "";
	
	// Open the csv file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var tso = fso.OpenTextFile(csvFileName, 1); 
	EchoAndLog(logFile, "Found Input File: " + fileName);

    // Create the SQL file
	var outputFile = fso.CreateTextFile(getXLSTemplateFolderPath(folderPath, fileName, processName) + "\SourceSQL\\" + fileName.substring(0,fileName.length-4)  + ".sql", 6, true);

	// Eat the first header line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
	// Eat first ---- line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
 
	// Write the Event Line (Only one per file)
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 

		eventLine = "INSERT bc_extract_cost_import (ImportId,SupplierXrefCode,EffectiveDate,ExecutionDate,ExportedTimeStamp,ImportedTimeStamp) SELECT " +
					vInputLine[0] + "," +
					"'" + vInputLine[1] + "'," +
					"'" + vInputLine[2] + "'," +
					"'" + vInputLine[3] + "'," +
					"'" + vInputLine[4] + "00',"  +  // Hack for some issue I don't have time to figure out right now.  SQL cmd is returning time as 00:00: so I add 00 to fix it.
					"GETDATE()" ;
			
		outputFile.WriteLine(eventLine);
	}
	
	// Eat the second header line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
	// Eat second ---- line
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}

 // Loop through the file
	while (!tso.AtEndOfStream) 
	{
		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 

		costLine = 	"INSERT bc_extract_cost_import_supplier_item (ImportId,SupplierItemCode,CostLevelName," +
					"SupplierPrice,SupplierAllowance,StartDate,EndDate,PromoFlag) SELECT " +
					vInputLine[0] + "," +
					"'" + formatXMLString(vInputLine[1]) + "'," +
					"'" + vInputLine[2] + "'," +
					vInputLine[3] + "," +
					vInputLine[4] + "," +
					"'" + vInputLine[5] + "'," +
					"'" + vInputLine[6] + "'," +
					"'" + vInputLine[7] + "'";
			
		outputFile.WriteLine(costLine);

		row ++;
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Item Rows: " + row);
		}
	}
	
	tso.Close();
	outputFile.Close();

	EchoAndLog(logFile, "Total Costs: " + (row));
	EchoAndLog(logFile, "File created in final SQL folder: " + processName + "-" + fileName.slice(fileName,-4) + ".sql");
	
	EchoAndLog(logFile, "...");
	
}

