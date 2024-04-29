#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SAVE_SCRIPT="$CURRENT_DIR/save.sh"
RESTORE_SCRIPT="$CURRENT_DIR/restore.sh"


prepend_to_hook() {
  local hook_name="@resurrect-hook-$1"
  local script="$2"

  local hook=$(tmux show-option -gqv "$hook_name")

  if [[ $hook == *"$script"* ]]; then
    return
  fi

  if [ -z "$hook" ]; then
    hook="$script"
  else
    hook="$script; $hook"
  fi

  tmux set-hook -g "$hook_name" "$hook"
}

prepend_to_hook "post-save-all" "$SAVE_SCRIPT"
prepend_to_hook "post-restore-all" "$RESTORE_SCRIPT"
