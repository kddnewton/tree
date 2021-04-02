#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const counts = { dirs: 0, files: 0 };

function walk(directory, prefix) {
  fs.readdirSync(directory, { withFileTypes: true }).forEach((file, index, files) => {
    if (file.name.charAt(0) != ".") {
      const parts = index == files.length - 1 ? ["└── ", "    "] : ["├── ", "│   "];
      console.log(`${prefix}${parts[0]}${file.name}`);

      if (file.isDirectory()) {
        counts.dirs += 1;
        walk(path.join(directory, file.name), `${prefix}${parts[1]}`);
      } else {
        counts.files += 1;
      }
    }
  });
}

const directory = process.argv[2] || ".";
console.log(directory);

walk(directory, "");
console.log(`\n${counts.dirs} directories, ${counts.files} files`);
