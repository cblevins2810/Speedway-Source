// XML Import Files
// Replace Sales IDs in RPOS XML Files
// ROC Associates April 2019

// Global Variables
var jsfileName = "ReplaceIdValuesInXMLUploadFiles.js";
var processName = "Replace Id Values in XML Upload Files";

// Other Variables
var sMappingFileName = "BCtoESO - RMI Mapping.csv";
var sMappingFilePath = "";
var sPreIdTag = "<SalesItemID>";
var sPostIdTag = "</SalesItemID>";


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
EchoAndLog(logFile, "------------------------------------------------");
EchoAndLog(logFile, "");

// Set Folder names for processing
sSourceFilePath = includePath.substring(0, includePath.indexOf("Program Files", 0));
sSourceFilePath += "Import Files\\" + processName;
sMappingFilePath = sSourceFilePath + "\\MapFiles\\";

// Record Folder names in log file
EchoAndLog(logFile, "------------------------------------------------");
EchoAndLog(logFile, "");
EchoAndLog(logFile, "Mapping Folder:  " + sMappingFilePath);
EchoAndLog(logFile, "");

// Get Array with BC ESO ID Mapping values for search
var array_bc = [];
var array_eso = [];
var array_regexp = [];
var i = 0;
var fsomap, tsmap, smap, rmap;
var ForReading = 1;
fsomap = new ActiveXObject("Scripting.FileSystemObject");
tsmap = fsomap.OpenTextFile(sMappingFilePath+sMappingFileName, ForReading);
while (!tsmap.AtEndOfStream)
{
	// Get line
	smap = tsmap.ReadLine();
	// Get values in array
	rmap = smap.split(",");
	array_bc[i] = sPreIdTag + rmap[0] + sPostIdTag;
	array_eso[i] = sPreIdTag + rmap[1] + sPostIdTag;
	// Set RegExp to be used for replacement of IDs in function "replaceIDs"
	array_regexp [i] = new RegExp(array_bc[i], "g");
	i++;

}
var numArrayElements = i;
tsmap.Close();

EchoAndLog(logFile, "Sales Item IDs Reference");
EchoAndLog(logFile, "------------------------------------------------");
EchoAndLog(logFile, "");
EchoAndLog(logFile, "Sales Item IDs in mapping array:  " + numArrayElements);
EchoAndLog(logFile, "");

var tStart = new Date().getTime();
var tEnd;
var processTime;


//Main Processing
try
{ 

	// Process Files
    processSourceXMLFiles(
    "C:\\Test Replace Id Values in XML Files\\1000008\\05-22-2019\\",
    "C:\\Test Replace Id Values in XML Files\\1000008\\Replaced\\05-22-2019\\",
    "C:\\Test Replace Id Values in XML Files\\1000008\\Replaced\\05-22-2019\\Errors\\",
    array_bc, array_eso, array_regexp, numArrayElements); 

}
catch(err)
{
	EchoAndLog(logFile, "Error --> " + err.message);
}

//Cleanup
tEnd = new Date().getTime();
processTime = tEnd - tStart;
var minutes = Math.floor(processTime/1000/60);
var seconds = Math.ceil((processTime/1000) - (minutes * 60));
EchoAndLog(logFile, "End Log - Total Process Time: " + minutes + " min " + seconds + " sec");
logFile.Close();
array_regexp = null;
array_eso = null;
array_bc = null;
tsmap = null;
fsomap = null;
fileStream = null;
fso = null;



// Iterates through each xml file and calls the function to process the file
function processSourceXMLFiles(srcfolderPath, rplfolderPath, errfolderPath, bc_array, eso_array, regexp_array, nArrayElem)
{
	var fso, f, fc, fileName;
	
	EchoAndLog(logFile, "Searching for XML Files");
	EchoAndLog(logFile, "------------------------------------------------");
	EchoAndLog(logFile, "");
	
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.GetFolder(srcfolderPath);
	fc = new Enumerator(f.files);
	
	if (fc.atEnd())
	{
		EchoAndLog(logFile, " No files found in Source folder");
	}
	else
	{

		EchoAndLog(logFile, " Files found in Source folder");
	}	
	
	EchoAndLog(logFile, "");
	
	for (; !fc.atEnd(); fc.moveNext())
	{
		fileName = "";
		fileName += fc.item();
		//fileName = fileName.substring(fileName.indexOf("\SourceXML") + 10,999);
      
	  
		if ((fileName.slice(-4) == ".xml") && (fileName.indexOf("Device") == -1))  // Ignore the Site Device File
		{
			EchoAndLog(logFile, " Processing File: " + fileName);
			EchoAndLog(logFile, "");
			
			replaceIDs(srcfolderPath, rplfolderPath, errfolderPath, fileName, bc_array, eso_array, regexp_array, nArrayElem);
			
			EchoAndLog(logFile, " Finished File:   " + fileName);
			EchoAndLog(logFile, "");
		}
	}  
   
	fso = null;
}


function  replaceIDs(srcfolderPath, rplfolderPath, errfolderPath, fileName, bc_array, eso_array, regexp_array, nArrayElem)
{ 
	// Decision Variables
	var bReplace = true;
	var bLogging = false;
	
	// Be careful with this setting.  By default the xml files from the POS are unicode.  If the contents of the file are cut and pasted, the format will change to ASCII.
	//var fileFormat = 0; // for ASCII 
	var fileFormat = -1; // for Unicode
	
	// Count Variables
	var x = 0;
	var rString = "";
	var rCount = 0;
	var iSalesItemReplacedCount = 0;
	var iSalesItemTotalCount = 0;
	var iEmplTotalCount = 0;
	
	// Preset Tag Variables and Reg Expressions for comparison
	var sSalesItemIdTag = "<SalesItemID>";
	var sRegExpSalesItemTag = new RegExp(sSalesItemIdTag, "g");
	var sEmplPreIdTag = "<EmployeeID>";
	var sEmplPostIdTag = "</EmployeeID>";
	var sRegExpEmplTag = new RegExp(sEmplPreIdTag + ".{1,7}" + sEmplPostIdTag, "g");
	// Employee ID replacement
	var sEmplReplaceTag = "<EmployeeID>297193</EmployeeID>";
	// Holder, Yolanda = 5066115
	//var sEmplReplaceTag = "<EmployeeID>5066115</EmployeeID>";
	//var sEmplReplaceTag = "<EmployeeID>1xxxxx1</EmployeeID>";
	
	// File Identifiers
	var sId_BU_Status		= "DM_RadXML_BUStatus_Import";
	var sRegExpBUStatus 	= new RegExp(sId_BU_Status);
	var sID_Summary_EOD		= "DM_RadXML_Summary_EODFinal";
	var sRegExpSumEOD		= new RegExp(sID_Summary_EOD);
	var sID_Summary			= "DM_RadXML_Summary_Import";
	var sRegExpSum			= new RegExp(sID_Summary);
	var sID_Site_Device		= "Site_Device_Import";
	var sRegExpSiteDevice	= new RegExp(sID_Site_Device);
		
	// File Handling Variables
	var fsosrc, tssrc, ssrc;
	var ForReading = 1;
	var fsotgt, tstgt, stgt;
	var ForWriting = 2;
	
	// -------------------------------------------------------------------------------------------
	// Open source file, read complete content, and close file
	// -------------------------------------------------------------------------------------------
	fsosrc = new ActiveXObject("Scripting.FileSystemObject");

	tssrc = fsosrc.OpenTextFile(fileName, ForReading, false, fileFormat);
	ssrc = tssrc.readAll();
	showMessage(ssrc.substr(0,1000));
	// Close source file
	tssrc.Close();
	
	// -------------------------------------------------------------------------------------------
	// Replace BC Sales Item IDs for all occurrences found based on BC/ESO Mapping Array
	// -------------------------------------------------------------------------------------------
	// Set target file content to original source content
	stgt = ssrc;
	// Get total count of Sales Item Ids in content
	rString = ssrc.match(sRegExpSalesItemTag);
	if (rString == null)
	{
		iSalesItemTotalCount = 0;
	}
	else
	{
		iSalesItemTotalCount = rString.length;
	}
	rString = null;
	
	// Attempt only if there are any occurrences of SalesItemIDs
	// otherwise no need to process
	showMessage(iSalesItemTotalCount);
	if (iSalesItemTotalCount > 0)
	{

		showMessage("Are we even here?")

		// Loop through all mapped BC Sales Item IDs in the array to replace in target content
		for (x=0; x<nArrayElem; x++) {

			// Get count for occurrences of current BC ID
			rString = ssrc.match(regexp_array[x]);
			if (rString == null)
			{
				rCount = 0;
			}
			else
			{
				rCount = rString.length;
			}
			// Replace and Log the replacement (only if there are occurrences for current BC ID)
			if (rCount > 0)
			{
				// Replace the IDs
				stgt = stgt.replace(regexp_array[x], eso_array[x]);
				iSalesItemReplacedCount += rCount;
				if (bLogging) EchoAndLog(logFile, " ---> Replaced " + rCount + " occurrences of " + bc_array[x] + " with " + eso_array[x]);
			}
			// Cleanup
			rCount = 0;
			rString = null;
		}
	}
	
	// -------------------------------------------------------------------------------------------
	// Replace Employee IDs for all occurrences with one preset ID
	// -------------------------------------------------------------------------------------------
	// Get total count of Employee Ids in content
	rString = ssrc.match(sRegExpEmplTag);
	if (rString == null)
	{
		iEmplTotalCount = 0;
	}
	else
	{
		iEmplTotalCount = rString.length;
		stgt = stgt.replace(sRegExpEmplTag, sEmplReplaceTag);
	}
	
	// Log counts
	EchoAndLog(logFile, " ---> Total Count of replaced Sales Item IDs: " + iSalesItemReplacedCount);
	EchoAndLog(logFile, " ---> Total Count of all Sales Item IDs:      " + iSalesItemTotalCount);
	EchoAndLog(logFile, " ---> Total Count of all Employee IDs:        " + iEmplTotalCount);
	
	// Determine where file will be placed (replaced or error folder)
	if (iSalesItemReplacedCount > 0)
	{
		bReplace = true;
	}
	else
	{
		bReplace = false;
		// Check for exception based on file identifier
		rString = ssrc.match(sRegExpBUStatus);
		if (rString != null)
		{
			bReplace = true;
			if (bLogging) EchoAndLog(logFile, " ---> BU Status File (" + sId_BU_Status + ") always moved to replaced folder");
		}
		rString = ssrc.match(sRegExpSumEOD);
		if (rString != null)
		{
			bReplace = true;
			if (bLogging) EchoAndLog(logFile, " ---> EOD Summary File (" + sID_Summary_EOD + ") always moved to replaced folder");
		
		}
		rString = ssrc.match(sRegExpSiteDevice);
		if (rString != null)
		{
			bReplace = true;
			if (bLogging) EchoAndLog(logFile, " ---> Site Device File (" + sID_Site_Device + ") always moved to replaced folder");
		
		}
	}
	rString = "";
	
	// -------------------------------------------------------------------------------------------
	// Open target file, write complete content, and close file
	// -------------------------------------------------------------------------------------------
	fsotgt = new ActiveXObject("Scripting.FileSystemObject");
	if (bReplace)
	{

		fileName = rplfolderPath + "r_" + fileName.substring(fileName.indexOf("DM_RadXML"), 512);
		tstgt = fsotgt.OpenTextFile(fileName, ForWriting, true, fileFormat);
		
	}
	else
	{

	    fileName = errfolderPath + "e_" + fileName.substring(fileName.indexOf("DM_RadXML"), 512)
		tstgt = fsotgt.OpenTextFile(fileName, ForWriting, true, fileFormat);
		
	}
	// Write file and close
	tstgt.WriteLine(stgt);
	tstgt.Close();
	
	// -------------------------------------------------------------------------------------------
	// Log file creation: folder and file name
	// -------------------------------------------------------------------------------------------
	EchoAndLog(logFile, " ---> File created: " + rString + fileName);
	EchoAndLog(logFile, "");
	
	// -------------------------------------------------------------------------------------------
	// Cleanup
	// -------------------------------------------------------------------------------------------
	sRegExpSiteDevice	= null;
	sRegExpSum			= null;
	sRegExpSumEOD		= null;
	sRegExpBUStatus		= null;
	sRegExpSalesItemTag	= null;
	sRegExpEmplTag		= null;
	tstgt				= null;
	fsotgt				= null;
	tssrc				= null;
	fsosrc				= null;
	
}


