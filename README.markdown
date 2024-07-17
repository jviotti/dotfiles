dotfiles
========

> My personal dotfiles

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

### Cursor blinking

Disable cursor blinking on macOS as follows:

```sh
defaults write -g NSTextInsertionPointBlinkPeriodOff -float 0
defaults write -g NSTextInsertionPointBlinkPeriodOn -float 4000000000
```
