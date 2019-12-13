#!/bin/bash

line() {
    echo -e "\e[01m${1}\e[00m"
}

line ":: Starting containers"
docker-compose up -d

echo -ne "\e[01m:: Waiting for splunk to start up..."
while ! curl -I http://localhost:8000/en-GB/account/login 2>/dev/null | grep -q "200 OK"; do
    echo -n "."
    sleep 1
done
echo -e "ready\e[00m"

line ":: Generating sample logs"

for i in $(seq 1 20); do
    if [ $i -lt 11 ]; then
        curl -qsSL http://localhost:8080 > /dev/null
    else
        curl -qsSL http://localhost:8080/notfound > /dev/null
    fi
done

cat <<EOF
Splunk started successfully! 

    Host:     http://localhost:8000
    Username: admin
    Password: supersecret

To generate more logs, go to http://localhost:8080
EOF
