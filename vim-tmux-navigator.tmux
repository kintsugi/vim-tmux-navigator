#!/usr/bin/env zsh

# source $0:a:h/lib/at_tab_page_edge
# source $0:a:h/lib/tmux-aware-no-wrap-navigate

tmux set-environment -g at_tab_page_edge $0:a:h/lib/at_tab_page_edge
tmux set-environment -g tmux-aware-no-wrap-navigate $0:a:h/lib/tmux-aware-no-wrap-navigate

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"


tmux bind C-h if-shell "$is_vim" "send-keys C-h" "run '#{tmux-aware-no-wrap-navigate} L'"
tmux bind C-j if-shell "$is_vim" "send-keys C-j" "run '#{tmux-aware-no-wrap-navigate} D'"
tmux bind C-k if-shell "$is_vim" "send-keys C-k" "run '#{tmux-aware-no-wrap-navigate} U'"
tmux bind C-l if-shell "$is_vim" "send-keys C-l" "run '#{tmux-aware-no-wrap-navigate} R'"

tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"


tmux bind-key -T copy-mode-vi C-h "run '#{tmux-aware-no-wrap-navigate} L'"
tmux bind-key -T copy-mode-vi C-j "run '#{tmux-aware-no-wrap-navigate} D'"
tmux bind-key -T copy-mode-vi C-k "run '#{tmux-aware-no-wrap-navigate} U'"
tmux bind-key -T copy-mode-vi C-l "run '#{tmux-aware-no-wrap-navigate} R'"
tmux bind-key -T copy-mode-vi C-\
