// Item Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates Dec 2018
// Dec 2018: Made changes to accomodate the additional 5 columns for Item Group

// Global Vars
var jsfileName = "GenerateItemXML.js";
var processName = "Retail Item";

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
//try
//{
	processFinalCSVFiles(getFinalCSVFolderPath(jsfileName, processName));
//}
//catch(err)
//{
//	EchoAndLog(logFile, "Error --> " + err.message);
//}

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
  
  	var retailPackList = [];
	var attributeList = [];
	// Added to accomodate the additional 5 columns for Item Group
	var itemGroupList = [];
	var i = 0;
	var bFristLineOfItem = true;
	var bFirstTime = true ;
	var priorItemExternalId = "~99";
	var priorPackName = "~99";
	var vInputLine = []; 
 
	// Read the first line
	if(!tso.AtEndOfStream)  
	{ 
		strInput = tso.ReadLine();
	}
	// If coming from a review spreadsheet "Save as csv" eat 2 more lines
	// Changed comparison to ",,Common" to account for the 2 columns before column with "Common"
	if (strInput.substring(0,8) == ",,Common")
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
	// Added to allow original file without item groups as well as
	// new file with item groups (when file is used directly without review)
	var bFileWithItemGroup = false;
	// Loop through the file 
	while(!tso.AtEndOfStream)  
	{ 
		row +=1;
	
		strInput = tso.ReadLine();
		vInputLine = strInput.split(","); 
	
		if (bFirstTime) 
		{
			priorItemExternalId = vInputLine[0];
			// Check if it is file with item group
			// Number of array elements = 103 (original file) and = 108 (file with item groups)
			if (vInputLine.length > 103)
			{
				bFileWithItemGroup = true;
			}
		}
		
		if (priorItemExternalId != vInputLine[0]) 
		{
			// Added itemGroupList as input to account for the Item Groups
			domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailPackList, attributeList, itemGroupList));
   			priorItemExternalId = vInputLine[0];
			priorPackName = "~99";
			var objXML  = new Object();
			var retailPackList = [];
			var attributeList = [];
			// Added to accomodate the additional 5 columns for Item Group
			var itemGroupList = [];
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
			objXML.ab = vInputLine[27];
			objXML.ac = vInputLine[28];  

			objXML.ad = vInputLine[29];
			objXML.ae = vInputLine[30];
			objXML.af = vInputLine[31];
			objXML.ag = vInputLine[32];
			objXML.ah = vInputLine[33];  
		    objXML.ai = vInputLine[34];  
			objXML.aj = vInputLine[35];  
			
			
		 	// Expanded count from 67 to 101 to get total of 30 attributes
			for (i = 43; i <= 101; i+=2)  				
			{
				if (vInputLine[i] != '')
				{
					attributeList.push({attributeName : vInputLine[i], attributeValue : vInputLine[i+1]}) ;
				}
			}
			
			// Only add item groups if it is file with item groups
			if (bFileWithItemGroup)
			{
				// Added to account for the additional 5 columns for Item Group
				for (i = 103; i <= 107; i+=1)   
				{
					if (vInputLine[i] != '')
					{
						itemGroupList.push({itemGroupName : vInputLine[i]}) ;
					}
				}
			}
			
			bFristLineOfItem = false;
    	}
		
				
		if (vInputLine[36] != "") 
		{
			if(vInputLine[36] != priorPackName)
			{
				retailPackList.push({packName: vInputLine[36], packQty: vInputLine[37], retailLevelGroup: vInputLine[38], packExternalId: vInputLine[39], listRetail: vInputLine[40], barcodeList : []});
				priorPackName = vInputLine[36];
			}
			if (vInputLine[42] != "")
			{
				retailPackList[retailPackList.length - 1].barcodeList.push({type: vInputLine[41], number: vInputLine[42]});
			}
		}

		bFirstTime = false; 
		
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Items Rows: " + row);
		}
	} 

	// Added itemGroupList as input to account for the Item Groups
	domNode.appendChild(XMLItemNode(objDOMDocument,objXML,retailPackList,attributeList,itemGroupList));
	tso.Close();
	
	//showMessage(objDOMDocument.xml);
	
  	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
	
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\ItemImportXform.xsl");
  
	// Load XML file and transform it
	var TempStagingDoc = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TempStagingDoc.async = false; 	
	TempStagingDoc.loadXML(objDOMDocument.xml);
	var FinalStr = TempStagingDoc.transformNode(TransformXSL);

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
	
	EchoAndLog(logFile, "Finished Items");
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
  objXMLDOMAttribute.text = "2018-07-19T21:00:00" //getTimestamp();
  XMLHead.attributes.setNamedItem(objXMLDOMAttribute);
  
  return(XMLHead);
} 

//function XMLItemNode(objDOMDocument,objXML, retailPackList, attributeList)
function XMLItemNode(objDOMDocument,objXML, retailPackList, attributeList, itemGroupList)
{     
  	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i,j;
  
	objXMLDOMElement = objDOMDocument.createElement("ItemExternalID"); 
	objXMLDOMElement.text = objXML.a;
	domNode.appendChild(objXMLDOMElement);

	// Skipping objXML.b (PurgeFlag) - not supported in import
	
	objXMLDOMElement = objDOMDocument.createElement("ItemName"); 
	objXMLDOMElement.text = formatXMLString(objXML.c);
	domNode.appendChild(objXMLDOMElement);
  
	if (objXML.d.length > 0)
	{
		objXMLDOMElement = objDOMDocument.createElement("ItemDescription"); 
		objXMLDOMElement.text = formatXMLString(objXML.d);
		domNode.appendChild(objXMLDOMElement);
	}
	
	objXMLDOMElement = objDOMDocument.createElement("SoldAs"); 
	objXMLDOMElement.text = objXML.e;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("Category"); 
	objXMLDOMElement.text = formatXMLString(objXML.f);
	domNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("BaseUOMClass"); 
	objXMLDOMElement.text = objXML.g;
	domNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("ReportedInUOM"); 
	objXMLDOMElement.text = objXML.h;
	domNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("Manufacturer"); 
	objXMLDOMElement.text = formatXMLString(objXML.i);
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("SKUNumber"); 
	objXMLDOMElement.text = objXML.j;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("Taxability"); 
	objXMLDOMElement.text = objXML.k;
	domNode.appendChild(objXMLDOMElement);
    
	objXMLDOMElement = objDOMDocument.createElement("Active"); 
	objXMLDOMElement.text = objXML.l;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("Track"); 
	objXMLDOMElement.text = objXML.m;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ExpenseUponReceiving"); 
	objXMLDOMElement.text = objXML.n;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("AllowFractionalQuantities"); 
	objXMLDOMElement.text = objXML.o;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("SetVarianceToZero"); 
	objXMLDOMElement.text = objXML.p;
	domNode.appendChild(objXMLDOMElement);    

	objXMLDOMElement = objDOMDocument.createElement("WasteTolerence"); 
	objXMLDOMElement.text = objXML.q;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("MissingTolerence"); 
	objXMLDOMElement.text = objXML.r;
	domNode.appendChild(objXMLDOMElement);    
  
	objXMLDOMElement = objDOMDocument.createElement("DefaultAdjustmentUOM"); 
	objXMLDOMElement.text = objXML.s;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("DefaultTransferUOM"); 
	objXMLDOMElement.text = objXML.t;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("ConvertFromUOMName1"); 
	objXMLDOMElement.text = formatXMLString(objXML.u);
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("ConvertFromUOMQty1"); 
	objXMLDOMElement.text = formatXMLString(objXML.v);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMClass1"); 
	objXMLDOMElement.text = formatXMLString(objXML.w);
	domNode.appendChild(objXMLDOMElement);
	
	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMName1"); 
	objXMLDOMElement.text = formatXMLString(objXML.x);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMQty1"); 
	objXMLDOMElement.text = formatXMLString(objXML.y);
	domNode.appendChild(objXMLDOMElement);
	
	objXMLDOMElement = objDOMDocument.createElement("ConvertFromUOMName2"); 
	objXMLDOMElement.text = formatXMLString(objXML.z);
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("ConvertFromUOMQty2"); 
	objXMLDOMElement.text = formatXMLString(objXML.aa);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMClass2"); 
	objXMLDOMElement.text = formatXMLString(objXML.ab);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMName2"); 
	objXMLDOMElement.text = formatXMLString(objXML.ac);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("ConvertToUOMQty2"); 
	objXMLDOMElement.text = formatXMLString(objXML.ad);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("RetailStrategy"); 
	objXMLDOMElement.text = formatXMLString(objXML.ae);
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("PromptForQtyAtPOS"); 
	objXMLDOMElement.text = objXML.af;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("AutoQueueShelfLabels"); 
	objXMLDOMElement.text = objXML.ag;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("RequiresSwipeAtPOS"); 
	objXMLDOMElement.text = objXML.ah;
	domNode.appendChild(objXMLDOMElement);

	objXMLDOMElement = objDOMDocument.createElement("CreditCategoryCode"); 
	objXMLDOMElement.text = objXML.ai;
	domNode.appendChild(objXMLDOMElement);
  
	objXMLDOMElement = objDOMDocument.createElement("UnitPriceUOMForShelfLabel"); 
	objXMLDOMElement.text = objXML.aj;
	domNode.appendChild(objXMLDOMElement);
    
	if (objXML.e == "g")
	{
		// Added to account for the additional 5 columns for Item Group
		for (i = 0; i < itemGroupList.length; i++)  
		{
			domElement = objDOMDocument.createElement("ItemGroup" + (i + 1)); 
			domElement.text = formatXMLString(itemGroupList[i].itemGroupName);
			domNode.appendChild(domElement);
		}
		
		for (i = 0; i < retailPackList.length; i++)   
		{
			domRetailPackElement = objDOMDocument.createElement("RetailPack"); 
			domNode.appendChild(domRetailPackElement);

			domElement = objDOMDocument.createElement("PackName"); 
			domElement.text = formatXMLString(retailPackList[i].packName);
			domRetailPackElement.appendChild(domElement);
    
			domElement = objDOMDocument.createElement("PackQty"); 
			domElement.text = retailPackList[i].packQty;
			domRetailPackElement.appendChild(domElement);
		
			domElement = objDOMDocument.createElement("RetailLevelGroup"); 
			domElement.text = retailPackList[i].retailLevelGroup;
			domRetailPackElement.appendChild(domElement);
		
			domElement = objDOMDocument.createElement("RetailItemPackExternalID"); 
			domElement.text = retailPackList[i].packExternalId;
			domRetailPackElement.appendChild(domElement);
    
			domElement = objDOMDocument.createElement("ListRetail"); 
			domElement.text = retailPackList[i].listRetail;
			domRetailPackElement.appendChild(domElement);
	
			for (j = 0; j < retailPackList[i].barcodeList.length; j++)   
			{
				domBarcodeElement = objDOMDocument.createElement("Barcode"); 
				domRetailPackElement.appendChild(domBarcodeElement);
			
				domElement = objDOMDocument.createElement("BarcodeTypeCode"); 
				domElement.text = retailPackList[i].barcodeList[j].type;
				domBarcodeElement.appendChild(domElement);
			
				domElement = objDOMDocument.createElement("BarcodeNumber"); 
				domElement.text = formatXMLString(retailPackList[i].barcodeList[j].number);
				domBarcodeElement.appendChild(domElement);
			}
		 
			for (j = 0; j < attributeList.length; j++)  
			{
				domElement = objDOMDocument.createElement("CustomAttribute" + (j + 1)); 
				domElement.text = formatXMLString(attributeList[j].attributeName);
				domRetailPackElement.appendChild(domElement);
  
				domElement = objDOMDocument.createElement("Value" + (j + 1)); 
				domElement.text = formatXMLString(attributeList[j].attributeValue);
				domRetailPackElement.appendChild(domElement);  			
			}

		}
	
	}
 
return(domNode);
}
