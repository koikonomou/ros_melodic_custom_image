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


RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -' \
 && sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' 



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

# Dependencies for installing Gazebo from source
RUN sudo apt-get install -y libccd-dev libbullet-dev
RUN sudo apt-get install -y pkg-config
RUN sudo apt-get install -y libdart6-dev
RUN sudo apt-get install -y ccache python3-colcon-common-extensions

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
# ARG user
ENV USERNAME user
# RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
#  && echo "$USERNAME:$USERNAME" | chpasswd \
#  && adduser $USERNAME sudo \
#  && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

USER $USERNAME

WORKDIR /home/$USERNAME

USER root
RUN mkdir -p /home/$USERNAME/.gazebo && git clone https://github.com/osrf/gazebo_models /home/$USERNAME/.gazebo/models
RUN apt-get update && apt-get install -y \
        gazebo9 \
        libgazebo9-dev 

RUN sudo apt-get update && sudo apt-get install -y \
    libzmq3-dev protobuf-compiler
    #libzmq-dev libzmq5 libzmq3-dev protobuf-compiler


ENV ROS_WS /opt/ros_ws/melodic
RUN mkdir -p $ROS_WS/src
RUN cd $ROS_WS && \
    git clone https://github.com/koikonomou/custom_ros_image && \
    cp -r custom_ros_image/gazebo.rosinstall . && \
    rm -rf custom_ros_image && \
    wstool init -j8 src gazebo.rosinstall
# Clone all the gazebo models so that you don't download them every time
# docker is run


RUN cd $ROS_WS && \
    ${ROS_WS}/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release


RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash "
