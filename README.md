# indirect

*managing package manager package lists, for easier installs*

## What it does

Helps with managing lists of indirect objects, i.e. packages.
Outputs scripts for installing with various package managers.
Transforms the data into csv format, a step towards improved handling with [dative](https://github.com/orlin/dative) or other tools.

## Motivation

Pretty much every platform or programming language has a package manager.
I got tired of forgetting what packages I use, why, and how they install.
So I started making lists [such as these](https://github.com/orlin/dots/tree/master/install/packages).
This tool parses the text files and generates data for further scripting.
By default, it produces install scripts. Installing is my main motivation.

## Install

A `Makefile` installs `indirect` to `/usr/local`, which is configurable...

From source, using `git` and `make`:

```sh
git clone https://github.com/orlin/indirect.git # or your own fork of it
cd indirect
make install
```

Or, with [bpkg](http://www.bpkg.io):

```sh
curl -sLo- http://get.bpkg.io | bash # in case you don't already have it
bpkg install -g orlin/indirect
```

## Use

```sh
indirect --help
```

## License

[MIT](http://orlin.mit-license.org)
