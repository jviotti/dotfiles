Bootstrap
=========

> A tiny cross-platform framework to manage project-specific bootstrap scripts.

`bootstrap` is a tiny utility to manage cross-platform scripts that setup
what's needed for a specific project. It supports macOS, GNU/Linux and Windows
under MSYS2 and Cygwin.

Installation
------------

The recommended way of installing `bootstrap` is through
`[vendorpull](https://github.com/jviotti/vendorpull)`:

```sh
echo "bootstrap https://github.com/jviotti/bootstrap <commit sha>" >> DEPENDENCIES
./vendor/vendorpull/pull bootstrap
```

Usage
-----

The `bootstrap` utility tool expects a directory called `bootstrap` which
include sequence of bootstrap scripts divided by platform. The supported
platforms are `linux`, `macos`, `windows` and `any`. Each of these directories
contains a set of executable scripts written in any programming language that
are executed in alphabetical order. For example:

```
bootstrap/
├── any
│   └── 0001-this-script-runs-for-any-platform.sh
├── linux
│   └── 0001-this-script-runs-only-on-linux.sh
│   └── 0002-this-script-runs-second-on-linux.sh
├── macos
│   └── 0001-this-script-runs-only-on-macos.sh
│   └── 0002-this-script-runs-second-on-macos.sh
└── windows
    └── 0001-this-script-runs-only-on-windows.sh
    └── 0002-this-script-runs-second-on-windows.sh
```

Then, execute the `bootstrap` script passing the bootstrap directory as an
argument:

```sh
./vendor/bootstrap/bootstrap path/to/bootstrap
```

GNU Make integration
--------------------

Add the following directive to your `Makefile`:

```make
include vendor/bootstrap/targets.mk
```

This will add one target:

- `bootstrap`: Execute bootstrap pointing at the `bootstrap` directory relative
  to the Makefile

License
-------

This project is licensed under the Apache-2.0 license.
