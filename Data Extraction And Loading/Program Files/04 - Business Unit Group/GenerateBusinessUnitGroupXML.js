// Business Unit Group Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018
  
// Global Vars  
var jsfileName = "GenerateBusinessUnitGroupXML.js";
var processName = "Business Unit Group";

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
	var bFirstTime = true;
	var objXML  = new Object();
	var BusinessUnitList = [];	
	var bFirstLineOfBusinessUnitGroupCode = true;
	var priorBusinessUnitGroupCode = '';
  
	// Loop through the file 
	//while((!tso.AtEndOfStream) && (row <= 99))
	while(!tso.AtEndOfStream)	  
	{ 
		row +=1;
		strInput = tso.ReadLine();
		var vInputLine = strInput.split(",");     

		if (bFirstTime) 
		{
			priorBusinessUnitGroupCode = vInputLine[0];
		}

		if (priorBusinessUnitGroupCode != vInputLine[0]) 
		{
			objXMLDOMNode.appendChild(XMLAssignmentNode(objDOMDocument,objXML,BusinessUnitList));
			priorBusinessUnitGroupCode = vInputLine[0];
			var objXML  = new Object();
			var BusinessUnitList = [];
			bFirstLineOfBusinessUnitGroupCode = true;
		}

		if (bFirstLineOfBusinessUnitGroupCode)
		{	
			objXML.a = vInputLine[0];
			objXML.b = vInputLine[1];
			objXML.c = vInputLine[2];
			objXML.d = vInputLine[3];
			objXML.e = vInputLine[4];
		
			bFirstLineOfBusinessUnitGroupCode = false;
		}
	
		if (vInputLine[7] == 'Assign')
		{
			BusinessUnitList.push({businessUnitCode: vInputLine[5], action: 'y'});
		}
		else
		{
			BusinessUnitList.push({businessUnitCode: vInputLine[5], action: 'n'});
		}
	
		bFirstTime = false; 
	
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Business Unit Group rows: " + row);
		}
	} 

	objXMLDOMNode.appendChild(XMLAssignmentNode(objDOMDocument,objXML,BusinessUnitList));
	tso.Close();

   	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
	
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\BusinessUnitGroupXform.xsl");
  
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
	
	EchoAndLog(logFile, "Finished Generating XML");
	EchoAndLog(logFile, "Total Assignment Nodes: " + (row));
	EchoAndLog(logFile, "File created in final xml folder: " + destFileName + ".xml");
	EchoAndLog(logFile, "...");
}

function XMLHeader(objDOMDocument)
{ 
  var XMLHead;
  XMLHead = objDOMDocument.createNode(1, "Document",""); 
 
  return(XMLHead);
} 

function XMLAssignmentNode(objDOMDocument,objXML, BusinessUnitList)
{     
	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i;
	
	domElement = objDOMDocument.createElement("GroupCode"); 
	domElement.text = formatXMLString(objXML.a);
	domNode.appendChild(domElement);
	
	domElement = objDOMDocument.createElement("GroupName"); 
	domElement.text = formatXMLString(objXML.b);
	domNode.appendChild(domElement);

	if (objXML.c.length > 0)
	{
		domElement = objDOMDocument.createElement("Description"); 
		domElement.text = formatXMLString(objXML.c);
		domNode.appendChild(domElement);	
	}
	
	domElement = objDOMDocument.createElement("TypeCode"); 
	domElement.text = objXML.d;
	domNode.appendChild(domElement);	

	domElement = objDOMDocument.createElement("TransferFlag"); 
	domElement.text = objXML.e;
	domNode.appendChild(domElement);
	
	for (i = 0; i < BusinessUnitList.length; i++)  
	{
		domSupplierAssigmentElement = objDOMDocument.createElement("BusinessUnit"); 
		domNode.appendChild(domSupplierAssigmentElement);

		domElement = objDOMDocument.createElement("BusinessUnitCode"); 
		domElement.text = formatXMLString(BusinessUnitList[i].businessUnitCode);
		domSupplierAssigmentElement.appendChild(domElement);
		
		domElement = objDOMDocument.createElement("Action"); 
		domElement.text = BusinessUnitList[i].action;
		domSupplierAssigmentElement.appendChild(domElement);
	}

  return(domNode);
}

