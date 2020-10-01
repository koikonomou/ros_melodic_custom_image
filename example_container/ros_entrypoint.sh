#!/bin/bash
set -e

echo "==> Executing master image entrypoint ..."

echo "-> Setting up ROS"
source "/opt/ros_ws/melodic/install_isolated/setup.bash"

echo "==> Container ready"
exec "$@"