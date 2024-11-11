<div align=center>

# RGBD GS-ICP SLAM (100FPS Gaussian Splatting SLAM)

[Seongbo Ha](https://riboha.github.io), [Jiung Yeon](https://humdrum-balance-b8f.notion.site/Jiung-Yeon-6754922a22814c9a95af88801a96fb4b), Hyeonwoo Yu

<h3 align="center"> ECCV 2024 </h3>

[Paper](https://arxiv.org/abs/2403.12550) | [Video](https://www.youtube.com/watch?v=e-bHh_uMMxE&t)

![github (1)](https://github.com/Lab-of-AI-and-Robotics/GS_ICP_SLAM/assets/34827206/5722e8f4-165d-4093-8064-a7ed5d9ea008)

</div>

This repository is intended to substantiate the results reported in the paper. Additional features including visualization tools will be updated soon!

## Environments
Install requirements
```bash
conda create -n gsicpslam python==3.9
conda activate gsicpslam
conda install pytorch==2.0.0 torchvision==0.15.0 torchaudio==2.0.0 pytorch-cuda=11.8 -c pytorch -c nvidia
pip install -r requirements.txt
```
Also, PCL is needed for fast-gicp submodule.

Install submodules

```bash
conda activate gsicpslam
pip install submodules/diff-gaussian-rasterization
pip install submodules/simple-knn

cd submodules/fast_gicp
mkdir build
cd build
cmake ..
make
cd ..
python setup.py install --user
```


## Datasets

- Replica
  - Download
    ```bash
    bash download_replica.sh
    ```
  - Configure
  
    Please modify the directory structure to ours.

    The original structure
    ```bash
    Replica
        - room0
            - results (contain rgbd images)
                - frame000000.jpg
                - depth000000.jpg
                ...
            - traj.txt
        ...
    ```
    Our structure
    ```bash
    Replica
        - room0
            - images (contain rgb images)
                - frame000000.jpg
                ...
            - depth_images (contain depth images)
                - depth000000.jpg
                ...
            - traj.txt
        ...
    ```    

- TUM-RGBD
  - Download
    ```bash
        bash download_tum.sh
    ```

## Run
- Limited to 30 FPS
    ```bash
        # Replica
        bash replica.sh
        # TUM
        bash tum.sh
    ```

- Unlimited tracking speed
    ```bash
        # Replica
        bash replica_unlimit.sh
        # TUM
        bash tum_unlimit.sh
    ```

## Installing SIBR Viewer
```bash
cd SIBR_viewers
cmake -Bbuild . -DCMAKE_BUILD_TYPE=Release
cmake --build build -j24 --target install
```

## Real-time demo
### Using rerun.io viewer

Rerun viewer shows the means of trackable Gaussians, and rendered image from reconstructed 3dgs map.

![GIFMaker_me](https://github.com/Lab-of-AI-and-Robotics/GS_ICP_SLAM/assets/34827206/b4715071-2e4a-4d17-b7a2-612bbd32dbd0)

```bash
python -W ignore gs_icp_slam.py --rerun_viewer
```


### Using SIBR viewer
```bash
python -W ignore gs_icp_slam.py --dataset_path dataset/Replica/office0 --verbose

# In other terminal
cd SIBR_viewers
./install/bin/SIBR_remoteGaussian_app --rendering-size 1280 720
```

## Docker
Please see the README.md in the docker_files folder.


## How to Fork this Repository

Follow the steps below to create a fork of this repository on your GitHub account and clone it to your local machine.

### Step 1: Fork the Repository on GitHub

1. Navigate to the original repository: [GS_ICP_SLAM](https://github.com/Lab-of-AI-and-Robotics/GS_ICP_SLAM).
1. In the upper right corner of the page, click the **Fork** button.
1. Select your GitHub account to create a copy of the repository in your account.

### Step 2: Clone Your Fork Locally

1. After forking, you will be redirected to your new repository (under your GitHub username). Copy the SSH URL (or HTTPS URL) from the repository page.
   - SSH URL: `git@github.com:<your-username>/GS_ICP_SLAM.git`
   - HTTPS URL: `https://github.com/<your-username>/GS_ICP_SLAM.git`
   
1. Open your terminal (or command prompt) and run the following command to clone your forked repository to your local machine:

   ```bash
   git clone git@github.com:<your-username>/GS_ICP_SLAM.git

### Step 3: Set Up Remote for the Original Repository

1. Change into the directory of the cloned repository:
    ```bash
    cd GS_ICP_SLAM
    ```
1. Add the original repository as a remote:
    ```bash
    git remote add upstream git@github.com:Lab-of-AI-and-Robotics/GS_ICP_SLAM.git
    ```
1. Verify that the remotes are set correctly:
1. Add the original repository as a remote:
    ```bash
    git remote -v
    ```
    You should see two remotes listed: origin (your fork) and upstream (the original repository).

### Step 4: Keeping Your Fork Up to Date
To keep your fork synchronized with the original repository:
1. Fetch updates from upstream:
    ```bash
    git fetch upstream
    ```
1. Merge changes into your local main branch:
    ```bash
    git checkout main  # or master, depending on the default branch name
    git merge upstream/main
    ```
1. Push changes to your fork:
    ```bash
    git push origin main
    ```