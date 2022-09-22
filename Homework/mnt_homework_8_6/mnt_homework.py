#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type
import os.path
DOCUMENTATION = r'''
---
module: my_homework
short_description: This is my test module
# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"
description: test module homework
options:
    path:
        description: Path new file.
        required: true
        type: str
    content:
        description: Contetnt writting to file
        required: true
        type: str
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_homework.my_collection.my_test_module
author:
    - Pavel Svitov (@psvitov)
'''

EXAMPLES = r'''
# Pass in a message
- name: Write a file
  my_homework.my_collection.my_test_module:
    path: '/tmp/file.txt'
    content: 'Netology is a great school'
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: Content passed.
    type: str
    returned: always
    sample: 'Netology is a great school'
message:
    description: Generated output message.
    type: str
    returned: always
    sample: 'Written complete'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=True,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    if not os.path.exists(module.params['path']):
        # Open function to open the file "MyFile1.txt" 
        # (same directory) in append mode and
        file1 = open(module.params['path'],"w")
        file1.write(module.params['content'])
        file1.close()
        result['changed'] = True
        result['message'] = 'Written complite'
    else:
        result['changed'] = False    
        result['message'] = 'File exists'
    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    result['original_message'] = module.params['content']

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()