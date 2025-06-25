BACKUP_DIR=/home/ansible/deploy_channel/env_backup
ENV_FILE=/home/ansible/deploy_channel/.env
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")

BACKUP_FILE="$BACKUP_DIR/env_$TIMESTAMP"

mkdir -p $BACKUP_DIR

cp "$ENV_FILE" "$BACKUP_FILE"

