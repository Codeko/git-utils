const utils = require('./utils');
const execFile = require('child_process').execFile;
const homedir = require('homedir');
const fs = require('fs-extra');
const path = require('path');

var script = path.resolve(__dirname) + '/';
script += 'install.sh';
execFile(script, function(err, out, stderr) {
	if (err instanceof Error)
	  throw err;
	  process.stderr.write(stderr);
	  process.stdout.write(out); 
	});
