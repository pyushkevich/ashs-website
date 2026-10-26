# Cloud HyperASHS Command-Line Tutorial

This tutorial uses the **HyperASHS-PMC** service. Make sure that your [MRI data is compatible](../mri-data/t2-t1-model.md) with this model. For T1-weighted MRI only, use the **HyperASHS-PMC-T1** service and leave out the T2 image.

## 1. Create an ITK-SNAP workspace

We assume that your MRI scans are named `t2_oblique.nii` and `t1_wholebrain.nii` and that these files are in the current directory. Create a workspace containing these files and save it as `mywork.itksnap`:

```bash
itksnap-wt -layers-set-main t2_oblique.nii -tags-add T2-MRI \
           -layers-add-anat t1_wholebrain.nii -tags-add T1-MRI \
           -layers-list -o mywork.itksnap
```

For the T1-only service, create a workspace with just the T1 image:

```bash
itksnap-wt -layers-set-main t1_wholebrain.nii -tags-add T1-MRI -o mywork.itksnap
```

## 2. Obtain a login token for ITK-SNAP DSS

Before you can send tasks to the Distributed Segmentation Service (DSS), you need to authenticate:

```bash
itksnap-wt -dss-auth https://dss.itksnap.org
```

Follow the link printed on the command line, log in using your Google account, and paste the token from the web page back into the command-line prompt.

## 3. Create a ticket

List the services currently available on the cloud:

```bash
itksnap-wt -dss-services-list
```

Then send the workspace to the cloud and create a numbered "ticket". You can give the service by name or by the unique code in the second column of the listing:

```bash
itksnap-wt -i mywork.itksnap -dss-tickets-create HyperASHS-PMC
```

If successful, the number of the ticket is printed after the `2>` prompt.

## 4. Monitor ticket status

```bash
itksnap-wt -dss-tickets-wait [ticket-id]
```

This command does not return until the ticket has finished. It shows log messages and links to the QC images. Enter `0` after the ticket ID to return immediately. Interrupting it with ++ctrl+c++ does not stop the processing of your ticket.

## 5. Download the results

```bash
itksnap-wt -dss-tickets-download [ticket-id] [directory]
```

The results are saved as a `ticket_XXXX.itksnap` workspace that can be opened in ITK-SNAP. See [Outputs](../usage.md#outputs) for a description of the HyperASHS results.

## Processing many subjects

These commands can be combined in a script. For example, to submit one ticket per subject:

```bash
for id in $(cat subjects.txt); do
  itksnap-wt -layers-set-main data/${id}_t2.nii.gz -tags-add T2-MRI \
             -layers-add-anat data/${id}_t1.nii.gz -tags-add T1-MRI \
             -o ws/${id}.itksnap
  itksnap-wt -i ws/${id}.itksnap -dss-tickets-create HyperASHS-PMC
done
```

For large studies, please [install HyperASHS locally](../installation.md) instead.
