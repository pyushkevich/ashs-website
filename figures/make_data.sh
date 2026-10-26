#!/bin/bash
# Prepare display volumes for the documentation figures from the outputs of
# 'hrashs run' on the example subject (T1+T2 and T1-only).
#
# The hyper-resolution segmentations live on their own ~0.4mm grids. ITK-SNAP
# displays everything in the space of the main image, so for figures we
# resample the anatomical images to ~0.4mm and reslice the left and right
# hyper-res segmentations into the same grid as a single label image.
#
# Usage: make_data.sh [for_docs_dir] [work_dir]
set -euo pipefail

FIGDIR=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "${1:-$FIGDIR/../../for_docs}" && pwd)
WORK=${2:-$FIGDIR/work}
C3D=${C3D:-c3d}
WT=${WT:-$HOME/tk/itksnap/xc64rel/Utilities/Workspace/itksnap-wt}
PYTHON=${PYTHON:-python3}

mkdir -p "$WORK/pmc" "$WORK/pmc_t1"

# Clip an image (in place) a little above the 99.9th percentile of its
# intensities inside a segmentation. ITK-SNAP's default contrast spans the
# whole intensity range, so without this the bright CSF and vessels in the
# TSE leave the MTL tissue nearly black.
window()
{
  local img=$1 seg=$2
  local hi=$("$PYTHON" -c '
import sys, numpy as np, SimpleITK as sitk
a = sitk.GetArrayFromImage(sitk.ReadImage(sys.argv[1]))
m = sitk.GetArrayFromImage(sitk.ReadImage(sys.argv[2])) > 0
print(round(1.1 * np.percentile(a[m], 99.9)))' "$img" "$seg")
  $C3D "$img" -clip 0 "$hi" -type short -o "$img"
}
TSE=$SRC/tse_3t_n4.nii.gz
T1=$SRC/mprage_3T_bet.nii
P=hsg_test

# Original inputs (used by figures that show the data as the user sees it)
cp "$TSE" "$WORK/pmc/tse.nii.gz"
$C3D "$T1" -type short -o "$WORK/pmc/mprage.nii.gz"
cp "$WORK/pmc/mprage.nii.gz" "$WORK/pmc_t1/mprage.nii.gz"

# T1+T2: copy native-space results and the label file
for side in left right; do
  cp "$SRC/t2_t1/${P}_tse_native_seg_${side}.nii.gz" "$WORK/pmc/native_seg_${side}.nii.gz"
  cp "$SRC/t2_t1/${P}_tse_patch_hyperres_seg_${side}.nii.gz" "$WORK/pmc/hyperres_seg_${side}.nii.gz"
  cp "$SRC/t1_only/${P}_tse_native_seg_${side}.nii.gz" "$WORK/pmc_t1/native_seg_${side}.nii.gz"
  cp "$SRC/t1_only/${P}_tse_patch_hyperres_seg_${side}.nii.gz" "$WORK/pmc_t1/hyperres_seg_${side}.nii.gz"
done
cp "$SRC/t2_t1/${P}_itksnap_labels.txt" "$WORK/pmc/labels.txt"
cp "$SRC/t1_only/${P}_itksnap_labels.txt" "$WORK/pmc_t1/labels.txt"
$C3D "$WORK/pmc/native_seg_left.nii.gz" "$WORK/pmc/native_seg_right.nii.gz" -max \
  -type short -o "$WORK/pmc/native_seg.nii.gz"
$C3D "$WORK/pmc_t1/native_seg_left.nii.gz" "$WORK/pmc_t1/native_seg_right.nii.gz" -max \
  -type short -o "$WORK/pmc_t1/native_seg.nii.gz"

# T1+T2: TSE upsampled 5x in the slice direction (~0.4mm isotropic), whole FOV
$C3D "$TSE" -interpolation Cubic -resample 100x100x500% -clip 0 inf -type short \
  -o "$WORK/pmc/tse_iso.nii.gz"
$C3D "$WORK/pmc/tse_iso.nii.gz" \
  "$WORK/pmc/hyperres_seg_left.nii.gz" -int 0 -reslice-identity \
  "$WORK/pmc/tse_iso.nii.gz" \
  "$WORK/pmc/hyperres_seg_right.nii.gz" -int 0 -reslice-identity -max \
  -type short -o "$WORK/pmc/hyperres_seg.nii.gz"
window "$WORK/pmc/tse_iso.nii.gz" "$WORK/pmc/hyperres_seg.nii.gz"
window "$WORK/pmc/tse.nii.gz" "$WORK/pmc/native_seg.nii.gz"

# T1-only: T1 cropped around both MTLs and resampled to 0.4mm isotropic
$C3D "$WORK/pmc_t1/native_seg.nii.gz" -thresh 1 inf 1 0 -trim 30vox \
  -resample-mm 0.4x0.4x0.4mm -o "$WORK/pmc_t1/ref_iso.nii.gz"
$C3D "$WORK/pmc_t1/ref_iso.nii.gz" "$T1" -interpolation Cubic -reslice-identity \
  -clip 0 inf -type short -o "$WORK/pmc_t1/mprage_iso.nii.gz"
$C3D "$WORK/pmc_t1/ref_iso.nii.gz" \
  "$WORK/pmc_t1/hyperres_seg_left.nii.gz" -int 0 -reslice-identity \
  "$WORK/pmc_t1/ref_iso.nii.gz" \
  "$WORK/pmc_t1/hyperres_seg_right.nii.gz" -int 0 -reslice-identity -max \
  -type short -o "$WORK/pmc_t1/hyperres_seg.nii.gz"
rm -f "$WORK/pmc_t1/ref_iso.nii.gz"

# Workspaces. T2 main + T1 overlay, as prepared for the HyperASHS-PMC service
"$WT" -layers-set-main "$WORK/pmc/tse.nii.gz" -props-set-nickname "T2-MRI" -tags-add T2-MRI \
  -layers-add-anat "$WORK/pmc/mprage.nii.gz" -props-set-nickname "T1-MRI" -tags-add T1-MRI \
  -o "$WORK/pmc/t2_t1.itksnap" < /dev/null
# T1 main with the T2 slab drawn on top in color, to show slab placement.
# (-props-set-sticky/-alpha are documented but not implemented in itksnap-wt,
# so the layer metadata is set through the registry.)
"$WT" -layers-set-main "$WORK/pmc/mprage.nii.gz" -props-set-nickname "T1-MRI" \
  -layers-add-anat "$WORK/pmc/tse.nii.gz" -props-set-nickname "T2-MRI" \
  -props-registry-set LayerMetaData.Sticky 1 -props-registry-set LayerMetaData.Alpha 0.5 \
  -props-set-colormap Hot \
  -o "$WORK/pmc/slab.itksnap" < /dev/null

# Report the voxel coordinates (1-based, as shown in ITK-SNAP) of the centroid
# of each hemisphere in each display image; figure scripts use these.
for spec in "pmc tse_iso hyperres_seg" "pmc tse native_seg" "pmc_t1 mprage_iso hyperres_seg" "pmc_t1 mprage native_seg"; do
  set -- $spec
  for side in left right; do
    $C3D "$WORK/$1/$2.nii.gz" "$WORK/$1/${3}_${side}.nii.gz" -int 0 -reslice-identity \
      -thresh 1 inf 1 0 -centroid \
      | awk -v k="$1/$2/$side" '/CENTROID_VOX/ {gsub(/[\[\],]/," "); printf "%s %d %d %d\n", k, $2+1.5, $3+1.5, $4+1.5}'
  done
done | tee "$WORK/centroids.txt"
