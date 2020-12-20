const fs = require("fs");
const papa = require("papaparse");
//const PATH_RESULTS = '../results';

const PATH_PROJECT = process.argv[2];
const PATH_UNDERSTAND_RESULTS = process.argv[3];

const RESULTS_UNDERSTAND_FILE = PATH_PROJECT + "/understand.csv";
const RESULTS_CLASS_FILE = PATH_UNDERSTAND_RESULTS + "/class_results.csv";
const RESULTS_FILE_FILE = PATH_UNDERSTAND_RESULTS + "/file_results.csv";
//const RESULTS_CLASS_FILE = "class_results_u.csv";

console.log(RESULTS_UNDERSTAND_FILE);
const file = fs.createReadStream(RESULTS_UNDERSTAND_FILE);

//Map between understand and lara names
var metricMapper = new Map();
metricMapper.set("AvgCyclomatic", "OO-CyC");
//metricMapper.set("Cyclomatic","OO-CyC"); // For function and methods
metricMapper.set("CountClassCoupled", "CK-CBO");
metricMapper.set("CountClassDerived", "CK-NOC");
metricMapper.set("CountDeclClass", "OO-NOCl");
//metricMapper.set("CountDeclClassMethod","LH-NOM""); // Always 0
metricMapper.set("CountDeclMethod", "LH-NOM");
metricMapper.set("CountDeclFile", "OO-NOFi");
metricMapper.set("CountDeclFunction", "OO-NOFu");
metricMapper.set("CountDeclMethodAll", "CK-RFC");
metricMapper.set("CountLine", "OO-NOL");
metricMapper.set("CountLineCode", "OO-LOC");
metricMapper.set("CountSemicolon", "LH-SIZE1");
metricMapper.set("MaxInheritanceTree", "CK-DIT");
metricMapper.set("PercentLackOfCohesion", "CK-LCOM");
metricMapper.set("SumCyclomatic", "CK-WMC");

//console.log(PATH_RESULTS_FILE);
//console.log(PATH_RESULTS_TIME);

var classResultsStr = "id;metric;value;time\n";
var fileResultsStr = "id;metric;value;time\n";

papa.parse(file, {
	header: true,
	dynamicTyping: true,
	worker: true, // Don't bog down the main thread if its a big file
	step: function (result) {
		if (result.data.Kind === "Class") {
			for (const [metric, value] of Object.entries(result.data)) {
				if (metricMapper.has(metric) && value !== null) {
					const _id = result.data.Name;
					const _metric = metricMapper.get(metric);
					const _value = value;
					const _time = "-";
					//classResults.push(_id+";"+_metric+";"+_value+";"+_time+"\n");
					classResultsStr +=
						_id + ";" + _metric + ";" + _value + ";" + _time + "\n";
				}
			}
        }
        
        if (result.data.Kind === "File") {
			for (const [metric, value] of Object.entries(result.data)) {
				if (metricMapper.has(metric) && value !== null) {
                    let _id = result.data.Name;
                    // Replace back slash (\) with forward slash (/)
                    _id =_id.replace(/\\/g, "/");

                    // Remove first folder in string
                    if(_id.indexOf('/')>=0)
                        _id=_id.substring(_id.indexOf('/') + 1)

					const _metric = metricMapper.get(metric);
					const _value = value;
                    const _time = "-";
                    //console.log(_id);
					//classResults.push(_id+";"+_metric+";"+_value+";"+_time+"\n");
					fileResultsStr +=
						_id + ";" + _metric + ";" + _value + ";" + _time + "\n";
				}
			}
		}
	},
	complete: function (results, file) {

		fs.writeFile(RESULTS_CLASS_FILE, classResultsStr, function (err) {
			if (err) throw err;
			console.log("write Understand class results!");
        });
        
        fs.writeFile(RESULTS_FILE_FILE, fileResultsStr, function (err) {
			if (err) throw err;
			console.log("write Understand file results!");
		});

	}
});
