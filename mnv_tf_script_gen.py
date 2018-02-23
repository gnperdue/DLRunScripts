"""
python mnv_script_gen.py config_file script_key
"""
from __future__ import print_function
import subprocess
import ConfigParser
import os
import sys


def setup_dir(dirname):
    if not os.path.exists(dirname):
        os.makedirs(dirname)


if '-h' in sys.argv or '--help' in sys.argv:
    print(__doc__)
    sys.exit(1)

if len(sys.argv) < 3:
    print('The configuration file and script key are mandatory.')
    print(__doc__)
    sys.exit(1)

config_file = str(sys.argv[1])
script_key = str(sys.argv[2])

p = subprocess.Popen('hostname', shell=True, stdout=subprocess.PIPE)
host_name = p.stdout.readlines()[0].strip()
host_name = host_name.split('.')[0]
job_name = 'job' + script_key + '.sh'
arg_parts = []

config_defaults_dict = {
    'network_model': 'TriColSTEpsilon',
    'network_creator': 'default',
    'save_every_n_batch': 500,
    'override_machine_name_in_model': 0,
    'restore_repo': 0
}

config = ConfigParser.SafeConfigParser(
    config_defaults_dict
)
# ConfigParser use:
# * Read sections: config.sections()
# * Read items in section: config.options('RunOpts')
# * Get item: config.get('RunOpts', 'short')
config.read(config_file)

# run opts
log_level = config.get('RunOpts', 'log_level')
num_epochs = int(config.get('RunOpts', 'num_epochs'))
job_base_dir = config.get('RunOpts', 'job_base_dir')
job_dir = os.path.join(job_base_dir, 'job' + script_key)
setup_dir(job_dir)
setup_dir(os.path.join(job_dir, 'mnvtf'))

# data description
n_classes = int(config.get('DataDescription', 'n_classes'))
n_planecodes = int(config.get('DataDescription', 'n_planecodes'))
imgw_x = int(config.get('DataDescription', 'imgw_x'))
imgw_uv = int(config.get('DataDescription', 'imgw_uv'))
targets_label = config.get('DataDescription', 'targets_label')
tfrec_type = config.get('DataDescription', 'tfrec_type')
filepat = config.get('DataDescription', 'filepat')
compression = config.get('DataDescription', 'compression')

# sample labels
train_sample = config.get('SampleLabels', 'train')
valid_sample = config.get('SampleLabels', 'valid')
test_sample = config.get('SampleLabels', 'test')
pred_sample = config.get('SampleLabels', 'pred')
override_machine_name_in_model = int(config.get(
    'SampleLabels', 'override_machine_name_in_model'
))
machine_name_in_model = host_name
if override_machine_name_in_model:
    machine_name_in_model = config.get('SampleLabels', 'machine_name_in_model')

# training opts
optimizer = config.get('Training', 'optimizer')
batch_norm = int(config.get('Training', 'batch_norm'))
batch_norm_label = 'doBatchNorm' if batch_norm > 0 else 'nodoBatchNorm'
batch_norm_flag = 'do_batch_norm' if batch_norm > 0 else 'nodo_batch_norm'
batch_size = int(config.get('Training', 'batch_size'))
save_every_n_batch = int(config.get('Training', 'save_every_n_batch'))
network_model = config.get('Training', 'network_model')
network_creator = config.get('Training', 'network_creator')

# paths
model_version = config.get('Paths', 'model_version')
model_code = model_version + '_' + targets_label + '_nclass' + \
             str(n_classes) + '_train' + train_sample.upper() + \
             '_valid' + valid_sample.upper() + '_test' + \
             test_sample.upper() + '_opt' + optimizer.upper() + \
             '_batchsz' + str(batch_size) + '_' + batch_norm_label + '_' + \
             machine_name_in_model
data_basep = os.path.join(
    config.get('Paths', 'data_path'),
    config.get('Paths', 'processing_version')
)
data_dirs = [os.path.join(data_basep, pth)
             for pth in config.get('Paths', 'data_ext_dirs').split(',')]
for dd in data_dirs:
    assert os.path.exists(dd)
data_dirs_flag = '--data_dir ' + ','.join(data_dirs)
log_dir = config.get('Paths', 'log_path')
if log_dir == '':
    log_dir = os.path.join(
        os.getcwd(),
        'job' + script_key
    )
setup_dir(log_dir)
log_file = os.path.join(
    log_dir,
    'log_mnv_st_epsilon_' + model_code + '_' + script_key + '.txt'
)
log_file_flag = '--log_name ' + log_file
model_dir = os.path.join(
    config.get('Paths', 'models_path'),
    config.get('Paths', 'processing_version'),
    model_code
)
setup_dir(model_dir)
model_dir_flag = '--model_dir ' + model_dir
pred_store_dir = os.path.join(
    config.get('Paths', 'pred_path'),
    config.get('Paths', 'processing_version'),
)
setup_dir(pred_store_dir)
pred_store_name = os.path.join(
    pred_store_dir,
    'mnv_st_epsilon_predictions' + pred_sample.upper() + '_model_' + model_code
)
pred_store_flag = '--pred_store_name ' + pred_store_name

# singularity
container = config.get('Singularity', 'container')

arg_parts.append('--n_planecodes %d' % n_planecodes)
arg_parts.append('--n_classes %d' % n_classes)
arg_parts.append('--imgw_x %d --imgw_uv %d' % (imgw_x, imgw_uv))
arg_parts.append('--targets_label %s' % targets_label)
if compression in ['gz', 'zz']:
    arg_parts.append('--compression %s' % compression)
arg_parts.append('--file_root ' + filepat + str(imgw_x) + '_')

if optimizer is not '':
    arg_parts.append('--strategy %s' % optimizer)
arg_parts.append('--batch_size %d' % batch_size)
arg_parts.append('--%s' % batch_norm_flag)
arg_parts.append('--save_every_n_batch %d' % save_every_n_batch)
arg_parts.append('--network_model %s' % network_model)
arg_parts.append('--network_creator %s' % network_creator)

arg_parts.append(data_dirs_flag)
arg_parts.append(log_file_flag)
arg_parts.append(model_dir_flag)
arg_parts.append('--tfrec_type %s' % tfrec_type)

# run opt switches
arg_parts.append('--log_level %s' % log_level)
arg_parts.append('--num_epochs %d' % num_epochs)
switches = ['training', 'validation', 'testing', 'prediction',
            'use_all_for_test', 'use_test_for_train', 'use_valid_for_test',
            'a_short_run', 'log_devices', 'pred_store_use_db']
for switch in switches:
    arg_parts.append(
        '--do_{0}'.format(switch)
        if int(config.get('RunOpts', switch))
        else '--nodo_{0}'.format(switch)
    )
if '--do_prediction' in arg_parts:
    arg_parts.append(pred_store_flag)

arg_string = ' '.join(arg_parts)

code_source_dir = config.get('Code', 'code_source_dir')
run_script = config.get('Code', 'run_script')
restore_repo = int(config.get('Code', 'restore_repo'))
if restore_repo:
    restore_repo_hash = config.get('Code', 'restore_repo_hash')
else:
    restore_repo_hash = 'HEAD'

repo_info_string = """
# print identifying info for this job
cd {0}
echo "{1} is `pwd`"
GIT_VERSION=`git describe --abbrev=12 --dirty --always`
echo "Git repo version is $GIT_VERSION"
DIRTY=`echo $GIT_VERSION | perl -ne 'print if /dirty/'`
if [[ $DIRTY != "" ]]; then
  echo "Git repo contains uncomitted changes!"
  echo ""
  echo "Changed files:"
  git diff --name-only
  echo ""
  # exit 0
fi
"""

restore_repo_string = """
pushd {0} >& /dev/null
git stash
git checkout -b {1}-br {1}
popd >& /dev/null
"""

revert_restored_repo_string = """
pushd {0} >& /dev/null
git checkout master
git branch -d {1}-br
popd >& /dev/null
"""

with open(os.path.join(job_dir, job_name), 'w') as f:
    f.write('#!/bin/bash\n')
    f.write('echo "started "`date`" "`date +%s`""\n')
    if 'gpu' in host_name:
        f.write('nvidia-smi -L\n')
    if restore_repo:
        f.write(restore_repo_string.format(code_source_dir, restore_repo_hash))
    f.write(repo_info_string.format(code_source_dir, 'Code source'))
    f.write(repo_info_string.format(job_dir, 'Work'))
    f.write('\n')
    framework_code = os.listdir(os.path.join(code_source_dir, 'mnvtf'))
    for src_file in framework_code:
        if (src_file.split('.')[-1] == 'py'):
            f.write('cp -v {0}/mnvtf/{1} {2}/mnvtf\n'.format(
                code_source_dir, src_file, job_dir
            ))
    f.write('cp -v {0}/{1} {2}\n'.format(
        code_source_dir, run_script, job_dir
    ))
    if restore_repo:
        f.write(revert_restored_repo_string.format(
            code_source_dir, restore_repo_hash
        ))
    f.write('\n')
    if container is not '':
        f.write('singularity exec {0} python {1} {2}\n\n'.format(
            container, run_script, arg_string
        ))
    else:
        f.write('python {0} {1}\n\n'.format(
            run_script, arg_string
        ))
    if 'gpu' in host_name:
        f.write('nvidia-smi -L >> {0}\n'.format(log_file))
        f.write('nvidia-smi >> {0}\n\n'.format(log_file))
    f.write('echo "finished "`date`" "`date +%s`""\n')
    f.write('rm -f *.pyc\n')
    f.write('rm -f mnvtf/*.pyc\n')
    f.write('exit 0')
