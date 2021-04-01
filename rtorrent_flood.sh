#!/bin/sh

## Variables

USERNAME="dan"

## End variables

# Create non-root user
echo "$USERNAME:::::::::" | adduser -f -

# Update pkg and install packages
env ASSUME_ALWAYS_YES=yes pkg update -f
yes "y" | pkg install tmux node npm rtorrent

# Switch to our non-root user and pull down the config template that comes with rTorrent, enabling RPC socket file
su $USERNAME
curl -Ls "https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md" \
    | sed -ne "/^######/,/^### END/p" \
    | sed -e 's/#network.scgi.open_local/network.scgi.open_local/' \
    | sed -re "s:/home/USERNAME:$HOME:" > ~/.rtorrent.rc
mkdir -p ~/rtorrent/

# Pull down the startup shell script that will launch rtorrent and flood in a detached tmux session
curl -Ls "https://raw.githubusercontent.com/sa7mon/iocages/master/rtorrent_flood_startup.sh" > ~/startup.sh
chmod +x ~/startup.sh

# Set startup script to run on boot
echo "@reboot /home/$USERNAME/startup.sh" | crontab -
