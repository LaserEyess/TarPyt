#!/usr/bin/env bash

port=10080
systemd-socket-activate -l $port ./tarpyt --protocol http --log-level DEBUG &
trap "kill -SIGINT $!" SIGINT

timeout -s SIGINT 20 curl -v "http://localhost:${port}"

if [[ $? -ne 124 ]]
then
    echo "FAILED"
    exit 1
fi