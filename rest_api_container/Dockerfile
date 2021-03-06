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

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y \
    apache2 \
    apache2-bin \
    apache2-utils \
    libaio1 \
    libaprutil1-dbd-sqlite3 \
    libaprutil1-ldap \
    libcgi-fast-perl \
    libhtml-parser-perl \
    libencode-locale-perl \
    libevent-core-2.1-6 \
    libfcgi-perl \
    libhtml-tagset-perl \
    libhtml-template-perl \
    libhttp-date-perl \
    libcgi-pm-perl \
    libhttp-message-perl \
    libio-html-perl \
    liblua5.2-0 \
    liblwp-mediatypes-perl \
    liburi-perl \
    libxfont2 \
    libxkbfile1 \ 
    mysql-client-5.7 \
    mysql-client-core-5.7 \
    mysql-server-5.7 \
    mysql-server-core-5.7 \
    psmisc \
    ssl-cert \
    x11-xkb-utils \
    xfonts-base \
    xfonts-encodings \
    xfonts-utils \
    xserver-common \
    xvfb \
    mysql-server \
    ros-cmake-modules \
    python-websocket \
    python-bson \
    python-matplotlib \
    python-tornado \
    google-mock \
    blt \
    fonts-lyx \
    libjs-jquery-ui \
    python-backports.functools-lru-cache \
    python-cycler \
    python-matplotlib-data \
    python-subprocess32 \
    python-tk \
    python-tz \
    ttf-bitstream-vera \
    tk8.6-blt2.5 \
    python-gnupg \
    python-pycryptodome \
    libnotify4 \
    libwxbase3.0-0v5 \
    libwxgtk3.0-gtk3-0v5 \
    python-paramiko \
    python-wxgtk3.0 \
    python-wstools \
    python-wxversion \
    fonts-liberation \
    graphviz \
    libann0 \
    libcdt5 \
    libgvc6 \
    libgvpr2 \
    liblab-gamut1 \
    libpathplan4 \
    python-backports-abc \
    python-singledispatch \
    python-pyqt5.qtsvg \
    python-bson-ext 
    
# ros-melodic-rospy-message-converter

RUN mkdir -p /opt/catkin_ws/src/robot_rest_api

COPY --from=middleman robot_rest_api /opt/catkin_ws/src/robot_rest_api
RUN apt-get install -y \
        build-essential \
        git \
        python-rosdep && \
    rosdep init && \
    rosdep update && \
    cd /opt/catkin_ws/src && \
#    git clone https://github.com/matplotlib/matplotlib && \
    git clone https://github.com/GT-RAIL/rosauth && \
#    git clone https://github.com/tornadoweb/tornado && \
    git clone https://github.com/qt/qtbase && \
#    git clone https://github.com/orocos/orocos_kinematics_dynamics && \
    git clone https://github.com/ros-visualization/rqt_robot_steering && \
#    git clone https://github.com/tu-darmstadt-ros-pkg/hector_slam && \
    cd ../ && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_make"  

RUN cd /opt/catkin_ws/src && \
    git clone https://github.com/uos/rospy_message_converter && \
    git clone https://github.com/ros-perception/perception_pcl -b 1.7.2 && \
    git clone https://github.com/ros-perception/pcl_msgs -b 0.3.0 && \
    git clone https://github.com/locusrobotics/robot_navigation -b melodic && \
    git clone https://github.com/OctoMap/octomap_mapping -b kinetic-devel && \
    git clone https://github.com/ros-teleop/twist_mux && \
    git clone https://github.com/roboskel/roboskel_msgs && \
    git clone https://github.com/UVrobot/mir_robot && \
    git clone https://github.com/gstavrinos/mir_experiments && \
    git clone https://github.com/UVrobot/ros_rvv && \
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
#    rosdep install --from-paths src --ignore-src -r -y && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; catkin_make --pkg roboskel_msgs" && \
    /bin/bash -c "source /opt/ros_ws/melodic/install_isolated/setup.bash; source /opt/catkin_ws/devel/setup.bash; catkin_make" && \
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

#RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash&& . /opt/catkin_ws/devel/setup.bash && . ~/.cargo/env && cd /opt/catkin_ws/src/robot_rest_api/rest/rust/robot-rest-api/ && cargo build"

EXPOSE 80
# EXPOSE 3306
# EXPOSE 11311/udp
# EXPOSE 11311/tcp

# ENTRYPOINT roslaunch mir_experiments changes_based_on_tidy_small_room_depth_camera.launch
# CMD ["roslaunch", "mir_experiments", "changes_based_on_tidy_small_room_depth_camera.launch"]

