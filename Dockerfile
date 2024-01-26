ARG ROS_DISTRO=humble
ARG PREFIX=

FROM ros:$ROS_DISTRO-ros-base AS pkg-builder

# select bash as default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /ros2_ws

ARG DEPTHAI_ROS_RELEASE="v2.8.1-${ROS_DISTRO}"

RUN apt-get update && apt-get install -y \
		python3-pip \
        python3-colcon-common-extensions \
        python3-rosdep

# install everything needed
RUN git clone https://github.com/luxonis/depthai-ros.git src/depthai-ros -b ${DEPTHAI_ROS_RELEASE} && \
    git clone https://github.com/ros-misc-utilities/ffmpeg_image_transport.git src/ffmpeg_image_transport && \
    vcs import src < src/ffmpeg_image_transport/ffmpeg_image_transport.repos && \
    rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
	rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -r -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    MAKEFLAGS="-j1 -l1" colcon build

FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

ARG PREFIX
ENV PREFIX_ENV=$PREFIX

# select bash as default shell
SHELL ["/bin/bash", "-c"]

COPY --from=pkg-builder /ros2_ws /ros2_ws

WORKDIR /ros2_ws

# installing deppendencies from rosdep
RUN apt-get update && apt-get install -y \
		python3-pip \
        python3-colcon-common-extensions \
        python3-rosdep && \
    rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
	rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -r -y && \
	apt-get clean && \
	apt-get remove -y \
		python3-pip \
        python3-colcon-common-extensions \
        python3-rosdep && \
	rm -rf /var/lib/apt/lists/*

RUN echo $(cat /ros2_ws/src/depthai-ros/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt

