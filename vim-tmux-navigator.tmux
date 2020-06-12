#!/usr/bin/env zsh

lib=${0:a:h}/lib

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

tmux set-environment -g at_edge $lib/at-edge.sh
tmux set-environment -g pane-nav $lib/pane-nav.sh

# bind C-h if-shell "$is_vim" "send-keys C-h" "run-shell '$lib/pane-nav.sh L'"
# bind C-j if-shell "$is_vim" "send-keys C-j" "run-shell '$lib/pane-nav.sh D'"
# bind C-k if-shell "$is_vim" "send-keys C-k" "run-shell '$lib/pane-nav.sh U'"
# bind C-l if-shell "$is_vim" "send-keys C-l" "run-shell '$lib/pane-nav.sh R'"
tmux bind C-h if-shell "$is_vim" "send-keys C-h" "run '#{pane-nav} L'"
tmux bind C-h if-shell "$is_vim" "send-keys C-j" "run '#{pane-nav} D'"
tmux bind C-h if-shell "$is_vim" "send-keys C-k" "run '#{pane-nav} U'"
tmux bind C-h if-shell "$is_vim" "send-keys C-l" "run '#{pane-nav} R'"

