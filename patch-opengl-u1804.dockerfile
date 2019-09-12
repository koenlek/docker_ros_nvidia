# This is a generic dockerfile to enable nvidia based opengl in an existing, Ubuntu 18.04 based, docker image.
# It might also work on other distributions, such as a recent Debian version (as long as it provides the requires apt packages)

# Example build:
# ORIG_IMG=<some_img>
# docker build . -f patch-opengl-u1804.dockerfile -t ${ORIG_IMG:?}-nvidia --build-arg FROM_ARG=${ORIG_IMG:?}
#
# Example run:
# xhost +local:docker
# DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# docker run -it --rm --net=host $DOCKER_COMMON_ARGS ${ORIG_IMG:?}-nvidia <your_opengl_app>

ARG FROM_ARG
FROM ${FROM_ARG}

RUN apt-get update && apt-get install -y --no-install-recommends \
      libglvnd0 \
      libgl1 \
      libglx0 \
      libegl1 \
      libgles2 && \
    rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:-all}