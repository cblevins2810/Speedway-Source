// Business Unit Price Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateBusinessUnitPriceChangeXML.js";
var processName = "Business Unit Price Change";

// Include Common Functions
var fso = new ActiveXObject ("Scripting.FileSystemObject");
var includePath = fso.GetAbsolutePathName(".");
includePath = includePath.substring(0,includePath.indexOf(processName,0)-5);    // Minus 5 removes the sequence number of the directory.  i.e., "01 - "
var fileStream = fso.openTextFile (includePath + "\Common\\ImportUtils.js");
var fileData = fileStream.readAll();
fileStream.Close();
eval(fileData);

// Create Log FileSystemObject
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
function  convertCSVtoXML(folderPath, fileName)
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
  var row = 0; 
  var csvfileName = folderPath + fileName;
  
  //EchoAndLog(logFile, "Processing File: " + csvfileName);
  var tso = fso.OpenTextFile(csvfileName, 1); 
  var strInput; 
  var priorBUName = "-99";
  var buCount;
 
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
 
  buCount = 0;
  // Loop through the file 
  while (!tso.AtEndOfStream) //&& (row < 2)) 
  { 
    strInput = tso.ReadLine();
	row += 1;
    
    var vInputLine = strInput.split(",");   
    objXML.a = vInputLine[0];
    objXML.b = vInputLine[1];
    objXML.c = vInputLine[2];
    objXML.d = vInputLine[3];
    objXML.e = vInputLine[4];
    objXML.f = vInputLine[5];
    objXML.g = vInputLine[6];

	if (priorBUName != vInputLine[0])
	{
		EchoAndLog(logFile, "Starting BU: " + vInputLine[0]);
		buCount += 1;
		priorBUName = vInputLine[0];
		row = 1;
	}
	
//	if ((row % 10) == 0)
//	{
//		EchoAndLog(logFile, "Price Rows: " + row);
//	}
	
	objXMLDOMNode.appendChild(XMLFileNode(objDOMDocument,objXML));

  } 
  tso.Close();

	EchoAndLog(logFile, "Finished File: " + fileName + " Business Unit Count: " + buCount);
	EchoAndLog(logFile, "Starting XSL Transform...this could take awhile");
  
    // Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\BusinessUnitPriceChangeXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);

	EchoAndLog(logFile, "Completed XSL Transform.");
	
	// Grab just the file name minus any extension
	var destfolderPath = folderPath.substring(0,folderPath.indexOf("\FinalCSV")) + "\FinalXML\\"; 
	var destfileName = fileName.substring(0,fileName.indexOf(".csv"));
	
	tmpxml = destfolderPath + destfileName + ".xml";  

	// Write out the transformed file. If writing out just the xml file before transform  
	var FSObject = fso.CreateTextFile(tmpxml, true);
	FSObject.WriteLine(FinalStr);
	FSObject.Close();
  
	// Create empty .flag file then rename it
	tmpxml += ".flag";
	var fsoEmptyFile = fso.CreateTextFile(tmpxml, true);
	fsoEmptyFile.Close();
  
  // Clear all objects
  objDOMDocument = null; 
  fso = null;
  TransformXSL = null;
  objXML = null;
  TempStagingDoc = null;
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

  objXMLDOMElement = objDOMDocument.createElement("BUName"); 
  objXMLDOMElement.text = formatXMLString(objXML.a);
  objXMLDOMNode.appendChild(objXMLDOMElement);
     
  objXMLDOMElement = objDOMDocument.createElement("BUIdentifier"); 
  objXMLDOMElement.text = formatXMLString(objXML.b);
  objXMLDOMNode.appendChild(objXMLDOMElement);
    
  objXMLDOMElement = objDOMDocument.createElement("itemName"); 
  objXMLDOMElement.text = formatXMLString(objXML.c);
  objXMLDOMNode.appendChild(objXMLDOMElement);
    
  objXMLDOMElement = objDOMDocument.createElement("itemRetailPackXRefID"); 
  objXMLDOMElement.text = objXML.d;
  objXMLDOMNode.appendChild(objXMLDOMElement);
    
  objXMLDOMElement = objDOMDocument.createElement("retailPrice"); 
  objXMLDOMElement.text = objXML.e;
  objXMLDOMNode.appendChild(objXMLDOMElement);

  objXMLDOMElement = objDOMDocument.createElement("startDate"); 
  objXMLDOMElement.text = formatDateYYYYMMDD(objXML.f);
  objXMLDOMNode.appendChild(objXMLDOMElement);

  objXMLDOMElement = objDOMDocument.createElement("endDate"); 
  objXMLDOMElement.text = formatDateYYYYMMDD(objXML.g);
  objXMLDOMNode.appendChild(objXMLDOMElement);
          
  return(objXMLDOMNode);
}
