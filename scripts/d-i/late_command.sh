#!/bin/sh

set -eufx

# This script setups ansible and runs it
# It should be ran at the end of the basic installation of a machine

# Here is where the parameters come from:

# linux /debian/stretch/amd64/linux gfxpayload=800x600x16,800x600 --- auto=true url=dc10b DEBCONF_DEBUG=5 tasks="" hw-detect/load_firmware=false hostname= domain= interface=${net_default_mac} ${appends} lc/playbook_repo=carlfk lc/playbook_branch=master lc/inventory_repo=xfxf lc/inventory_branch=master

# d-i preseed/late_command string cd /target/tmp && wget http://$url/d-i/late_command.sh && chmod u+x late_command.sh && ANSIBLE_UNDER_DI=1 in-target /tmp/late_command.sh $url $(debconf-get mirror/suite) $(debconf-get passwd/username) $(debconf-get lc/playbook_repo) $(debconf-get lc/playbook_branch) $(debconf-get lc/inventory_repo) $(debconf-get lc/inventory_branch)

server=$1
suite=$2
user=$3

playbook_repo=$4
playbook_branch=$5
inventory_repo=$6
inventory_branch=$7

# provide current ansible
# apt install -y software-properties-common
# case $suite in
#    stretch|stable)
#        apt install dirmngr
#        apt-key adv --recv-keys 93C4A3FD7BB9C367
#        apt-add-repository --yes --update "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
#    ;;
#    xenial)
#        apt-add-repository --yes --update ppa:ansible/ansible
#    ;;
#esac

apt install -y ansible git eatmydata

# We clone our ansible repository and copy the ansible config files

cd /home/$user

# unset http_proxy
# wget --recursive --level=0 --no-host-directories --no-parent \
    # --reject "*.iso","*.gz",".*","*.swp","*.efi" \
    # --reject-regex "carl/.*" \
    # --default-page=.hideme \
    # http://$server:8000/
# #    --reject-regex ".*\.git/.*" \


git clone $playbook_repo /root/playbook-repo
(cd /root/playbook-repo; git checkout $playbook_branch)
# INVENTORY=/root/playbook-repo/inventory/hosts
PLAYBOOKS=/root/playbook-repo/site.yml

git clone $inventory_repo /root/inventory-repo
(cd /root/inventory-repo; git checkout $inventory_branch)

INVENTORY=/root/inventory-repo/inventory/hosts
if [ -e /root/inventory-repo/site.yml ]; then
	PLAYBOOKS="$PLAYBOOKS /root/inventory-repo/site.yml"
fi

cat > /usr/local/sbin/ansible-up <<EOF
#!/bin/sh

set -euf

cd /root/

(cd playbook-repo; git pull)
(cd inventory-repo; git pull)

exec ansible-playbook \\
	--inventory-file=$INVENTORY \\
	--connection=local \\
	--limit=\$(hostname) \\
	$PLAYBOOKS \\
	"\$@"
EOF
chmod +x /usr/local/sbin/ansible-up

eatmydata ansible-playbook \
	-vvvv \
	--inventory-file=$INVENTORY \
	--connection=local \
	--limit=$(hostname) \
	$PLAYBOOKS
