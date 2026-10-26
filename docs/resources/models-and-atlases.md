# Models and Atlases

The pre-trained HyperASHS models and the ASHS Classic atlas packages are hosted on [Hugging Face](https://huggingface.co/upennpatchlab), under the `upennpatchlab` account.

## HyperASHS models and templates

!!! tip "You don't need to download these yourself"
    `hrashs run` downloads the model you select, and the template it uses, automatically the first time you use them, and keeps them in a local cache. [Cloud HyperASHS](../hyperashs/cloud/index.md) needs no download at all. The repositories are listed here for reference, for example to read a model's description, check its version, or download models in advance for a computer without internet access.

All HyperASHS repositories are at <https://huggingface.co/upennpatchlab>.

**Segmentation models.** Each repository holds a trained model together with its description (inputs, labels and citations), which you can also view with `hrashs desc`.

| Model ID | Hugging Face repository | Input MRI |
|---|---|---|
| `PMC_Atlas` | [upennpatchlab/hyperresashs_model_pmc_uni_v1](https://huggingface.co/upennpatchlab/hyperresashs_model_pmc_uni_v1) | T2w + T1w |
| `PMC_T1_Atlas` | [upennpatchlab/hyperresashs_model_pmc_uni_t1_v1](https://huggingface.co/upennpatchlab/hyperresashs_model_pmc_uni_t1_v1) | T1w only |
| `HSG_Body_Atlas` | [upennpatchlab/hyperresashs_model_hsg_body_v1](https://huggingface.co/upennpatchlab/hyperresashs_model_hsg_body_v1) | T2w + T1w |

**Templates.** Models use a template to locate and crop the medial temporal lobe (MTL) region in whole-brain MRI. Each model names the template it needs, and `hrashs` downloads it along with the model.

| Template | Hugging Face repository |
|---|---|
| Aging 3T (used by the current models) | [upennpatchlab/hyperresashs_template_aging3t_v1](https://huggingface.co/upennpatchlab/hyperresashs_template_aging3t_v1) |
| CPLEX 3T | [upennpatchlab/hyperresashs_template_cplex3t_v1](https://huggingface.co/upennpatchlab/hyperresashs_template_cplex3t_v1) |
| Whole brain (for tasks that work on the whole brain) | [upennpatchlab/hyperresashs_template_wholebrain_v1](https://huggingface.co/upennpatchlab/hyperresashs_template_wholebrain_v1) |

**Model directory.** [upennpatchlab/hyperresashs_atlas_directory](https://huggingface.co/upennpatchlab/hyperresashs_atlas_directory) lists the models that `hrashs list` shows.

If you [train your own model](../hyperashs/training.md), the `hrashs upload` command can publish it to Hugging Face.

## ASHS Classic atlas packages

ASHS Classic atlas packages can be downloaded from the [upennpatchlab/ashs_atlases](https://huggingface.co/datasets/upennpatchlab/ashs_atlases/tree/main) dataset on Hugging Face, as well as from [NITRC](https://www.nitrc.org/frs/?group_id=370). Unlike HyperASHS models, these must be downloaded and unpacked by hand before running ASHS locally (see [Installation](../ashs/local/installation.md#download-and-install-ashs-atlas-packages)). You don't need them for [Cloud ASHS](../ashs/cloud/index.md).

Each package is a `.tgz` archive of 2–5 GB, named after the atlas and its release date (YYYYMMDD). The dataset includes:

| Package | Atlas |
|---|---|
| `ashs_atlas_upennpmc_20170810.tgz`, `ashs_atlas_upennpmc_20210803.tgz` | [ASHS-PMC](../ashs/mri-data/pmc-atlas.md): Penn Memory Center, 3T T2-weighted MRI |
| `ashs_atlas_upennpmc_t1_20180720.tgz`, `ashs_atlas_upennpmc_t1_20230717.tgz` | [ASHS-PMC-T1](../ashs/mri-data/pmc-t1-atlas.md): Penn Memory Center, 3T T1-weighted MRI |
| `ashs_atlas_upennpmc_t1ext_20240617.tgz` | Penn Memory Center, T1-weighted MRI, extended version |
| `ashs_atlas_abc_prisma_20200406.tgz` | ABC atlas, 3T (Prisma) |
| `ashs_atlas_abc_prisma_7t_20200622.tgz` | ABC atlas, 7T |
| `ashs_atlas_magdeburg_7t_20180416.tgz` | Magdeburg 7T atlas |
| `ashs_atlas_neuropresage_lc_20230331.tgz` | NeuroPresage atlas |

See the README of each package for its segmentation protocol and citation.

To download a single package from the command line, you can use the Hugging Face CLI:

```bash
pip install -U huggingface_hub
hf download upennpatchlab/ashs_atlases ashs_atlas_upennpmc_20210803.tgz \
    --repo-type dataset --local-dir ./atlases
```
