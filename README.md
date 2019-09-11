# ROS docker images for nvidia

This repo hosts Dockerfiles that apply a patch on top of the osrf/ros docker images. This patch
fixes opengl based programs when run under docker with nvidia acceleration

> NOTE: The patching methodology in this repo can be applied similarly on other docker images as well.

# How to use

> These instructions are for docker version 19.03 or later, which removes the need for nvidia-docker2
> However, this should work well under nvidia-docker v2 as well.

## Prerequisites

- [docker 19.03](https://docs.docker.com/install/linux/docker-ce/ubuntu/) or later
- [nvidia-container-runtime](https://nvidia.github.io/nvidia-container-runtime/)

To verify if your prerequisites work, you should be able to see a table with nvidia details when 
you run:

```sh
docker run --gpus all nvidia/cuda:9.0-base nvidia-smi
```

## Example: run RVIZ

Normally, you could use e.g. these commands:

```sh
# prepare for running dockerized GUIs
xhost +local:docker
DOCKER_COMMON_ARGS="--env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# start a roscore (if none is running already)
docker run -it --rm --net=host $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full roscore
# run rviz
docker run -it --rm --net=host $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full rviz
```

These would work fine on Intel graphics, but won't work on Nvidia graphics.

For nvidia, you can now use these commands instead:

```sh
# prepare for running dockerized GUIs
xhost +local:docker
DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# start a roscore (if none is running already)
docker run -it --rm --net=host $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full roscore
# run rviz
docker run -it --rm --net=host $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full rviz
```

# Troubleshooting

First, make sure that non-accelerated GUIs work:

```sh
# prepare for running dockerized GUIs
xhost +local:docker
DOCKER_COMMON_ARGS="--gpus all --env=DISPLAY --env=XDG_RUNTIME_DIR --env=QT_X11_NO_MITSHM=1 --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# start a roscore (if none is running already)
docker run -it --rm --net=host $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full roscore
# run RQT
docker run -it --rm --net=host $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full rqt
```

If rqt won't work, then you need to fix running basic GUIs through docker first.
