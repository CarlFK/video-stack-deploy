#!/bin/bash

set -e

directory=$(mktemp -d)

queuename=$1
slots=$2

if [ "$queuename" = "hiprio.q" ]
then
  subordinate="slots=$slots(lowprio.q)"
else
  subordinate="NONE"
fi

cat > "${directory}/queue" <<EOF
qname $queuename
hostlist @allhosts
seq_no 0
load_thresholds np_load_avg=1.75
suspend_thresholds NONE
nsuspend 1
suspend_interval 00:05:00
priority 0
min_cpu_interval 00:05:00
processors UNDEFINED
qtype BATCH INTERACTIVE
ckpt_list NONE
pe_list smp
rerun FALSE
slots $slots
tmpdir /tmp
shell /bin/sh
prolog NONE
epilog NONE
shell_start_mode posix_compliant
starter_method NONE
suspend_method NONE
resume_method NONE
terminate_method NONE
notify 00:00:60
owner_list NONE
user_lists NONE
xuser_lists NONE
subordinate_list $subordinate
complex_values NONE
projects NONE
xprojects NONE
calendar NONE
initial_state default
s_rt INFINITY
h_rt INFINITY
s_cpu INFINITY
h_cpu INFINITY
s_fsize INFINITY
h_fsize INFINITY
s_data INFINITY
h_data INFINITY
s_stack INFINITY
h_stack INFINITY
s_core INFINITY
h_core INFINITY
s_rss INFINITY
h_rss INFINITY
s_vmem INFINITY
h_vmem INFINITY
EOF

qconf -Aq "${directory}/queue"
rm -r "${directory}"
