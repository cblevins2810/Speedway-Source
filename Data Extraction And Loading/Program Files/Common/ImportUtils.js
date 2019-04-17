// Import Utilities
// ROC Associates June 2018

// Returns the path of SourceCSV directory based upon the JScript file name and the import process
function getSourceCSVFolderPath(fileName, processName)
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var s = "";
	s += fso.GetAbsolutePathName(fileName);
	
	var csvFolderPath = s.substring(0,s.indexOf(fileName,0));
	csvFolderPath = csvFolderPath.substring(0, csvFolderPath.indexOf("Program Files", 0)); 
	csvFolderPath += "Import Files\\" + processName + "\\SourceCSV\\";
	
	return csvFolderPath;
}

// Iterates thru each csv file and calls the process specific implementation of importCSVtoXLS
function processSourceCSVFiles(folderPath)
{
	var fso, f, fc, fileName;
	
    WScript.ECho(getTimestamp() + " Searching Source Folder for csv files");
	
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.GetFolder(folderPath);
	fc = new Enumerator(f.files);
	
	if (fc.atEnd())
	{
		WScript.ECho(getTimestamp() + " No files found in source csv folder");	
	}
	else
	{

		WScript.ECho(getTimestamp() + " Files found in source csv folder" );
	}	
   
	for (; !fc.atEnd(); fc.moveNext())
	{
		fileName = "";
		fileName += fc.item();
		fileName = fileName.substring(fileName.indexOf("\SourceCSV") + 10,999);
      
		if (fileName.slice(-4) == ".csv")
		{
			WScript.ECho(getTimestamp() + " Processing File: " + fileName );
			// This function is declared in the process specific JScript
			importCSVtoXLS(folderPath, fileName);
		}
	}  
   
	fso = null;
}

// Returns the path of FinalXLS directory based upon the JScript file name and the import process
function getFinalXLSFolderPath(fileName, processName)
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var s = "";
	s += fso.GetAbsolutePathName(fileName);
	
	var csvFolderPath = s.substring(0,s.indexOf(fileName,0));
	csvFolderPath = csvFolderPath.substring(0, csvFolderPath.indexOf("Program Files", 0)); 
	csvFolderPath += "Import Files\\" + processName + "\\FinalXLS\\";
	
	return csvFolderPath;
}

// Iterates thru each xls file and calls the process specific implementation of saveXLStoCSV
function processFinalXLSFiles(folderPath)
{
	var fso, f, fc, fileName;
	
    WScript.ECho(getTimestamp() + " Searching Final Folder for xls files");
	
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.GetFolder(folderPath);
	fc = new Enumerator(f.files);

	if (fc.atEnd())
	{
		WScript.ECho(getTimestamp() + " No files found in final`xls folder");	
	}
	else
	{

		WScript.ECho(getTimestamp() + " Files found in final xls folder" );
	}	
   
	for (; !fc.atEnd(); fc.moveNext())
	{
		fileName = "";
		fileName += fc.item();
		fileName = fileName.substring(fileName.indexOf("\FinalXLS") + 9,999);
      
		if ((fileName.slice(-5) == ".xlsx") && (fileName.indexOf("~") == -1))
		{

			WScript.ECho(getTimestamp() + " Processing File: " + fileName );
			// This function is declared in the process specific JScript
			saveXLStoCSV(folderPath, fileName);
		}
	}  
   
	fso = null;
}

// Returns the path of FinalCSV directory based upon the JScript file name and the import process
function getFinalCSVFolderPath(fileName, processName)
{
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var s = "";
	s += fso.GetAbsolutePathName(fileName);
	
	var csvFolderPath = s.substring(0,s.indexOf(fileName,0));
	csvFolderPath = csvFolderPath.substring(0, csvFolderPath.indexOf("Program Files", 0)); 
	csvFolderPath += "Import Files\\" + processName + "\\FinalCSV\\";

	return csvFolderPath;
}

// Iterates thru each csv file and calls the process specific implementation of convertCSVtoXML
function processFinalCSVFiles(folderPath)
{
	var fso, f, fc, fileName;
	
    WScript.ECho(getTimestamp() + " Searching Final Folder for csv files");
	
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.GetFolder(folderPath);
	fc = new Enumerator(f.files);
	
	if (fc.atEnd())
	{
		WScript.ECho(getTimestamp() + " No files found in final` csv folder");	
	}
	else
	{

		WScript.ECho(getTimestamp() + " Files found in final csv folder" );
	}	
   
	for (; !fc.atEnd(); fc.moveNext())
	{
		fileName = "";
		fileName += fc.item();
		fileName = fileName.substring(fileName.indexOf("\FinalCSV") + 9,999);
      
		if (fileName.slice(-4) == ".csv")
		{
			WScript.ECho(getTimestamp() + " Processing File: " + fileName );
			// This function is declared in the process specific JScript
			convertCSVtoXML(folderPath, fileName);
		}
	}  
   
	fso = null;
}

// Returns the path of the template file.  
// The template file is location in the root of the process name for the import files folder
function getXLSTemplateFolderPath(folderPath, fileName, processName)
{
	var s = folderPath + fileName;
	var templateFolderPath = s.substring(0,s.indexOf(fileName,0));
	templateFolderPath = templateFolderPath.substring(0, templateFolderPath.indexOf("Import Files", 0)); 
	templateFolderPath += "Import Files\\" + processName + "\\";
	
	return templateFolderPath;
}

// Adds a zero to the front of a single digit number
function padZeros(s)
{
    var r = String(s);
	if ( r.length === 1 )
	{
		r = '0' + r;
    }
	return r;
}

// Accepts a string and returns (999) 999-9999
// Strip out all non=numeric values first, then reformat the string
function formatPhone(phoneNumber)
{
	var s = ""
	if (phoneNumber != "")
	{
    // Trim parenthesis and dashes
    s = phoneNumber.replace(/[\(\)\- ]/g, '');  
    // Trim whitespace, tabs, and carriage returns
    s = s.replace(/^(\s)*/g, '');
    s = s.replace(/(\s)*$/g, '');
        
    s = "("+ s.substring(0,3)+ ") " + s.substring(3,6) + "-" + s.substring(6,10) + " " + s.substring(10,23)
	}
    return(s);
}

// Formats the current date and time.  Typically used in messages/logs
function getTimestamp()
{
	var d = new Date();
	var yy = d.getFullYear().toString().substr(2,2)
	var mm = padZeros(d.getMonth()+1);
	var dd = padZeros(d.getDate());
	var hh = padZeros(d.getHours());
	var mn = padZeros(d.getMinutes());
	var ss = padZeros(d.getSeconds());
  
	return mm+"-"+dd+"-"+yy+"T"+ hh +":"+ mn +":"+ ss + ":";
}

// Formats the current date and time to be used within a file name
function getFileTimestamp()
{
	var d = new Date();
	var yy = d.getFullYear().toString().substr(2,2)
	var mm = padZeros(d.getMonth()+1);
	var dd = padZeros(d.getDate());
	var hh = padZeros(d.getHours());
	var mn = padZeros(d.getMinutes());
	var ss = padZeros(d.getSeconds());
  
	return "-"+mm+"-"+dd+"-"+yy+"T"+hh+"h"+mn+"m"+ss+"s";
}

// Display a string message to a dialog
function showMessage(message)
{

	var timeout = 0;
	var buttons = 0;  // OK
	var icon = 48; // Exclamation

	var shell = new ActiveXObject("WScript.Shell");
	shell.Popup(message, timeout, "Message", buttons + icon);

}

// Accepts a valid date string and converts it to a YYYY-MM-DD formatted string
function formatDateYYYYMMDD(dateString)
{  
	// if is already starts with YY, ignore
	if ((dateString.substring(0,2) != "20") && (dateString.substring(0,2) != "19") && (dateString.length > 0))
	{
		var myDate = new Date(dateString);
		var myDateString = myDate.getFullYear()
			+ '-' + padZeros( myDate.getMonth()+1)
			+ '-' + padZeros( myDate.getDate());
	}
	else
	{
		var myDateString = dateString;
	}
	return myDateString;
}

// Clean up quotation marks in the source data, for example a quoted string will have the beginning and ending quotes removed.
function formatXMLString(s)
{
    var i = 0;
	
	s = s.replace(/^\s+|\s+$/gm,'');  // used in lieu of trim

	// replace special characters with xml encoding
    for (var i = 0; i < s.length; ++i)
	{
        if(s.charCodeAt(i) > 127)
		{
			s = s.substr(0,i) + '#x' + s.charCodeAt(i) + ';' + s.substr(i+1,s.length - i);
			//showMessage(s);
        }
    }
	
	// removed beginning and ending quotes from a string that is quoted
	while ((s.substring(0,1) == "\"") && (s.substring(s.length-1,s.length) == "\""))
	{
		s = s.substring(1,s.length);
		s = s.substring(0, s.length-1);
	}

	// Replaces "" with "
	while (s.indexOf("\"\"") > 0)
	{
		s = s.replace(/""/g,"\"")
	} 
  
	// Replaces tilde placeholder with a comma
	s = s.replace(/~/g,",");

	// Replaces caret placeholder with a tilde
	s = s.replace(/\^/g, ",");
  
	// Replace an underscore at the beginning of a field
	if (s.substring(0,1) == "_")
	{
		s = s.substring(1,s.length);
	}

	return s;
}

function formatTwoDecimalPalces(amount) {
	var i = parseFloat(amount);
	if(isNaN(i)) { i = 0.00; }
	var minus = '';
	if(i < 0) { minus = '-'; }
	i = Math.abs(i);
	i = parseInt((i + .005) * 100);
	i = i / 100;
	s = new String(i);
	if(s.indexOf('.') < 0) { s += '.00'; }
	if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
	s = minus + s;
	return s;
}

function EchoAndLog(logFile, message)
{
	var ts = getTimestamp() + " ";
	logFile.WriteLine(ts + message)
	WScript.Echo(ts + message);
}