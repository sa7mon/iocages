```bash
echo '{"pkgs":["plexmediaserver","ca_root_nss"]}' > /tmp/pkg.json

iocage create --release 11.1-RELEASE --name io-plex --pkglist /tmp/pkg.json boot="off" allow_raw_sockets="1" ip4_addr="igb0|10.0.1.155/24" resolver="nameserver 10.0.1.120;nameserver 1.1.1.1"

iocage exec io-plex mkdir -p /mnt/config
iocage exec io-plex mkdir -p /mnt/orange/video/tvshows
iocage exec io-plex mkdir -p /mnt/orange/video/movies
iocage fstab -a io-plex /mnt/vol1/jail-configs/plex/ /mnt/config nullfs rw 0 0
iocage fstab -a io-plex /mnt/orange/video/tvshows /mnt/orange/video/tvshows nullfs ro 0 0
iocage fstab -a io-plex /mnt/orange/video/movies /mnt/orange/video/movies nullfs ro 0 0
iocage exec io-plex chown -R plex:plex /mnt/config
iocage exec io-plex sysrc "plexmediaserver_enable=YES"
iocage exec io-plex sysrc plexmediaserver_support_path="/mnt/config"
iocage exec io-plex service plexmediaserver start
```
