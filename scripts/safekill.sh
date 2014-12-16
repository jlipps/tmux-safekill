#!/usr/bin/env bash
set -e

function safe_end_procs {
    old_ifs="$IFS"
    IFS=$'\n'
    panes=$(tmux list-panes -s -F "#{pane_id} #{pane_current_command}")
    for pane_set in $panes; do
        pane_id=$(echo "$pane_set" | awk -F " " '{print $1}')
        pane_proc=$(echo "$pane_set" | awk -F " " '{print tolower($2)}')
        cmd="C-c"
        if [[ "$pane_proc" == "vim" ]]; then
            cmd='":qa" Enter'
        elif [[ "$pane_proc" == "man" ]] || [[ "$pane_proc" == "less" ]]; then
            cmd='"q"'
        elif [[ "$pane_proc" == "bash" ]] || [[ "$pane_proc" == "zsh" ]]; then
            cmd='C-c "exit" Enter'
        elif [[ "$pane_proc" == "ssh" ]]; then
            cmd='Enter "~."'
        fi
        echo $cmd | xargs tmux send-keys -t "$pane_id"
    done
    IFS="$old_ifs"
}

safe_end_tries=0
while [ $safe_end_tries -lt 3 ]; do
    safe_end_procs
    safe_end_tries=$[$safe_end_tries+1]
    sleep 0.75
done
tmux send-message "Could not end all processes, you're on your own now!"
