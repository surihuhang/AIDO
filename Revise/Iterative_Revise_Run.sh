#!/bin/bash
on_exit() {
  # All tasks complete, attempting to clean up child processes...
  echo "All tasks complete, attempting to clean up child processes..."

  # Get the current script's PID and Process Group ID (PGID)
  CURRENT_PID=$$
  PGID=$(ps -o pgid= $$ | tr -d ' ')

  # Current script PID: $CURRENT_PID | PGID: $PGID
  echo "Current script PID: $CURRENT_PID | PGID: $PGID"

  # Find all processes with the same PGID as the current script (excluding itself)
  CHILD_PIDS=$(ps -eo pid,pgid,comm | awk -v pgid="$PGID" -v ppid="$$" '$2==pgid && $1!=ppid { print $1 }')

  if [[ -z "$CHILD_PIDS" ]]; then
    # No cleanup needed, no residual child processes found belonging to this script.
    echo "No cleanup needed, no residual child processes found belonging to this script."
  else
    # Terminating the following child processes spawned by this script:
    echo "Terminating the following child processes spawned by this script:"
    echo "$CHILD_PIDS"
    kill $CHILD_PIDS
    # Child process cleanup complete.
    echo "Child process cleanup complete."
  fi
}
trap on_exit EXIT


set -euo pipefail

export Strong_API_BASE="http://0.0.0.0:9000/v1"  # The 8B model
export Strong_MODEL_NAME="llama3.1-70B"

export Backbone_API_BASE="http://0.0.0.0:8000/v1"  # The 70B model
export Backbone_MODEL_NAME="llama3.1-8B"

Dataset_dir="/mnt/beegfs/xr/liu_zy/Data_OP/AIDO/Select/data/stage_2_Clustering_Ranking/Dolly/"
Base_dir="/mnt/beegfs/xr/liu_zy/Data_OP/AIDO/Revise/Revise_Low/step_output"
result_Path="/mnt/beegfs/xr/liu_zy/Data_OP/AIDO/Result/Dolly_low_revised.json"
name="Dolly"


echo "---------------------------------step1 has started------------------------------"
python step1.py \
    --dataset_dir $Dataset_dir \
    --base_dir $Base_dir \
    --Name $name \

echo "--------------------------------step2 has started------------------------------"
python step2.py \
    --base_dir $Base_dir \
    --Name $name \

echo "-------------------------step3 and "step4" has started-------------------------"
python step3.py \
    --base_dir $Base_dir \
    --Name $name \
    --Result_Path $result_Path



trap "echo '❌ The script was interrupted, exiting immediately.'; exit 1" SIGINT SIGTERM


