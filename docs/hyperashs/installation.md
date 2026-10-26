# HyperASHS: Installation

## Requirements

- **Linux** with an **NVIDIA GPU** is strongly recommended. Inference can run on the CPU, but takes over an hour per subject, compared with about 3 minutes on a GPU. [Training](training.md) requires a GPU.
- **Python 3.10** or later. We recommend installing HyperASHS in its own [conda](https://docs.conda.io/) environment or Python virtual environment.
- An internet connection the first time you use a model, so that it can be downloaded from [Hugging Face](https://huggingface.co/upennpatchlab).

Unlike ASHS Classic, HyperASHS does not need a computing cluster. Registration and image processing tools ([Greedy](https://sites.google.com/view/greedyreg/home) and [Convert3D](http://itksnap.org/c3d)) are installed automatically as Python packages.

## Easy setup (most users)

### 1. Create a Python environment

Create a new `conda` environment with Python 3.10 or higher:

```bash
conda create -n hyperresashs python=3.10
conda activate hyperresashs
```

Alternatively, create a Python virtual environment:

```bash
cd /my/project/path
python -m venv .venv
source .venv/bin/activate
```

### 2. Install HyperASHS from PyPI

Install the package and all its dependencies:

```bash
pip install hyperresashs
```

### 3. Verify the installation

```bash
hrashs check
```

The command should report that HyperResASHS was successfully installed and print the software version. If you see errors or warnings related to PyTorch and CUDA, follow the instructions for installing PyTorch under [Advanced setup](#advanced-setup-developers) below.

## Advanced setup (developers)

Follow these steps to install HyperASHS from source, or to install a version of PyTorch that matches your CUDA version.

### 1. Create a conda environment

```bash
conda create -n hyperresashs python=3.10
conda activate hyperresashs
```

### 2. Clone the repository

Clone the repository with its submodules:

```bash
git clone --recursive https://github.com/pyushkevich/HyperResASHS.git
cd HyperResASHS
```

If you have already cloned it without submodules, initialize them with:

```bash
git submodule update --init --recursive
```

### 3. Install PyTorch

!!! warning "PyTorch version"
    PyTorch version compatibility is critical. HyperASHS requires PyTorch 2.5.x (tested with 2.5.1). Newer versions (e.g., 2.9) may cause compatibility issues.

For the best performance, install the PyTorch build that matches your CUDA version. To check your CUDA version, type:

```bash
nvidia-smi | grep "CUDA Version"
```

The output will look like this. If you get an error, CUDA is probably not configured on your machine.

```text
| NVIDIA-SMI 535.288.01             Driver Version: 535.288.01   CUDA Version: 12.2     |
```

Then enter the following command, with `cu118` changed to match your CUDA version (e.g., `cu121`):

```bash
pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 \
    --index-url https://download.pytorch.org/whl/cu118
```

### 4. Install HyperASHS

Install the package in editable mode, together with its remaining dependencies:

```bash
pip install -e .
```

### 5. Verify the installation

```bash
hrashs check
```

## Install ITK-SNAP

We also recommend installing [ITK-SNAP](http://itksnap.org/), which can be used to view your images and the segmentation results. The instructions in this documentation assume that ITK-SNAP can be run from the command line by typing `itksnap`.
