# Cloud HyperASHS Tutorial: T2-MRI

This tutorial uses the **HyperASHS-PMC** service. Make sure that your [MRI data is compatible](../mri-data/t2-t1-model.md) with this model. The procedure is the same for the **HyperASHS-HSG-Body** service.

!!! note
    To use this service, you need [ITK-SNAP](http://www.itksnap.org/pmwiki/pmwiki.php?n=Downloads.SNAP3) 3.8 or later.

## 1. Create an ITK-SNAP workspace

To send your images to the cloud, you need to create an ITK-SNAP workspace that contains the T2-weighted and T1-weighted images.

- Open ITK-SNAP
- Use `File->Open Main Image...` to load the **T2-weighted image** as the main image
- Use `File->Add Another Image...` to load the **T1-weighted image** as the secondary image
- Save the ITK-SNAP workspace to a file using `Workspace->Save Workspace`

HyperASHS registers the T1w image to the T2w image automatically, so you don't need to align them first.

<figure markdown>
![ITK-SNAP with T2 and T1 images loaded](../../assets/images/ashs/cloud_t2_1.png)
<figcaption>ITK-SNAP with a T2-weighted image loaded as the main image and the T1-weighted image loaded as the additional image.</figcaption>
</figure>

## 2. Log in to the Distributed Segmentation Service (DSS)

Next, you need to log in to the DSS server. This requires a Google account.

- Open the DSS window using `Tools->Distributed Segmentation Service`
- Select the "Connect" tab if it is not already selected
- Press the **Get Token** button. This opens a web browser at the DSS login page, shown below.
    - Follow the login prompts on the website. Once you log in with your Google account, you will see a 40-character **login token**. Copy the token and paste it back into ITK-SNAP.
- The ITK-SNAP DSS window should show an updated status, in green, indicating that you have logged in
    - The next time you open ITK-SNAP on the same device, your login information will be remembered.

<div class="fig-row" markdown>
<figure markdown>
![DSS window, connect tab](../../assets/images/ashs/cloud_dss_connect.png)
<figcaption>The ITK-SNAP DSS window, configuration tab. Press "Get Token" to log in.</figcaption>
</figure>
<figure markdown>
![DSS login web page](../../assets/images/ashs/cloud_dss_login.png)
<figcaption>The login web page. Paste the token into ITK-SNAP.</figcaption>
</figure>
</div>

## 3. Upload your workspace and create a ticket

In this step, you send your workspace to the cloud for segmentation with HyperASHS.

- Select the "Submit" tab in the ITK-SNAP DSS window
- Select the **HyperASHS-PMC** service from the list (or **HyperASHS-HSG-Body**)
- In the table of "tags", make sure that the correct images are assigned to the "T2-MRI" and "T1-MRI" tags
- Press **Submit**. The workspace will be uploaded to the server and a new ticket will be created.

## 4. Monitor ticket status

Once a ticket is created, the DSS window switches to the "Results" tab, where you can monitor the progress of your ticket. While the ticket is being processed, you can close ITK-SNAP or submit additional tickets.

- Your ticket is highlighted in the list of tickets on the left of the window, and its progress is shown on the right.
- Note the status of your ticket:
    - **ready**: the ticket has been uploaded and is in the queue to be processed
    - **claimed**: the ticket is being processed
    - **success**: the ticket was processed successfully and results are available
    - **failed/timed out**: an error occurred while servicing the ticket
- Once your ticket is in the **claimed** state, log messages show the progress of the segmentation. Some log messages have attachments: the registration and segmentation [QC images](../usage.md#quality-control). Click the attachment button to list the attachments and open them in a web browser.
- To abort ticket processing, press the **Delete** button

## 5. Download and examine the results

Once a ticket completes successfully, you can download the results as an ITK-SNAP workspace.

- Select a ticket that is in the **success** state and press the **Download** button
- Choose where to save the result workspace and whether to open it after downloading
- Use the Layer Inspector in ITK-SNAP (`Tools->Layer Inspector`) to see the segmentation layers in the workspace

See [Outputs](../usage.md#outputs) for a description of the HyperASHS results.
