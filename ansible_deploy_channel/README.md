# Ansible Deploy Channel - Hướng dẫn sử dụng

## 1. Cấu trúc thư mục

```
ansible_deploy_channel/
├── ansible.cfg
├── backup_local.sh
├── inventories/
│   ├── dev/hosts.ini
│   └── prod/hosts.ini
├── group_vars/
│   └── all.yml
├── logs/
├── playbooks/
│   ├── p0.init_docker.yml
│   ├── p1.backup_file.yml
│   ├── p2.deploy_file.yml
│   ├── p3.up_service.yml
│   └── p9.rollback_from_lastest_bk.yml
├── roles/
│   ├── r0.init_docker/
│   │   └── tasks/main.yml
│   ├── r1.backup_file/
│   │   ├── tasks/main.yml
│   │   └── template/backup_before_deploy.sh.j2
│   ├── r2.deploy_file/
│   │   ├── bk/
│   │   ├── tasks/main.yml
│   │   └── templates/*.j2 (các file env, docker-compose, ...)
│   ├── r3.up_service/
│   │   ├── tasks/main.yml
│   │   └── templates/up-all.sh.j2
│   └── r9.rollback_from_lastest_bk/
│       ├── tasks/main.yml
│       └── templates/rollback_from_lastest_bk.sh.j2
├── site.yml
├── README.md
├── bk/
└── ...
```

## 2. Chuẩn bị môi trường

- Chạy playbook khởi tạo Docker và user docker:
  ```bash
  ansible-playbook -i inventories/dev/hosts.ini playbooks/p0.init_docker.yml
  ```

## 3. Backup cấu hình local

- Chạy script backup local:
  ```bash
  ./backup_local.sh
  ```

## 4. Chỉnh sửa template cấu hình
- Sửa các file `.j2` trong:
  - `roles/r2.deploy_file/templates/`
  - `roles/r1.backup_file/template/`
  - `roles/r3.up_service/templates/`

## 5. Triển khai ứng dụng

- Chạy từng bước:
  ```bash
  ansible-playbook -i inventories/dev/hosts.ini playbooks/p1.backup_file.yml
  ansible-playbook -i inventories/dev/hosts.ini playbooks/p2.deploy_file.yml
  ansible-playbook -i inventories/dev/hosts.ini playbooks/p3.up_service.yml
  ```
- Hoặc chạy tất cả qua site.yml:
  ```bash
  ansible-playbook -i inventories/dev/hosts.ini site.yml
  ```

## 6. Rollback (khôi phục từ backup gần nhất)

- Chạy playbook rollback:
  ```bash
  ansible-playbook -i inventories/dev/hosts.ini playbooks/p9.rollback_from_lastest_bk.yml
  ```

## 7. Cấu hình biến
- Biến chung: `group_vars/all.yml`
- Biến riêng: file `inventories/dev/hosts.ini` hoặc `inventories/prod/hosts.ini`

## 8. Lưu ý
- Các thao tác đều thực hiện với user/group `docker:docker`.
- Thư mục backup lưu tại `bk/`.
- Nếu thiếu file template, hãy bổ sung đúng tên và nội dung.
