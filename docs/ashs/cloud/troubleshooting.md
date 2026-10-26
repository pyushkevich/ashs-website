# Troubleshooting Cloud ASHS

If a ticket fails or the results look wrong:

- Check that your data meet the requirements of the atlas you selected ([ASHS-PMC](../mri-data/pmc-atlas.md), [ASHS-PMC-T1](../mri-data/pmc-t1-atlas.md)).
- Open the QC attachments in the ticket log (see step 4 of the [T2-MRI tutorial](t2-mri.md#4-monitor-ticket-status)) to see whether registration between the template, T1-MRI and T2-MRI succeeded. If the T1 and T2 scans are poorly aligned, register them manually in ITK-SNAP before creating the workspace.
- Ask on the [ashs-users mailing list](../../resources/mailing-list.md). Please include the ticket number.
