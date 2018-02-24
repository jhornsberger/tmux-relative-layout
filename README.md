# Tmux Relative Layouts

Tmux plugin that defines layouts relative to window size. This makes it much quicker to get back to work after a window is resized (switch from laptop to monitor, reconnect from different terminal, etc).

Tested and working on Linux. Let me know if you try it elsewhere!

### Layouts
The plugin redefines some of the stock layouts described in the [Tmux man page](http://man.openbsd.org/OpenBSD-current/man1/tmux.1) and then adds a couple more based on the originals. For convenience all of the Tmux layouts are described below.

#### even-horizontal
Panes are spread out evenly from left to right across the window. The plugin does not modify this layout.

*Default binding:* `M-1`

#### even-vertical
Panes are spread evenly from top to bottom. The plugin does not modify this layout.

*Default binding:* `M-2`

#### main-horizontal
A large (main) pane is shown at the top of the window and the remaining panes are spread from left to right in the leftover space at the bottom. Use the `@main_pane_height_percent` Tmux option to specify the proportional height of the top pane and the `@alt_pane_height_min` Tmux option to specify the absolute minimum height of the lower panes. Use the alternate key binding to select to be prompted for the main pane height.

*Default binding:* `M-3`
*Default alternate binding:* `M-#`

#### main-vertical
Similar to main-horizontal but the large pane is placed on the left and the others spread from top to bottom along the right. Use the `@main_pane_width_percent` Tmux option to specify the proportional width of the left pane and the `@alt_pane_width_min` Tmux option to specify the absolute minimum width of the right panes. Use the alternate key binding to select to be prompted for the main pane width.

*Default binding:* `M-4`
*Default alternate binding:* `M-$`

#### tiled
Panes are spread out as evenly as possible over the window in both rows and columns.

*Default binding:* `M-5`

#### main-horizontal-tiled
Like main-horizontal, a single pane is shown at the top of the window. Remaining panes are tiled in two columns in the space at the bottom. The `@main_pane_height_percent` Tmux option specifies the proportional height of the tiled area. The `@alt_pane_height_min` Tmux option to specifies the absolute minimum height of the top pane.

*Default binding:* `M-6`

#### main-vertical-tiled
Like main-vertical, a single pane is shown at the left of the window. Remaining panes are tiled in two columns in the space at the right. The `@main_pane_width_percent` Tmux option specifies the proportional width of the tiled area. The `@alt_pane_width_min` Tmux option to specifies the absolute minimum width of the left pane.

*Default binding:* `M-7`

### Configuration

The plugin supports a number of configuration options to control behaviour. Available options and default values are given below. Options are set in your Tmux configuration file using `set-option -g @option 'value'`

```
main_pane_height_percent="66"
main_pane_width_percent="66"
alt_pane_height_min="20"
alt_pane_width_min="80"
main_horz_layout_key="M-3"
main_vert_layout_key="M-4"
main_horz_tile_layout_key="M-6"
main_vert_tile_layout_key="M-7"
```

### Installation
#### [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)
Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'jhornsberger/tmux-relative-layout'

Hit `prefix + I` to fetch the plugin and source it.

You should now have all `tmux-relative-layout` bindings defined.

#### Manual
Clone the repo:

    $ git clone https://github.com/jhornsberger/tmux-relative-layout ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/layout.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now have all `tmux-relative-layout` bindings defined.

### License
[MIT](LICENSE.md)
