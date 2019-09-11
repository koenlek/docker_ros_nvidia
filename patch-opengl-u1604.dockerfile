# Example usage:
# ORIG_IMG=osrf/ros:kinetic-desktop-full
# docker build . -f add-opengl-u1604.dockerfile -t ${ORIG_IMG:?}-nvidia --build-arg FROM_ARG=${ORIG_IMG:?}
# docker run -it --rm --net=host $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full-nvidia rviz

# This is for Ubuntu 16.04 based images.
# For others, see: https://hub.docker.com/r/nvidia/opengl

ARG FROM_ARG
FROM ${FROM_ARG}

# add opengl nvidia drivers to the iamge
COPY --from=nvidia/opengl:1.1-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu

COPY --from=nvidia/opengl:1.1-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics