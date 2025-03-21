#!/bin/bash
set -ouex pipefail
RELEASE="$(rpm -E %fedora)"


### Install cached ZFS and appropriate kernel
rpm-ostree override replace /tmp/rpms/kernel/*.rpm /tmp/rpms/zfs/*.rpm
# Auto-load ZFS module
depmod -a "$(rpm -qa kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
echo "zfs" > /etc/modules-load.d/zfs.conf && \
# we don't want any files on /var
rm -rf /var/lib/pcp
## Just in case, according to https://openzfs.github.io/openzfs-docs/Getting%20Started/Fedora/index.html#installation
echo 'zfs' > /etc/dnf/protected.d/zfs.conf
