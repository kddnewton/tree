#!/usr/bin/python
# -*- coding: utf-8 -*-

import os

class Tree:
    def __init__(self):
        self.dirCount = 0
        self.fileCount = 0

    def register(self, absolute):
        if os.path.isdir(absolute):
            self.dirCount += 1
        else:
            self.fileCount += 1

    def summary(self):
        return str(self.dirCount) + " directories, " + str(self.fileCount) + " files"

    def walk(self, directory, prefix = ""):
        filepaths = [filepath for filepath in os.listdir(directory)]

        for index in range(len(filepaths)):
            if filepaths[index][0] == ".":
                continue

            absolute = os.path.join(directory, filepaths[index])
            self.register(absolute)

            if index == len(filepaths) - 1:
                print(prefix + "└── " + filepaths[index])
                if os.path.isdir(absolute):
                    self.walk(absolute, prefix + "    ")
            else:
                print(prefix + "├── " + filepaths[index])
                if os.path.isdir(absolute):
                    self.walk(absolute, prefix + "│   ")

tree = Tree()

print(".")
tree.walk(".")
print("\n" + tree.summary())
