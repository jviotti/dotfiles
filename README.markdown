dotfiles
========

> My personal dotfiles

Pre-requisites
--------------

### Ubuntu

```sh
sudo apt-get install git make zsh gnupg vim gpp python pass duplicity
```

Tools
-----

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

### Private environment variables

Add zsh scripts exporting private environment variables to `$HOME/.private`.
The directory can contain multiple files, and all of them will get imported
when zsh starts.
