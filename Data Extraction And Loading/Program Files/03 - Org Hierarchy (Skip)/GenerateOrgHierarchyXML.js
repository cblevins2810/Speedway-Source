// Org Hierarchy Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateOrgHierarchyXML.js";
var processName = "Org Hierarchy";

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

	var row = 0;
	
	// Loop through the file 
	while(!tso.AtEndOfStream)  
	{ 
		row +=1;
		strInput = tso.ReadLine();

        var vInputLine = strInput.split(",");     
		objXML.a = vInputLine[0];
		objXML.b = vInputLine[1];
		objXML.c = vInputLine[2];
		objXML.d = vInputLine[3];

		EchoAndLog(logFile, "Org Hierarchy #" + row + " Org Code: " + vInputLine[0]);
		
		objXMLDOMNode.appendChild(XMLFileNode(objDOMDocument,objXML));
	} 
	tso.Close();
 
	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
	
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\OrgHierarchyXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);

	EchoAndLog(logFile, "Completed XSL Transform.");
	
	// Grab just the file name minus any extension
	var destFolderName = foldername.substring(0,foldername.indexOf("\FinalCSV")) + "\FinalXML\\"; 
	var destFileName = filename.substring(0,filename.indexOf(".csv"));
	
	tmpxml = destFolderName + destFileName + ".xml";  

	// Write out the transformed file. If writing out just the xml file before transform  
  
	var FSObject = fso.CreateTextFile(tmpxml, true);
	FSObject.WriteLine(FinalStr);
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
	EchoAndLog(logFile, "Total Org Nodes: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destFileName + ".xml");
	EchoAndLog(logFile, "...");

}

function XMLHeader(objDOMDocument)
{ 
  var XMLHead;
  XMLHead = objDOMDocument.createNode(1, "Document",""); 
  
  var objXMLDOMAttribute = objDOMDocument.createAttribute("Version"); 
  objXMLDOMAttribute.text = "1.0";
  XMLHead.attributes.setNamedItem(objXMLDOMAttribute);
  
  var objXMLDOMAttribute = objDOMDocument.createAttribute("CreationTimestamp"); 
  objXMLDOMAttribute.text = getTimestamp();
  XMLHead.attributes.setNamedItem(objXMLDOMAttribute);
  
  return(XMLHead);
} 

function XMLFileNode(objDOMDocument,objXML)
{     
	var objXMLDOMNode = objDOMDocument.createNode(1, "RawXMLRow",""); 

	objXMLDOMElement = objDOMDocument.createElement("Name"); 
	objXMLDOMElement.text = formatXMLString(objXML.a);
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("LongName"); 
	objXMLDOMElement.text = formatXMLString(objXML.b);
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ParentOrgHierarchyName"); 
	objXMLDOMElement.text = formatXMLString(objXML.c);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("OrgHierarchyLevelName"); 
	objXMLDOMElement.text = formatXMLString(objXML.d);
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	return(objXMLDOMNode);
}
