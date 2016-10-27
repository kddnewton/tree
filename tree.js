#!/usr/bin/env node

var fs = require('fs');
var path = require('path');

function Tree() {
  this.dirCount = 0;
  this.fileCount = 0;
}

Tree.prototype._register = function (filepath) {
  if (fs.lstatSync(filepath).isDirectory()) {
    this.dirCount += 1;
  } else {
    this.fileCount += 1;
  }
};

Tree.prototype.walk = function (directory, prefix) {
  var _this = this;
  var filepaths = fs.readdirSync(directory);

  filepaths.forEach(function (filepath, index) {
    var absolute;
    var isDirectory;

    if (filepath.charAt(0) == '.') {
      return;
    }
    absolute = path.join(directory, filepath);
    _this._register(absolute);

    isDirectory = fs.lstatSync(absolute).isDirectory();

    if (index == filepaths.length - 1) {
      console.log(prefix + '└── ' + filepath);
      if (isDirectory) {
        _this.walk(absolute, prefix + '    ');
      }
    } else {
      console.log(prefix + '├── ' + filepath);
      if (isDirectory) {
        _this.walk(absolute, prefix + '│   ');
      }
    }
  });
};

Tree.prototype.summary = function () {
  return this.dirCount.toString() + ' directories, ' + this.fileCount + ' files';
}

var directory = '.';
if (process.argv.length > 2) {
  directory = process.argv[2];
}
console.log(directory);

var tree = new Tree();
tree.walk(directory, '');
console.log("\n" + tree.summary());
