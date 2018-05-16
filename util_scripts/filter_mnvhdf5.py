#!/usr/bin/env python
"""
Usage:
    python filter_mnvhdf5.py input_hdf5_file list_of_filtered_events_file
"""
from __future__ import print_function
import h5py
import numpy as np
import os
import sys


if '-h' in sys.argv or '--help' in sys.argv:
    print(__doc__)
    sys.exit(1)

if not len(sys.argv) == 3:
    print(__doc__)
    sys.exit(1)

input_hdf5_file = sys.argv[1]
output_hdf5_file = '.'.join(input_hdf5_file.split('.')[:-1]) + '_filtered.hdf5'
evtidsfile = sys.argv[2]
evtidset = set()
with open(evtidsfile, 'r') as f:
    for evt in f.readlines():
        evtidset.add(int(evt.strip()))
n_writing = len(evtidset)


def prepare_hdf5_file(hdf5file):
    if os.path.exists(hdf5file):
        os.remove(hdf5file)
    f = h5py.File(hdf5file, 'w')
    return f


fin = h5py.File(input_hdf5_file, 'r')
fout = prepare_hdf5_file(output_hdf5_file)

for group in fin:
    print('making fout group {}...'.format(group))
    grp = fout.create_group(group)
    for dset in fin[group]:
        shp = list(np.shape(fin[group][dset]))
        shp[0] = n_writing
        dtyp = fin[group][dset].dtype
        print('  making fout dset {} with shape {} and dtyp {}...'.format(
            dset, shp, dtyp
        ))
        grp.create_dataset(dset, shp, dtype=dtyp, compression='gzip')

n_inp = fin['event_data/eventids'].shape[0]
cntr = 0
for idx, evtid in enumerate(np.reshape(fin['event_data/eventids'][:], n_inp)):
    if evtid in evtidset:
        for group in fin:
            for dset in fin[group]:
                fout[group][dset][cntr] = fin[group][dset][idx]
        cntr += 1

fin.close()
fout.close()
