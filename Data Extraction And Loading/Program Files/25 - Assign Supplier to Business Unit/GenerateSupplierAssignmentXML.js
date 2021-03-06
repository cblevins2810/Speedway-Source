// Supplier Assignment Import
// Convert a comma delimited file into the JDA ESO Import XML format
// ROC Associates June 2018

// Global Vars
var jsfileName = "GenerateSupplierAssignmentByBusinessUnitGroupXML.js";
var processName = "Assign Supplier to Business Unit";

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
	var supplierAssignmentList = [];	
	var bFirstLineOfOrgCode = true;
	var priorOrgCode = '';
  
	// Loop through the file 
	//while((!tso.AtEndOfStream) && (row <= 99))
   while(!tso.AtEndOfStream)	  
   { 
		row +=1;
		strInput = tso.ReadLine();
		var vInputLine = strInput.split(",");     

		if (bFirstTime) 
		{
			priorOrgCode = vInputLine[0];
		}

		if (priorOrgCode != vInputLine[0]) 
		{
			objXMLDOMNode.appendChild(XMLAssignmentNode(objDOMDocument,objXML,supplierAssignmentList));
			priorOrgCode = vInputLine[0];
			var objXML  = new Object();
			var supplierAssignmentList = [];
			bFirstLineOfOrgCode = true;
		}

		if (bFirstLineOfOrgCode)
		{	
			objXML.a = vInputLine[0];
			bFirstLineOfOrgCode = false;
		}
	
		if (vInputLine[4] == 'Assign')
		{
			supplierAssignmentList.push({supplierXRefID: vInputLine[3], action: 'y'});
		}
		else
		{
			supplierAssignmentList.push({supplierXRefID: vInputLine[3], action: 'n'});
		}
	
		bFirstTime = false; 
	
		if ((row % 10) == 0)
		{
			EchoAndLog(logFile, "Supplier Assignment Rows: " + row);
		}
   	
	} 

	objXMLDOMNode.appendChild(XMLAssignmentNode(objDOMDocument,objXML,supplierAssignmentList));
	tso.Close();
 
  	EchoAndLog(logFile, "Starting XSL Transform, this may take awhile.");
 
	// Load Transform file
	var TransformXSL = new ActiveXObject("MSXML2.DOMDocument.6.0");
	TransformXSL.async = false  
	TransformXSL.load("\SupplierAssignmentXform.xsl");
  
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

function XMLAssignmentNode(objDOMDocument,objXML, supplierAssignmentList)
{     
	var domNode = objDOMDocument.createNode(1, "RawXMLRow",""); 
	var i;
	
	domElement = objDOMDocument.createElement("BusinessUnitName"); 
	domElement.text = formatXMLString(objXML.a);
	domNode.appendChild(domElement);
 
	for (i = 0; i < supplierAssignmentList.length; i++)  
	{
		domSupplierAssigmentElement = objDOMDocument.createElement("Assignment"); 
		domNode.appendChild(domSupplierAssigmentElement);

		domElement = objDOMDocument.createElement("SupplierXRefID"); 
		domElement.text = supplierAssignmentList[i].supplierXRefID;
		domSupplierAssigmentElement.appendChild(domElement);
		
		domElement = objDOMDocument.createElement("Action"); 
		domElement.text = supplierAssignmentList[i].action;
		domSupplierAssigmentElement.appendChild(domElement);
	}
	
	return(domNode);
}
