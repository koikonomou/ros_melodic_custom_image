# Build with: sudo docker build -t kymco_im <kymco_maxxer90_robot-location>/containers/Dockerfile
# Run with: sudo docker-compose up --remove-orphans

FROM gazebo_im:latest

LABEL maintainer="Katerina Oikonomou <koikonomou@iit.demokritos.gr>"


RUN apt-get install -y \
    xvfb \
    libignition-msgs-dev \
    libqt4-dev \
    libqglviewer-dev-qt5 \
    libusb-1.0-0 \
    unzip -q \
    apt-utils
#     ros-melodic-hector-gazebo-plugins \
RUN apt-get install libc6-i386

RUN /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash "

# ENV ROS_WS /opt/ros_ws/melodic
RUN rm /opt/ros_ws/melodic/*.rosinstall
COPY addons.rosinstall /opt/ros_ws/melodic/

RUN cd /opt/ros_ws/melodic && \
    # wstool init src && \
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
    wget https://github.com/roboticsgroup/roboticsgroup_gazebo_plugins/archive/master.zip && \
    unzip -q master.zip && \
    rm -rf master.zip && \
    wget https://github.com/roboskel/roboskel_msgs/archive/master.zip && \
    unzip -q master.zip && \
    rm -rf master.zip && \
    wget https://github.com/roboskel/roboskel_ros_resources/archive/master.zip && \
    unzip -q master.zip && \
    rm -rf master.zip && \
    wget https://github.com/roboskel/kymco_maxxer90_robot/archive/master.zip && \
    unzip -q master.zip && \
    rm -rf master.zip && \
    wget https://github.com/cra-ros-pkg/robot_localization/archive/2.6.7.zip && \
    unzip -q 2.6.7.zip && \
    wget https://github.com/wjwwood/serial/archive/master.zip && \
    rm -rf *.zip && \
    # git clone https://github.com/osrf/gazebo_models && \
    # cd .. && \
    mkdir -p ~/.gazebo/models && \
    cp -r roboskel_ros_resources-master/gazebo/models/* ~/.gazebo/models && \
    rm -rf roboskel_ros_resources-master/graspit && \
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