#!/bin/bash

set -e

directory=$(mktemp -d)

cat > "${directory}/smppe" <<EOF
pe_name smp
slots 0
user_lists NONE
xuser_lists NONE
start_proc_args NONE
stop_proc_args NONE
allocation_rule \$pe_slots
control_slaves FALSE
job_is_first_task TRUE
urgency_slots min
accounting_summary FALSE
qsort_args NONE
EOF

qconf -Ap "${directory}/smppe"
