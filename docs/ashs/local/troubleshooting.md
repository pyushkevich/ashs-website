# Troubleshooting Local ASHS

If ASHS fails or the results look wrong:

- Check that your data meet the requirements of the atlas you are using ([ASHS-PMC](../mri-data/pmc-atlas.md), [ASHS-PMC-T1](../mri-data/pmc-t1-atlas.md)). In particular, the *x* and *y* dimensions of the T2-weighted image must be larger than the *z* dimension.
- Look at the ASHS output (`nohup.out`) for the first error message.
- Check the QC images in the `qa` subdirectory of the working directory to see whether registration between the template, T1-MRI and T2-MRI succeeded. If the T1 and T2 scans are poorly aligned, register them manually in ITK-SNAP and save the transform in Convert3D format.
- When running on a cluster, make sure that jobs are actually being scheduled (`qstat`), and that each core has enough memory (at least 2GB).
- Ask on the [ashs-users mailing list](../../resources/mailing-list.md).
