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

safe_end_tries=0
window_count=$(tmux list-windows | wc -l)
while [ $safe_end_tries -lt 5 ]; do
    if [ $1 == "w" ]; then
       panes=$(tmux list-panes -F "#{pane_id} #{pane_current_command}")
    else
       panes=$(tmux list-panes -s -F "#{pane_id} #{pane_current_command}")
    fi
    safe_end_procs "$panes"
    safe_end_tries=$[$safe_end_tries+1]
    sleep 0.8
    if [ $1 == "w" ] && [ $window_count -ne $(tmux list-windows | wc -l) ]; then
       exit 0
    fi
done
tmux send-message "Could not end all processes, you're on your own now!"
