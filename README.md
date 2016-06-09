# Tmux Layouts

Tmux plugin for better control of existing tmux layouts and adds a couple of new layouts.

Tested and working on Linux.

### Layouts

*TODO*

### Configuration

*TODO*

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'jhornsberger/tmux-layout'

Hit `prefix + I` to fetch the plugin and source it.

You should now have all `tmux-layout` bindings defined.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/jhornsberger/tmux-layout ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/layout.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now have all `tmux-layout` bindings defined.

### License
[MIT](LICENSE.md)
