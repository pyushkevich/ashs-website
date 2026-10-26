# MRI Requirements: ASHS-PMC-T1 Atlas

## Overview

This page describes the MRI data requirements for using ASHS with the ASHS-PMC-T1 atlas. This atlas is used to automatically segment the **whole hippocampus (anterior and posterior)** and **extrahippocampal medial temporal lobe subregions**, including entorhinal cortex (ERC), Brodmann areas 35 and 36 (BA35, BA36) and parahippocampal cortex (PHC), together with the dura mater, which has similar intensity to gray matter in 3T T1-weighted MRI (figure below).

The pipeline is not designed for hippocampal subfield segmentation, because 3T T1-weighted MRI does not have enough contrast and resolution to resolve the subfields. High-resolution T2-weighted MRI is required to reliably segment hippocampal subfields automatically.

Please see the following paper for more detail:

*Xie L., Wisse L.E.M., Manjón J.V., Wang H., Das S.R., Wolk D.A., Yushkevich P.A. Accounting for the Confound of Meninges in Segmenting Entorhinal and Perirhinal Cortices in T1-weighted MRI. Medical Image Computing and Computer-Assisted Intervention – MICCAI 2016, pp. 564–571. Springer International Publishing.*

## MRI requirements

To use the ASHS-PMC-T1 atlas, your data must meet these specifications:

- **T1-weighted MRI:**
    - voxel size 1.0 mm × 1.0 mm × 1.0 mm or similar
    - whole brain coverage, not skull stripped

In addition, your subjects should be older adults (55+).

<figure markdown>
![Input data and segmentation for the ASHS-PMC-T1 atlas](../../assets/images/ashs/pmc_t1_input_seg.jpg)
<figcaption>Input data and segmentation for the ASHS-PMC-T1 atlas.</figcaption>
</figure>
