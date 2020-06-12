#!/usr/bin/env zsh
direction=$1
keys=$2

prompt_action() {
  tmux set -u -w @smart_edge_dir
  tmux set -u -w @smart_edge_keys
  tmux set -u -w @smart_edge_selection
  tmux command-prompt -k -p "Press Enter to 'send-keys $keys' or any other key to 'select-pane $direction' [Enter/*]: " "set -w @smart_edge_dir '$direction'; set -w @smart_edge_keys '$keys'; set -w @smart_edge_selection '%1'; run '#{smart_edge}'"
}

detect_smart_edge() {
  at_edge=$(tmux run "#{navigator} at-edge $direction")
  if (test $at_edge -eq 1) {
    tmux send-keys $keys
  } else {
    prompt_action
  }
}

run_action() {
  direction=$(tmux run 'echo #{@smart_edge_dir}')
  keys=$(tmux run 'echo #{@smart_edge_keys}')
  selection=$(tmux run 'echo #{@smart_edge_selection}')
  if (test "$selection" = "Enter") {
    tmux send-keys "$keys"
  } else {
    tmux run "#{navigator} select-pane $direction"
  }
  tmux set -u -w @smart_edge_dir
  tmux set -u -w @smart_edge_keys
  tmux set -u -w @smart_edge_selection
}

if (test -z $direction && test -z $keys) {
  run_action
} else {
  detect_smart_edge
}

