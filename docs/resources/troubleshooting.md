# Troubleshooting

This page covers problems common to all versions of ASHS. Each version also has its own troubleshooting page:

| | Cloud | Local |
|---|---|---|
| HyperASHS | [Troubleshooting Cloud HyperASHS](../hyperashs/cloud/troubleshooting.md) | [Troubleshooting HyperASHS](../hyperashs/troubleshooting.md) |
| ASHS Classic | [Troubleshooting Cloud ASHS](../ashs/cloud/troubleshooting.md) | [Troubleshooting Local ASHS](../ashs/local/troubleshooting.md) |

## SSL certificate errors when downloading models

`hrashs` downloads models and templates from [Hugging Face](models-and-atlases.md). On some institutional or corporate networks, a proxy or firewall intercepts secure connections, and the download fails with an error that mentions SSL or certificate verification (for example, `SSLCertVerificationError` or `CERTIFICATE_VERIFY_FAILED`). `hrashs check` reports this as:

```text
SSL certificate verification failed when trying to connect to Hugging Face Hub.
```

To work around this, add the `-k` (`--disable-ssl-verification`) option to the `hrashs` command. It works with `run`, `list`, `desc`, `check`, `train` and `upload`:

```bash
hrashs check -k
hrashs run -k -a PMC_Atlas -g sub01_mprage.nii.gz -f sub01_tse.nii.gz -I sub01 -w ./output/sub01
```

!!! warning
    `-k` turns off the check that you are really connected to Hugging Face. Use it only on a network you trust. The better long-term fix is to ask your IT department for your institution's root certificate and point Python to it, for example with `export REQUESTS_CA_BUNDLE=/path/to/institution-ca.pem`.

## Results look wrong

Most problems with segmentation quality come from the input data or from registration:

- Check that your MRI data meet the requirements of the model or atlas you are using: see MRI Data for [HyperASHS](../hyperashs/mri-data/index.md) or [ASHS Classic](../ashs/mri-data/index.md).
- Look at the registration QC images. If the T1-weighted and T2-weighted scans are not aligned, register them manually in ITK-SNAP.
- When measuring volumes with HyperASHS, use the hyper-resolution segmentation rather than the native-space one (see [Outputs](../hyperashs/usage.md#outputs)).

## Getting help

If none of the above helps, ask on the [ashs-users mailing list](mailing-list.md) or open an issue on [GitHub](source-code.md). Please include:

- the version of ASHS you are using (HyperASHS or ASHS Classic, cloud or local), and the model or atlas;
- the exact command you ran and the error message, or the ticket number for cloud runs;
- the output of `hrashs check` (HyperASHS) and the QC images, if relevant.
