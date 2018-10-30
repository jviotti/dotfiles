dotf
====

> Module-based dotfiles manager

Group your dotfiles as module directories, write manifests that describe the
mappings, run `dotf`, and done!

```sh
$ ls path/to/dotfiles/modules/email
MANIFEST        mailcap         muttrc          offlineimaprc
Makefile        msmtprc         offlineimap.py  signature

$ cat path/to/dotfiles/modules/email/MANIFEST
DIRECTORY .mutt/cache
DIRECTORY Mail
SYMLINK mailcap .mailcap
SYMLINK msmtprc .msmtprc 600
SYMLINK offlineimaprc .offlineimaprc
SYMLINK offlineimap.py .offlineimap.py
SYMLINK muttrc .mutt/muttrc
SYMLINK signature .mutt/signature
```

***

```sh
dotf -m path/to/dotfiles/modules/email
```

See https://github.com/jviotti/dotfiles for an example.

Features
--------

- Keep multiple instances of a dotfile for different versions and operating
  systems
- Group related dotfiles, even when they are used by different programs
- Undo dotfiles installations
- Assign UNIX modes automatically
- Apply the same dotfiles tree to different base directories

Installation
------------

dotf aims for POSIX shell compliance, so it should run in most systems out of
the box. It also requires the following programs:

- `cut`
- `dirname`
- `basename`
- `tr`
- `true`
- `grep`
- `getopts`

Which should be present by default in virtually all UNIX systems.

Clone the repository and run the `dotf.sh` script:

```sh
git clone https://github.com/jviotti/dotf.git
cd dotf
make install PREFIX=/usr/local
```

Documentation
-------------

The `man` page is the source of truth. Go to http://jviotti.com/dotf/ for an
online version.

Machine Configuration
---------------------

I constantly switch between macOS and various GNU/Linux distributions, that
have `tmux` 1.8 and 2.4 respectively. With `dotf`, I can create a `tmux` module
that has various versions of `tmux.conf`:

```
tmux/1.8/darwin/tmux.conf
tmux/1.8/linux/tmux.conf
tmux/2.4/darwin/tmux.conf
tmux/2.4/linux/tmux.conf
```

I can then add the following command in `MANIFEST`:

```
SYMLINK tmux.conf .tmux.conf
```

And create configuration files for each of my machines, specifying what is the
required `tmux.conf` version:

```
$ cat MACOS_CONFIG
tmux tmux.conf 2.4
```

Finally, `dotf` gets me the right version of `tmux.conf` everywhere:

```
dotf -m tmux -c MACOS_CONFIG
```

Contribute
----------

The following dependencies are required to develop dotf:

- [`ronn`](https://github.com/rtomayko/ronn)
- [`shellcheck`](https://github.com/koalaman/shellcheck)

On macOS:

```sh
gem install ronn
brew install shellcheck
```

On Ubuntu:

```sh
sudo apt-get install ruby-ronn shellcheck
```

Please make sure you run the linter (`make lint`) and re-generate the
documentation (`make doc`), if relevant, before submitting a patch.

Support
-------

Don't hesitate in reporting any bugs, incompatibilities, or suggestions!

- Repository: https://github.com/jviotti/dotf
- Issue tracker: https://github.com/jviotti/dotf/issues

License
-------

dotf is free software, and may be redistributed under the terms specified in
the [3-clause BSD license][license].

[license]: https://github.com/jviotti/dotf/blob/master/LICENSE
