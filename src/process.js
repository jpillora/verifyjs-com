// process
require('colors');
var fs = require('fs');

var execsStr = fs.readFileSync('process.json');

execs = JSON.parse(execsStr);

var colors = ['blue','green','yellow'];
var children = [];

var log = function(color, str) {
  console.log((""+str.replace("\n",""))[color]);
};
var opts = {};
var spawn = require('child_process').spawn;
var run = function(name, path) {

  var i = children.length;
  var args = path.split(/\s+/);
  var bin = args.shift();
  var child = null;

  // console.log(bin, args);

  try {
    child = spawn(bin, args, opts);
  } catch(e) {
    log('white', "process.js: Could not run: " + path);
    return;
  }

  log('white', "process.js: Running '"+name+"'");

  child.stdout.on('data', function (data) {
    log(colors[i], name + ': ' + data);
  });

  child.stderr.on('data', function (data) {
    log('red', name + ': ' + data);
  });

  child.on('close', function (code) {
    log(colors[i], name + ': exited with ' + code);
  });

  children.push(child);
};

//kick off
for(var name in execs) run(name, execs[name]);
