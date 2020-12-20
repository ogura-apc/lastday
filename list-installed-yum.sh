#!/bin/bash

ansible all -i /usr/etc/ansible/server_list.txt -b -a "yum list installed" > /usr/etc/ansible/installed_packages/list-installed.txt

exit 0
