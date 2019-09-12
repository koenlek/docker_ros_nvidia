# This is a generic dockerfile to enable nvidia based opengl in an existing, Ubuntu 16.04 based, docker image.

# Example build:
# ORIG_IMG=osrf/ros:kinetic-desktop-full
# docker build . -f patch-opengl-u1604.dockerfile -t ${ORIG_IMG:?}-nvidia --build-arg FROM_ARG=${ORIG_IMG:?}
#
# Example run:
# xhost +local:docker
# DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# docker run -it --rm --net=host $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full-nvidia rviz

# This is for Ubuntu 16.04 based images.
# For others, see: https://hub.docker.com/r/nvidia/opengl
# mainly based on: https://gitlab.com/nvidia/container-images/opengl/blob/ubuntu16.04/glvnd/runtime/Dockerfile

ARG FROM_ARG
FROM ${FROM_ARG}

# Install glvnd + opengl libraries
# They don't come over apt for Ubuntu 16.04, so we just grab them from another img
COPY --from=nvidia/opengl:1.1-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu
RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig
    
# Set up env variables to enable nvidia for opengl
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:-all}