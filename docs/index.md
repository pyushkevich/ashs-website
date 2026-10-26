---
title: Home
hide:
  - navigation
  - toc
---

<div class="hero" markdown>
<div markdown>

# ASHS: Automatic Segmentation of Hippocampal Subfields

<p class="tagline">Software for segmenting hippocampal subfields and medial temporal lobe subregions in brain MRI, from the Penn Image Computing and Science Laboratory.</p>

[Get started with HyperASHS](hyperashs/quick-start.md){ .md-button .md-button--primary }
[Looking for ASHS Classic?](ashs/index.md){ .md-button }

</div>
<div markdown>
![3D rendering of a HyperASHS segmentation](assets/images/hyperashs/home_3d_pmc.png)
</div>
</div>

!!! tip "New in 2026: HyperASHS"
    HyperASHS is an all-new version of ASHS. It produces **isotropic-resolution** segmentations, it's **Python-based** and runs on a single GPU workstation, and its T2w + T1w and T1w-only models use a **unified protocol**. HyperASHS is described in our new paper in *NeuroImage*: [Li et al., 2026](https://doi.org/10.1016/j.neuroimage.2026.122294).

## Which version should I use?

<div class="grid cards" markdown>

-   **[HyperASHS](hyperashs/index.md)** · *recommended*

    ---

    - Deep learning (nnU-Net) trained on isotropic, INR-upsampled atlases
    - Segmentations at ~0.4 mm isotropic resolution
    - T2w + T1w or T1w-only models with a unified protocol
    - `pip install hyperresashs`. About 3 minutes per subject on an NVIDIA GPU

    [Quick Start](hyperashs/quick-start.md) · [Installation](hyperashs/installation.md) · [Usage](hyperashs/usage.md)

-   **[ASHS Classic](ashs/index.md)**

    ---

    - Multi-atlas segmentation with joint label fusion and corrective learning
    - Segmentations at the resolution of the T2w MRI
    - Runs in the cloud through ITK-SNAP, or locally on Linux/MacOS
    - Used in many published studies and in ADNI

    [Quick Start](ashs/quick-start.md) · [Cloud ASHS](ashs/cloud/index.md) · [Local ASHS](ashs/local/installation.md)

</div>

Both versions segment the same structures: hippocampal subfields, or anterior/posterior hippocampus in T1w MRI, and the MTL cortical subregions (entorhinal cortex, Brodmann areas 35 and 36, and parahippocampal cortex). Use the **HyperASHS / ASHS Classic** switch at the top of every page to move between the two sets of documentation.

## About us

ASHS and HyperASHS are developed by members of the [Penn Image Computing and Science Laboratory (PICSL)](https://picsl.upenn.edu/) in the Department of Radiology at the University of Pennsylvania. Please see [Citations](resources/citations.md) for the papers to cite, and join the [mailing list](resources/mailing-list.md) for updates and help.

Research reported on this website was supported by the National Institutes of Health under award numbers R01-AG056014, R01-AG037376, and R01-EB017255. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.
