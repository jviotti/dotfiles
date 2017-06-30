dotfiles
========

> My personal dotfiles

Supported Platforms
-------------------

- macOS
- GNU/Linux

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
- reattach-to-user-namespace (macOS)

### macOS

```sh
brew install git gnupg macvim gpp python reattach-to-user-namespace
```

### Ubuntu

```sh
sudo apt-get install git make zsh gnupg vim gpp python
```

Tools
-----

### macOS

```sh
brew install ack mutt tmux w3m todo-txt pass ispell urlview offlineimap openssl
```

### Ubuntu

```sh
sudo apt-get install ack-grep mutt tmux w3m todotxt-cli pass ispell urlview offlineimap
```

Documentation
-------------

```sh
git clone git@github.com:jviotti/dotfiles.git
cd dotfiles
```

### Show help

```sh
make help
```

### Install all modules

```sh
make install-all
```

### Install a single module

```sh
make install-<module>
```

### Uninstall all modules

```sh
make uninstall-all
```

### Uninstall a single module

```sh
make uninstall-<module>
```

### Rebuild a module

```sh
make build-<module>
```

### Install system changes (experimental)

```sh
sudo make system
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
