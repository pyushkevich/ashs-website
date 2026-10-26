# MRI Data

HyperASHS models are trained on MRI scans acquired with a particular protocol, and they work best on scans that look similar. Before running HyperASHS, check that your data meet the requirements of the model you plan to use:

- [T2w + T1w Model Requirements](t2-t1-model.md): T2-weighted MRI (about 0.4 × 0.4 × 2.0 mm³) plus whole-brain T1-weighted MRI, for hippocampal subfields and MTL cortical subregions (`PMC_Atlas`, `HSG_Body_Atlas`).
- [T1w-Only Model Requirements](t1-model.md): whole-brain T1-weighted MRI only, for anterior/posterior hippocampus and MTL cortical subregions (`PMC_T1_Atlas`).

You can also see the expected resolution and coverage of each input for any model with:

```bash
hrashs desc <model_id>
```

HyperASHS reads images in NIfTI format (`.nii` or `.nii.gz`). Convert DICOM data to NIfTI first, for example with [dcm2niix](https://github.com/rordenlab/dcm2niix).

Large, public datasets with suitable T2-weighted MTL scans include [ADNI3](../../ashs/mri-data/adni3.md).
