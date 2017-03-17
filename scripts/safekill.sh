#!/usr/bin/env bash
set -e

function safe_end_procs {
  old_ifs="$IFS"
  IFS=$'\n'
  for pane_set in $1; do
    pane_id=$(echo "$pane_set" | awk -F " " '{print $1}')
    pane_proc=$(echo "$pane_set" | awk -F " " '{print tolower($2)}')
    cmd="C-c"
    if [[ "$pane_proc" == "vim" ]] || [[ "$pane_proc" == "nvim" ]]; then
      cmd='":qa" Enter'
    elif [[ "$pane_proc" == "man" ]] || [[ "$pane_proc" == "less" ]]; then
      cmd='"q"'
    elif [[ "$pane_proc" == "bash" ]] || [[ "$pane_proc" == "zsh" ]] || [[ "$pane_proc" == "fish" ]]; then
      cmd='C-c C-u space "exit" Enter'
    elif [[ "$pane_proc" == "ssh" ]] || [[ "$pane_proc" == "vagrant" ]]; then
      cmd='Enter "~."'
    elif [[ "$pane_proc" == "psql" ]]; then
      cmd='Enter "\q"'
    fi
    echo $cmd | xargs tmux send-keys -t "$pane_id"
  done
  IFS="$old_ifs"
}

function safe_kill_panes_of_current_session {
  session_name=$(tmux display-message -p '#S')
  current_panes=$(tmux list-panes -a -F "#{pane_id} #{pane_current_command} #{session_name}\n" | grep "$session_name")

  SAVEIFS="$IFS"
  IFS=$'\n'
  array=($current_panes)
  # Restore IFS
  IFS=$SAVEIFS
  for (( i=0; i<${#array[@]}; i++ ))
  do
    safe_end_procs "${array[$i]}"
    sleep 0.8
  done
}

safe_kill_panes_of_current_session
safe_kill_panes_of_current_session
exit 0
