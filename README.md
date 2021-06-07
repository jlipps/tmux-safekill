tmux-safekill
=============

A tmux plugin that attempts to safely kill processes before exiting a tmux session. Works with [TPM](https://github.com/tmux-plugins/tpm)

### Usage

In tmux, use the command:

```
<prefix> C
```

The plugin will attempt to recursively end processes it knows about (right now: vim, man, less, bash, zsh, and ssh). It defaults to `Ctrl-C` for processes it doesn't know about. Ultimately, the session should have exited on its own after all child processes are gone.

It is also possible to close only the panes in the current window:

```
<prefix> Q
```

Warning: this is kind of a big hammer. If you have any sensitive processes, make sure they are dealt with before running this :-)

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin "jlipps/tmux-safekill"

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

### Configuration

Support the following environment variables which could influence how it proceeds in quiting the processes.

Set it up by creating a new file `~/.bashrc_tmux_safekill` then add the following line per setting you desire to have (you don't have to manually source it,
it will be automatically picked up internally).

```
export <CONFIG-NAME>=<VALUE>
```

wheres you substitue `<CONFIG-NAME>`, and `<VALUE>` according to the following

* `TMUX_SAFEKILL_FORCE` - `1` to attempt quiting processes which support force quit, `0` or other values to just normally quit

### License

[Apache 2](LICENSE)
