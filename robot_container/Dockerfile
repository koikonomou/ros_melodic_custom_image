# Docker container to easily test the robot-rest-api functionality

# Build with: docker build -t robot_rest_api --build-arg ssh_prv_key="$(cat <private-key-location>)" <robot-rest-api-location>/containers/Dockerfile

# Command for building with the commented out copy for rust code replacement:
# sudo docker build -t robot_rest_api --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" -f ./containers/Dockerfile .

# Run with: docker-compose up --remove-orphans

# NOTE
# If mysql fails to install, run the following commands on the HOST machine:
# sudo ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/
# sudo apparmor_parser -R /etc/apparmor.d/usr.sbin.mysqld

FROM ros:melodic-ros-core as middleman

ARG ssh_prv_key

RUN apt-get update && apt-get install -y git openssh-client

RUN mkdir /root/.ssh/ && \
    ssh-keyscan github.com > /root/.ssh/known_hosts && \
    echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    git clone git@github.com:UVrobot/robot_rest_api && \
    rm -rf /root/.ssh

FROM gazebo_im:latest
ENV ROS_DISTRO=melodic

LABEL maintainer="George Stavrinos <gstavrinos@iit.demokritos.gr>"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y \
    apache2 \
    xvfb \
    mysql-server \
    ros-cmake-modules \
    ros-melodic-twist-mux
    # ros-melodic-costmap-2d \
    # ros-melodic-costmap-queue \
    # ros-melodic-octomap-mapping \
    # ros-melodic-octomap-msgs \
    # ros-melodic-octomap-ros \
    # ros-melodic-octomap-server \
    # ros-melodic-rosbridge-server \
    # ros-melodic-tf2-web-republisher \
    # ros-melodic-rospy-message-converter \
    # ros-melodic-gazebo-ros-control \
    # ros-melodic-gazebo-plugins && \
    # rm -rf /var/lib/apt-get/lists/*
# RUN apt install -y ros-cmake-modules
RUN mkdir -p /opt/catkin_ws/src/robot_rest_api

COPY --from=middleman robot_rest_api /opt/catkin_ws/src/robot_rest_api

RUN apt-get install -y \
        build-essential \
        git \
        python-rosdep && \
    rosdep init && \
    rosdep update && \
    cd /opt/catkin_ws/src && \
    git clone https://github.com/roboskel/roboskel_msgs && \
    git clone https://github.com/gstavrinos/mir_robot && \
    git clone https://github.com/gstavrinos/mir_experiments && \
    git clone https://github.com/gstavrinos/ros_rvv && \
    git clone https://github.com/carlosmccosta/laserscan_to_pointcloud && \
    git clone https://github.com/roboskel/roboskel_ros_resources && \
    git clone https://github.com/osrf/gazebo_models && \
    cp -r robot_rest_api/web/demo.html /var/www/html/ && \
    cp -r robot_rest_api/web/apache2.conf /etc/apache2/ && \
    cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/ && \
    cp -r mir_robot/mir_description /var/www/html && \
    cp -r roboskel_ros_resources /var/www/html && \
    mkdir -p ~/.gazebo/models && \
    cp -r gazebo_models/ambulance ~/.gazebo/models/ && \
    cp -r gazebo_models/cardboard_box ~/.gazebo/models/ && \
    cp -r gazebo_models/grey_tote ~/.gazebo/models/ && \
    cp -r gazebo_models/suv ~/.gazebo/models/ && \
    cp -r gazebo_models/plastic_cup ~/.gazebo/models/ && \
    cp -r gazebo_models/bowl ~/.gazebo/models/ && \
    cp -r gazebo_models/cordless_drill ~/.gazebo/models/ && \
    cp -r gazebo_models/coke_can ~/.gazebo/models/ && \
    rm -rf gazebo_models && \
    cp -r roboskel_ros_resources/gazebo/models/* ~/.gazebo/models && \
    rm -rf roboskel_ros_resources/graspit && \
    git clone -b melodic-devel https://github.com/ros-simulation/gazebo_ros_pkgs/ && \
    git clone -b melodic-devel https://github.com/ros-controls/ros_control && \
    git clone -b master https://github.com/RobotWebTools/rosbridge_suite && \
    git clone -b master https://github.com/RobotWebTools/tf2_web_republisher && \
    git clone -b melodic-devel https://github.com/ros/geometry2 && \
    cd .. && \
    rosdep install --from-paths src --ignore-src -r -y && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; source /opt/ros/melodic/setup.bash; catkin_make --pkg roboskel_msgs" && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; source /opt/ros/melodic/setup.bash; source /opt/catkin_ws/devel/setup.bash; catkin_make" && \
    apt-get purge -y \
        build-essential \
        git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt-get/lists/*

RUN mkdir var/www/html/maps && cp /opt/catkin_ws/src/robot_rest_api/samples/maps/floor* /var/www/html/maps/
# COPY samples/maps/floor* /var/www/html/maps/
# COPY rest/rust/robot-rest-api/ /opt/catkin_ws/src/robot_rest_api/rest/rust/robot-rest-api/
# COPY web/ /var/www/html/
COPY ros_entrypoint.sh /usr/local/bin/ros_entrypoint.sh

# RUN touch /usr/local/bin/ros_entrypoint.sh
RUN  chmod +x /usr/local/bin/ros_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ros_entrypoint.sh"]
CMD ["/bin/bash"]

RUN sed --in-place --expression \
    '$isource "/opt/catkin_ws/devel/setup.bash"' \
    /usr/local/bin/ros_entrypoint.sh

RUN sh /opt/catkin_ws/src/robot_rest_api/rest/rust/install_all.sh

RUN /bin/bash -c ". /opt/ros/melodic/setup.bash && . /opt/catkin_ws/devel/setup.bash && . ~/.cargo/env && cd /opt/catkin_ws/src/robot_rest_api/rest/rust/robot-rest-api/ && cargo build"

EXPOSE 80
# EXPOSE 3306
# EXPOSE 11311/udp
# EXPOSE 11311/tcp

# ENTRYPOINT roslaunch mir_experiments changes_based_on_tidy_small_room_depth_camera.launch
# CMD ["roslaunch", "mir_experiments", "changes_based_on_tidy_small_room_depth_camera.launch"]