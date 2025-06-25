# Hướng dẫn triển khai Ansible Deploy Channel

## 1. Backup file cấu hình local

Chạy script backup local để sao lưu các file cấu hình hiện tại:

```bash
./backup_local.sh
```

## 2. Thay đổi nội dung template

Chỉnh sửa các file template trong thư mục:

```
ansible_deploy_channel/roles/backup_file/templates/
```

Bạn có thể thay đổi nội dung các file `.j2` theo nhu cầu (ví dụ: cập nhật biến, cấu hình, v.v).

## 3. Chạy playbook Ansible

Chạy playbook để thực hiện backup, deploy file, hoặc up service:

- Chạy từng bước riêng lẻ:
  ```bash
  ansible-playbook -i inventory playbooks/backup_file.yml
  ansible-playbook -i inventory playbooks/deploy_file.yml
  ansible-playbook -i inventory playbooks/up_service.yml
  ```
- Hoặc chạy tất cả các bước:
  ```bash
  ansible-playbook -i inventory playbooks/deploy_all.yml
  ```

**Lưu ý:**
- Đảm bảo đã cập nhật đúng thông tin trong file `inventory`.
- Các biến như `remote_app_dir`, `remote_config_dir`, `node_id` cần được cấu hình phù hợp trong inventory hoặc group_vars/host_vars.
