# Based on: https://gitlab.com/nvidia/container-images/opengl/blob/ubuntu18.04/glvnd/runtime/Dockerfile

FROM osrf/ros:melodic-desktop-full

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