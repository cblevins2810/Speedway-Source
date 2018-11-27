// Price Change Event
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GeneratePriceEventXML.js";
var processName = "Price Change Event";

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
	EchoAndLog(logFile, "Error --> " + err.name + ":" + err.message);
}

//Cleanup
EchoAndLog(logFile, "End Log");
logFile.Close();
fileStream = null;
fso = null;

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
  
  	var retailPackList = [];
	var bFristLineOfItem = true;
	var bFirstTime = true ;
	var priorItemExternalId = "~99";
	var priorPackXRefID = "~99";
	var vInputLine = []; 
 
	// Eat the first line
	if(!tso.AtEndOfStream)  
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
		vInputLine = strInput.split(","); 
	
		if (bFirstTime) 
		{
			priorItemExternalId = vInputLine[3];
		}
		
		if (priorItemExternalId != vInputLine[3]) 
		{
			domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailPackList));
			priorItemExternalId = vInputLine[3];
			priorPackXRefID = "~99";
			var objXML  = new Object();
			var retailPackList = [];
			bFristLineOfItem = true;
		}

		if (bFristLineOfItem)
		{
			objXML.a = vInputLine[0];  // Event Name`
			objXML.b = vInputLine[1];  // Start Date  
			objXML.c = vInputLine[2];  // End Date
			objXML.d = vInputLine[3];  // Item XRefID
			objXML.e = vInputLine[4];  // Item Name (Not imported, for user reference only)
			objXML.f = vInputLine[5];  // Retail Strategy
			
			bFristLineOfItem = false;
		}			

		if(vInputLine[6] != priorPackXRefID)
		{
			retailPackList.push({XRefID: vInputLine[6], retailLevelGroup: vInputLine[7], retailPriceList : []});
			priorPackXRefID = vInputLine[6];
		}
		
		retailPackList[retailPackList.length - 1].retailPriceList.push({retailLevelName: vInputLine[8], listRetail: vInputLine[9]});

		bFirstTime = false; 
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Items Rows: " + row);
		}	
	} 
  
	domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailPackList));
	tso.Close();
	
	//showMessage(objDOMDocument.xml);
  
  	EchoAndLog(logFile, "Transforming raw XML");
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\PriceEventImportXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);
  
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
	
	EchoAndLog(logFile, "Finished Price Event");
	EchoAndLog(logFile, "Total Items: " + (row));
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

function XMLItemNode(objDOMDocument,objXML, retailPackList)
{     
  	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i,j;
  
	objXMLDOMElement = objDOMDocument.createElement("eventName"); 
	objXMLDOMElement.text = formatXMLString(objXML.a);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("startDate"); 
	objXMLDOMElement.text = formatDateYYYYMMDD(objXML.b);
	domNode.appendChild(objXMLDOMElement);
  
	if (objXML.c.length > 0)
	{
	objXMLDOMElement = objDOMDocument.createElement("endDate"); 
	objXMLDOMElement.text = formatDateYYYYMMDD(objXML.c);
	domNode.appendChild(objXMLDOMElement);
	}
  
	objXMLDOMElement = objDOMDocument.createElement("itemXRefID"); 
	objXMLDOMElement.text = objXML.d;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("retailStrategy"); 
	objXMLDOMElement.text = formatXMLString(objXML.f);
	domNode.appendChild(objXMLDOMElement);
  
  	for (i = 0; i < retailPackList.length; i++)   
	{

		domRetailPackElement = objDOMDocument.createElement("RetailModifiedItem"); 
		domNode.appendChild(domRetailPackElement);

		domElement = objDOMDocument.createElement("XRefID"); 
		domElement.text = retailPackList[i].XRefID
		domRetailPackElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("retailLevelGroup"); 
		domElement.text = formatXMLString(retailPackList[i].retailLevelGroup);
		domRetailPackElement.appendChild(domElement);
		
		for (j = 0; j < retailPackList[i].retailPriceList.length; j++)   
		{
			domBarcodeElement = objDOMDocument.createElement("RetailLevel"); 
			domRetailPackElement.appendChild(domBarcodeElement);

			domElement = objDOMDocument.createElement("retailLevelName"); 
			domElement.text = formatXMLString(retailPackList[i].retailPriceList[j].retailLevelName);
			domBarcodeElement.appendChild(domElement);

			domElement = objDOMDocument.createElement("retailType"); 
			domElement.text = "Primary";
			domBarcodeElement.appendChild(domElement);
			
			domElement = objDOMDocument.createElement("listRetail"); 
			domElement.text = retailPackList[i].retailPriceList[j].listRetail;
			domBarcodeElement.appendChild(domElement);
		}
	}
 
  return(domNode);
}
