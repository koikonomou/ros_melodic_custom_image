FROM ubuntu:18.04

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"

ENV TZ=Europe
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    python-rosdep \
    python-rosinstall-generator \
    python-wstool \
    python-rosinstall \
    build-essential \
    git \
    python-catkin-pkg \
    lsb-release \
    python-rosdep && \
    apt-get clean all && \
    rosdep init && \
    rosdep update 

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN mkdir -p /opt/catkin_ws/src

RUN apt-get update && apt-get install -y \
        git \
        ros-melodic-catkin

RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/ros-drivers/ackermann_msgs && \
    git clone https://github.com/ros-controls/ros_controllers && \
    git clone https://github.com/ros/actionlib && \
    git clone https://github.com/ros/common_msgs && \
    git clone https://github.com/ros-planning/navigation && \
    cd .. && \
    rosdep install --from-paths src --ignore-src -r -y && \
    # /bin/bash -c "source /opt/ros/melodic/setup.bash; catkin_make -DCATKIN_WHITELIST_PACKAGES="roboticsgroup_gazebo_plugins" " && \
    /bin/bash -c "source /opt/ros/melodic/setup.bash; source /opt/catkin_ws/devel/setup.bash; catkin_make" && \
    apt-get purge -y \
        build-essential \
        git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt-get/lists/*


RUN sed --in-place --expression \
    '$isource "/opt/catkin_ws/devel/setup.bash"' \
    /ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros/melodic/setup.bash && . /opt/catkin_ws/devel/setup.bash "

EXPOSE 80