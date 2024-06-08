#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y wget
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y par2
$STD apt-get install -y p7zip-full
cat <<EOF >/etc/apt/sources.list.d/non-free.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
EOF
$STD apt-get update
$STD apt-get install -y unrar
rm /etc/apt/sources.list.d/non-free.list
msg_ok "Installed Dependencies"

msg_info "Installing nzbget"
mkdir -p /opt/nzbget
cd /opt/nzbget
wget https://nzbget.net/download/nzbget-latest-bin-linux.run
chmod +x ./nzbget-latest-bin-linux.run
sh ./nzbget-latest-bin-linux.run
rm ./nzbget-latest-bin-linux.run
msg_ok "Installed nzbget"

msg_info "Creating Service"
service_path="/etc/systemd/system/nzbget.service"
echo "[Unit]
Description=nzbget
After=network.target
[Service]
WorkingDirectory=/opt/nzbget
ExecStart=./nzbget -s
Restart=always
User=root
[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable --now -q nzbget.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"