# PiiGan

Korean real address-based address generator

source 

https://www.juso.go.kr/openIndexPage.do

https://business.juso.go.kr/addrlink/adresInfoProvd/guidance/othbcAdresInfo.do

# Getting Start

# requires CUDA 8 to be pre-installed
Cuda 8.0
https://developer.nvidia.com/cuda-downloads
libculas
https://developer.nvidia.com/cudnn

```bash
# CUDA 저장소 추가
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update

# CUDA 8.0 설치
sudo apt-get install cuda-8-0
```


# Develop Envirement
WSL2 Ubuntu 20.04.6 LTS, Window10, anaconda python 2.7

# install WSL2
```
window10 1093, powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart 
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2 
```
# Enable NVIDIA CUDA on WSL2
https://learn.microsoft.com/en-us/windows/ai/directml/gpu-cuda-in-wsl

https://docs.nvidia.com/cuda/wsl-user-guide/index.html#getting-started-with-cuda-on-wsl


```
# 1. NVIDIA Driver Install
# 2. WSL2 CUDA Install

```


# Install Anaconda on WSL2
```
wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
sh Anaconda3-2022.10-Linux-x86_64.sh
source ~/.bashrc
```


# Start env in WSL2  (python 2.7 or python 3.6)
```
conda create -n piigan python=2.7
conda activate piigan
pip install -r requirement.txt
```

# use python2.7 or python3.6
Based on python 2.7 fix need for python 3.6
Python2 code style left (ex, print )
```

Python2.7
print "\t{}: {}".format(var_name, var_value)

Python3.6
print("\t{}: {}".format(var_name, var_value))

Python2.7
charmap = pickle.load(f)
for i in xrange(int(args.num_samples / args.batch_size)):

Python3.6
charmap = pickle.load(f, encoding='latin1')
for i in range(int(args.num_samples / args.batch_size)):



```

# Trouble Shooting

## environment variable
```

sudo ./cuda-linux64-rel-8.0.61-21551265.run

export CUDA_HOME=/usr/local/cuda-8.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUDA_HOME/lib64
export PATH=$PATH:$CUDA_HOME/bin


ls /usr/local/cuda-8.0/lib64/ | grep libcudnn
sudo find /usr/ -name "libcudnn*"

echo $LD_LIBRARY_PATH
source ~/.bashrc

```

