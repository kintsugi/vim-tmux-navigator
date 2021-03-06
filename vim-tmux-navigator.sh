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

select-pane() {
  direction=$1
  result=$(at-edge $direction)
  if (test $result -eq 0) {
    tmux select-pane "-$direction"
  } else {
  :
  }
}

command=$1
direction=$2

$1 $2
