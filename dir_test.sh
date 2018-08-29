#!/bin/bash
python -c "import os; print os.listdir('/data/perdue/singularity')"
python -c "import os; print os.listdir('/lfstev/e-938/perdue/test/hdf5')"

# note - `singularity` must be in your PATH
SNGLRTY="/data/perdue/singularity/gnperdue-singularity_imgs-master-py2_tf18.simg"
# /lfstev is not yet included in the default bind, so explicitly bind it here
singularity exec -B /lfstev:/lfstev --nv $SNGLRTY python -c "import os; print os.listdir('/lfstev/e-938/perdue/test/hdf5')"
