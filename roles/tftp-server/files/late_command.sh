#!/bin/sh

set -eufx

# This script setups ansible and runs it
# It should be ran at the end of the basic installation of a machine

apt install -y software-properties-common
# apt-add-repository --yes --update "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
apt-add-repository --yes --update ppa:ansible/ansible

apt install -y ansible git eatmydata

# We clone our ansible repository and copy the ansible config files

# git clone https://anonscm.debian.org/git/debconf-video/ansible.git /root/debconf-ansible
git clone https://github.com/CarlFK/video-stack-deploy.git /root/debconf-ansible
cd /root/debconf-ansible
git checkout pxe-toucheup
cd -

git clone https://github.com/xfxf/av-foss-stack.git /root/lca2017-av

ln -s /root/lca2017-av/inventory/ansible-up.sh /usr/local/sbin/ansible-up

# Aaaand we run ansible
eatmydata ansible-playbook \
	--connection=local \
	--limit=$(hostname) \
    --inventory-file=/root/lca2017-av/inventory/hosts \
	/root/debconf-ansible/site.yml
