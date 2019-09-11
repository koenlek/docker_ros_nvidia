# This is a generic dockerfile to enable nvidia based opengl in an existing, Ubuntu 18.04 based, docker image.

# Example build:
# ORIG_IMG=osrf/ros:melodic-desktop-full
# docker build . -f patch-opengl-u1804.dockerfile -t ${ORIG_IMG:?}-nvidia --build-arg FROM_ARG=${ORIG_IMG:?}
#
# Example run:
# xhost +local:docker
# DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# docker run -it --rm --net=host $DOCKER_COMMON_ARGS osrf/ros:melodic-desktop-full-nvidia rviz

# This is for Ubuntu 18.04 based images.
# For others, see: https://hub.docker.com/r/nvidia/opengl
# mainly based on: https://gitlab.com/nvidia/container-images/opengl/blob/ubuntu18.04/glvnd/runtime/Dockerfile

ARG FROM_ARG
FROM ${FROM_ARG}

RUN apt-get update && apt-get install -y --no-install-recommends \
      libglvnd0 \
      libgl1 \
      libglx0 \
      libegl1 \
      libgles2 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04 \
  /usr/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/share/glvnd/egl_vendor.d/10_nvidia.json

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compat32,utility