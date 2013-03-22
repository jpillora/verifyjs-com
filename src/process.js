// process
require('colors');
var fs = require('fs');

var execsStr = fs.readFileSync('process.json');

execs = JSON.parse(execsStr);

var colors = ['blue','green','yellow', 'red'];
var getColor = function(i) {
  return colors[i % colors.length];
};

var children = [];

var makeLog = function(color, name) {
  return function(msg) {
    if(typeof msg !== 'string') msg = msg.toString();
    console.log(name[color] + ": " + msg.replace(/\n/g, ''));
  };
};

var mainLog = makeLog('white', 'process.js');

var opts = {};
var spawn = require('child_process').spawn;
var run = function(name, path) {

  var i = children.length;
  var args = path.split(/\s+/);
  var bin = args.shift();
  var child = null;
  var log = makeLog(getColor(i), name);

  try {
    child = spawn(bin, args, opts);
  } catch(e) {
    mainLog("Could not run: " + path);
    return;
  }

  mainLog("Running '"+name+"'");

  child.stdout.on('data', function (data) {
    log(data);
  });

  child.stderr.on('data', function (data) {
    log(String(data).red);
  });

  child.on('close', function (code) {
    log('exited with ' + code);
  });

  children.push(child);
};

//kick off
for(var n in execs)
  run(n, execs[n]);
