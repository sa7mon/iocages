#!/bin/sh

tmux new -s rtorrent_flood -d
tmux rename-window -t rtorrent_flood rtorrent
tmux send-keys -t rtorrent_flood 'rtorrent' C-m

tmux new-window -t rtorrent_flood
tmux rename-window -t rtorrent_flood flood
tmux send-keys -t rtorrent_flood 'npx flood' C-m
