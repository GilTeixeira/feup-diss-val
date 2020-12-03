const fetch = require("node-fetch");
const fs = require('fs');

const PATH_RESULTS =  process.argv[2];
const SONAR_URL =  process.argv[3];
const PROJECT_ID = process.argv[4];

const RESULTS_FILE = PATH_RESULTS + 'file_results.txt';
const LANG = 'java';

console.log()

let url = new URL(SONAR_URL + '/api/measures/component_tree');
url.search = new URLSearchParams({
  component:PROJECT_ID,
  metricKeys:"cognitive_complexity,complexity"
})

console.log(url.toString());

fs.writeFileSync(RESULTS_FILE, "file;metric;result\n");

(function fetchData(page=1) 
{
fetch(url+"&p="+page)
  .then(response => response.json())
  .then(data => {
    //console.log(data)

    let resultsStr = "";

    if(data.components.length === 0)
      return;

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

      resultsStr+=path+";OO-CyC;"+cyclocomplex+"\n";
      resultsStr+=path+";OO-CoC;"+cognicomplex+"\n";

    }

    fs.appendFile(RESULTS_FILE, resultsStr, function (err) {
        if (err) throw err;
        //console.log(page++)
        fetchData(++page);
        
        console.log('Updated!');
      });
  
  
  });
})();


