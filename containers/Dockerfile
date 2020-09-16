FROM ubuntu:18.04

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"

ARG DEBIAN_FRONTEND=noninteractive

# RUN apt-get update -qq     && apt-get -qq install --no-install-recommends -y apt-utils gnupg wget ca-certificates lsb-release dirmngr
SHELL ["/bin/bash","-c"]

RUN apt-get update && apt-get install -q -y \
    build-essential \
    libboost-all-dev \
    python-pip \
    python-catkin-pkg \
    python-rosdep \
    python-wstool \
    python-vcstools \
    git \
    dirmngr \
    gnupg2 \
    wget \
    python-rosinstall-generator \
    python-rosinstall \
    lsb-release \
    ssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN for i in 1 2 3; do { apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 'C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; } &&  break || sleep 1; done

RUN rosdep init && \
    rosdep update 
# RUN rosdep update

ENV ROS_WS /opt/ros/melodic
RUN mkdir -p ${ROS_WS}/src

RUN cd ${ROS_WS} && \
    git clone https://github.com/koikonomou/custom_ros_image && \
    cp -r custom_ros_image/melodic-custom-desktop-full.rosinstall . && \
    rm -rf custom_ros_image && \
    wstool init -j8 ${ROS_WS}/src melodic-custom-desktop-full.rosinstall

USER $USERNAME
# Set env var again after changing user name

# ENV ROS_WS /opt/ros/melodic
RUN apt-get clean && apt-get update
# RUN apt-get install --reinstall python-catkin-pkg
# RUN apt-get update && apt-get install --only-upgrade python-catkin-pkg
# RUN rosdep init && \
#     rosdep update && \
ENV CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS/src

RUN apt-get update && \
    cd $CATKIN_WS && \
    rosdep install --from-paths ${ROS_WS}/src --ignore-src --rosdistro melodic -y

RUN rosdep install --from-paths ${ROS_WS}/src --ignore-src --rosdistro melodic -y --skip-keys='python3-opencv dkms opencv libopencv-dev libopencv rviz'  
 # USER root
# Build catkin workspace
# cd into the correct directory first, so that catkin can find relative
#   directory src/
RUN cd ${ROS_WS} && \
    ${ROS_WS}/src/catkin/bin/catkin_make_isolated --install

# RUN sed --in-place --expression \
#     '$isource "~/ros_catkin_ws/install_isolated/setup.bash"' \
#     /ros_entrypoint.sh
# USER $USERNAME
# WORKDIR /home/$USERNAME
# EXPOSE 80
RUN echo "source /ros_entrypoint.sh" >> /root/.bashrc

COPY ./ros_catkin_entrypoint.sh /
RUN chmod +x /ros_catkin_entrypoint.sh

ENTRYPOINT ["/ros_catkin_entrypoint.sh"]
CMD ["bash"]