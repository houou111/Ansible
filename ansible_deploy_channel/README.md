# Hướng dẫn triển khai Ansible Deploy Channel

## 1. Chuẩn bị môi trường (chạy 1 lần duy nhất trên mỗi node)

- Cài đặt user docker và Docker Engine:
  ```bash
  ansible-playbook -i inventory playbooks/init_docker.yml
  ```
  - Tạo user `docker` UID 8001, home `/home/docker`, shell `/bin/bash`, group `docker`.
  - Cài đặt Docker Engine bằng script chính thức cho CentOS 9.

## 2. Backup file cấu hình local

Chạy script backup local để sao lưu các file cấu hình hiện tại:

```bash
./backup_local.sh
```

## 3. Thay đổi nội dung template

Chỉnh sửa các file template trong thư mục:

```
ansible_deploy_channel/roles/deploy_file/templates/
ansible_deploy_channel/roles/backup_file/templates/
ansible_deploy_channel/roles/up_service/templates/
```

Bạn có thể thay đổi nội dung các file `.j2` theo nhu cầu (ví dụ: cập nhật biến, cấu hình, v.v).

## 4. Chạy playbook Ansible triển khai

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

## 5. Cấu hình biến

- Biến dùng chung cho các node được khai báo trong:
  - `group_vars/channel_app.yml`:
    ```yaml
    remote_app_dir: /var/www/jbsv-prod/application
    remote_config_dir: /var/www/jbsv-prod/data/config
    ```
- Biến riêng cho từng node (ví dụ: `node_id`) khai báo trực tiếp trong file `inventory`:
    ```ini
    [channel_app]
    node1 ansible_host=10.148.0.21 node_id=1
    node2 ansible_host=10.148.0.20 node_id=2
    ```

## 6. Lưu ý
- Các thư mục và file trên remote sẽ được tạo và gán quyền `docker:docker` tự động.
- Toàn bộ thao tác copy, backup, up service đều thực hiện với user `docker`.
- Đảm bảo các file template docker-compose cần thiết đều có trong thư mục templates.
- Nếu thiếu file template nào, hãy bổ sung đúng tên và nội dung.
