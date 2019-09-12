# ROS docker images for nvidia

[Docker Hub link](https://hub.docker.com/r/koenlek/ros-nvidia)

This repo hosts Dockerfiles that apply a patch on top of the osrf/ros docker images. This patch
fixes opengl based programs when run under docker with nvidia acceleration. 

The patch basicaly consists of adding [libglvnd](https://github.com/NVIDIA/libglvnd) and activating it for nvidia.

> NOTE: The patching methodology in this repo can be applied similarly on other docker images as well. 
> Feel free to use the generic `patch-opengl-<ubuntu_version>.dockerfile` for your own uses.

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

## Examples

### RVIZ (ROS Kinetic)

I usually add these to my .bashrc (but you can also run them manually on each shell if you prefer):

```sh
# prepare for running dockerized GUIs
xhost +local:docker &> /dev/null # actually only needs to be run once per system boot (though rerunning is harmless, so you can also just put it in your .bashrc)
DOCKER_COMMON_ARGS="--gpus all --env=NVIDIA_VISIBLE_DEVICES=all --env=NVIDIA_DRIVER_CAPABILITIES=all --env=DISPLAY --env=QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix:/tmp/.X11-unix:rw"
# Feel free to add e.g. "--privileged" or remove things from DOCKER_COMMON_ARGS to, if you want
# For Intel graphics, you'll want to remove "--gpus all --env=NVIDIA_VISIBLE_DEVICES=all --env=NVIDIA_DRIVER_CAPABILITIES=all"
# and add "--device=/dev/dri:/dev/dri"
```

Normally, you could use e.g. these commands:

```sh
# start a roscore (if none is running already)
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full roscore
# run rviz
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS osrf/ros:kinetic-desktop-full rviz
```

These would work fine on Intel graphics (given that you adjusted `DOCKER_COMMON_ARGS` for Intel 
Graphics as suggested above), but won't work on Nvidia graphics.

For Nvidia, you can now use these commands instead:

```sh
# start a roscore (if none is running already)
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full roscore
# run rviz
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full rviz
```

### RVIZ (ROS Melodic or newer)

Good news! This should work with the vanilla docker images (as they already contain libglvnd):

```sh
# start a roscore (if none is running already)
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS osrf/ros:melodic-desktop-full roscore
# run rviz (melodic)
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS osrf/ros:melodic-desktop-full rviz
```


# Troubleshooting

First, make sure that non-accelerated GUIs work:

```sh
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full roscore
# run RQT
docker run -it --rm --net=host --privileged $DOCKER_COMMON_ARGS koenlek/ros-nvidia:kinetic-desktop-full rqt
```

If rqt crashes, then you need to fix running basic GUIs through docker first. 
Fixing that is out of the scope of this README.

# Known issues

You'll probably see console errors like:

```
QXcbConnection: XCB error: 2 (BadValue), sequence: 588, resource id: 400, major code: 130 (Unknown), minor code: 3
```

My experience is that these can safely be ignored.
