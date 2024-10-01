# Running GS_ICP_SLAM with docker and custom dataset

## 1. Clone forked repository
```bash
git clone git@github.com:Lucasmogsan/GS_ICP_SLAM.git
```

## 2. Build docker image
```bash
cd GS_ICP_SLAM/docker
docker build -t gs_icp_slam_image .
```

## 3. Run container
```bash
chmod +x run.sh
./run.sh
```

## 4. Access container
```bash
docker exec -it gsicp_exp1 bash
```
- name of container is set in `run.sh`

## 5. Install submodules (fast_gicp, diff-gaussian-rasterization, simple-knn)
```bash
cd /home/GS_ICP_SLAM/docker
chmod +x install_submodules.sh
./install_submodules.sh    
```

## 6. Run the algorithm with live stream data from a realsense depth camera or jump to 7.
- Connect your realsense depth camera
```bash
python gs_icp_slam_live.py
```
- You can specify the following arguments:
  - `save_images`
  - `save_dir`
  - `stop_after`
  - `fps`

## 7. Create your own custom dataset and config
- Your custom dataset should have the following structure:
```bash
custom_dataset/
├── rgb/
│   ├── frame000000.jpg
│   ├── frame000001.jpg
│   └── ...
├── depth/
│   ├── depth000000.png
│   ├── depth000001.png
│   └── ...
```

- Don't forget to add your config inside `GS_ICP_SLAM/configs/custom/your_caminfo.txt`, which should look similar to this:
``` bash
## camera parameters
H W fx fy cx cy depth_scale depth_trunc dataset_type
1200 680 600.0 600.0 599.5 339.5 6553.5 12.0 custom
```

## 8. Run gs_icp_slam.py
```bash
cd /home/GS_ICP_SLAM
python -W ignore gs_icp_slam.py --dataset_path /path/to/your/dataset --config /path/to/your/config/caminfo.txt --rerun_viewer
python -W ignore gs_icp_slam.py --dataset_path /home/GS_ICP_SLAM/dataset/TUM/rgbd_dataset_freiburg1_desk --config /home/GS_ICP_SLAM/configs/TUM/rgbd_dataset_freiburg1_desk.txt --rerun_viewer
```


## troubleshooting
[rerun docker issue](https://github.com/rerun-io/rerun/issues/6835)

[Nvidia Developer Forum](https://forums.developer.nvidia.com/t/new-computer-install-gpu-docker-error/266084/6)




# OLD:


# Docker
Our Dockerfile contains requirements for either GS-ICP SLAM and SIBR_viewer.

## Requirements
Docker and nvidia-docker2 must be installed.

## Make docker image from Dockerfile
```bash
cd docker_folder
docker build -t gsidocker:latest .
```

## Make GS-ICP SLAM container

When making docker container, users must set 'dataset directory of main environment' and 'shared memory size'.
- Dataset directory of main environment
  - We can link a directory of main environment and that of docker container. So without downloading Replica/TUM dataset in the docker container, we can use datasets downloaded in the main environment.
  - -v {dataset directory of main environment}:{dataset directory of docker container}
- shared memory size
  - The size of shared memory is 4mb in default, and this is not sufficient for our system. When testing, I set this value as 12G and it worked well.

An example command for making a container is shown below.
```bash
# In main environment
docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e USER=$USER \
-e runtime=nvidia -e NVIDIA_DRIVER_CAPABILITIES=all -e NVIDIA_VISIBLE_DEVICES=all \
-v {dataset directory of main environment}:/home/dataset --shm-size {shared memory size} \
--net host --gpus all --privileged --name gsicpslam gsidocker:latest /bin/bash
```

## Install submodules
The fast_gicp submodule may already installed while making docker image from Dockerfile.
So users need to install only 'diff-gaussian-rasterization' and 'simple_knn' submodules.
```bash
# In docker container
cd /home/GS_ICP_SLAM
pip install submodules/diff-gaussian-rasterization
pip install submodules/simple_knn
```

## Edit dataset directory

In our system, the directory of datasets are defined as GS_ICP_SLAM/dataset, so we need to change it to the dataset directory in the docker container.
ex)
replica.sh
```bash
OUTPUT_PATH="experiments/results"
DATASET_PATH="dataset/Replica" #<- Change this to the dataset directory in the docker container
```