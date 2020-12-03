const fs = require('fs');
const papa = require('papaparse');
//const PATH_RESULTS = '../results';

const PATH_RESULTS =  process.argv[2];

//$console.log(process.argv[2]);

const RESULTS_FILE = 'full_results.txt';
const RESULTS_TIME = 'time_results.txt';

const PATH_RESULTS_FILE = PATH_RESULTS + RESULTS_FILE;
const PATH_RESULTS_TIME = PATH_RESULTS + RESULTS_TIME;

const file = fs.createReadStream(PATH_RESULTS_FILE);

var mapMetric = new Map();

console.log(PATH_RESULTS_FILE);
console.log(PATH_RESULTS_TIME);

var classes = new Set();

papa.parse(file, {
    header: true,
    dynamicTyping: true,
    worker: true, // Don't bog down the main thread if its a big file
    step: function(result) {
	
	// if not in map, its 0
	var currVal = mapMetric.get(result.data.metric) || 0;

        var accumResult = result.data.time + currVal;
        mapMetric.set(result.data.metric, accumResult);
        console.log(result);
       
        var output = result.data.class.split(/::/).pop();
        classes.add(output)

    },
    complete: function(results, file) {
	// Sort Map
    	var mapAsc = new Map([...mapMetric.entries()].sort());
    	
    	var timesStr = "metric;time\n";
    	console.log("Metric = time in micrseconds (10^-6)\n");
        for (let [key, value] of mapAsc.entries()) {
	        timesStr+=key + ';' + value + '\n';
            //console.log(key + ' = ' + value);
            /*
            var metricSigla = key.split("(")[0];
            metricSigla = metricSigla.replace(/[a-z]| /g, '');  
            console.log(metricSigla + ' = ' + value);
            */
          }
        fs.writeFile(PATH_RESULTS_TIME, timesStr, function (err) {
            if (err) throw err;
            console.log('Updated!');
          });

          console.log(new Array(...classes).join('\n '));
          console.log(classes.size);
    }
});
