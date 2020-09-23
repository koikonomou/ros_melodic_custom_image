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
        python-sip-dev \
        python-pyqt5 \
        python-nose \
        sip-dev \
        pyqt5-dev \
        pyqt5-dev-tools \
        libtinyxml-dev \
        libtinyxml2-dev \
        software-properties-common \
        curl \
        libcurl4-openssl-dev \
        libtf-conversions-dev \
        libblkid-dev \
        e2fslibs-dev \
        libeigen3-dev \
        libboost-all-dev \
        libaudit-dev \
        qtbase5-dev \
        libqt5widgets5 \
        libresource-retriever-dev \
        libpoco-dev \
        libgtest-dev \
        libconsole-bridge-dev \
        qt5-default \
        libgl1-mesa-dev \
        qt-at-spi \
        liblz4-dev \
        libbond-dev \
        libbondcpp-dev \
        libjpeg-dev \
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
RUN apt-get install -y python-catkin-tools \
    python-catkin-pkg-modules \
    python-catkin-pkg

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id
ENV USERNAME kate
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

USER $USERNAME

WORKDIR /home/$USERNAME

USER root
# RUN rm -rf /etc/ros/rosdep/sources.list.d/20-default.list
# RUN rosdep init && \
#     rosdep update

# Resolve dependencies and install ROS melodic from custome rosinstall package
ENV ROS_WS /opt/ros_ws/melodic
RUN mkdir -p $ROS_WS/src
RUN cd $ROS_WS && \
    git clone https://github.com/koikonomou/custom_ros_image && \
    cp -r custom_ros_image/melodic-custom-desktop-full.rosinstall . && \
    rm -rf custom_ros_image && \
    wstool init -j8 src melodic-custom-desktop-full.rosinstall

# RUN rosdep install --from-paths $ROS_WS/src --ignore-src --rosdistro melodic -y --skip-keys='gazebo'

RUN cd $ROS_WS && \
    ${ROS_WS}/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

# RUN echo "#!/bin/bash" | tee /ros_entrypoint.sh;\
#     echo "set -e" >> /ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash "
