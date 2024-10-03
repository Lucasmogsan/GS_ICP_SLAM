XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

# Run Docker container
docker run -d -it --gpus all --privileged --network=host --shm-size=15G \
    --device=/dev \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=$XAUTH \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    -v ./..:/home/GS_ICP_SLAM \
    --name gsicp_exp1 \
    gs_icp_slam_image