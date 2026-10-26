#!/bin/bash
# Generate the static documentation figures with scripted ITK-SNAP sessions.
# Run make_data.sh first. Each figure is one ITK-SNAP session, driven by
# scripts/fig_view.js with the options given below, and written straight to
# the website's image folder.
#
# Usage: make_figures.sh [figure_name ...]     (default: all figures)
set -euo pipefail

FIGDIR=$(cd "$(dirname "$0")" && pwd)
WORK=${WORK:-$FIGDIR/work}
OUT=${OUT:-$FIGDIR/../docs/assets/images/hyperashs}
SNAP=${SNAP:-$HOME/tk/itksnap/xc64rel/ITK-SNAP}
PYTHON=${PYTHON:-python3}

mkdir -p "$WORK/wrappers" "$WORK/shots" "$WORK/cameras" "$OUT"
FAILED=()
SELECT=("$@")

selected() { [[ ${#SELECT[@]} -eq 0 || " ${SELECT[*]} " == *" $1 "* ]]; }

# fig NAME "ITK-SNAP image options (paths relative to WORK)" 'JS fig fields' [HxW]
# The optional HxW crops the screenshot around its center (macOS sips).
fig()
{
  local name=$1 opts=$2 js=$3 crop=${4:-}
  selected "$name" || return 0
  echo "=== $name"
  printf 'var fig = {name: "%s", %s};\ninclude("fig_view.js")\n' "$name" "$js" > "$WORK/wrappers/$name.js"
  rm -f "$WORK/shots/$name.png"
  local args=()
  for a in $opts; do
    if [[ $a == -* ]]; then args+=("$a"); else args+=("$WORK/$a"); fi
  done
  if (cd "$FIGDIR/scripts" && "$SNAP" "${args[@]}" --test "$WORK/wrappers/$name.js" --testdir "$WORK" \
        > "$WORK/wrappers/$name.log" 2>&1) && [[ -f "$WORK/shots/$name.png" ]]; then
    cp "$WORK/shots/$name.png" "$OUT/$name.png"
    if [[ -n $crop ]]; then sips --cropToHeightWidth ${crop/x/ } "$OUT/$name.png" > /dev/null; fi
  else
    echo "    FAILED, see $WORK/wrappers/$name.log"
    FAILED+=("$name")
  fi
}

# camera NAME SEG LABELS [make_camera.py options]: 3D viewpoint for figure NAME
camera()
{
  local name=$1 seg=$2 labels=$3; shift 3
  selected "$name" || return 0
  "$PYTHON" "$FIGDIR/make_camera.py" "$WORK/$seg" "$WORK/$labels" "$WORK/cameras/$name.json" "$@"
}

# Voxel coordinates of the hippocampus in each display image (from make_data.sh)
cen() { awk -v k="$1" '$1 == k {printf "[%d,%d,%d]", $2, $3, $4}' "$WORK/centroids.txt"; }
mid() { awk -v a="$1" -v b="$2" '$1 == a {x1=$2; y1=$3; z1=$4} $1 == b {x2=$2; y2=$3; z2=$4}
          END {printf "[%d,%d,%d]", (x1+x2)/2, (y1+y2)/2, (z1+z2)/2}' "$WORK/centroids.txt"; }

PMC_ISO="-g pmc/tse_iso.nii.gz -s pmc/hyperres_seg.nii.gz -l pmc/labels.txt"
T1_ISO="-g pmc_t1/mprage_iso.nii.gz -s pmc_t1/hyperres_seg.nii.gz -l pmc_t1/labels.txt"

# --- Home page: 3D renderings of the hyper-resolution segmentations
camera home_3d_pmc pmc/hyperres_seg.nii.gz pmc/labels.txt --view 0,-0.35,1
fig home_3d_pmc "$PMC_ISO" 'expand: "panel3D", camera: true, background: "#000000", target: "view"' 480x750
camera home_3d_pmc_t1 pmc_t1/hyperres_seg.nii.gz pmc_t1/labels.txt --view 0,-0.35,1
fig home_3d_pmc_t1 "$T1_ISO" 'expand: "panel3D", camera: true, background: "#000000", target: "view"' 480x750

# --- Quick start: input image and segmentation, coronal slice through both MTLs
C=$(mid pmc/tse_iso/left pmc/tse_iso/right)
fig quickstart_pmc_input "$PMC_ISO" "cursor: $C, expand: \"panel2\", zoom: 7.5, noseg: true, target: \"view\""
fig quickstart_pmc_seg "$PMC_ISO" "cursor: $C, expand: \"panel2\", zoom: 7.5, target: \"view\""
C=$(mid pmc_t1/mprage_iso/left pmc_t1/mprage_iso/right)
fig quickstart_pmc_t1_input "$T1_ISO" "cursor: $C, expand: \"panel2\", zoom: 7.5, noseg: true, target: \"view\""
fig quickstart_pmc_t1_seg "$T1_ISO" "cursor: $C, expand: \"panel2\", zoom: 7.5, target: \"view\""

# --- MRI requirements: T2 and T1 side by side; T2 slab position on the T1
fig mri_pmc_t2_t1_tiled "-w pmc/t2_t1.itksnap" "cursor: $(cen pmc/tse/left), tile: true, zoom: 2"
fig mri_pmc_slab_sagittal "-w pmc/slab.itksnap" \
  "cursor: $(cen pmc_t1/mprage/left), expand: \"panel0\", target: \"view\""

# --- Local usage: what 'itksnap -g tse -s seg -l labels' shows
fig usage_itksnap_result "-g pmc/tse.nii.gz -s pmc/native_seg_left.nii.gz -l pmc/labels.txt" \
  "cursor: $(cen pmc/tse/left), mesh: true"

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo "Failed figures: ${FAILED[*]}"
  exit 1
fi
