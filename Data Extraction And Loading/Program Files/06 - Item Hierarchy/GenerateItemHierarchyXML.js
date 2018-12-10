// Item Hierarchy Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates Dec 2018

// Global Vars
var jsfileName = "GenerateItemHierarchyXML.js";
var processName = "Item Hierarchy";

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
	processFinalCSVFiles(getFinalCSVFolderPath(jsfileName, processName));
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

// Import Functions
function  convertCSVtoXML(foldername, filename)
{ 
	var objDOMDocument = new ActiveXObject("MSXML2.DOMDocument.6.0"); 
	objDOMDocument.async = false; 
  
	//Create Header
	objDOMDocument.appendChild(XMLHeader(objDOMDocument)); 
	var objXMLDOMNode = objDOMDocument.documentElement.selectSingleNode("//Document"); 
 
	// Declare XML object -- this makes it easier to pass as a parameter 
	var objXML  = new Object(); 
  
	// Open the extracted csv from zip file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
  
	var csvFilename = foldername + filename;
  
	var tso = fso.OpenTextFile(csvFilename, 1); 
	var strInput;
  
  	// Get the header line (first line)
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}

	var row = 0;
	
	// Loop through the file 
	while(!tso.AtEndOfStream)	  
	{
		// Get the next line, thus eating the header line
		strInput = tso.ReadLine();
		
		// Check if next line is a "----" line
		// This check is added to support the direct import of the Source .csv file without review step
		// as the Source .csv file would have the "----" line
		if (strInput.substring(0,10) == "----------")
		{
			// This will stop processing this line and continue the loop
			continue;
		}
		
		row +=1;
		
		var vInputLine = strInput.split(",");     
		objXML.a = vInputLine[0];
		objXML.b = vInputLine[1];
		objXML.c = vInputLine[2];
		objXML.d = vInputLine[3];
		objXML.e = vInputLine[4];

		EchoAndLog(logFile, "Item Hierarchy #" + row + " Name: " + vInputLine[0]);	
	
		objXMLDOMNode.appendChild(XMLFileNode(objDOMDocument,objXML));
	} 
	tso.Close();
  
  	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
  
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\ItemHierarchyXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var finalStr = TempStagingDoc.transformNode(TransformXSL);
	
	// For some reason the apostrophe breaks the category import, even when imported as &apos;.
	// Replacing apostrophe with a custom place string **apos** and will fix after import via SQL
	// finalStr = finalStr.replace(/'/g,'*apos*');
	
	EchoAndLog(logFile, "XSL Transform Complete.");
	
	// Grab just the file name minus any extension

	var destFolderName = foldername.substring(0,foldername.indexOf("\FinalCSV")) + "\FinalXML\\"; 
	var destFileName = filename.substring(0,filename.indexOf(".csv"));
	
	tmpxml = destFolderName + destFileName + ".xml";  

	// Write out the transformed file. If writing out just the xml file before transform  
  
	var FSObject = fso.CreateTextFile(tmpxml, true);
	FSObject.WriteLine(finalStr);
	FSObject.Close();
  
	// Create empty .flag file then rename it
	tmpxml += ".flag";
	var fsoEmptyFile = fso.CreateTextFile(tmpxml, true);
	fsoEmptyFile.Close();
  
	objDOMDocument = null; 
	fso = null;
	TransformXSL = null;
	objXML = null;
	TempStagingDoc = null;
	
	EchoAndLog(logFile, "Finished Generating XML");
	EchoAndLog(logFile, "Total Category Nodes: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destFileName + ".xml");
	EchoAndLog(logFile, "...");

}

function XMLHeader(objDOMDocument)
{ 
  var XMLHead;
  XMLHead = objDOMDocument.createNode(1, "Document",""); 
  
  return(XMLHead);
} 

function XMLFileNode(objDOMDocument,objXML)
{     
	var objXMLDOMNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
  
	objXMLDOMElement = objDOMDocument.createElement("ExternalID"); 
	objXMLDOMElement.text = formatXMLString(objXML.a);
	objXMLDOMNode.appendChild(objXMLDOMElement);
 
	objXMLDOMElement = objDOMDocument.createElement("CategoryName");
	objXMLDOMElement.text = formatXMLString(objXML.b);
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("CategoryLevel"); 
	objXMLDOMElement.text = objXML.c;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("ParentCategoryExternalID"); 
	objXMLDOMElement.text = formatXMLString(objXML.d);
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("NonTaxable"); 
	objXMLDOMElement.text = formatXMLString(objXML.e);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	return(objXMLDOMNode);
}
