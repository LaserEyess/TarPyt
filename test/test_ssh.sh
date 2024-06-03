#!/usr/bin/env bash

port=10022
systemd-socket-activate -l $port $1 --protocol ssh --log-level DEBUG --log-to-stdout &
trap "kill -SIGTERM $!" SIGINT EXIT

timeout -s SIGINT 10 ssh -v 127.0.0.1 -p $port

if [[ $? -ne 124 ]]
then
    echo "FAILED"
    exit 1
fi