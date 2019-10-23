c:
	gcc -Wall -o tree tree.c
	./tree

elixir:
	elixir tree.exs

go:
	go run tree.go

java:
	javac Tree.java
	java Tree

javascript:
	node tree.js

objectivec:
	clang -framework Foundation -o tree tree.m
	./tree

php:
	php tree.php

python:
	python tree.py

ruby:
	ruby tree.rb

rust:
	rustc -o tree tree.rs
	./tree

scala:
	scalac Tree.scala
	scala Tree

shell:
	sh tree.sh
