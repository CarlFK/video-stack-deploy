#!/bin/sh

set -eufx

# This script setups ansible and runs it
# It should be ran at the end of the basic installation of a machine

apt install -y ansible git eatmydata

# We clone our ansible repository and copy the ansible config files

git clone https://github.com/CarlFK/video-stack-deploy.git /root/playbook-repo
(cd /root/playbook-repo; git checkout master)
INVENTORY=/root/playbook-repo/inventory/hosts
PLAYBOOKS=/root/playbook-repo/site.yml

git clone https://github.com/xfxf/av-foss-stack.git /root/inventory-repo
(cd /root/inventory-repo; git checkout master)
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
