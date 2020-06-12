#!/usr/bin/env zsh

navigator=${0:a:h}/vim-tmux-navigator.sh
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

tmux set-environment -g navigator $navigator
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

tmux bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "run '#{navigator} select-pane L'"
tmux bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "run '#{navigator} select-pane D'"
tmux bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "run '#{navigator} select-pane U'"
tmux bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "run '#{navigator} select-pane R'"

tmux bind-key -T copy-mode-vi C-h "run '#{navigator} select-pane L'"
tmux bind-key -T copy-mode-vi C-j "run '#{navigator} select-pane D'"
tmux bind-key -T copy-mode-vi C-k "run '#{navigator} select-pane U'"
tmux bind-key -T copy-mode-vi C-l "run '#{navigator} select-pane R'"
tmux bind-key -T copy-mode-vi C-\\ select-pane -l
