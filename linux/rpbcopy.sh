#! /bin/bash
# ssh-config: RemoteForward 3084 127.0.0.1:3084
# remote-cmd: echo 'Hello World' | nc -q0 127.0.0.1 3084

PIDFILE=~/var/run/rpbcopy.pid
LOGFILE=~/var/log/rpbcopy.log

if test -f /proc/version && grep -q Microsoft /proc/version; then
    # WSL
    PBCOPY=/mnt/c/WINDOWS/system32/clip.exe
    COMMAND="while (true); do nc -l -p 3084 | $PBCOPY; done"
elif test -f /proc/version; then
    # Linux
    COMMAND="TODO"
else
    # OSX
    PBCOPY=/usr/bin/pbcopy
    COMMAND="while (true); do nc -l 3084 | $PBCOPY; done"
fi

eval "$COMMAND &"
