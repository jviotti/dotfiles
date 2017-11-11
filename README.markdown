dotfiles
========

> My personal dotfiles

Supported Platforms
-------------------

- macOS
- GNU/Linux

Pre-requisites
--------------

- [dotf](https://github.com/jviotti/dotf)
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

```sh
git clone https://github.com/jviotti/dotf
cd dotf
make install
```

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
brew install ack mutt tmux w3m todo-txt ispell urlview offlineimap openssl msmtp
```

### Ubuntu

```sh
sudo apt-get install ack-grep mutt tmux w3m todotxt-cli ispell urlview offlineimap msmtp
```

Configuration
-------------

### `$PATH`

Add machine independent custom paths to a file called `$HOME/.paths`. For
example:

```sh
/opt/depot_tools
/opt/gnat/bin
```

### Private environment variables

Add zsh scripts exporting private environment variables to `$HOME/.private`.
The directory can contain multiple files, and all of them will get imported
when zsh starts.
