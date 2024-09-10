# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

import os
import subprocess

from joblib import delayed
from joblib import Parallel

file_src = "annotations/val_output.csv"
folder_path = "val/"
output_path = "val_256/"

file_list = []

f = open(file_src, "r")

for line in f:
    rows = line.strip().split()
    fname = rows[0].strip('"')
    fname = rows[0]
    file_list.append(fname)

f.close()


def downscale_clip(inname, outname):
    status = False
    inname = '"%s"' % inname
    outname = '"%s"' % outname
    command = 'ffmpeg  -loglevel panic -i "{}" -filter:v scale="trunc(oh*a/2)*2:256" -q:v 1 -c:a copy "{}"'.format(
        inname, outname
    )
    try:
        subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as err:
        return status, err.output

    status = os.path.exists(outname)
    return status, "Downscaled"


def downscale_clip_wrapper(row):
    nameset = row.split(",")
    videoname = nameset[0]

    if os.path.isdir(output_path) is False:
        try:
            os.mkdir(output_path)
        except:  # noqa: E722
            print(output_path)

    inname = folder_path + videoname
    outname = output_path + videoname

    downscaled, log = downscale_clip(inname, outname)
    return downscaled


status_lst = Parallel(n_jobs=16)(
    delayed(downscale_clip_wrapper)(row) for row in file_list
)
