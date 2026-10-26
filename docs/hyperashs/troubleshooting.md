# Troubleshooting HyperASHS

## Installation

**`hrashs check` reports problems with PyTorch or CUDA.**
HyperASHS requires PyTorch 2.5.x. Install the PyTorch build that matches your CUDA version, as described under [Advanced setup](installation.md#3-install-pytorch), and then reinstall HyperASHS.

**Segmentation is very slow.**
HyperASHS is probably running on the CPU. Check that `nvidia-smi` lists your GPU and that `hrashs check` finds CUDA. You can force the GPU with `--device cuda`.

**Models cannot be downloaded from Hugging Face (SSL errors).**
If you are behind a corporate or institutional proxy, add the `-k` option to the `hrashs` command to disable SSL verification (see [SSL certificate errors](../resources/troubleshooting.md#ssl-certificate-errors-when-downloading-models)).

## Results

**The segmentation is in the wrong place, or the QC images show misaligned images.**
Check the registration QC images in the `qc` folder. If the T1w and T2w scans are not aligned, register them manually and pass the transform with `--reg-t1t2`, or use `--reg-t1t2-identity` if they are already aligned (see [Registration options](usage.md#registration-options)).

**The segmentation looks blocky.**
You are probably looking at the native-space segmentation (`*_tse_native_seg_*`). Use the hyper-resolution segmentation (`*_tse_patch_hyperres_seg_*`) for measurements (see [Outputs](usage.md#outputs)).

**The T1-only run prints a warning.**
T1-only mode is only recommended for models that do not label hippocampal subfields, such as `PMC_T1_Atlas`.

## Getting help

Ask on the [ashs-users mailing list](../resources/mailing-list.md), or [open an issue on GitHub](https://github.com/pyushkevich/HyperResASHS/issues). Please include the `hrashs` command you ran, the output of `hrashs check`, and the QC images if relevant.
