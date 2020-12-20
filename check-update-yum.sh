#!/bin/bash

ansible all -i /usr/etc/ansible/server_list.txt -b -a "yum check-update" > /usr/etc/ansible/check-update/check-update.txt

exit 0
