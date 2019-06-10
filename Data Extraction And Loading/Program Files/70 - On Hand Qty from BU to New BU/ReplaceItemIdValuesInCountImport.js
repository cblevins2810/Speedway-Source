// Global Variables
var jsfileName = "ReplaceItemIdValuesInCountImport.js";
var processName = "On Hand Qty from BU to New BU";

var mapFilePath = "";
var mapFileName = "ItemIdMapping.csv";
var originalFileName = "Count Export Original.csv"
var replacedFileName = "Count Export Replaced.csv"
var itemCountLine = "";

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

// Set Folder names for processing
mapFilePath = includePath.substring(0, includePath.indexOf("Program Files", 0));
mapFilePath += "Import Files\\" + processName;
mapFilePath = mapFilePath + "\\MapFiles\\";

// Record Folder names in log file
EchoAndLog(logFile, "Mapping Folder:  " + mapFilePath);

// Get Array with BC ESO ID Mapping values for search
var bcId = [];
var esoId = [];

var i = 0;
var fso, fileItemIdMap, mapLine, fileOriginal, fileReplaced;
var ForReading = 1;
var ForWriting = 2;

var bReplaced = false;

fso = new ActiveXObject("Scripting.FileSystemObject");
fileItemIdMap = fso.OpenTextFile(mapFilePath + mapFileName, ForReading);

while (!fileItemIdMap.AtEndOfStream)
{
	// Get line and add array elements
	mapLine = fileItemIdMap.ReadLine();
	bcId[i] = mapLine.split(",")[0];
	esoId[i] = mapLine.split(",")[2];
	i++;
}

var numArrayElements = i;
fileItemIdMap.Close();

EchoAndLog(logFile, "Item IDs in mapping array:  " + numArrayElements);

fileOriginal = fso.OpenTextFile(mapFilePath + originalFileName, ForReading);
fileReplaced = fso.OpenTextFile(mapFilePath + replacedFileName, ForWriting, true);
fileReplaced.WriteLine ("business_unit_id,worksheet_id,inventory_item_id,count,last_count_timestamp");

if (!fileOriginal.AtEndOfStream)
	fileOriginal.ReadLine();

while (!fileOriginal.AtEndOfStream)
{
	itemCountLine = fileOriginal.ReadLine().split(",");
	
	bReplaced = false;
	
	for (i = 0; i <= numArrayElements; i++)
	{
		if (itemCountLine[2] == bcId[i])
		{ 
			bReplaced = true;
			itemCountLine[2] = esoId[i];
		}
	}
	
	if (bReplaced) 
	{
		EchoAndLog(logFile, "Processing Item Id: " + itemCountLine[2]);
		fileReplaced.WriteLine(itemCountLine);
	}

}

//Cleanup
EchoAndLog(logFile, "End Log");
logFile.Close();
fileOriginal.Close();
fileReplaced.Close();
esoId = null;
bcId = null;
fileItemIdMap = null;
fso = null;
fileStream = null;


