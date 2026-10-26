# Cloud HyperASHS: Overview

The easiest way to try out HyperASHS is through our web-based Distributed Segmentation Service (DSS), the same system used by [Cloud ASHS](../../ashs/cloud/index.md). You don't need a GPU or any software besides ITK-SNAP. Your images are anonymized, encrypted and sent to a secure server, where they are processed at the Penn Image Computing and Science Laboratory (PICSL) at the University of Pennsylvania. This service is currently provided for free.

## Available services

| DSS service | HyperASHS model | Input MRI |
|---|---|---|
| **HyperASHS-PMC** | [PMC_Atlas](../mri-data/t2-t1-model.md) | T2w + T1w MRI |
| **HyperASHS-PMC-T1** | [PMC_T1_Atlas](../mri-data/t1-model.md) | T1w MRI only |
| **HyperASHS-HSG-Body** | [HSG_Body_Atlas](../mri-data/t2-t1-model.md) ([HSG harmonized protocol](https://hippocampalsubfields.com/)) | T2w + T1w MRI |

## Requirements

- You will need to install [ITK-SNAP](http://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.SNAP4) **4.6 or later**. HyperASHS returns segmentations in a different (finer) voxel space than the T2-weighted MRI, and earlier versions of ITK-SNAP cannot handle this
- You need a Google account (e.g., Gmail) to log in to the server
- Your data must be compatible with the model behind the service you choose (see [MRI Data](../mri-data/index.md))

## GUI or command line?

The easiest way to run HyperASHS in the cloud is with the graphical user interface (GUI) in ITK-SNAP. With just a few clicks you can send your images to the server for processing. Follow one of the tutorials below, depending on what kind of MRI data you want to segment:

- [Cloud HyperASHS GUI tutorial: hippocampal subfields from T2-weighted and T1-weighted MRI](t2-mri.md)
- [Cloud HyperASHS GUI tutorial: medial temporal lobe subregions from T1-weighted MRI only](t1-mri.md)

If you need to process several datasets from a script, use the command-line tool **itksnap-wt**, which is installed as part of ITK-SNAP:

- [Cloud HyperASHS command-line tutorial](command-line.md)

For large projects, please [install HyperASHS locally](../installation.md). Our server is set up to handle only a moderate number of requests.
