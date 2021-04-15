c:
	gcc -Wall -o tree tree.c && ./tree

c++:
	g++ -Wall -std=c++17 -o tree tree.cpp && ./tree

elixir:
	which elixir && elixir tree.exs

go:
	go run tree.go

java:
	javac Tree.java && java Tree

javascript:
	node tree.js

objectivec:
	clang -framework Foundation -o tree tree.m && ./tree

php:
	php tree.php

python:
	python tree.py

ruby:
	ruby tree.rb

rust:
	which rustc && rustc -o tree tree.rs && ./tree

scala:
	which scalac && scalac Tree.scala && scala Tree

shell:
	sh tree.sh
