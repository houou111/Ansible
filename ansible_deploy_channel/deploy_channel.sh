#!/bin/bash
BACKUP_DIR=/var/www/jbsv-prod/application/env_backup
ENV_FILE=/var/www/jbsv-prod/application/.env

BACKUP_FILE=$(ls -t "$BACKUP_DIR"/env_* 2>/dev/null | head -n 1)


# Lấy danh sách image thay đổi
CHANGED_IMAGES=$(diff $BACKUP_FILE $ENV_FILE | grep '^>' | awk -F '=' '{print $1}' | sed 's/^>//' | grep 'IMAGE_')

if [ -n "$CHANGED_IMAGES" ]; then
    echo "Các image bị thay đổi: $CHANGED_IMAGES"
    for IMAGE in $CHANGED_IMAGES; do
        CONTAINER_NAME=$(echo $IMAGE | sed 's/IMAGE_//' | tr '[:upper:]' '[:lower:]')
        echo "Restarting container: $CONTAINER_NAME"
	cd /var/www/jbsv-prod/application
	/var/www/jbsv-prod/application/pull-image.sh
        docker-compose -f docker-compose-trading.yml up -d $CONTAINER_NAME
    done
else
    echo "Không có image nào thay đổi, không cần restart container."
fi
