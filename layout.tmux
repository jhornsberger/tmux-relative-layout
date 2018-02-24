#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Defaults
default_main_pane_height_percent="66"
default_main_pane_width_percent="66"
default_alt_pane_height_min="20"
default_alt_pane_width_min="80"
default_main_horz_layout_key="M-3"
default_alt_main_horz_layout_key="M-#"
default_main_vert_layout_key="M-4"
default_alt_main_vert_layout_key="M-$"
default_main_horz_tiled_layout_key="M-6"
default_main_vert_tiled_layout_key="M-7"

# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z $option_value ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

setup_main_horz_key_binding() {
	local key="$(get_tmux_option "@main_horz_layout_key" "$default_main_horz_layout_key")"
	local alt_key="$(get_tmux_option "@alt_main_horz_layout_key" "$default_alt_main_horz_layout_key")"
	local main_pane_height_percent=$(get_tmux_option "@main_pane_height_percent" "$default_main_pane_height_percent")
	tmux bind-key "$key" run-shell "$CURRENT_DIR/layout.tmux main_horizontal_layout $main_pane_height_percent"
	tmux bind-key "$alt_key" command-prompt -I $main_pane_height_percent -p "Main pane height:" "run-shell \"$CURRENT_DIR/layout.tmux main_horizontal_layout '%%'\""
}

main_horizontal_layout() {
	if [ -z $1 ]; then
		return
	fi
	local main_pane_height_percent=$1
	local alt_pane_height_min=$(get_tmux_option "@alt_pane_height_min" "$default_alt_pane_height_min")
	local window_height=$(tmux display-message -p "#{window_height}")
	local main_pane_height=$(expr $window_height \* $main_pane_height_percent / 100)
	local max_main_pane_height=$(expr $window_height - $alt_pane_height_min)
	main_pane_height=$(($main_pane_height > $max_main_pane_height ? $max_main_pane_height : $main_pane_height))
	tmux set-window-option -g main-pane-height $main_pane_height
	tmux select-layout main-horizontal
}

setup_main_vert_key_binding() {
	local key="$(get_tmux_option "@main_vert_layout_key" "$default_main_vert_layout_key")"
	local alt_key="$(get_tmux_option "@alt_main_vert_layout_key" "$default_alt_main_vert_layout_key")"
	local main_pane_width_percent=$(get_tmux_option "@main_pane_width_percent" "$default_main_pane_width_percent")
	tmux bind-key "$key" run-shell "$CURRENT_DIR/layout.tmux main_vertical_layout $main_pane_width_percent"
	tmux bind-key "$alt_key" command-prompt -I $main_pane_width_percent -p "Main pane width:" "run-shell \"$CURRENT_DIR/layout.tmux main_vertical_layout '%%'\""
}

main_vertical_layout() {
	if [ -z $1 ]; then
		return
	fi
	local main_pane_width_percent=$1
	local alt_pane_width_min=$(get_tmux_option "@alt_pane_width_min" "$default_alt_pane_width_min")
	local window_width=$(tmux display-message -p "#{window_width}")
	local main_pane_width=$(expr $window_width \* $main_pane_width_percent / 100)
	local max_main_pane_width=$(expr $window_width - $alt_pane_width_min)
	main_pane_width=$(($main_pane_width > $max_main_pane_width ? $max_main_pane_width : $main_pane_width))
	tmux set-window-option -g main-pane-width $main_pane_width
	tmux select-layout main-vertical
}

setup_main_horz_tiled_key_binding() {
	local key="$(get_tmux_option "@main_horz_tiled_layout_key" "$default_main_horz_tiled_layout_key")"
	tmux bind-key "$key" run-shell "$CURRENT_DIR/layout.tmux main_horizontal_tiled_layout"
}

main_horizontal_tiled_layout() {
	local main_pane_height_percent=$(get_tmux_option "@main_pane_height_percent" "$default_main_pane_height_percent")
	main_pane_height_percent=$((100 - $main_pane_height_percent))
	local alt_pane_height_min=$(get_tmux_option "@alt_pane_height_min" "$default_alt_pane_height_min")
	local window_width=$(tmux display-message -p "#{window_width}")
	local window_height=$(tmux display-message -p "#{window_height}")
	local main_pane_height=$(expr $window_height \* $main_pane_height_percent / 100)
	main_pane_height=$(($main_pane_height < $alt_pane_height_min ? $alt_pane_height_min : $main_pane_height))
	tmux set-window-option -g main-pane-height $main_pane_height
	local window_panes=$(tmux display-message -p "#{window_panes}")
	local pane_index=$(tmux display-message -p "#{pane_index}")
	local alt_pane_width=$(expr $window_width / $(( $window_panes / 2 )) )
	tmux select-layout main-horizontal
	for i in `seq 2 2 $window_panes`
	do
		tmux move-pane -t $((i - 1)) -s $i -v
	done
	for i in `seq 1 2 $window_panes`
	do
		tmux resize-pane -t $i -x $alt_pane_width
	done
	tmux select-pane -t $pane_index
}

setup_main_vert_tiled_key_binding() {
	local key="$(get_tmux_option "@main_vert_tiled_layout_key" "$default_main_vert_tiled_layout_key")"
	tmux bind-key "$key" run-shell "$CURRENT_DIR/layout.tmux main_vertical_tiled_layout"
}

main_vertical_tiled_layout() {
	local main_pane_width_percent=$(get_tmux_option "@main_pane_width_percent" "$default_main_pane_width_percent")
	main_pane_width_percent=$((100 - $main_pane_width_percent))
	local alt_pane_width_min=$(get_tmux_option "@alt_pane_width_min" "$default_alt_pane_width_min")
	local window_width=$(tmux display-message -p "#{window_width}")
	local window_height=$(tmux display-message -p "#{window_height}")
	local main_pane_width=$(expr $window_width \* $main_pane_width_percent / 100)
	main_pane_width=$(($main_pane_width < $alt_pane_width_min ? $alt_pane_width_min : $main_pane_width))
	tmux set-window-option -g main-pane-width $main_pane_width
	local window_panes=$(tmux display-message -p "#{window_panes}")
	local pane_index=$(tmux display-message -p "#{pane_index}")
   local alt_pane_height=$(expr $window_height / $(( $window_panes / 2 )) )
	tmux select-layout main-vertical
	for i in `seq 2 2 $window_panes`
	do
		tmux move-pane -t $((i - 1)) -s $i -h
	done
	for i in `seq 1 2 $window_panes`
	do
		tmux resize-pane -t $i -y $alt_pane_height
	done
	tmux select-pane -t $pane_index
}

if [ -z $@ ]; then
	# With no arguments just setup bindings
	setup_main_horz_key_binding
	setup_main_vert_key_binding
	setup_main_horz_tiled_key_binding
	setup_main_vert_tiled_key_binding
else
   # Run requested action and ignore output
   $@ >> /dev/null
fi
