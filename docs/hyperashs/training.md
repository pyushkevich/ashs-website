# Training a HyperASHS Model

## Overview

The pre-trained HyperASHS models each follow a specific segmentation protocol and are optimized for a specific MRI protocol. If you want to label MTL structures following another protocol, or your MRI scans differ substantially from ours, you can train your own model from a set of manually segmented scans. This is the HyperASHS counterpart of [building an ASHS atlas](../ashs/local/atlas-t2.md), and **existing ASHS atlases can be reused as HyperASHS training sets**.

Training runs in five stages:

1. **Preprocessing:** neck trimming, T1w-to-T2w registration, and extraction of a patch around each hippocampus
2. **INR upsampling:** an implicit neural representation is fitted to each subject's T2w MRI, T1w MRI and manual segmentation, and sampled at nearly isotropic resolution
3. **nnU-Net preparation:** resampling, cropping and formatting of the upsampled training data for nnU-Net
4. **nnU-Net training:** five-fold training of the segmentation network, separately for each side
5. **Finalize:** packaging of the trained networks into a model directory that `hrashs run` can use

## Required data

You need a set of about 20–30 manually segmented subjects, with:

- T1-weighted whole-brain MRI for each subject in NIfTI format
- T2-weighted oblique coronal MRI for each subject in NIfTI format
- Manual segmentations of the left and right MTL structures in the space of the T2-MRI, in NIfTI format
    - Each voxel should be assigned a numerical label, with label 0 representing background

You also need a Linux computer with an NVIDIA GPU. Unlike ASHS Classic, a cluster is not required, but a cluster with GPUs makes it possible to run INR upsampling and nnU-Net training for several subjects or folds in parallel (see `-F` below).

## Preparing the data

Training a model requires three files, plus an optional fourth:

1. Configuration file (required)
2. Data manifest file (required)
3. Label description file (required)
4. Cross-validation file (optional)

### Configuration file (`-c`)

A YAML file with model metadata and training parameters:

```yaml
metadata:
  id: 'MyAtlas'
  name: 'My Custom Atlas'
  version: '1.0.0'
config:
  EXP_NUM: 401                                  # Unique experiment number
  MODEL_NAME: 'IsotropicSeg'                    # Model name
  TRAINER: 'ModAugPartialCoverageUNetTrainer'   # nnU-Net trainer class
  CONDITION: 'in_vivo'                          # Condition identifier
  UPSAMPLING_METHOD: 'INRUpsampling'
  SIDES:
    - left
    - right
```

The following parameters can be set in the `config` section:

`EXP_NUM`
:   A unique numeric key for this experiment. The nnU-Net dataset is named `Dataset<EXP_NUM>_<MODEL_NAME>`.

`TRAINER`
:   Name of the nnU-Net trainer class used for training. This is important because it determines the **type of augmentation used**. `ModAugUNetTrainer` uses modality augmentation: modalities are occasionally left out during training, which forces the model to learn from all available modalities. `ModAugPartialCoverageUNetTrainer` adds augmentation for partial coverage, which may make the model more robust for slab TSE images. Other trainers provided by nnU-Net, or included in the `hyperresashs/submodules/nnUNet/nnunetv2/training/nnUNetTrainer/variants/data_augmentation` folder, can also be specified.

`UPSAMPLING_METHOD`
:   How images and segmentations are upsampled during training. `INRUpsampling` uses an implicit neural representation to upsample the segmentations to isotropic or nearly isotropic resolution. This is recommended for highly anisotropic TSE scans and manual segmentations. Other options are `None`, for no upsampling, and `GreedyUpsampling`, for faster upsampling based on Gaussian smoothing and voting (not recommended).

`TARGET_SPACING`
:   The resolution to which images are upsampled when using `INRUpsampling`. By default (value `0.0`), the resolution is determined from the TSE image, making the image isotropic or nearly isotropic. For example, an image with `0.4x0.5x2.0` resolution would be upsampled to `0.4x0.5x0.4`. You can also specify a target resolution, either as a vector (`0.4x0.4x0.4`) or as a single number (`0.4`).

`SIDES`
:   When left and right structures are segmented by separately trained nnU-Net networks (e.g., the medial temporal lobe), this should be a list containing `left` and `right`. For structures that are not split by hemisphere (e.g., the brainstem), use `mid`.

`MODEL_NAME`
:   Name of the model used for segmentation. Currently only `IsotropicSeg` is supported.

`CONDITION`
:   Should be `in_vivo`.

### Data manifest file (`-m`)

A CSV file listing the training cases. Paths can be absolute or relative to the manifest file:

```text
id,date,mprage,tse,seg_left,seg_right
subj01,2024-01-15,subj01/mprage.nii.gz,subj01/tse.nii.gz,subj01/seg_left.nii.gz,subj01/seg_right.nii.gz
subj02,,subj02/mprage.nii.gz,subj02/tse.nii.gz,subj02/seg_left.nii.gz,subj02/seg_right.nii.gz
```

The required columns are `id`, `mprage`, `tse`, `seg_left` and `seg_right`. The `date` column is optional.

### Label description file (`-l`)

The label description file specifies the name and color of each label in your protocol, in ITK-SNAP format. The best way to create it is with ITK-SNAP:

1. Load your T2-weighted MRI in ITK-SNAP (`File->Open Main Image`)
2. Load your left or right segmentation (`Segmentation->Open Segmentation`)
3. Open the label editor (`Tools->Label Editor`)
4. Specify a name and a color for each of the labels used in your segmentation
5. Save your labels to a file (`Segmentation->Export Label Descriptions`)

The file should look like this:

```text
# IDX   -R-  -G-  -B-  -A--  VIS MSH  LABEL
   0     0    0    0    0    0   0    "Clear Label"
   1   255    0    0    1    1   1    "CA1"
   2     0  255    0    1    1   1    "CA2"
```

If you are converting an existing ASHS atlas, use the `snap/snaplabels.txt` file from the atlas package.

### Cross-validation file (`-x`)

An optional text file in which each line lists the subject IDs held out in one fold, separated by spaces:

```text
subj01 subj02 subj03
subj04 subj05 subj06
subj07 subj08 subj09
```

If this file is not provided, a random five-fold split is used.

## Training the model

Run all stages of training with:

```bash
hrashs train -c atlas.yaml -m manifest.csv -l labels.txt -w ./training -t 8
```

**Required arguments:**

| Option | Description |
|---|---|
| `-c, --config` | Path to the training configuration YAML file |
| `-m, --manifest` | Path to the manifest CSV describing the training data |
| `-l, --labels` | Path to the ITK-SNAP label description file |
| `-w, --workdir` | Output directory for training artifacts |

**Optional arguments:**

| Option | Description |
|---|---|
| `-x, --xval` | Cross-validation fold file (if not provided, a random five-fold split is used) |
| `-s, --stage` | Run specific stage(s): `1` (preprocess), `2` (INR), `3` (nnU-Net prep), `4` (nnU-Net train), `5` (finalize), or ranges like `1-3` |
| `-F, --filter` | Regular expression that restricts a stage to some of the data. In stage 1 it is matched to the subject ID and date; in stage 2, to the subject ID, date and side; in stage 4, to the fold number (0–4). It is ignored in stage 3 |
| `-R, --inr-random-seed` | Random seed for the INR optimization; use it to rerun failed INR experiments |
| `--inr-batch-size` | INR batch size [default: 2000] |
| `--inr-epochs` | INR training epochs [default: 60] |
| `-t`, `--device`, `-N`, `-L`, `-T`, `-k` | Same as for [`hrashs run`](usage.md#3-run-segmentation) |

Stages 2 and 4 are the slowest. You can split them into independent jobs with `-F`, for example to train each fold on a different GPU:

```bash
hrashs train -c atlas.yaml -m manifest.csv -l labels.txt -w ./training -s 1-3 -t 8
for fold in 0 1 2 3 4; do
  CUDA_VISIBLE_DEVICES=$fold hrashs train -c atlas.yaml -m manifest.csv -l labels.txt \
    -w ./training -s 4 -F "^${fold}$" &
done
wait
hrashs train -c atlas.yaml -m manifest.csv -l labels.txt -w ./training -s 5
```

## Examining the output and using the model

The working directory is organized as follows:

```text
workdir/
├── preproc/           # Preprocessed images per subject
├── inr_training/      # INR training data and outputs
├── nnunet_training/   # nnU-Net datasets and trained models
└── final/             # Final trained model, ready for deployment
```

Before training the networks, check the INR-upsampled segmentations in `inr_training/` in ITK-SNAP. They should follow the manual segmentation closely in the T2w slice plane, and be smooth along the slice direction.

When training completes, `final/atlas/` contains the model directory. To use your model, pass this directory to `hrashs run`:

```bash
hrashs run -a ./training/final/atlas -g t1.nii.gz -f t2.nii.gz -I sub01 -w ./output/sub01
```

To share your model, you can upload it to the Hugging Face Hub with `hrashs upload`.
