FROM ubuntu:18.04

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"

# This avoids keyboard interaction when asked for geographic area
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        cmake \
        cppcheck \
        gdb \
        git \
        libcwiid-dev \
        libgoogle-glog-dev \
        libspnav-dev \
        libusb-dev \
        lsb-release \
        mercurial \
        python-dbg \
        python-empy \
        python-numpy \
        python-pip \
        software-properties-common \
        sudo \
        vim \
        wget \
    && apt-get clean


RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654



RUN apt-get update \
 && apt-get install -y \
        python-rosdep \
        python-rosinstall-generator \
        python-wstool \
        python-vcstools \
        python-rosinstall \
        build-essential
#RUN apt-get install -y python-catkin-tools
RUN rosdep init


# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below run as the developer user
USER $USERNAME

# Make a couple folders for organizing docker volumes
RUN mkdir ~/workspaces ~/other

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

RUN rm -rf /etc/ros/rosdep/sources.list.d/20-default.list
RUN rosdep init && \
    rosdep update
USER root

# Resolve dependencies and install ROS 1 melodic from source
ENV ROS_WS /opt/ros_ws/melodic
RUN mkdir -p $ROS_WS/src
RUN cd $ROS_WS && \
    git clone https://github.com/koikonomou/custom_ros_image && \
    cp -r custom_ros_image/melodic-custom-desktop-full.rosinstall . && \
    rm -rf custom_ros_image && \
    wstool init -j8 src melodic-custom-desktop-full.rosinstall


# RUN apt-get install ros-melodic-cmake-modules
# Already exists
#RUN apt-get update && apt-get install -y -o Dpkg::Options::="--force-overwrite" python-catkin-pkg python-rosdistro python-rosdep-modules
# TODO: For some reason it can't find this. But if I go into Ubuntu 20.04 Docker container, I can locate it.
#RUN apt-get update && apt-get install -y python-catkin-pkg-modules

RUN rosdep install --from-paths $ROS_WS/src --ignore-src --rosdistro melodic -y --skip-keys='gazebo'

RUN cd $ROS_WS && \
  ${ROS_WS}/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
