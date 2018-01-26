Run scripts for deep learning frameworks (currently targeting TensorFlow
code from ANNMINERvA). Currently aimed at local interactive execution and
batch submission on the Wilson Cluster at Fermilab.

* `mnv_tf_script_gen.py` - Produce scripts for training / testing / etc.
using the configuration files stored in the `Config` directory. This
script is not meant to be run directly, but is wrapped by one of the
training shell scripts.
* `tf_examine_tfrecords_local.sh` - Examine TFRecrord files (count entries, 
print event IDs) directly.
* `tf_process_hdf5_to_tfrecord_local.sh` - Read HDF5 files and produce
TFRecord files directly.
* `tf_process_txt_to_sqlite_local.sh` - Read text files and produce a SQLite
database from the information.
* `tf_run_local.sh` - Run training (wrap `mnv_tf_script_gen.py`) directly.
* `tf_sbatch_process_hdf5_to_tfrecord.sh` - Run the production of TFRecord
files using `tf_slurm_process_hdf5_to_tfrecord.sh` in a SLURM batch
system.
* `tf_sbatch_train_minerva.sh` - Run training (wrap `mnv_tf_script_gen.py`)
using a SLURM batch system.
* `tf_slurm_process_hdf5_to_tfrecord.sh` - Write TFRecord files based on
HDF5 input. This script is not meant to be run directly (instead, use
`tf_sbatch_process_hdf5_to_tfrecord.sh`).
