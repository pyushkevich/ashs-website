#!/usr/bin/env python3
"""Generate an ITK-SNAP camera viewpoint (JSON) that frames the 3D meshes of a
segmentation, viewed from a given direction.

ITK-SNAP's 3D world coordinates are physical RAS coordinates. Only labels
whose 'MSH' flag is set in the label description file are rendered as meshes,
so only those are used to compute the bounding box.

Example:
  make_camera.py seg.nii.gz labels.txt out.json --view 0,-0.35,1 --up 0,1,0
"""
import argparse
import json
import re

import numpy as np
import SimpleITK as sitk


def mesh_labels(label_file):
    """Labels with the mesh flag on, from an ITK-SNAP label description file."""
    labels = []
    with open(label_file) as f:
        for line in f:
            m = re.match(r'\s*(\d+)\s+\d+\s+\d+\s+\d+\s+[\d.]+\s+(\d+)\s+(\d+)\s+"', line)
            if m and int(m.group(1)) > 0 and int(m.group(2)) and int(m.group(3)):
                labels.append(int(m.group(1)))
    return labels


def vec(s):
    return np.array([float(x) for x in s.split(',')])


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('seg')
    ap.add_argument('labels')
    ap.add_argument('output')
    ap.add_argument('--view', type=vec, default=vec('0,0,1'),
                    help='direction from the target to the camera, RAS (default: superior)')
    ap.add_argument('--up', type=vec, default=vec('0,1,0'),
                    help='approximate screen-up direction, RAS (default: anterior)')
    ap.add_argument('--fill', type=float, default=0.95,
                    help='fraction of the view filled by the bounding sphere')
    ap.add_argument('--angle', type=float, default=30.0, help='camera view angle, degrees')
    args = ap.parse_args()

    img = sitk.ReadImage(args.seg)
    arr = sitk.GetArrayFromImage(img)  # z, y, x
    idx = np.argwhere(np.isin(arr, mesh_labels(args.labels)))[:, ::-1].astype(float)
    if len(idx) == 0:
        raise SystemExit('no mesh labels found in segmentation')

    # Voxel index to LPS, then to RAS
    D = np.array(img.GetDirection()).reshape(3, 3)
    S = np.diag(img.GetSpacing())
    lps = idx @ (D @ S).T + np.array(img.GetOrigin())
    ras = lps * np.array([-1, -1, 1])

    lo, hi = ras.min(0), ras.max(0)
    center = (lo + hi) / 2
    radius = np.linalg.norm(hi - lo) / 2

    view = args.view / np.linalg.norm(args.view)
    up = args.up - np.dot(args.up, view) * view
    up /= np.linalg.norm(up)

    dist = radius / np.sin(np.radians(args.angle / 2)) / args.fill
    cam = {
        'file_type': 'itksnap_camera_viewpoint',
        'version': '1.0.0',
        'camera': {
            'position': list(center + dist * view),
            'focal_point': list(center),
            'view_up': list(up),
            'clipping_range': [max(dist - 2 * radius, 1.0), dist + 2 * radius],
            'view_angle': args.angle,
            'parallel_scale': radius,
            'parallel_projection': False,
        },
    }
    with open(args.output, 'w') as f:
        json.dump(cam, f, indent=2)


if __name__ == '__main__':
    main()
