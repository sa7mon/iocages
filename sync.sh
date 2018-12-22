#iocage create --release 11.2-RELEASE --name sync boot="off" allow_raw_sockets="1" ip4_addr="igb0|10.0.1.161/24" resolver="nameserver 10.0.1.120;nameserver 1.1.1.1"

# Go get all the ports
portsnap fetch
portsnap extract
cd /usr/ports/ports-mgmt/portmaster
make install clean
echo "WITH_PKGNG=yes" >> /etc/make.conf
pkg2ng

# Install Resilio Sync
cd /usr/ports/net-p2p/rslsync
make install clean
sysrc rslsync_enable=YES
service rslsync start

# Once started, visit the following to configure: 
# http://localhost:8888/
