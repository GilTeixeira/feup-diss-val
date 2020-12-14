const fetch = require("node-fetch");
const fs = require("fs");

const PATH_RESULTS = process.argv[2];
const SONAR_URL = process.argv[3];
const PROJECT_ID = process.argv[4];

const FILE_RESULTS = PATH_RESULTS + "file_results.csv";
const PROJECT_RESULTS = PATH_RESULTS + "project_results.csv";
const LANG = "java";

console.log();

let url = new URL(SONAR_URL + "/api/measures/component_tree");
url.search = new URLSearchParams({
	component: PROJECT_ID,
	metricKeys:
		"cognitive_complexity,complexity,lines,ncloc,functions,classes,files"
});

console.log(url.toString());

fs.writeFileSync(FILE_RESULTS, "id;metric;value\n");

(function fetchFilesData(page = 1) {
	fetch(url + "&p=" + page)
		.then((response) => response.json())
		.then((data) => {
			//console.log(data)

			let resultsStr = "";

			if (data.components.length === 0) return;

			for (let component of data.components) {
				let path = component.path;
				//if(!path.endsWith(LANG))
				//continue;

				let cyclocomplex, cognicomplex, nol, loc, nocl, nofu, nofi;
				for (let measure of component.measures) {
					if (measure.metric === "complexity")
						cyclocomplex = measure.value;
					if (measure.metric === "cognitive_complexity")
						cognicomplex = measure.value;
					if (measure.metric === "lines") nol = measure.value;
					if (measure.metric === "ncloc") loc = measure.value;
					if (measure.metric === "classes") nocl = measure.value;
          if (measure.metric === "functions") nofu = measure.value;
          //if (measure.metric === "files") nofi = measure.value;
				}
				resultsStr += path + ";OO-CyC;" + cyclocomplex + "\n";
				resultsStr += path + ";OO-CoC;" + cognicomplex + "\n";
				resultsStr += path + ";OO-NOL;" + nol + "\n";
				resultsStr += path + ";OO-LOC;" + loc + "\n";
				resultsStr += path + ";OO-NOCl;" + nocl + "\n";
        resultsStr += path + ";OO-NOFu;" + nofu + "\n";
        //resultsStr += path + ";OO-NOFi;" + nofi + "\n";
			}

			fs.appendFile(FILE_RESULTS, resultsStr, function (err) {
				if (err) throw err;
				//console.log(page++)
				fetchFilesData(++page);

				console.log("Updated!");
			});
		});
})();

fs.writeFileSync(PROJECT_RESULTS, "metric;value;\n");

(function fetchProjectData() {
	fetch(url)
		.then((response) => response.json())
		.then((data) => {
			//console.log(data)

			let resultsStr = "";

			if (data.baseComponent.measures === 0) return;

			let cyclocomplex, cognicomplex, nol, loc, nocl, nofu;

			for (let measure of data.baseComponent.measures) {
				if (measure.metric === "complexity")
					cyclocomplex = measure.value;
				if (measure.metric === "cognitive_complexity")
					cognicomplex = measure.value;
        if (measure.metric === "lines") 
          nol = measure.value;
        if (measure.metric === "ncloc") 
          loc = measure.value;
        if (measure.metric === "classes") 
          nocl = measure.value;
        if (measure.metric === "functions") 
          nofu = measure.value;
        if (measure.metric === "files") 
          nofi = measure.value;
			}
			resultsStr += "OO-CyC;" + cyclocomplex + "\n";
			resultsStr += "OO-CoC;" + cognicomplex + "\n";
			resultsStr += "OO-NOL;" + nol + "\n";
			resultsStr += "OO-LOC;" + loc + "\n";
			resultsStr += "OO-NOCl;" + nocl + "\n";
      resultsStr += "OO-NOFu;" + nofu + "\n";
      resultsStr += "OO-NOFi;" + nofi + "\n";

			fs.appendFile(PROJECT_RESULTS, resultsStr, function (err) {
				if (err) throw err;
			});
		});
})();
