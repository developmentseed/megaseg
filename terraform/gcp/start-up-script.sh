#!/bin/bash
# General
apt-get update
apt-get -y upgrade 

# Docker
apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
docker run hello-world

# Conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh
eval "$(miniconda3/bin/conda shell.bash hook)"
conda init
source .bashrc

# Conda packages
conda install mamba -n base -c conda-forge -y
mamba install -c conda-forge scikit-learn pandas jupyter ipython -y
mamba create -n megaseg -y
mamba activate megaseg
mamba install pytorch=1.10 torchvision torchaudio cudatoolkit=11.3 -c pytorch -y
mamba install -c fastchan fastai -y
mamba install -c conda-forge ipykernel ipywidgets black isort  jupyterlab_code_formatter -y

# detectron2 for DETR
mamba install -c conda-forge gcc_linux-64
git clone https://github.com/facebookresearch/detectron2.git
python -m pip install -e detectron2

# jupyter
mamba deactivate
mamba install -n base -c conda-forge jupyterlab_widgets jupyterlab nb_conda_kernels -y


# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt-get update
apt-get -y install gh

# CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
apt-get update
apt-get -y install cuda

# NVIDIA docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update
apt-get install -y nvidia-docker2
systemctl restart docker
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
