tmux-safekill
=============

A tmux plugin that attempts to safely kill processes before exiting a tmux session. Works with [TPM](https://github.com/tmux-plugins/tpm)

### Usage

In tmux, use the command:

```
<prefix> C
```

The plugin will attempt to recursively end processes it knows about (right now: vim, man, less, bash, zsh, and ssh). It defaults to `Ctrl-C` for processes it doesn't know about. Ultimately, the session should have exited on its own after all child processes are gone.

Warning: this is kind of a big hammer. If you have any sensitive processes, make sure they are dealt with before running this :-)

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "             \
      tmux-plugins/tpm                \
      jlipps/tmux-safekill            \
    "

Hit `prefix + I` to fetch the plugin and source it.

The key binding should now be available

### Manual Installation

Clone the repo:

    $ git clone https://github.com/jlipps/tmux-safekill ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/safekill.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

### License

[Apache 2](LICENSE)
