# Ansible Deploy Channel - Hướng dẫn sử dụng

## 1. Cấu trúc thư mục

```
ansible_deploy_channel/
├── ansible.cfg
├── backup_local.sh
├── inventory
├── README.md
├── bk/
│   └── deploy_file_<timestamp>/
├── group_vars/
│   └── channel_app.yml
├── logs/
├── playbooks/
│   ├── 0.init_docker.yml
│   ├── 1.0.deploy_all.yml
│   ├── 1.1.backup_file.yml
│   ├── 1.2.deploy_file.yml
│   ├── 1.3.up_service.yml
│   └── 2.0.rollback_from_lastest_bk.yml
├── roles/
│   ├── backup_file/
│   │   ├── tasks/main.yml
│   │   └── templates/backup_before_deploy.sh.j2
│   ├── deploy_file/
│   │   ├── bk/
│   │   ├── tasks/main.yml
│   │   └── templates/*.j2 (các file env, docker-compose, ...)
│   ├── init_docker/
│   │   └── tasks/main.yml
│   ├── rollback/
│   │   ├── tasks/main.yml
│   │   └── templates/rollback_from_lastest_bk.sh.j2
│   └── up_service/
│       ├── tasks/main.yml
│       └── templates/up-all.sh.j2
```

## 2. Chuẩn bị môi trường

- Chạy playbook khởi tạo Docker và user docker:
  ```bash
  ansible-playbook -i inventory playbooks/0.init_docker.yml
  ```

## 3. Backup cấu hình local

- Chạy script backup local:
  ```bash
  ./backup_local.sh
  ```

## 4. Chỉnh sửa template cấu hình
- Sửa các file `.j2` trong:
  - `roles/deploy_file/templates/`
  - `roles/backup_file/templates/`
  - `roles/up_service/templates/`

## 5. Triển khai ứng dụng

- Chạy từng bước:
  ```bash
  ansible-playbook -i inventory playbooks/1.1.backup_file.yml
  ansible-playbook -i inventory playbooks/1.2.deploy_file.yml
  ansible-playbook -i inventory playbooks/1.3.up_service.yml
  ```
- Hoặc chạy tất cả:
  ```bash
  ansible-playbook -i inventory playbooks/1.0.deploy_all.yml
  ```

## 6. Cấu hình biến

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

## 7. Lưu ý
- Các thư mục và file trên remote sẽ được tạo và gán quyền `docker:docker` tự động.
- Toàn bộ thao tác copy, backup, up service đều thực hiện với user `docker`.
- Đảm bảo các file template docker-compose cần thiết đều có trong thư mục templates.
- Nếu thiếu file template nào, hãy bổ sung đúng tên và nội dung.
