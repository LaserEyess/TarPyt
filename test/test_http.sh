#!/usr/bin/env bash

port=10080
systemd-socket-activate -l $port $1 --protocol http --log-level DEBUG --log-to-stdout &
trap "kill -SIGTERM $!" SIGINT EXIT

timeout -s SIGINT 10 curl -v "http://127.0.0.1:${port}"

if [[ $? -ne 124 ]]
then
    echo "FAILED"
    exit 1
fi