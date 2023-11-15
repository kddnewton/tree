# tree

The GNU [tree](https://linux.die.net/man/1/tree) utility prints out a directory structure in a tree-like display using utf-8 characters. I've been using it as something to build when learning a new programming language. This repository contains all of the implementations that I have done in various languages. To execute, run `make [language]` where language is one of:

* c
* c++
* elixir
* go
* java
* javascript
* objectivec
* php
* python
* ruby
* rust
* scala
* shell

Note that this does not include information on getting the necessary utilities installed, so you may not be able to run every one of them depending on your setup.

## Testing

To test one of the implementations for example bash:
```bash
cd test; bash ../tree.sh cd ..;
```

The bash implementation has hidden file support with the -a flag:
```bash
cd test; bash ../tree.sh -a; cd ..;
```

You should see something like the following output:

<img width="550" alt="Screenshot 2023-11-15 at 3 52 16 PM" src="https://github.com/kddnewton/tree/assets/11463275/aa2d894c-2e54-4cba-abf0-ca327e1c5a3d">

