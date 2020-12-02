const fetch = require("node-fetch");
const fs = require('fs');

const RESULTS_FILE = 'file_results.txt';
const LANG = 'java';
const PROJECT_ID = 'elasticsearch';



let url = new URL('http://localhost:9000/api/measures/component_tree');
url.search = new URLSearchParams({
  component:"PROJECT_ID",
  metricKeys:"cognitive_complexity,complexity"
})


fetch(url)
  .then(response => response.json())
  .then(data => {
    //console.log(data)

    let resultsStr = "file;metric;value\n"
    for(let component of data.components){
      let path = component.path;
      //if(!path.endsWith(LANG))
        //continue;

      let cyclocomplex,cognicomplex;
      for(let measure of component.measures){
        if(measure.metric==="complexity")
          cyclocomplex = measure.value;
        if(measure.metric==="cognitive_complexity")
          cognicomplex = measure.value;
      }

      resultsStr+=path+";cyclocomplex;"+cyclocomplex+"\n";
      resultsStr+=path+";cognicomplex;"+cognicomplex+"\n";

    }

    fs.writeFile(RESULTS_FILE, resultsStr, function (err) {
        if (err) throw err;
        console.log('Updated!');
      });
  
  
  });

