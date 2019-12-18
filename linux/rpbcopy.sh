#! /bin/bash
# ssh-config: RemoteForward 3084 127.0.0.1:3084
# remote-cmd: nc -q0 127.0.0.1 3084
if [ -f /proc/version ]; then
    # Linux & WSL
    # while (true); do nc -l -p 3084 | pbcopy; done &
    # TODO
else
    while (true); do nc -l 3084 | pbcopy; done &
fi
