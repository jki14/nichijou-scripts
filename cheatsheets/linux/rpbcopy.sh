#! /bin/bash
# ssh-config: RemoteForward 3085 127.0.0.1:3084
# remote-cmd: echo 'Hello World' | nc 127.0.0.1 3085

if test -n "$SSH_TTY"; then
    # Remote Session
    # TODO
    # if test -f /proc/version && grep -q Ubuntu /proc/version; then
    #     PBCOPY='nc -q0 127.0.0.1 3085'
    # else
    #     PBCOPY='nc -w0 127.0.0.1 3085'
    # fi
    :
elif test -f /proc/version && grep -q Microsoft /proc/version; then
    # WSL
    PBCOPY=/mnt/c/WINDOWS/system32/clip.exe
elif test -f /proc/version && grep -q Ubuntu /proc/version; then
    # Mint/Ubuntu
    PBCOPY='xclip -sel clip'
else
    # OSX
    PBCOPY=/usr/bin/pbcopy
fi

RSTRIP='python3 -c "import sys; sys.stdout.write(sys.stdin.read().rstrip())"'

if test -f /proc/version && grep -q Ubuntu /proc/version; then
    # Mint/Ubuntu/WSL
    RPBCOPY="while (true); do nc -l -p 3084 | $RSTRIP | $PBCOPY; done"
else
    # OSX
    RPBCOPY="while (true); do nc -l 3084 | $RSTRIP | $PBCOPY; done"
fi

eval "$RPBCOPY &"
