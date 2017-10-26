# time required for notification to be sent
NOTIFY_AFTER_SECONDS=5

function active-window-id {
    echo `xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}'`
}

# end and compare timer, notify-send if needed
function notify-completion-precmd() {
    if [ ! -z "$cmd" ]; then
        cmd_end=`date +%s`
        ((cmd_time=$cmd_end - $cmd_start))
    fi
    if [ ! -z "$cmd" -a $cmd_time -gt $NOTIFY_AFTER_SECONDS -a "$window_id_before" != "$(active-window-id)" ]; then
        notify-send -i utilities-terminal -u low "$cmd completed" "Running time: $cmd_time seconds"
        unset cmd
    fi
}

# make sure this plays nicely with any existing precmd
precmd_functions+=( notify-completion-precmd )

# get command name and start the timer
function notify-completion-preexec() {
    window_id_before=$(active-window-id)
    cmd=$1
    cmd_start=`date +%s`
}

# make sure this plays nicely with any existing preexec
preexec_functions+=( notify-completion-preexec )
