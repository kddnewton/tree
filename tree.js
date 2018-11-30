#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const walk = (directory, prefix, counts) => {
  const filepaths = fs.readdirSync(directory);

  filepaths.forEach((filepath, index) => {
    if (filepath.charAt(0) == ".") {
      return;
    }

    const absolute = path.join(directory, filepath);
    const isDirectory = fs.lstatSync(absolute).isDirectory();

    counts[isDirectory ? "dirs" : "files"] += 1;

    if (index == filepaths.length - 1) {
      console.log(`${prefix}└── ${filepath}`);
      if (isDirectory) {
        walk(absolute, `${prefix}    `, counts);
      }
    } else {
      console.log(`${prefix}├── ${filepath}`);
      if (isDirectory) {
        walk(absolute, `${prefix}│   `, counts);
      }
    }
  });
};

const directory = process.argv[2] || ".";
const counts = { dirs: 0, files: 0 };

console.log(directory);
walk(directory, "", counts);

console.log(`\n${counts.dirs} directories, ${counts.files} files`);
