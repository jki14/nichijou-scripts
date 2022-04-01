#! /bin/bash

stdbuf -o0 -e0 /usr/local/bin/ss-server -v -c /etc/shadowsocks/config.json >log/shadowsocks.log 2>&1 &
stdbuf -o0 -e0 /usr/local/bin/ss-server -v -c /etc/shadowsocks/config-alt.json >log/shadowsocks-alt.log 2>&1 &
# stdbuf -o0 -e0 /usr/local/bin/ss-local -v -c /etc/shadowsocks/client.json >log/ss-client.log 2>&1 &
