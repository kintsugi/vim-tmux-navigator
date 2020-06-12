#!/usr/bin/env zsh
at-edge() {
  direction=$1
  coord=''
  op=''

  case $direction in
    U)
      coord='top'
      op='<='
      ;;
    D)
      coord='bottom'
      op='>='
      ;;
    L)
      coord='left'
      op='<='
      ;;
    R)
      coord='right'
      op='>='
      ;;
    *)
      >&2 echo 'direction must be one of UDLR'
      return 1
  esac

  tmux_cmd="#{pane_id}:#{pane_$coord}:#{?pane_active,_active_,_no_}"
  panes=$(tmux list-panes -F "$tmux_cmd")
  active_pane=$(echo "$panes" | grep _active_)
  active_pane_id=$(echo "$active_pane" | cut -d: -f1)
  active_coord=$(echo "$active_pane" | cut -d: -f2)
  coords=$(echo "$panes" | cut -d: -f2)

  if (test "$op" = ">=") {
    test_coord=$(echo "$coords" | sort -nr | head -n1)
    at_edge=$(( active_coord >= test_coord ? 1 : 0 ))
  } else {
    test_coord=$(echo "$coords" | sort -n | head -n1)
    at_edge=$(( active_coord <= test_coord ? 1 : 0 ))
  }

  echo $at_edge
}

pane-nav() {
  direction=$1
  result=$(at-edge $direction)
  if (test $result -eq 0) {
    tmux select-pane "-$direction"
  } else {
  :
  }
}


tmux set-environment -g at_edge at-edge
tmux set-environment -g pane_nav pane-nav

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"


# bind C-h if-shell "$is_vim" "send-keys C-h" "run-shell '$lib/pane-nav.sh L'"
# bind C-j if-shell "$is_vim" "send-keys C-j" "run-shell '$lib/pane-nav.sh D'"
# bind C-k if-shell "$is_vim" "send-keys C-k" "run-shell '$lib/pane-nav.sh U'"
# bind C-l if-shell "$is_vim" "send-keys C-l" "run-shell '$lib/pane-nav.sh R'"
tmux bind C-h if-shell "$is_vim" "send-keys C-h" "run '#{pane_nav} L'"
tmux bind C-h if-shell "$is_vim" "send-keys C-j" "run '#{pane_nav} D'"
tmux bind C-h if-shell "$is_vim" "send-keys C-k" "run '#{pane_nav} U'"
tmux bind C-h if-shell "$is_vim" "send-keys C-l" "run '#{pane_nav} R'"
