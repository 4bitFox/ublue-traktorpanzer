## BUILD ARGS
ARG SOURCE_IMAGE="silverblue"
ARG SOURCE_SUFFIX="-main"
ARG SOURCE_TAG="42"
ARG IMAGE_NAME="traktorpanzer"
ARG IMAGE_VENDOR="alya"


### IMAGES
# ZFS kmod RPMs incl. kernel
FROM ghcr.io/ublue-os/akmods-zfs:coreos-stable-${SOURCE_TAG} AS zfs-cache
# standard Containerfile
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}


### MODIFICATIONS
COPY build.sh /tmp/build.sh
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=zfs-cache,src=/kernel-rpms,dst=/tmp/rpms/kernel \
    --mount=type=bind,from=zfs-cache,src=/rpms/kmods/zfs,dst=/tmp/rpms/zfs \
    mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
