# Building an Atlas for T1-MRI

## Overview

Building an atlas for T1-MRI is similar to [building one for T2-MRI](atlas-t2.md). This tutorial shows how to use the ASHS training pipeline to build your own atlas for T1-weighted MRI. The organization of the ASHS software is shown on the [T2-MRI page](atlas-t2.md#overview).

## Required data

You need a set of 20 or so manually segmented MRI scans with:

- T1-weighted whole-brain MRI for each subject in NIfTI format
- Manual segmentation of the structures of interest in the T1-MRI in NIfTI format
    - Each voxel should be assigned a numerical label, with label 0 representing background.

A Linux cluster with Sun Grid Engine (SGE) is **required** to build an ASHS atlas package. Building a package is a time-consuming process that may take a day or so on a cluster, and would take weeks or months on a personal workstation.

### How many subjects?

There is no definitive answer to this question yet. However, our experience suggests that you should include 20–30 subjects to achieve good results. If you plan to study a heterogeneous population (e.g., some controls and some patients), it is best to include representative examples from each group in the atlas set.

For optimal performance, your cluster should be able to run twice as many jobs in parallel as there are subjects.

## Preparing the data

All the input images should satisfy the requirements described in [MRI Data](../mri-data/pmc-t1-atlas.md).

Building an atlas package also requires the following files, each described below:

1. Data manifest file (required)
2. Label description file (required)
3. Configuration file (optional)
4. Cross-validation file (optional)

### Data manifest file

The data manifest file is a text file that describes the data used to build the atlas. Each row corresponds to one subject and contains 5 entries, separated by spaces:

1. Subject ID (no spaces)
2. Path to the T1-weighted MRI in NIfTI format
3. **The same path to the T1-weighted MRI again**
4. Path to the left MTL segmentation in NIfTI format
5. Path to the right MTL segmentation in NIfTI format

No entry may contain spaces. Here is an example manifest file:

```text
XZY001 data/xzy001_t1.nii data/xzy001_t1.nii seg/xzy001_l.nii seg/xzy001_r.nii
XZY002 data/xzy002_t1.nii data/xzy002_t1.nii seg/xzy002_l.nii seg/xzy002_r.nii
```

To avoid errors, we recommend using full paths in the manifest file (the example above uses relative paths for brevity).

### Label description file

The label description file specifies the names of the anatomical labels used in your protocol, as well as the colors used when generating figures. Create it with the ITK-SNAP label editor, as described on the [T2-MRI page](atlas-t2.md#label-description-file). The saved file should look like this:

```text
################################################
# ITK-SnAP Label Description File
# File format:
# IDX   -R-  -G-  -B-  -A--  VIS MSH  LABEL
################################################
    0     0    0    0        0  0  0    "Clear Label"
    1   255    0    0        1  1  1    "Hippocampus"
    2     0  255  255        1  1  1    "EC"
    3   255    0  255        1  1  1    "PRC"
    4   255  239  213        1  1  1    "Cyst"
```

### Configuration file (optional)

You should not need your own configuration file if the T1-MRI has ~1.0 × 1.0 × 1.0 mm³ resolution, covers the whole brain, and the structures are < 5 cm³ in volume. Otherwise, copy the default configuration file and edit it as described on the [T2-MRI page](atlas-t2.md#configuration-file-optional):

```bash
cp $ASHS_ROOT/bin/ashs_config.sh work/my_ashs_config.sh
```

### Cross-validation file (optional)

The cross-validation file has the same format as for [T2-MRI atlases](atlas-t2.md#cross-validation-file-optional).

## Building the atlas

To build the atlas, run `ashs_train.sh`, ideally from a small script such as `runme.sh`:

```bash
#!/bin/bash
# Script for running ASHS training pipeline
$ASHS_ROOT/bin/ashs_train.sh \
  -D manifest.txt \
  -L snaplabels.txt \
  -w /home/pauly/work/ashs/testatlas \
  -Q \
  | tee ashs_train.log
```

- `-D` specifies the manifest file
- `-L` specifies the label description file
- `-w` gives the working directory where the atlas will be created
- `-Q` specifies that atlas building runs in parallel on a cluster that uses the Grid Engine (qsub) scheduling system

To provide your own configuration and cross-validation files, use the options `-C` and `-x`, respectively:

```bash
#!/bin/bash
# Script for running ASHS training pipeline
$ASHS_ROOT/bin/ashs_train.sh \
  -D manifest.txt \
  -L snaplabels.txt \
  -w /home/pauly/work/ashs/testatlas \
  -Q \
  -C my_config.sh \
  -x my_xval.txt \
  | tee ashs_train.log
```

Then launch your script with `nohup`:

```bash
nohup bash ./runme.sh &
```

## Examining the output and using the atlas

When atlas building completes, the `final` folder in the working directory is the atlas package. See [Examining the output](atlas-t2.md#examining-the-output-and-using-the-atlas) on the T2-MRI page for what it should contain. To use your atlas, pass the path to the `final` directory to `ashs_main`, supplying the T1-weighted MRI to both the `-g` and `-f` options (see [Basic Usage](usage.md)).
