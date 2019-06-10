// Business Unit Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateBusinessUnitXML.js";
var processName = "Business Unit";

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
  
	var csvfileName = folderPath + fileName;
  
	var tso = fso.OpenTextFile(csvfileName, 1); 
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
		objXML.e = vInputLine[4];
		objXML.f = vInputLine[5];
		objXML.g = vInputLine[6];
		objXML.h = vInputLine[7]; 
		objXML.i = vInputLine[8];  
		objXML.j = vInputLine[9];
		objXML.k = vInputLine[10];
		objXML.l = vInputLine[11];  
		objXML.m = vInputLine[12];  
		objXML.n = vInputLine[13];
		objXML.o = vInputLine[14];
		objXML.p = vInputLine[15];
		objXML.q = vInputLine[16];
		objXML.r = vInputLine[17];  
		objXML.s = vInputLine[18];  
		objXML.t = vInputLine[19];
		objXML.u = vInputLine[20];
		objXML.v = vInputLine[21];
		objXML.w = vInputLine[22];
		objXML.x = vInputLine[23];  
		objXML.y = vInputLine[24];  
		objXML.z = vInputLine[25];
		objXML.aa = vInputLine[26];

		EchoAndLog(logFile, "Processing Business Unit #" + row + " BU Code: " + vInputLine[0]);
		objXMLDOMNode.appendChild(XMLFileNode(objDOMDocument,objXML));
	} 
	tso.Close();
  
	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");

    // Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\BusinessUnitXform.xsl");
  
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
  
	objDOMDocument = null; 
	fso = null;
	TransformXSL = null;
	objXML = null;
	TempStagingDoc = null;
	
	EchoAndLog(logFile, "Finished Generating XML");
	EchoAndLog(logFile, "Total Business Units: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destfileName + ".xml");
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
    
	objXMLDOMElement = objDOMDocument.createElement("Status"); 
	objXMLDOMElement.text = objXML.c;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("TimeZoneId"); 
	objXMLDOMElement.text = objXML.d;
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("StartDate"); 
	objXMLDOMElement.text = objXML.e;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("EDINumber"); 
	objXMLDOMElement.text = formatXMLString(objXML.f);
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("WorkdayProfileName"); 
	objXMLDOMElement.text = formatXMLString(objXML.g);
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("MailingAddressLine1"); 
	objXMLDOMElement.text = formatXMLString(objXML.h);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MailingAddressLine2"); 
	objXMLDOMElement.text = formatXMLString(objXML.i);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MailingCity"); 
	objXMLDOMElement.text = objXML.j;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MailingStateCode"); 
	objXMLDOMElement.text = objXML.k;
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("MailingPostalCode"); 
	objXMLDOMElement.text = objXML.l;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MailingCountryCode"); 
	objXMLDOMElement.text = objXML.m;
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("MailingHomePhone"); 
	objXMLDOMElement.text = formatPhone(objXML.n);
	objXMLDOMNode.appendChild(objXMLDOMElement);  
  
	objXMLDOMElement = objDOMDocument.createElement("MailingWorkPhone"); 
	objXMLDOMElement.text = formatPhone(objXML.o);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MailingFaxNumber"); 
	objXMLDOMElement.text = formatPhone(objXML.p);
	objXMLDOMNode.appendChild(objXMLDOMElement);  
  
	objXMLDOMElement = objDOMDocument.createElement("MailingEmail"); 
	objXMLDOMElement.text = objXML.q;
	objXMLDOMNode.appendChild(objXMLDOMElement);   

	objXMLDOMElement = objDOMDocument.createElement("BillingAddressLine1"); 
	objXMLDOMElement.text = formatXMLString(objXML.r);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("BillingAddressLine2"); 
	objXMLDOMElement.text = formatXMLString(objXML.s);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("BillingCity"); 
	objXMLDOMElement.text = objXML.t;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("BillingStateCode"); 
	objXMLDOMElement.text = objXML.u;
	objXMLDOMNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("BillingPostalCode"); 
	objXMLDOMElement.text = objXML.v;
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("BillingCountryCode"); 
	objXMLDOMElement.text = objXML.w;
	objXMLDOMNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("BillingHomePhone"); 
	objXMLDOMElement.text = formatPhone(objXML.x);
	objXMLDOMNode.appendChild(objXMLDOMElement);  
  
	objXMLDOMElement = objDOMDocument.createElement("BillingWorkPhone"); 
	objXMLDOMElement.text = formatPhone(objXML.y);
	objXMLDOMNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("BillingFaxNumber"); 
	objXMLDOMElement.text = formatPhone(objXML.z);
	objXMLDOMNode.appendChild(objXMLDOMElement);  
  
	objXMLDOMElement = objDOMDocument.createElement("BillingEmail"); 
	objXMLDOMElement.text = objXML.aa;
	objXMLDOMNode.appendChild(objXMLDOMElement);   
  
	return(objXMLDOMNode);
}
