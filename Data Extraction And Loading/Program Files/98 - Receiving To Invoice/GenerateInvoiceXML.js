// Generate Invoice
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateInvoiceXML.js";
var processName = "Receiving To Invoice";

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
	processFinalCSVFiles(getFinalCSVFolderPath(jsfileName, processName));
//}
//catch(err)
//{
//	EchoAndLog(logFile, "Error --> " + err.name + ":" + err.message);
//}

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
  
	var bFristLineOfInvoice = true;
	var bFirstTime = true ;
    var priorInvoiceNumber = ""
	var invoiceItemList = [];
	
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
			priorInvoiceNumber = vInputLine[3];
		}
		
		if (priorInvoiceNumber != vInputLine[3]) 
		{
			domNode.appendChild(XMLInvoiceNode(objDOMDocument,objXML,invoiceItemList));
			priorInvoiceNumber = vInputLine[3];
			var objXML  = new Object();
			var invoiceItemList = [];
			bFristLineOfInvoice = true;
		}

		if (bFristLineOfInvoice)
		{
			
			objXML.a = vInputLine[0];  // Business Unit Code
			objXML.b = vInputLine[1];  // Supplier Xref
			objXML.c = vInputLine[2];  // Supplier EDI Number
			objXML.d = vInputLine[3];  // Invoice Number
			objXML.e = vInputLine[4];  // Invoice Date
			
			bFristLineOfInvoice = false;
		}			

		invoiceItemList.push({productCode: vInputLine[5], receivedQty: vInputLine[6], receivedCost: vInputLine[7]});

		bFirstTime = false; 
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Invoice Line Item Rows: " + row);
		}	
	} 
  
	domNode.appendChild(XMLInvoiceNode(objDOMDocument,objXML,invoiceItemList));
	tso.Close();
	
	//showMessage(objDOMDocument.xml);

  	EchoAndLog(logFile, "Transforming raw XML");
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\InvoiceImportXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);
  
	// Grab just the file name minus any extension

	var destFolderName = foldername.substring(0,foldername.indexOf("\FinalCSV")) + "\FinalXML\\"; 
	var destFileName = filename.substring(0,filename.indexOf(".csv"));
	
	tmpxml = destFolderName + destFileName + ".xml";  

	// Write out the transformed file. 
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
	
	EchoAndLog(logFile, "Finished Receiving to Invoice");
	EchoAndLog(logFile, "Total Items: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destFileName + ".xml");
	EchoAndLog(logFile, "...");
	
}

function XMLHeader(objDOMDocument)
{ 
  var XMLHead;
  XMLHead = objDOMDocument.createNode(1, "Document",""); 
  
  return(XMLHead);
} 

function XMLInvoiceNode(objDOMDocument,objXML, invoiceItemList)
{     
  	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i,j;

	objXMLDOMElement = objDOMDocument.createElement("businessUnitCode"); 
	objXMLDOMElement.text = formatXMLString(objXML.a);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("supplierXRef"); 
	objXMLDOMElement.text = formatXMLString(objXML.b);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("supplierEDINumber"); 
	objXMLDOMElement.text = formatXMLString(objXML.c);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("invoiceRefNumber"); 
	objXMLDOMElement.text = formatXMLString(objXML.d);
	domNode.appendChild(objXMLDOMElement);
	
	objXMLDOMElement = objDOMDocument.createElement("invoiceDate"); 
	objXMLDOMElement.text = formatDateYYYYMMDD(objXML.e);
	domNode.appendChild(objXMLDOMElement);	
	
  	for (i = 0; i < invoiceItemList.length; i++)   
	{

		domInvoiceItemElement = objDOMDocument.createElement("ItemList"); 
		domNode.appendChild(domInvoiceItemElement);

		domElement = objDOMDocument.createElement("ProductCode"); 
		domElement.text = formatXMLString(invoiceItemList[i].productCode);
		domInvoiceItemElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("Quantity"); 
		domElement.text = formatTwoDecimalPalces(invoiceItemList[i].receivedQty);
		domInvoiceItemElement.appendChild(domElement);
		
		domElement = objDOMDocument.createElement("Cost"); 
		domElement.text = formatTwoDecimalPalces(invoiceItemList[i].receivedCost);
		domInvoiceItemElement.appendChild(domElement);
		
	}
 
  return(domNode);
}
