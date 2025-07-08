#!/bin/bash

# Thư mục backup và đích đến
BACKUP_DIR=/home/ansible/ansible/ansible_deploy_channel/bk
SRC_DIR=/home/ansible/ansible/ansible_deploy_channel/roles/r2.deploy_file/templates
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")
DEST_DIR="$BACKUP_DIR/deploy_file_$TIMESTAMP"

# Backup thư mục đích hiện tại
mkdir -p "$DEST_DIR"
cp "$SRC_DIR"/* "$DEST_DIR" 2>/dev/null || true
echo "📦 Templates backed up to $DEST_DIR"


# Thư mục chứa các file .env gốc
ENV_DIR=/home/ansible/ansible/ansible_deploy_channel/new_env


# Xử lý các file .env trong ENV_DIR
for file in "$ENV_DIR"/*.env; do
    # Lấy tên file
    filename=$(basename "$file")
    newfile="${filename}.j2"

    # Tạo file tạm để xử lý
    tmpfile=$(mktemp)

    # Thay NODEID hoặc NODE_ID thành NODEID={{ node_id }}
    sed -E 's/^(NODEID|NODE_ID)=.*/NODEID={{ node_id }}/' "$file" > "$tmpfile"

    # Copy sang SRC_DIR với tên .env.j2
    cp "$tmpfile" "$SRC_DIR/$newfile"
    echo "✅ Processed $filename → $SRC_DIR/$newfile"

    # Xoá file tạm
    rm -f "$tmpfile"
done

echo -e "\n🎉 Done. All processed .env files saved as .j2 to $SRC_DIR"

