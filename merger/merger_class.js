const fs = require("fs");
const papa = require("papaparse");
const path = require("path");
const util = require("util");
const readdir = util.promisify(fs.readdir);

const PATH_RESULTS = process.argv[2];
const RESULTS_FILE = PATH_RESULTS + "/full_results.txt";

(async function () {
	let metrics = new Set();
	let classes = [];
	let tools = [];
	let results = new Map();

	const LARA_PATH = PATH_RESULTS + "/lara/full_results.txt";
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
					classes.push(result.data.class);

					let resTool = {
						tool: "lara",
						metric: result.data.metric,
						result: result.data.result
					};
					if (results.has(result.data.class))
						results.set(
							results.get(result.data.class).push(resTool)
						);
					else results.set(result.data.class, [resTool]);
				}
			});
		});
	})();

	await (function () {
		return new Promise(async (resolve, reject) => {
			let dirs = await readdir(PATH_RESULTS);
			console.log(dirs);

			for (let dir of dirs) {
				// Make one pass and make the file complete
				let dirPath = path.join(PATH_RESULTS, dir);
				let filePath = path.join(dirPath, "full_results.txt");

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
								if (!results.has(result.data.class)) return;

								let resTool = {
									tool: dir,
									metric: result.data.metric,
									result: result.data.result
								};

								results.set(
									results.get(result.data.class).push(resTool)
								);
							}
						});
					});
				})();
			}

			resolve();
		});
	})();

	console.log(results);
	console.log("END");

	let resultsStr = "classes;";

	//Header
	for (metric of metrics)
		for (tool of tools) {
			resultsStr += tool + "-" + metric + ";";
			console.log(tool + "  " + metric);
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
				else line += res[0].result;
				line += ";";
			}
		line += "\n";
		resultsStr += line;
		//console.log(value, key)
	});

	console.log(RESULTS_FILE);
	fs.writeFile(RESULTS_FILE, resultsStr, function (err) {
		if (err) throw err;
		console.log("Updated!");
	});
})();
