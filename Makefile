c:
	gcc -Wall -o tree tree.c && ./tree

c++:
	g++ -Wall -std=c++17 -o tree tree.cpp && ./tree

elixir:
	elixir tree.exs

go:
	go run tree.go

java:
	javac Tree.java && java Tree

javascript:
	node tree.js

objectivec:
ifeq ($(shell uname -s), Darwin)
	clang -framework Foundation -o tree tree.m && ./tree
else
	gcc -I/usr/include/GNUstep -fconstant-string-class=NSConstantString -o tree tree.m -lobjc -lgnustep-base && ./tree
endif

php:
	php tree.php

python:
	python tree.py

ruby:
	ruby tree.rb

rust:
	rustc -o tree tree.rs && ./tree

scala:
	scalac Tree.scala && scala Tree

shell:
	bash tree.sh $(CFLAGS)
