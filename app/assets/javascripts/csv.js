var separator=',';
/*
$('#btn_search').on('click', function(e){
    e.preventDefault();
    
    //var results = findEntriesWithID("ID",$('#search_box').val());
    var results = findEntriesWithID("Localidad",$('#search_box_loc').val());
    
    $('.output').text(ConvertToCSV(results));
})
*/
//var csvString = $.trim($('#csvContentHidden').html());

var csvArray; 
function findEntriesWithID(f,q){
    var entries = [];
    for(var i = 0; i < csvArray.length; ++i){
        var row = csvArray[i];
/*    
        if($( row.ID+":contains("+ID+")" )){
            console.debug(row.ID+":contains("+ID+")");
            entries.push(row);
        }
 */
        //if(row.ID === q){
        //if(row[6].match(q)){
        if(row.ID.match(q)){
          entries.push(row);
        }
    }
    
    return entries;
}


// Returns a csv from an array of objects with
// values separated by tabs and rows separated by newlines
function ConvertToCSVOLD(array) {
    // Use first element to choose the keys and the order
    var keys = Object.keys(array[0]);

    // Build header
    var result = keys.join(",") + "\n";

    // Add the rows
    array.forEach(function(obj){
        keys.forEach(function(k, ix){
            if (ix) result += ",";
            result += obj[k];
        });
        result += "\n";
    });

    return result;
}


    function ConvertToCSV(data) {
      var str = '"id","species","EspecieOriginal","lon","lat","Localidad","Municipio","Departamento","Pais","Altitud","Fecha","Institucion","Colector","Evidencia","Publico"'+ '\r\n';

      if(typeof(data[0]) === 'undefined') {
        return null;
      }

      if(data[0].constructor === Object) {
        for(var row in data) {
          var line = '';
          for(var item in data[row]) {
            if (line != '') line += ','
            line += '"'+encode_utf8(data[row][item])+'"';
          }
          str += line + '\r\n';
        }
      }
      return str;

    }

    function encode_utf8(s) {
      return unescape(encodeURIComponent(s));
    }
 // build HTML table data from an array (one or two dimensional)
    function generateTable(data) {
      var html = '<table id="result2" border="1">';

      if(typeof(data[0]) === 'undefined') {
        return null;
      }

      if(data[0].constructor === Object) {
        for(var row in data) {
          html += '<tr>\r\n';
          for(var item in data[row]) {
            html += '<td>' + item + ':' + data[row][item] + '</td>\r\n';
          }
          html += '</tr>\r\n';
        }
      }

      html += "</table>";
      return html;
    }

function csvToArray(csvString){
  // The array we're going to build
  var csvArray   = [];
  // Break it into rows to start
  var csvRows    = csvString.split(/\n/);
  // Take off the first line to get the headers, then split that into an array
  var csvHeaders = csvRows.shift().split(separator);

  // Loop through remaining rows
  for(var rowIndex = 0; rowIndex < csvRows.length; ++rowIndex){
    var rowArray  = csvRows[rowIndex].split(separator);

    // Create a new row object to store our data.
    var rowObject = csvArray[rowIndex] = {};
    
    // Then iterate through the remaining properties and use the headers as keys
    for(var propIndex = 0; propIndex < rowArray.length; ++propIndex){
      // Grab the value from the row array we're looping through...
      var propValue =   rowArray[propIndex].replace(/^"|"$/g,'');
      // ...also grab the relevant header (the RegExp in both of these removes quotes)
      var propLabel = csvHeaders[propIndex].replace(/^"|"$/g,'').replace(" ","");

      rowObject[propLabel] = propValue;
    }
  }
  return csvArray;
}