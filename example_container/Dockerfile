# Build with: sudo docker build -t kymco_im <kymco_maxxer90_robot-location>/containers/Dockerfile
# Run with: sudo docker-compose up --remove-orphans

FROM gazebo_im:latest

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"


# RUN apt-get install -y \
#     apache2 \
#     xvfb \
#     python-catkin-tools \
#     python-genpy \
#     libignition-msgs-dev \
#     ros-melodic-rosmsg \
#     ros-melodic-costmap-2d \
#     ros-melodic-costmap-queue \
#     ros-melodic-octomap-mapping \
#     ros-melodic-octomap-msgs \
#     ros-melodic-octomap-ros \
#     ros-melodic-octomap-server \
#     ros-melodic-ros-control \
#     ros-melodic-ros-controllers \
#     ros-melodic-hector-gazebo-plugins \
#     ros-melodic-gazebo-ros \
#     ros-melodic-simulators \
#     ros-melodic-gazebo-plugins \
#     ros-melodic-gazebo-ros-pkgs \
#     ros-melodic-gazebo-ros-control \
#     ros-melodic-move-base \
#     ros-melodic-rosbridge-server \
#     ros-melodic-tf2-web-republisher \
#     ros-melodic-robot-state-publisher \
#     ros-melodic-position-controllers \
#     ros-melodic-effort-controllers \
#     ros-melodic-joint-state-controller \
#     ros-melodic-controller-manager \
#     ros-melodic-ackermann-steering-controller && \
#     rm -rf /var/lib/apt-get/lists/*

RUN mkdir -p /opt/catkin_ws/src

RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/roboskel/roboskel_msgs && \
    git clone https://github.com/roboskel/roboskel_ros_resources && \
    git clone https://github.com/roboticsgroup/roboticsgroup_gazebo_plugins && \
    git clone https://github.com/roboskel/kymco_maxxer90_robot && \
    git clone https://github.com/ros-controls/ros_controllers -b 0.17.0 && \
    git clone https://github.com/ros-controls/ros_control -b 0.18.2 && \
    git clone https://github.com/cra-ros-pkg/robot_localization-release -b debian/melodic/robot_localization && \
    git clone https://github.com/ros-planning/navigation -b  1.16.7 && \
    git clone https://github.com/OctoMap/octomap_mapping -b 0.6.5 && \
    mkdir -p ~/.gazebo/models && \
    cp -r roboskel_ros_resources/gazebo/models/* ~/.gazebo/models && \
    rm -rf roboskel_ros_resources/graspit && \
    cd .. && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_make -DCATKIN_WHITELIST_PACKAGES="roboticsgroup_gazebo_plugins" " && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; source /opt/catkin_ws/devel/setup.bash; catkin_make" 

COPY ros_entrypoint.sh /usr/local/bin/ros_entrypoint.sh

RUN  chmod 755 /usr/local/bin/ros_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ros_entrypoint.sh"]
CMD ["bash"]

RUN sed --in-place --expression \
    '$isource "/opt/catkin_ws/devel/setup.bash"' \
    /usr/local/bin/ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash && . /opt/catkin_ws/devel/setup.bash "


EXPOSE 80
