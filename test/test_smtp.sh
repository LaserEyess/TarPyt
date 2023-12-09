#!/usr/bin/env bash

port=10026
systemd-socket-activate -l $port ./tarpyt --protocol smtp --log-level DEBUG &
trap "kill -SIGINT $!" SIGINT EXIT

timeout -s SIGINT 20 python -c \
    "import smtplib; s = smtplib.SMTP(); s.set_debuglevel(1); s.connect(port=$port)"

if [[ $? -ne 124 ]]
then
    echo "FAILED"
    exit 1
fi