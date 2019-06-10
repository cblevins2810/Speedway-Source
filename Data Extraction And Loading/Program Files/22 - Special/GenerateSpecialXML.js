// Special Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSpecialXML.js";
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

	var objDOMDocument = new ActiveXObject("Msxml2.DOMDocument.6.0"); 
	objDOMDocument.async = false; 
  
	//Create Header
	objDOMDocument.appendChild(XMLHeader(objDOMDocument)); 
	var domNode = objDOMDocument.documentElement.selectSingleNode("//Document"); 
 
	// Declare XML object -- this makes it easier to pass as a parameter 
	var objXML  = new Object(); 
  
	// Open the extracted csv from zip file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
  
	var csvFilename = foldername + filename;
	var tso = fso.OpenTextFile(csvFilename, 1); 
	var strInput; 
  
	EchoAndLog(logFile, "Found Input File: " + csvFilename);
  
  	var retailItemGroupList = [];
	var bFristLineOfItem = true;
	var bFirstTime = true ;
	var vInputLine = []; 
 
	// Read the first line
	if(!tso.AtEndOfStream)  
	{ 
		strInput = tso.ReadLine();
	}
	// If coming from a review spreadsheet "Save as csv" eat 2 more lines
	if (strInput.substring(0,7) == ",Common")
	{
		if(!tso.AtEndOfStream)  
		{	 
			strInput = tso.ReadLine();
		}
	}
	// Eat ---- line or header line
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
		vInputLine = strInput.split(","); 
	
		if (bFirstTime) 
		{
			priorItemExternalId = vInputLine[0];
		}
		
		if (priorItemExternalId != vInputLine[0]) 
		{
			domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailItemGroupList));
   			priorItemExternalId = vInputLine[0];
			priorPackName = "~99";
			var objXML  = new Object();
			var retailItemGroupList = [];
			bFristLineOfItem = true;
        }

		if (bFristLineOfItem)
		{
	
			objXML.a = vInputLine[0];
			objXML.b = vInputLine[1];    
			objXML.c = vInputLine[2];
			objXML.d = vInputLine[3];
			objXML.e = vInputLine[4];
			objXML.f = vInputLine[5];
			objXML.g = vInputLine[6];
			objXML.h = vInputLine[7];
			
			bFristLineOfItem = false;
    	}

		retailItemGroupList.push({retailItemGroupName: vInputLine[8], minimumIdentifier: vInputLine[9], minimumValue: vInputLine[10], discountType: vInputLine[11], discountValue: vInputLine[12], taxReduced: vInputLine[13]});

		bFirstTime = false; 
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Special Rows: " + row);
		}
	} 
  
	domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailItemGroupList));
	tso.Close();
	
  	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
	
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false;
	
	TransformXSL.load("\SpecialXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);
	//var FinalStr = objDOMDocument.xml;

	EchoAndLog(logFile, "XSL Transform Complete.");
	
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
	
	EchoAndLog(logFile, "Finished Specials");
	EchoAndLog(logFile, "Total Specials: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destFileName + ".xml");
	EchoAndLog(logFile, "...");
	
}

function XMLHeader(objDOMDocument)
{ 
  var XMLHead;
  XMLHead = objDOMDocument.createNode(1, "Document",""); 
  
  var objXMLDOMAttribute = objDOMDocument.createAttribute("Version"); 
  objXMLDOMAttribute.text = "1.0.0";
  XMLHead.attributes.setNamedItem(objXMLDOMAttribute);
  
  var objXMLDOMAttribute = objDOMDocument.createAttribute("CreationTimestamp"); 
  objXMLDOMAttribute.text = "2018-07-19T21:00:00" //getTimestamp();
  XMLHead.attributes.setNamedItem(objXMLDOMAttribute);
  
  return(XMLHead);
} 

function XMLItemNode(objDOMDocument,objXML, retailItemGroupList)
{     
  	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i;

	objXMLDOMElement = objDOMDocument.createElement("specialXRefID"); 
	objXMLDOMElement.text = formatXMLString(objXML.a);
	domNode.appendChild(objXMLDOMElement);
	
	objXMLDOMElement = objDOMDocument.createElement("specialName"); 
	objXMLDOMElement.text = formatXMLString(objXML.b);
	domNode.appendChild(objXMLDOMElement);
	
	objXMLDOMElement = objDOMDocument.createElement("specialReceiptText"); 
	objXMLDOMElement.text = formatXMLString(objXML.c);
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("priorityRanking"); 
	objXMLDOMElement.text = objXML.d;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("requiresLoyalty"); 
	objXMLDOMElement.text = objXML.e;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("startDate"); 
	objXMLDOMElement.text = formatDateYYYYMMDD(objXML.f);
	domNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("endDate"); 
	objXMLDOMElement.text = formatDateYYYYMMDD(objXML.g);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("status"); 
	objXMLDOMElement.text = objXML.h;
	domNode.appendChild(objXMLDOMElement);
	
  	for (i = 0; i < retailItemGroupList.length; i++)   
	{

		domRetailPackElement = objDOMDocument.createElement("Qualifier"); 
		domNode.appendChild(domRetailPackElement);

		domElement = objDOMDocument.createElement("retailItemGroupName"); 
		domElement.text = formatXMLString(retailItemGroupList[i].retailItemGroupName);
		domRetailPackElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("minimumIdentifier"); 
		domElement.text = retailItemGroupList[i].minimumIdentifier;
		domRetailPackElement.appendChild(domElement);
		
		domElement = objDOMDocument.createElement("minimumValue"); 
		domElement.text = retailItemGroupList[i].minimumValue;
		domRetailPackElement.appendChild(domElement);
		
		domElement = objDOMDocument.createElement("discountType"); 
		domElement.text = retailItemGroupList[i].discountType;
		domRetailPackElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("discountValue"); 
		domElement.text = formatTwoDecimalPalces(retailItemGroupList[i].discountValue);
		domRetailPackElement.appendChild(domElement);
	
		domElement = objDOMDocument.createElement("taxReduced"); 
		domElement.text = retailItemGroupList[i].taxReduced;
		domRetailPackElement.appendChild(domElement);
		
	}
 
return(domNode);
}


