#!/bin/bash
BACKUP_DIR=/home/ansible/ansible/ansible_deploy_channel/bk
SRC_DIR=/home/ansible/ansible/ansible_deploy_channel/roles/r2.deploy_file/templates
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")
DEST_DIR="$BACKUP_DIR/deploy_file_$TIMESTAMP"

mkdir -p "$DEST_DIR"
cp $SRC_DIR/* "$DEST_DIR" 2>/dev/null || true

