#!/bin/sh

set -efux

# This script (late_command.sh) sets up ansible and runs it.
# It should be ran at the end of the basic installation of a machine.
# It takes one parameter, the base url that was passed to d-i. This should be a
# bare hostname of the PXE server.

server=$1
wget http://$server/scripts/late_command.cfg -O /tmp/late_command.cfg
. /tmp/late_command.cfg

apt-get install -y git eatmydata
# Ansible >= 2.4
suite=$(lsb_release -cs)
case $suite in
	stretch)
		apt-get install -y ansible/stretch-backports
		;;
	xenial|artful)
		apt-add-repository --yes --update ppa:ansible/ansible
		apt-get install -y ansible
		;;
	*)
		apt-get install -y ansible
		;;
esac

# clone our ansible repository(s)
# create and run a script to run ansible on the local box.

git clone $playbook_repo /root/playbook-repo
(cd /root/playbook-repo; git checkout $playbook_branch)
INVENTORY=/root/playbook-repo/$inventory_repo_dir/hosts
PLAYBOOKS=/root/playbook-repo/site.yml

if [ "${inventory_repo}" != "" ]; then
	git clone $inventory_repo /root/inventory-repo
	INVENTORY=/root/inventory-repo/$inventory_repo_dir/hosts
	if [ -e /root/inventory-repo/$inventory_repo_dir/site.yml ]; then
		PLAYBOOKS="$PLAYBOOKS /root/inventory-repo/$inventory_repo_dir/site.yml"
	fi
fi

echo "$vault_pw" | base64 -d > /root/.ansible-vault
chmod 600 /root/.ansible-vault

vault_pw_arg=
if [ "$vault_pw" != "" ]; then
    vault_pw_arg="--vault-password-file=/root/.ansible-vault"
fi

script=/usr/local/sbin/ansible-up
cat > $script <<EOF
#!/bin/sh

set -euf

# playbook_repo="${playbook_repo}"
# playbook_branch="${playbook_branch}"
# inventory_repo="${inventory_repo}"
# inventory_repo_dir="${inventory_repo_dir}"

cd /root/

(cd playbook-repo; git pull)

if [ "${inventory_repo}" != "" ]; then
	(cd inventory-repo; git pull)
fi

ansible-playbook \\
    --diff --inventory-file=$INVENTORY \\
    ${vault_pw_arg} \\
    --connection=local \\
    --limit=\$(hostname) \\
    $PLAYBOOKS \\
    "\$@"
EOF
chmod +x $script

ANSIBLE_UNDER_DI=1 $script
