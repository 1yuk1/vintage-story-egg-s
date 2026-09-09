#!/bin/bash
cd /home/container

INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

export DOTNET_ROOT=/usr/share/dotnet

printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mdotnet --info\n"
dotnet --list-runtimes || true

MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP}
