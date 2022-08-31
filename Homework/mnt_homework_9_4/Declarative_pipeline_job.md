Started by user Pavel Svitov
[Pipeline] Start of Pipeline
[Pipeline] node
Running on jenkins-agent in /opt/jenkins_agent/workspace/Pipeline-molecule
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git clone)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
Fetching changes from the remote Git repository
Checking out Revision b1b6ecb01f63561516f3d221f5a92faeb225aea1 (refs/remotes/origin/main)
Commit message: "version 0.0.4"
 > git rev-parse --resolve-git-dir /opt/jenkins_agent/workspace/Pipeline-molecule/.git # timeout=10
 > git config remote.origin.url https://github.com/psvitov/mnt_homework_8_5.git # timeout=10
Fetching upstream changes from https://github.com/psvitov/mnt_homework_8_5.git
 > git --version # timeout=10
 > git --version # 'git version 1.8.3.1'
 > git fetch --tags --progress https://github.com/psvitov/mnt_homework_8_5.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f b1b6ecb01f63561516f3d221f5a92faeb225aea1 # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main b1b6ecb01f63561516f3d221f5a92faeb225aea1 # timeout=10
 > git rev-list --no-walk b1b6ecb01f63561516f3d221f5a92faeb225aea1 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Directory)
[Pipeline] dir
Running in /opt/jenkins_agent/workspace/Pipeline-molecule/roles/vector-role
[Pipeline] {
[Pipeline] sh
+ molecule test
/home/jenkins/.local/lib/python3.6/site-packages/requests/__init__.py:104: RequestsDependencyWarning: urllib3 (1.26.12) or chardet (5.0.0)/charset_normalizer (2.0.12) doesn't match a supported version!
  RequestsDependencyWarning)
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/6b261f/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/6b261f/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/6b261f/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
INFO     Running ansible-galaxy collection install -v --force containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install -v --force ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'podman'
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature
changed: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '716533762924.15936', 'results_file': '/home/jenkins/.ansible_async/716533762924.15936', 'changed': True, 'failed': False, 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '102435333828.15962', 'results_file': '/home/jenkins/.ansible_async/102435333828.15962', 'changed': True, 'failed': False, 'item': {'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '524028800307.15993', 'results_file': '/home/jenkins/.ansible_async/524028800307.15993', 'changed': True, 'failed': False, 'item': {'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /opt/jenkins_agent/workspace/Pipeline-molecule/roles/vector-role/molecule/default/converge.yml
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature
fatal: [localhost]: FAILED! => {"changed": false, "cmd": ["which", "podman"], "delta": "0:00:00.002148", "end": "2022-08-31 18:29:15.769011", "msg": "non-zero return code", "rc": 1, "start": "2022-08-31 18:29:15.766863", "stderr": "which: no podman in (/usr/local/bin:/usr/bin:/home/jenkins/.local/bin)", "stderr_lines": ["which: no podman in (/usr/local/bin:/usr/bin:/home/jenkins/.local/bin)"], "stdout": "", "stdout_lines": []}

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/jenkins/.cache/molecule/vector-role/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/jenkins/.local/lib/python3.6/site-packages/molecule_podman/playbooks/create.yml']
WARNING  An error occurred during the test sequence action: 'create'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature
changed: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '939337909793.16154', 'results_file': '/home/jenkins/.ansible_async/939337909793.16154', 'changed': True, 'failed': False, 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '137319785739.16180', 'results_file': '/home/jenkins/.ansible_async/137319785739.16180', 'changed': True, 'failed': False, 'item': {'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '313970718919.16213', 'results_file': '/home/jenkins/.ansible_async/313970718919.16213', 'changed': True, 'failed': False, 'item': {'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
ERROR: script returned exit code 1
Finished: FAILURE
