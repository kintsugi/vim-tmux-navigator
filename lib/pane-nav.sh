#!/usr/bin/env zsh

lib=$0:a:h
direction=$1
result=$(lib/at-edge.sh $direction)
if (test $result -eq 0) {
  tmux select-pane "-$direction"
} else {
:
}
