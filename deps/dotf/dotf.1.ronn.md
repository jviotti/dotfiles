dotf(1) -- module-based dotfiles manager
========================================

SYNOPSIS
--------

`dotf` [`-dhv`] [`-a` <action>] [`-c` <file>] [`-m` <directory>] [`-n` <directory>] [`-o` <directory>]

DESCRIPTION
-----------

The `dotf` utility allows the user to manage a large set of personal dotfiles.
Dotfiles are divided by logical groups and you may store different instances of
a same file for different operating systems or versions of the program that
consumes it.

The user maintains a directory subdivided by `dotf` modules, where a module is
just another directory. Each module must contain a `MANIFEST` file that maps
the other files in the module to their expected locations.

For example, a basic dotfiles directory with a simple `email' module containing
mutt(1), msmtp(1), and offlineimap(1) configuration files may look like this:

```
dotfiles/
  email/
    MANIFEST
    muttrc
    offlineimaprc
    msmtprc
```

The `MANIFEST` file inside such module may look like this:

```
DIRECTORY .mutt/cache
SYMLINK msmtprc .msmtprc 600
SYMLINK offlineimaprc .offlineimaprc
SYMLINK muttrc .mutt/muttrc
```

For detailed descriptions of each command see chapter [MANIFEST FILE][MANIFEST
FILE].

MANIFEST FILE
-------------

The `MANIFEST` file describes how to prepare the environment before applying
the module and how every file inside the module maps to its expected
destination. Note that the mapping is bi-directional, and it allows `dotf` to
revert a module from the system. This file is evaluated from top to bottom.

The following directives are supported:

* `DIRECTORY` <path>:
  Create a directory called <path>, relative to the destination base directory.
  This is useful when certain programs expect a directory (even if empty) in a
  certain location to start correctly.

  When a module is reverted, <path> will only be deleted if empty.

* `SYMLINK` <source> <target> [<mode>]:
  Symlink <source>, which is a file relative to the module path, to <target>,
  which is a path relative to the destination base directory. You can
  optionally pass <mode>, an octal UNIX mode number to apply to <target>.

  When a module is reverted, <target> will be deleted.

## OPTIONS

* `-a` <action>:

  The action to take. Possible values are `apply` and `revert`. If this option
  is omitted, the action defaults to `apply`.

* `-c` <file>:

  Set a configuration file that specifies entries for the version of any
  dotfile to use in that particular system. The structure of a configuration
  file is <module> <file> <version>. For example: `email muttrc 1.9.1`, where
  the module name is `email`, the dotfile inside that module is `muttrc`, and
  the requested version is 1.9.1.

  If the `SYMLINK` directive encounters a file for which there is an entry on a
  configuration file, it will first try to find the correct <source> at
  `module/version/os/file` (where `os` is the lowercase version of `uname`),
  and then at `module/version/file`, aborting the action if the file was not
  found.

* `-d`:

  Dry run. Print the required file-system actions without executing them.
  Useful for debugging purposes.

* `-h`:

  Print basic help and quit.

* `-m` <directory>:

  Run the specified action on a particular module located at <directory>. If
  this option is omitted, the action will be applied to every module found in
  the namespace directory (`-n`). If this path is relative, it will be resolved
  from the namespace directory.

* `-n` <directory>:

  Set the directory containing all the available modules (the top level
  dotfiles directory). Defaults to the current working directory.

* `-o` <directory>:

  Set the destination base directory. This is the location where modules will
  be installed. Defaults to `$HOME`.

* `-v`:

  Print the version of the program and quit.

BUGS
----

This project aims to support GNU/Linux, macOS, and *BSD. Please report any
issues or suggestions at
[https://github.com/jviotti/dotf/issues](https://github.com/jviotti/dotf/issues).

AUTHOR
------

Written by Juan Cruz Viotti ([jv@jviotti.com](mailto:jv@jviotti.com),
[jviotti.com](jviotti.com)).

SEE ALSO
--------

stow(8)
