const fs = require("fs");
const papa = require("papaparse");
const path = require("path");
const util = require("util");
const readdir = util.promisify(fs.readdir);

const PATH_RESULTS = process.argv[2];
const FILE_TO_MERGE = process.argv[3];
//FILE_TO_MERGE = "file_results.csv"; 
const RESULTS_FILE = PATH_RESULTS + "/"+FILE_TO_MERGE;

(async function () {
	let metrics = new Set();
	let files = [];
	let tools = [];
	let results = new Map();

	const LARA_PATH = PATH_RESULTS + "/lara/"+FILE_TO_MERGE;
	const LARA_FILE = fs.createReadStream(LARA_PATH);

	await (function () {
		return new Promise((resolve, reject) => {
			const file = fs.createReadStream(LARA_PATH);

			papa.parse(file, {
				header: true,
				complete: function (results) {
					resolve(results);
				},
				error: function (error) {
					reject(error);
				},
				step: function (result) {
					metrics.add(result.data.metric);
					files.push(result.data.id);

					let resTool = {
						tool: "lara",
						metric: result.data.metric,
						value: result.data.value
					};
					if (results.has(result.data.id))
						results.set(
							results.get(result.data.id).push(resTool)
						);
					else results.set(result.data.id, [resTool]);
				}
			});
		});
	})();

	await (function () {
		return new Promise(async (resolve, reject) => {
			let dirs = await readdir(PATH_RESULTS);
			//console.log(dirs);

			for (let dir of dirs) {
				// Make one pass and make the file complete
				let dirPath = path.join(PATH_RESULTS, dir);
				let filePath = path.join(dirPath, FILE_TO_MERGE);

				// Skip if doesnt exist file
				if (!fs.existsSync(filePath)) continue;

				tools.push(dir);

				// Skip lara
				if (dir === "lara") continue;

				await (function () {
					return new Promise((resolve, reject) => {
						const file = fs.createReadStream(filePath);

						papa.parse(file, {
							header: true,
							complete: function (results) {
								resolve(results);
							},
							error: function (error) {
								reject(error);
							},
							step: function (result) {
								if (!results.has(result.data.id)) return;

								let resTool = {
									tool: dir,
									metric: result.data.metric,
									value: result.data.value
								};

								results.set(
									results.get(result.data.id).push(resTool)
								);
							}
						});
					});
				})();
			}

			resolve();
		});
	})();

	//console.log(results);
	//console.log("END");

	let resultsStr = "files;";

	//Header
	//console.log("tools:  " + tools);
	//console.log("metrics:  " + metrics);
	for (metric of metrics)
		for (tool of tools) {
			resultsStr += tool + "-" + metric + ";";
			//console.log(tool + "  " + metric);
		}

	resultsStr += "\n";

	//Body
	results.forEach((value, key) => {
		if (value === undefined) return;
		let line = key + ";";
		for (metric of metrics)
			for (tool of tools) {
				let res = value.filter(
					(res) => res.tool === tool && res.metric === metric
				);
				if (res.length === 0) line += "-";
				else line += res[0].value;
				line += ";";
			}
		line += "\n";
		resultsStr += line;
		//console.log(value, key)
	});

	//console.log(RESULTS_FILE);
	fs.writeFile(RESULTS_FILE, resultsStr, function (err) {
		if (err) throw err;
		console.log("Updated!");
	});
})();
