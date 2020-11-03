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

RUN apt-get install -y ros-melodic-turtlebot3*
RUN apt-get install -y ros-melodic-gmapping
COPY ros_entrypoint.sh /usr/local/bin/ros_entrypoint.sh

# RUN touch /usr/local/bin/ros_entrypoint.sh
RUN  chmod +x /usr/local/bin/ros_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ros_entrypoint.sh"]
CMD ["/bin/bash"]

# RUN sed --in-place --expression \
#     '$isource "/opt/catkin_ws/devel/setup.bash"' \
#     /usr/local/bin/ros_entrypoint.sh

RUN /bin/bash -c ". /opt/ros_ws/melodic/install_isolated/setup.bash ; . /opt/ros/melodic/setup.bash"
RUN export TURTLEBOT3_MODEL=burger
ENV TURTLEBOT3_MODEL=burger
RUN rosdep init && \
    rosdep update
# CMD ["gzserver"]
EXPOSE 80
EXPOSE 11345