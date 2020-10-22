# Build with: sudo docker build -t kymco_im <kymco_maxxer90_robot-location>/containers/Dockerfile
# Run with: sudo docker-compose up --remove-orphans

FROM gazebo_im:latest

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"


RUN apt-get install -y \
    xvfb \
    libignition-msgs-dev \
    libqt4-dev \
    libqglviewer-dev-qt5 \
    libusb-1.0-0 
#     ros-melodic-hector-gazebo-plugins \
RUN apt-get install libc6-i386

RUN /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash "

# ENV ROS_WS /opt/ros_ws/melodic

COPY addons.rosinstall /opt/ros_ws/melodic/

RUN cd /opt/ros_ws/melodic && \
    wstool merge -t src addons.rosinstall 

RUN cd /opt/ros_ws/melodic && \
   /opt/ros_ws/melodic/src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

RUN /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash"
RUN /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.sh"
RUN mkdir -p /opt/catkin_ws/src 
# RUN rosdep init && \
#     rosdep update 

# RUN cd /opt/catkin_ws/src && \
#     cd .. && \
#     /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_make"
# # RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_init_workspace /opt/catkin_ws/src" 

RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/roboticsgroup/roboticsgroup_gazebo_plugins && \
    git clone https://github.com/roboskel/roboskel_msgs && \
    git clone https://github.com/roboskel/roboskel_ros_resources && \
    git clone https://github.com/roboskel/kymco_maxxer90_robot && \
    git clone https://github.com/cra-ros-pkg/robot_localization -b 2.6.7 && \
    # git clone https://github.com/osrf/gazebo_models && \
    # cd .. && \
    mkdir -p ~/.gazebo/models && \
    cp -r roboskel_ros_resources/gazebo/models/* ~/.gazebo/models && \
    rm -rf roboskel_ros_resources/graspit && \
    cd .. && \
    # rosdep install --from-paths src --ignore-src -r -y && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash && catkin build" 

RUN rosdep init && \
    rosdep update 

COPY ros_entrypoint.sh /usr/local/bin/ros_entrypoint.sh

# RUN touch /usr/local/bin/ros_entrypoint.sh
RUN  chmod +x /usr/local/bin/ros_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ros_entrypoint.sh"]
CMD ["/bin/bash"]

RUN sed --in-place --expression \
    '$isource "/opt/catkin_ws/devel/setup.bash"' \
    /usr/local/bin/ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash; . /opt/catkin_ws/devel/setup.bash "

# CMD ["gzserver"]
EXPOSE 80
EXPOSE 11345