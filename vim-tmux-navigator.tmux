#!/usr/bin/env zsh

__dirname=$0:a:h
navigator=$__dirname/vim-tmux-navigator.sh
smart_edge=$__dirname/smart-edge.sh

disable_bindings=$(tmux run 'echo #{@navigator_disable_bindings}')

tmux set-environment -g navigator $navigator
tmux set-environment -g smart_edge $smart_edge

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

if (test -z "$disable_bindings") {
  tmux bind-key -n 'c-h' if-shell "$is_vim" "send-keys C-h" "run '#{navigator} select-pane L'"
  tmux bind-key -n 'c-j' if-shell "$is_vim" "send-keys C-j" "run '#{navigator} select-pane D'"
  tmux bind-key -n 'c-k' if-shell "$is_vim" "send-keys C-k" "run '#{navigator} select-pane U'"
  tmux bind-key -n 'c-l' if-shell "$is_vim" "send-keys C-l" "run '#{navigator} select-pane R'"
  tmux bind-key -T copy-mode-vi 'c-h' "run '#{navigator} select-pane L'"
  tmux bind-key -T copy-mode-vi 'c-j' "run '#{navigator} select-pane D'"
  tmux bind-key -T copy-mode-vi 'c-k' "run '#{navigator} select-pane U'"
  tmux bind-key -T copy-mode-vi 'c-l' "run '#{navigator} select-pane R'"
  tmux bind-key -T copy-mode-vi 'c-\\' select-pane -l
}
