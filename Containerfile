## BUILD ARGS
# Surce Images: https://github.com/orgs/ublue-os/packages
ARG SOURCE_IMAGE="bazzite-gnome"
ARG SOURCE_TAG="43"
ARG IMAGE_NAME="traktorpanzer"
ARG IMAGE_VENDOR="alya"


### IMAGES
# ZFS kmod RPMs incl. kernel
FROM ghcr.io/ublue-os/akmods-zfs:coreos-stable-${SOURCE_TAG} AS zfs-cache
# standard Containerfile
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}:${SOURCE_TAG}


### MODIFICATIONS
COPY build.sh /tmp/build.sh
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=zfs-cache,src=/kernel-rpms,dst=/tmp/rpms/kernel \
    --mount=type=bind,from=zfs-cache,src=/rpms/kmods/zfs,dst=/tmp/rpms/zfs \
    mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
