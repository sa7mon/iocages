echo '{"pkgs":["python27","ca_root_nss"]}' > /tmp/pkg.json

iocage create --release 11.2-RELEASE --name sync boot="off" --pkglist /tmp/pkg.json allow_raw_sockets="1" ip4_addr="igb0|10.0.1.161/24" resolver="nameserver 10.0.1.120;nameserver 1.1.1.1"

iocage exec sync mkdir -p /mnt/config
iocage exec sync mkdir -p /mnt/syncdata

iocage fstab -a sync /mnt/vol1/jail-configs/rslsync /mnt/config nullfs rw 0 0
iocage fstab -a sync /mnt/vol1/homesync /mnt/syncdata nullfs rw 0 0

# link python
iocage exec sync ln -s /usr/local/bin/python2.7 /usr/bin/python
iocage exec sync ln -s /usr/local/bin/python2.7 /usr/bin/python2

# Install resilio 
iocage exec sync mkdir /usr/local/rslsync
iocage exec sync "fetch https://download-cdn.resilio.com/stable/FreeBSD-x64/resilio-sync_freebsd_x64.tar.gz -o /usr/local/rslsync/"
iocage exec sync "tar -xzvf /usr/local/rslsync/resilio-sync_freebsd_x64.tar.gz -C /usr/local/rslsync/"
iocage exec sync rm /usr/local/rslsync/resilio-sync_freebsd_x64.tar.gz

# add rslsync user using pid:uid used by rslsync in the past
iocage exec sync "pw user add rslsync -c rslsync -u 817 -d /nonexistent -s /usr/bin/nologin"

#create config file
# iocage exec sync "ee /mnt/config/sync.conf"
# Paste in:

#{
#  "storage_path": "/mnt/config",
#  "webui": {
#    "force_https": false,
#    "listen": "0.0.0.0:8888",
#    "ssl_certificate": "",
#    "ssl_private_key": ""
#  }
#}

# Link the rslsync config file to one from config directory outside of jail
iocage exec sync ln -s /mnt/config/sync.conf /usr/local/etc/sync.conf

# change ownership of config and data directories
iocage exec sync chown -R rslsync:rslsync /mnt/syncdata /mnt/config

# create the run command directory and file
iocage exec sync mkdir /usr/local/etc/rc.d

## Create rc.d/rslsync




## !/bin/sh

## PROVIDE: resilio
## REQUIRE: LOGIN DAEMON NETWORKING
## KEYWORD: shutdown

## To enable Resilio, add this line to your /etc/rc.conf:

## resilio_enable="YES"

## And optionally these line:

## resilio_user="username" # Default is "root"
## resilio_bin="/path/to/resilio" # Default is "/usr/local/share/rslsync"

## . /etc/rc.subr

# name="rslsync"
# rcvar="resilio_enable"

# load_rc_config $name

# required_files=$resilio_bin

# : ${resilio_enable:="NO"}
# : ${resilio_user:="rslsync"}
# : ${resilio_bin:="/usr/local/sbin/rslsync"}

# command=$resilio_bin
# command_args="--config /mnt/config/sync.conf"

# run_rc_command "$1"





#move the executable from rslsync to sbin
iocage exec sync mv /usr/local/rslsync/rslsync /usr/local/sbin/

# make the run command file executable
iocage exec sync chmod u+x /usr/local/etc/rc.d/rslsync

#enable start up of rslsync and start
iocage exec sync sysrc "resilio_enable="YES""
iocage exec sync service rslsync start

##use epair0b to correct vnet issues with freenas 11.1 U2
# iocage exec sync 'sysrc ifconfig_epair0_name="epair0b"'
iocage restart sync
