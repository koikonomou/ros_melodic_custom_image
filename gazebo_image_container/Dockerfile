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
        libyaml-cpp-dev \
        libyaml-cpp0.5v5 \
        libpcl-dev \
        libgtk2.0-dev \
        sudo \
        xsltproc \
        wget \
    && apt-get clean


RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
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
RUN sudo apt-get install -y libsdl-image1.2-dev
RUN sudo apt-get install libsdl-dev

RUN sudo apt-get update && sudo apt-get install -y \
    libzmq3-dev protobuf-compiler protobuf-c-compiler

# RUN sudo apt install ros-melodic-gazebo-ros \
#     ros-melodic-gazebo-dev \
#     ros-melodic-gazebo-plugins \
#     ros-melodic-gazebo-msgs \
#     ros-melodic-gazebo-ros-pkgs 

# USER root
RUN mkdir -p /home/.gazebo && git clone https://github.com/osrf/gazebo_models /home/.gazebo/models
RUN apt-get update && apt-get install -y \
        gazebo9 \
        gazebo9-common \
        libgazebo9-dev 



ENV ROS_WS /opt/ros_ws/melodic
RUN mkdir -p $ROS_WS/src
# Install PCL
# RUN cd /opt && git clone https://github.com/Airsquire/pcl pcl
# RUN cd /opt/pcl && git checkout master
# RUN mkdir -p /opt/pcl/build
# RUN cd /opt/pcl/build && cmake -D BUILD_visualization=true -D VTK_DIR=/opt/VTK/build -D BUILD_2d=true -D BUILD_tools=false ..
# RUN cd /opt/pcl/build && make -j 32 && make install
# RUN cd /opt/pcl/build && make clean

# RUN apt-get update -y --fix-missing && apt-get install -y libvtk7-dev libvtk7-java libvtk7-jni
# RUN apt-get update -y --fix-missing && apt-get install -y libgdal-* libgeotiff-dev
# RUN apt-get update -y --fix-missing && apt-get install -y libeigen3-dev libflann-dev
# RUN apt-get update -y --fix-missing && apt-get install -y libboost-all-dev 
# RUN apt-get install -y libvtk6-dev libvtk6-qt-dev libvtk6-java libvtk6-jni
# RUN apt-get install -y git build-essential cmake gdb 
# RUN apt-get install -y liblas-dev liblas-bin liblas-c-dev liblas3
# RUN sudo apt-get install -y libpcl-*
# RUN apt-get install -y ros-pcl-msgs

# RUN git clone https://github.com/PDAL/PDAL.git --branch 1.8.0 /root/pdal
# RUN cd /root/pdal && mkdir build && cd build && cmake ../ && make -j 16 && make install && cd /

# RUN git clone https://github.com/PointCloudLibrary/pcl -b pcl-1.9.1 /root/pcl
# RUN cd /root/pcl && mkdir build && cd build && cmake ../ -DBUILD_CUDA=ON -DBUILD_GPU=ON && make -j 16 && make install && cd /

# RUN git clone git://github.com/libLAS/libLAS.git --branch 1.8.1 /root/libLAS
# RUN cd /root/libLAS && mkdir build && cd build && cmake ../ && make -j 16 && make install && cd /
COPY gazebo.rosinstall /opt/ros_ws/melodic/

RUN cd $ROS_WS && \
    wstool init -j8 src gazebo.rosinstall

RUN cd $ROS_WS && \
    ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release
RUN mkdir ~/ros_ws && \
    cd ~/ros_ws && \
    rosws init . /opt/ros_ws/melodic/install_isolated


RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash "
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]