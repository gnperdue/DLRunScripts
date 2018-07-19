Configuration file explanations

## Hadron multiplicity

* `tf_mnv_hadmultp_local_iMac2017_prediction.cfg` - test file for GNP Mac
* `tf_mnv_hadmultp_local_iMac2017_training.cfg` - test file for GNP Mac
* `tf_mnv_hadmultp_wilson_cluster_training_AB.cfg`

## Vertex finder

### "Local" testing (_not_ "production")

* `tf_mnv_vtxfindr_local_iMac2017_data_prediction_using_LOP.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_mc_prediction_using_LOP.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_prediction.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_prediction_check_using_LOP.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_prediction_using_E.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_training.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_training_LOP.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_iMac2017_training_menndl_633167.cfg` - test file for GNP Mac
* `tf_mnv_vtxfindr_local_MBP2017_training.cfg` - test file for GNP Mac

### Wilson cluster ("production")

The `data_prediction` and `mc_prediction` files are for making predictions with
the specified model (e.g., `using_X`). `ABCDG` should be used to make predictions
for `EF` and vice versa, and `LOP` should be used to make predictions for `MN`
and vice versa.

The `training` files are for producing new models, or for adding to an existing
model (generally these will only be needed for the vertex finder if we decide to
do a new training based on a new model).

Generally, we want to run the `prediction` files and update the `pred` and
`data_ext_dirs` values in the config file (e.g., to `me1Fmc`, etc.). Generally,
we always saved the configuration in GitHub before running training or predictions,
so it is possible to look at the commit history to get a sense for what it looks like
to toggle between different runs, etc.

* `tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_ABCDG.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_EF.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_LOP.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_data_prediction_using_MN.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_ABCDG.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_EF.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_LOP.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_mc_prediction_using_MN.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_training_ABCDG.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_training_EF.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_training_LOP.cfg`
* `tf_mnv_vtxfindr_wilson_cluster_training_MN.cfg`
