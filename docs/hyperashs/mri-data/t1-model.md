# MRI Requirements: T1w-Only Model

## Overview

This page describes the MRI data requirements for the HyperASHS `PMC_T1_Atlas` model, which uses only T1-weighted MRI. This model segments the **hippocampus (anterior and posterior)**, the **amygdala** and the **extrahippocampal medial temporal lobe subregions**: entorhinal cortex (ERC), Brodmann areas 35 and 36 (BA35, BA36) and parahippocampal cortex (PHC). Like ASHS-PMC-T1, it also labels the dura mater, which has similar intensity to gray matter in 3T T1-weighted MRI.

This model does not segment hippocampal subfields, because 3T T1-weighted MRI does not have enough contrast and resolution to resolve them. High-resolution T2-weighted MRI and a [T2w + T1w model](t2-t1-model.md) are required for that.

The T1w-only model uses the same segmentation protocol as the T2w + T1w `PMC_Atlas` model, so measures of the MTL cortex can be compared between participants scanned with and without T2w MRI.

## MRI requirements

Your data should meet these specifications:

- **T1-weighted MRI** (e.g., MPRAGE):
    - voxel size of about 1.0 mm × 1.0 mm × 1.0 mm or finer
    - whole brain coverage, not skull stripped
- 3 Tesla field strength

In addition, the model was trained on older adults (55+) and is intended for studies of aging and neurodegenerative disease.

<div class="fig-row" markdown>
<figure markdown>
![T1-weighted input image](../../assets/images/hyperashs/quickstart_pmc_t1_input.png)
<figcaption>Coronal slice of T1-weighted MRI suitable for the PMC_T1_Atlas model.</figcaption>
</figure>
<figure markdown>
![PMC_T1_Atlas segmentation](../../assets/images/hyperashs/quickstart_pmc_t1_seg.png)
<figcaption>HyperASHS segmentation with the PMC_T1_Atlas model.</figcaption>
</figure>
</div>
