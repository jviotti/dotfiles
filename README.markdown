dotfiles
========

> My personal dotfiles

Supported Platforms
-------------------

- macOS
- GNU/Linux
- OpenBSD

Pre-requisites
--------------

- git
- make
- zsh
- gpg
- vim
- gpp
- python
- pass
- duplicity
- reattach-to-user-namespace (macOS)

### macOS

```sh
brew install git gnupg macvim gpp python pass duplicity reattach-to-user-namespace
```

### Ubuntu

```sh
sudo apt-get install git make zsh gnupg vim gpp python pass duplicity
```

Tools
-----

### macOS

```sh
brew install ack mutt tmux w3m todo-txt ispell urlview isync openssl msmtp gh
```

### Ubuntu

```sh
sudo apt-get install ack-grep mutt tmux w3m todotxt-cli ispell urlview isync msmtp
```

Configuration
-------------

### `$PATH`

Add machine dependent custom paths to a file called `$HOME/.paths`. For
example:

```sh
/opt/depot_tools
/opt/gnat/bin
```

### `$CDPATH`

Add machine dependent custom paths to append to `$CDPATH` in a file called
`$HOME/.hotdirs`. For example:

```sh
/home/jviotti/projects
```

### Private environment variables

Add zsh scripts exporting private environment variables to `$HOME/.private`.
The directory can contain multiple files, and all of them will get imported
when zsh starts.
