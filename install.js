const execFile = require('child_process').execFile;
const path = require('path');

var script = path.resolve(__dirname) + '/';
script += 'install.sh';
execFile(script, function(err, out, stderr) {
	if (err !== null)
	  console.log(err);
	  process.stderr.write(stderr);
	  process.stdout.write(out); 
	});
