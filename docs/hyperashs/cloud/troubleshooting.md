# Troubleshooting Cloud HyperASHS

If a ticket fails or the results look wrong:

- Check that your data meet the requirements of the model behind the service you selected ([T2w + T1w models](../mri-data/t2-t1-model.md), [T1w-only model](../mri-data/t1-model.md)).
- Check that the images are assigned to the right tags ("T2-MRI", "T1-MRI") in the Submit tab.
- Open the registration QC attachments in the ticket log (see step 4 of the [T2-MRI tutorial](t2-mri.md#4-monitor-ticket-status)) to see whether the T1w and T2w scans were aligned. If registration failed, you can [run HyperASHS locally](../usage.md#registration-options) with your own T1w-to-T2w transform.
- Ask on the [ashs-users mailing list](../../resources/mailing-list.md). Please include the ticket number.
