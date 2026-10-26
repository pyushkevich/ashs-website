# Local ASHS: Installation

## Requirements

ASHS requires the Linux or MacOS operating system. For segmenting many subjects and for generating new atlas packages, we recommend installing ASHS on a Linux cluster running [Sun Grid Engine](http://en.wikipedia.org/wiki/Oracle_Grid_Engine) or a compatible scheduler.

You can also run ASHS on a standalone Linux or MacOS workstation using [GNU parallel](https://www.gnu.org/software/parallel/). On an eight-core machine, a single segmentation takes under 30 minutes.

!!! tip
    The easiest way to try out ASHS is to [run ASHS on the cloud](../cloud/index.md).

## Download and install the ASHS software

1. Download the latest release of the ASHS software package from the [NITRC repository](https://www.nitrc.org/frs/?group_id=370). Be sure to download the software itself, under the **fast-ashs** package. The other packages are ASHS atlas sets.

2. Uncompress the software package in the directory of your choice:

    ```bash
    cd /home/pauly/ashs
    unzip ashs-fastashs-20170223.zip
    ```

3. Set up your environment. Users of the bash shell can add the following line to their `.bashrc` file:

    ```bash
    export ASHS_ROOT=/home/pauly/ashs/ashs-fastashs
    ```

    Users of the csh shell should add the following line to their `.cshrc` file:

    ```csh
    setenv ASHS_ROOT /home/pauly/ashs/ashs-fastashs
    ```

4. Verify the installation. Running the scripts **ashs_main.sh** and **ashs_train.sh** with the `-h` option should print the usage instructions for these commands:

    ```console
    $ $ASHS_ROOT/bin/ashs_main.sh -h
    ashs_main: automatic segmentation of hippocampal subfields
    usage:
      ashs_main [options]
    ...
    $ $ASHS_ROOT/bin/ashs_train.sh -h
    ...
    ```

## Download and install ASHS atlas packages

ASHS atlas packages are required to perform segmentation. Different atlas packages are based on different segmentation protocols. Be sure to download an atlas that is compatible with the current version of ASHS (1.0.0 or later). The most commonly used ASHS atlas is:

- The *ASHS UPENN PMC* atlas package (2014 paper), developed in collaboration with Dr. David A. Wolk at the University of Pennsylvania (Penn) Memory Center. It labels subfields along the entire length of the hippocampal formation and includes several cortical regions (PRC/ERC). This atlas package is suitable for labeling **older adult** brains in **3 Tesla** MRI.

Several additional atlases are available (7T older adults, 3T younger adults, 3T older adults hippocampal body only, and 3T older adults for T1-weighted MRI), and are listed on the [Models and Atlases](../../resources/models-and-atlases.md#ashs-classic-atlas-packages) page. Some only work with older ASHS versions.

Some users may prefer to build their own atlas package instead of using one of the packages that we provide. See [Building an Atlas for T2-MRI](atlas-t2.md) or [Building an Atlas for T1-MRI](atlas-t1.md) for details.

To use an existing atlas package:

1. Download the desired atlas package from [Hugging Face](https://huggingface.co/datasets/upennpatchlab/ashs_atlases/tree/main) or [NITRC](http://www.nitrc.org/frs/?group_id=370) to a directory of your choice. See [Models and Atlases](../../resources/models-and-atlases.md#ashs-classic-atlas-packages) for the list of packages.

2. Uncompress the atlas package:

    ```bash
    cd /home/pauly/ashs/atlases
    tar -xvf ashs_atlas_upennpmc_20161128.tar ashs_pmc
    ```

    The atlas package will be created in the subdirectory `ashs_pmc`.

## Download and install ITK-SNAP

We recommend also installing [ITK-SNAP](http://itksnap.org/) on the system. ITK-SNAP can be used to view images and segmentation results. If possible, install ITK-SNAP version 3.6.2 or later, which makes it easy to debug registration problems and to perform manual registration when automatic registration fails.

The instructions in this tutorial assume that ITK-SNAP can be invoked from the command line by entering `itksnap`.
