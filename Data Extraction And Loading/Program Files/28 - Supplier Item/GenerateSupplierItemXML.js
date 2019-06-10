// Supplier Item Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSupplierItemXML.js";
var processName = "Supplier Item";

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
function  convertCSVtoXML(folderPath, fileName)
{ 
 
	var objDOMDocument = new ActiveXObject("MSXML2.DOMDocument.6.0"); 
	objDOMDocument.async = false; 
 
	//Create Header
	objDOMDocument.appendChild(XMLHeader(objDOMDocument)); 
	var objXMLDOMNode = objDOMDocument.documentElement.selectSingleNode("//Document"); 
  
	// Declare XML object -- this makes it easier to pass as a parameter 
	var objXML  = new Object(); 
	var barcodeList = [];
	var costList = [];
	var bFristLineOfProduct = true;
	var bFirstTime = true ;
	var supplier = "";
	var supplierXref = "";
	var csvFileName = folderPath + fileName;
	var strInput; 
	var priorProductCode = "-99";
	var vInputLine = []; 
	var row = 1;
 
	// Open the csv file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var tso = fso.OpenTextFile(csvFileName, 1); 
	EchoAndLog(logFile, "Found Input File: " + csvFileName);

	// Get the Supplier Xref
	supplierXref = fileName.substring(fileName.indexOf(processName + "-") + processName.length+1,999);
	supplierXref = supplierXref.substring(0, supplierXref.indexOf("_"));
	
	// Get the Supplier
	supplier = fileName.substring(fileName.indexOf(supplierXref + "_") + supplierXref.length + 1);
	supplier = supplier.substring(0, supplier.indexOf("_"));
	
	// Get the Supplier Batch Number
	extractBatchNumber = fileName.substring(fileName.indexOf(supplier + "_") + supplier.length + 1);
	extractBatchNumber = extractBatchNumber.substring(0, extractBatchNumber.indexOf("."));

	EchoAndLog(logFile, "Supplier Name: " + supplier);

	// Read the first line
	if(!tso.AtEndOfStream)  
	{ 
		strInput = tso.ReadLine();
	}
	// If coming from a review spreadsheet "Save as csv" eat 2 more lines
	if (strInput.substring(0,13) == "Supplier Name")
	{
		if(!tso.AtEndOfStream)  
		{	 
			strInput = tso.ReadLine();
		}
		if(!tso.AtEndOfStream)  
		{	 
			strInput = tso.ReadLine();
		}
	}

	// Eat ---- line or header line from spreadsheet
	if (!tso.AtEndOfStream)
	{	   
		strInput = tso.ReadLine();
	}
  
	// Loop through the file
	while(!tso.AtEndOfStream)  
	{ 

		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 
	 
		if (bFirstTime) 
		{
			priorProductCode = vInputLine[0];
		}
		
		if (priorProductCode != vInputLine[0]) 
		{
            objXMLDOMNode.appendChild(XMLSupplierItemNode(supplier, supplierXref, objDOMDocument,objXML,barcodeList,costList));
   			priorProductCode = vInputLine[0];
			var objXML  = new Object();
			var barcodeList = [];
			var costList = [];
			bFristLineOfProduct = true;
        }

		if (bFristLineOfProduct)
		{
			objXML.a = vInputLine[0];
			objXML.b = vInputLine[1];    
			objXML.c = vInputLine[2];
			objXML.d = vInputLine[3];
			
			// These are ignored for the xml generation
			objXML.e = vInputLine[4];
			objXML.f = vInputLine[5];

			objXML.g = vInputLine[6];
			objXML.h = vInputLine[7];
			objXML.i = vInputLine[8];
			objXML.j = vInputLine[9];
			objXML.k = vInputLine[10];
			objXML.l = vInputLine[11];
			objXML.m = vInputLine[12];
			
			
			bFristLineOfProduct = false;
    	}
		
        if ((vInputLine[13] != "") && (vInputLine[14] != "")) 
		{
			barcodeList.push({barcodeType: vInputLine[13], barcodeNumber: vInputLine[14]});
		}

		if ((vInputLine[15] != "")  && (vInputLine[16] != ""))
		{
			costList.push({costLevel: vInputLine[15], packageCost: vInputLine[16], allowance: vInputLine[17], costStartDate: vInputLine[18], costEndDate: vInputLine[19]});
		}

		bFirstTime = false; 
		
		row++;
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Supplier Items Rows: " + row);
		}
	}
	
	if (row > 1)
	{
		objXMLDOMNode.appendChild(XMLSupplierItemNode(supplier, supplierXref, objDOMDocument,objXML,barcodeList,costList));
	}
	tso.Close();
	
  	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
	
  	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\SupplierItemXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);
	
	// Need this so that the numerical representation of special characters is correct.  It needs to be &#x9999 in the final xml.
	FinalStr = FinalStr.replace(/&amp;#x/g,'&#x');

  	EchoAndLog(logFile, "XSL Transform Completed.");
	
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
	EchoAndLog(logFile, "" + destfileName + " completed.");
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

function XMLSupplierItemNode(supplier, supplierXref, objDOMDocument,objXML, barcodeList, costList)
{     
	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i;
 
	domElement = objDOMDocument.createElement("SupplierName"); 
	domElement.text = supplier;
	domNode.appendChild(domElement);
    
	domElement = objDOMDocument.createElement("SupplierID"); 
	domElement.text = supplierXref;
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("ProductCode"); 
	domElement.text = formatXMLString(objXML.a);
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("Name"); 
	domElement.text = formatXMLString(objXML.b);
	domNode.appendChild(domElement);

	domElement = objDOMDocument.createElement("XRefID"); 
	domElement.text = objXML.c;
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("InventoryItemExternalID"); 
	domElement.text = objXML.d;
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("Description"); 
	domElement.text = formatXMLString(objXML.g);
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("Status"); 
	domElement.text = objXML.h;
	domNode.appendChild(domElement);    
    
	domElement = objDOMDocument.createElement("SupplierItemGroupName"); 
	domElement.text = formatXMLString(objXML.i);
	domNode.appendChild(domElement);
    
	domElement = objDOMDocument.createElement("SupplierPackageUOM"); 
	domElement.text = formatXMLString(objXML.j);
	domNode.appendChild(domElement);
    
	domElement = objDOMDocument.createElement("QuantityFactor"); 
	domElement.text = objXML.k;
	domNode.appendChild(domElement);
  
	domElement = objDOMDocument.createElement("AvailabilityStartDate"); 
	domElement.text = formatDateYYYYMMDD(objXML.l);
	domNode.appendChild(domElement);  

	domElement = objDOMDocument.createElement("AvailabilityEndDate"); 
	domElement.text = formatDateYYYYMMDD(objXML.m);
	domNode.appendChild(domElement);  
    
	for (i = 0; i < barcodeList.length; i++)   
	{
		domBCElement = objDOMDocument.createElement("Barcode"); 
		domNode.appendChild(domBCElement);

		domElement = objDOMDocument.createElement("TypeCode"); 
		domElement.text = barcodeList[i].barcodeType;
		domBCElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("Number"); 
		domElement.text = formatXMLString(barcodeList[i].barcodeNumber);
		domBCElement.appendChild(domElement);
	}

	for (i = 0; i < costList.length; i++)   
	{
		domCostElement = objDOMDocument.createElement("Cost"); 
		domNode.appendChild(domCostElement);

		domElement = objDOMDocument.createElement("CostLevel"); 
		domElement.text = formatXMLString(costList[i].costLevel);
		domCostElement.appendChild(domElement);
    
		domElement = objDOMDocument.createElement("PackageCost"); 
		domElement.text = costList[i].packageCost;
		domCostElement.appendChild(domElement);
  
		if (costList[i].allowance != "")
		{
			domElement = objDOMDocument.createElement("Allowance"); 
			domElement.text = costList[i].allowance;
			domCostElement.appendChild(domElement);
		}
		if (costList[i].costStartDate != "") 
		{
			domElement = objDOMDocument.createElement("CostStartDate"); 
			domElement.text = costList[i].costStartDate;
			domCostElement.appendChild(domElement);
		}
		if (costList[i].costEndDate != "")
		{
			domElement = objDOMDocument.createElement("CostEndDate"); 
			if (costList[i].costEndDate != "")
			{
				domElement.text = costList[i].costEndDate;
			}
			domCostElement.appendChild(domElement);
		}
		
	}
  
  return(domNode);
}

