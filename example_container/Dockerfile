# Build with: sudo docker build -t kymco_im <kymco_maxxer90_robot-location>/containers/Dockerfile
# Run with: sudo docker-compose up --remove-orphans

FROM gazebo_im:latest

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"


RUN apt-get install -y \
    xvfb \
    libignition-msgs-dev 
#     ros-melodic-hector-gazebo-plugins \
RUN apt-get install libc6-i386

RUN /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash "

# ENV ROS_WS /opt/ros_ws/melodic

COPY addons.rosinstall /opt/ros_ws/melodic/

RUN cd /opt/ros_ws/melodic && \
    wstool merge -t src addons.rosinstall 

RUN cd /opt/ros_ws/melodic && \
   /opt/ros_ws/melodic/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

RUN mkdir -p /opt/catkin_ws/src

# RUN rosdep init && \
#     rosdep update 
# RUN sudo apt install ros-melodic-gazebo-ros \
#     ros-melodic-gazebo-dev \
#     ros-melodic-gazebo-plugins \
#     ros-melodic-gazebo-msgs \
#     ros-melodic-gazebo-ros-pkgs \
#     ros-melodic-camera-info-manager \
#     ros-melodic-camera-calibration-parsers \
#     libyaml-cpp-dev


RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/roboticsgroup/roboticsgroup_gazebo_plugins && \
    cd .. && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_make -DCATKIN_WHITELIST_PACKAGES=roboticsgroup_gazebo_plugins"

RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/roboskel/roboskel_msgs && \
    git clone https://github.com/roboskel/roboskel_ros_resources && \
    git clone https://github.com/ros-perception/image_common -b image_common-1.8.0 && \
    git clone https://github.com/roboskel/kymco_maxxer90_robot && \
    git clone https://github.com/ros-controls/ros_controllers -b 0.17.0 && \
    git clone https://github.com/ros-controls/ros_control -b 0.18.2 && \
    git clone https://github.com/ros-controls/urdf_geometry_parser && \
    git clone https://github.com/ros-drivers/four_wheel_steering_msgs && \
    git clone https://github.com/cra-ros-pkg/robot_localization -b 3.1.1 && \
    git clone https://github.com/ros-planning/navigation -b 1.16.7 && \
    git clone https://github.com/OctoMap/octomap -b v1.9.5 && \
    git clone https://github.com/OctoMap/octomap_msgs -b 0.3.5 && \
    git clone https://github.com/OctoMap/octomap_mapping -b 0.6.5 && \
    git clone https://github.com/introlab/rtabmap_ros -b 0.20.0-melodic && \
    git clone https://github.com/RobotWebTools/rosbridge_suite -b 0.8.1 && \
    git clone https://github.com/RobotWebTools/tf2_web_republisher -b 0.3.2 && \
    # git clone https://github.com/osrf/gazebo_models && \
    # cd .. && \
    mkdir -p ~/.gazebo/models && \
    cp -r roboskel_ros_resources/gazebo/models/* ~/.gazebo/models && \
    rm -rf roboskel_ros_resources/graspit && \
    cd .. && \
    # rosdep install --from-paths src --ignore-src -r -y && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; source /opt/catkin_ws/devel/setup.bash; catkin_make "

COPY ros_entrypoint.sh /usr/local/bin/ros_entrypoint.sh

# RUN touch /usr/local/bin/ros_entrypoint.sh
RUN  chmod +x /usr/local/bin/ros_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ros_entrypoint.sh"]
CMD ["/bin/bash"]

RUN sed --in-place --expression \
    '$isource "/opt/catkin_ws/devel/setup.bash"' \
    /usr/local/bin/ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash && . /opt/catkin_ws/devel/setup.bash "

EXPOSE 80
EXPOSE 11345
