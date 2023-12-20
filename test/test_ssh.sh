#!/usr/bin/env bash

port=10022
systemd-socket-activate -l $port ./tarpyt --protocol ssh --log-level DEBUG --log-to-stdout &
trap "kill -SIGTERM $!" SIGINT EXIT

timeout -s SIGINT 20 ssh -v localhost -p $port

if [[ $? -ne 124 ]]
then
    echo "FAILED"
    exit 1
fi