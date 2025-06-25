#!/bin/bash
BACKUP_DIR=/var/www/jbsv-prod/application/env_backup
ENV_FILE=/var/www/jbsv-prod/application/.env
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/env_$TIMESTAMP"

mkdir -p $BACKUP_DIR

cp "$ENV_FILE" "$BACKUP_FILE"

