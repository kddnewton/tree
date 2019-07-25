c:
	gcc -Wall -o tree tree.c
	./tree

elixir:
	elixir tree.exs

go:
	go run tree.go

haskell:
	ghc -o tree tree.hs
	./tree

java:
	javac Tree.java
	java Tree

javascript:
	node tree.js

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
