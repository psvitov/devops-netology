[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
[33mchanged: [localhost] => (item=centos_7)[0m
[33mchanged: [localhost] => (item=centos_8)[0m
[33mchanged: [localhost] => (item=ubuntu)[0m

TASK [Wait for instance(s) deletion to complete] *******************************
[1;30mFAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).[0m
[33mchanged: [localhost] => (item=centos_7)[0m
[33mchanged: [localhost] => (item=centos_8)[0m
[33mchanged: [localhost] => (item=ubuntu)[0m

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
[33mlocalhost[0m                  : [32mok=2   [0m [33mchanged=2   [0m unreachable=0    failed=0    [36mskipped=1   [0m rescued=0    ignored=0


playbook: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/molecule/default/converge.yml
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
[36mskipping: [localhost] => (item=None) [0m
[36mskipping: [localhost] => (item=None) [0m
[36mskipping: [localhost] => (item=None) [0m
[36mskipping: [localhost][0m

TASK [Check presence of custom Dockerfiles] ************************************
[32mok: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})[0m
[32mok: [localhost] => (item={'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True})[0m
[32mok: [localhost] => (item={'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True})[0m

TASK [Create Dockerfiles from image names] *************************************
[36mskipping: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}) [0m
[36mskipping: [localhost] => (item={'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True}) [0m
[36mskipping: [localhost] => (item={'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True}) [0m

TASK [Discover local Docker images] ********************************************
[32mok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})[0m
[32mok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})[0m
[32mok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})[0m

TASK [Build an Ansible compatible image (new)] *********************************
[36mskipping: [localhost] => (item=molecule_local/centos:7) [0m
[36mskipping: [localhost] => (item=molecule_local/centos:8_update) [0m
[36mskipping: [localhost] => (item=molecule_local/ubuntu:python) [0m

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
[32mok: [localhost] => (item={'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True})[0m
[32mok: [localhost] => (item={'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True})[0m
[32mok: [localhost] => (item={'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True})[0m

TASK [Create molecule instance(s)] *********************************************
[33mchanged: [localhost] => (item=centos_7)[0m
[33mchanged: [localhost] => (item=centos_8)[0m
[33mchanged: [localhost] => (item=ubuntu)[0m

TASK [Wait for instance(s) creation to complete] *******************************
[1;30mFAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).[0m
[33mchanged: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '490375956064.90855', 'results_file': '/root/.ansible_async/490375956064.90855', 'changed': True, 'failed': False, 'item': {'image': 'centos:7', 'name': 'centos_7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})[0m
[33mchanged: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '533292124163.90881', 'results_file': '/root/.ansible_async/533292124163.90881', 'changed': True, 'failed': False, 'item': {'image': 'centos:8_update', 'name': 'centos_8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})[0m
[33mchanged: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '586741511051.90906', 'results_file': '/root/.ansible_async/586741511051.90906', 'changed': True, 'failed': False, 'item': {'image': 'ubuntu:python', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})[0m

PLAY RECAP *********************************************************************
[33mlocalhost[0m                  : [32mok=5   [0m [33mchanged=2   [0m unreachable=0    failed=0    [36mskipped=4   [0m rescued=0    ignored=0


PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_8][0m
[32mok: [ubuntu][0m
[32mok: [centos_7][0m

TASK [Include vector-role] *****************************************************

TASK [vector-role : Download Vector] *******************************************
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/yum.yml for centos_7[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/dnf.yml for centos_8[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/apt.yml for ubuntu[0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [centos_7][0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [centos_8][0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [ubuntu][0m

TASK [vector-role : Install Vector] ********************************************
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/yum.yml for centos_7[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/dnf.yml for centos_8[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/apt.yml for ubuntu[0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [centos_7][0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [centos_8][0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[33mchanged: [ubuntu][0m

PLAY RECAP *********************************************************************
[33mcentos_7[0m                   : [32mok=5   [0m [33mchanged=2   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[33mcentos_8[0m                   : [32mok=5   [0m [33mchanged=2   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[33mubuntu[0m                     : [32mok=5   [0m [33mchanged=2   [0m unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [ubuntu][0m
[32mok: [centos_8][0m
[32mok: [centos_7][0m

TASK [Include vector-role] *****************************************************

TASK [vector-role : Download Vector] *******************************************
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/yum.yml for centos_7[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/dnf.yml for centos_8[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/download/apt.yml for ubuntu[0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_7][0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_8][0m

TASK [vector-role : Download Vector] *******************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [ubuntu][0m

TASK [vector-role : Install Vector] ********************************************
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/yum.yml for centos_7[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/dnf.yml for centos_8[0m
[36mincluded: /home/devops/Netology/mnt_homework_8_5/roles/vector-role/tasks/install/apt.yml for ubuntu[0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_7][0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_8][0m

TASK [vector-role : Install Vector] ********************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [ubuntu][0m

PLAY RECAP *********************************************************************
[32mcentos_7[0m                   : [32mok=5   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[32mcentos_8[0m                   : [32mok=5   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[32mubuntu[0m                     : [32mok=5   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_7] => {[0m
[32m    "changed": false,[0m
[32m    "msg": "All assertions passed"[0m
[32m}[0m
[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m
[32mok: [centos_8] => {[0m
[32m    "changed": false,[0m
[32m    "msg": "All assertions passed"[0m
[32m}[0m
[32mok: [ubuntu] => {[0m
[32m    "changed": false,[0m
[32m    "msg": "All assertions passed"[0m
[32m}[0m

PLAY RECAP *********************************************************************
[32mcentos_7[0m                   : [32mok=1   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[32mcentos_8[0m                   : [32mok=1   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
[32mubuntu[0m                     : [32mok=1   [0m changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[1;35m[WARNING]: Collection community.docker does not support Ansible version 2.10.8[0m

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
[33mchanged: [localhost] => (item=centos_7)[0m
[33mchanged: [localhost] => (item=centos_8)[0m
[33mchanged: [localhost] => (item=ubuntu)[0m

TASK [Wait for instance(s) deletion to complete] *******************************
[1;30mFAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).[0m
[33mchanged: [localhost] => (item=centos_7)[0m
[33mchanged: [localhost] => (item=centos_8)[0m
[33mchanged: [localhost] => (item=ubuntu)[0m

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
[33mlocalhost[0m                  : [32mok=2   [0m [33mchanged=2   [0m unreachable=0    failed=0    [36mskipped=1   [0m rescued=0    ignored=0

