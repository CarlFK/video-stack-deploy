#!/bin/sh

# This script setups ansible and runs it
# It should be ran at the end of the basic installation of a machine


# We need backports for ansible, so we need the right sources

echo "deb http://deb.debian.org/debian/ jessie-backports main contrib non-free" >> /etc/apt/sources.list
apt update

# We then install the packages we need

apt install -y -t jessie-backports ansible
apt install -y git

# We clone our ansible repository and copy the ansible config files

git clone https://anonscm.debian.org/git/debconf-video/ansible.git /root/debconf-ansible
cp /root/debconf-ansible/ansible.cfg /etc/ansible/ansible.cfg

# Aaaand we run ansible

ansible-playbook -i /root/debconf-ansible/inventory/hosts /root/debconf-ansible/site.yml
