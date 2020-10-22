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
        liburdfdom-headers-dev \
        liburdfdom-dev \
        liburdfdom-tools \
        liburdf-parser-plugin-dev \
        qt-at-spi \
        liblz4-dev \
        libbond-dev \
        libbondcpp-dev \
        libjpeg-dev \
        libsmc-dev \
        libpng-dev \
        libzip-dev \
        libfltk1.1-dev \
        libbz2-dev \
        libgpgme-dev \
        libkdl-parser-dev \
        libopencv-dev \
        libyaml-cpp0.3-dev \
        libpcl-dev \
        libgtk2.0-dev \
        sudo \
        xsltproc \
        wget \
    && apt-get clean


RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' 



RUN apt-get update \
 && apt-get install -y \
        python-rosdep \
        python-rosinstall-generator \
        python-wstool \
        python-vcstools \
        python-rosinstall \
        python-defusedxml \
        python-netifaces \
        build-essential 


RUN apt-get install -y python-catkin-tools \
    python-catkin-pkg-modules \
    python-catkin-pkg



ENV ROS_WS /opt/ros_ws/melodic
RUN mkdir -p $ROS_WS/src

# Resolve dependencies and install ROS melodic from custome rosinstall package
COPY melodic-custom-desktop-full.rosinstall /opt/ros_ws/melodic/src/.rosinstall

RUN cd /opt/ros_ws/melodic/src && \
    wstool update && \
    cd ../ && \
    catkin init

RUN cd /opt/ros_ws/melodic && \
    catkin build && ls build && ls devel
# RUN cd $ROS_WS && \
#     ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

# RUN echo "#!/bin/bash" | tee /ros_entrypoint.sh;\
#     echo "set -e" >> /ros_entrypoint.sh

# RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash "