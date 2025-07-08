# Ansible Project Structure (Best Practice)

```
ansible-project/
├── inventories/
│   ├── dev/
│   │   ├── hosts.ini
│   │   ├── group_vars/
│   │   │   └── all.yml
│   │   └── host_vars/
│   │       └── db01.yml
│   └── prod/
│       ├── hosts.ini
│       ├── group_vars/
│       │   └── all.yml
│       └── host_vars/
│           └── db01.yml
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── files/
│   │   ├── templates/
│   │   └── defaults/
│   │       └── main.yml
│   └── mysql/
│       └── ...
├── files/
├── templates/
├── playbooks/
│   ├── db.yml
│   ├── web.yml
│   └── monitoring.yml
├── vars/
│   ├── global.yml
│   └── app_specific.yml
├── vault/
│   ├── dev/
│   │   └── secrets.yml
│   └── prod/
│       └── secrets.yml
├── tests/
│   └── test.yml
├── ansible.cfg
├── site.yml
└── README.md
```

## Cách chạy
```bash
ansible-playbook -i inventories/dev/hosts.ini site.yml
```
│       │   └── manage_services.yml # Service management tasks
│       └── templates/
│           ├── postgresql.conf.j2 # PostgreSQL configuration template
│           ├── pg_hba.conf.j2    # pg_hba.conf template
│           ├── recovery.conf.j2  # recovery.conf template
│           └── patroni.yml.j2    # Patroni configuration template
└── site.yml                     # Main playbook file
```

## File Descriptions and Execution Order

### Main Playbook (site.yml)
- Orchestrates the entire deployment process
- Executes roles in the correct order: etcd first, then PostgreSQL

### etcd Role Files
1. `defaults/main.yml`: Defines default variables for etcd installation and configuration
2. `tasks/main.yml`: Main task list that imports other task files
3. `tasks/pre_install.yml`: Prepares system for etcd installation
4. `tasks/install_etcd.yml`: Downloads and installs etcd binaries
5. `tasks/configure_etcd.yml`: Configures etcd cluster settings
6. `tasks/manage_services.yml`: Manages etcd service
7. `templates/etcd.conf.j2`: Template for etcd configuration

### PostgreSQL with Patroni Role Files
1. `defaults/main.yml`: Defines default variables for PostgreSQL and Patroni
2. `tasks/main.yml`: Main task list that imports other task files
3. `tasks/pre_install.yml`: Prepares system for PostgreSQL installation
4. `tasks/install_postgresql.yml`: Installs PostgreSQL 16
5. `tasks/install_patroni.yml`: Installs and configures Patroni service
6. `tasks/configure_postgresql.yml`: Configures PostgreSQL settings
7. `tasks/configure_patroni.yml`: Configures Patroni settings
8. `tasks/manage_services.yml`: Manages PostgreSQL and Patroni services
9. Templates:
   - `postgresql.conf.j2`: PostgreSQL configuration template
   - `pg_hba.conf.j2`: Client authentication configuration template
   - `recovery.conf.j2`: Recovery configuration template
   - `patroni.yml.j2`: Patroni configuration template

## Execution Order

1. etcd Cluster Setup:
   - System preparation (pre_install.yml)
   - etcd installation (install_etcd.yml)
   - etcd configuration (configure_etcd.yml)
   - Service management (manage_services.yml)

2. PostgreSQL with Patroni Setup:
   - System preparation (pre_install.yml)
   - PostgreSQL installation (install_postgresql.yml)
   - Patroni installation (install_patroni.yml)
   - PostgreSQL configuration (configure_postgresql.yml)
   - Patroni configuration (configure_patroni.yml)
   - Service management (manage_services.yml)

## Configuration

1. Update the inventory file (`inventory/hosts`) with your server details:
   ```ini
   [etcd]
   etcd1 ansible_host=etcd1.example.com
   etcd2 ansible_host=etcd2.example.com
   etcd3 ansible_host=etcd3.example.com

   [postgresql]
   pg1 ansible_host=pg1.example.com
   pg2 ansible_host=pg2.example.com
   pg3 ansible_host=pg3.example.com
   ```

2. Adjust variables in `roles/*/defaults/main.yml` if needed.

## Usage

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd postgresql-patroni-ansible
   ```

2. Run the playbook:
   ```bash
   ansible-playbook -i inventory/hosts site.yml
   ```

## Features

- Installs and configures PostgreSQL 16
- Sets up Patroni for high availability
- Configures etcd cluster for distributed configuration
- Configures automatic failover
- Sets up streaming replication
- Configures WAL archiving
- Sets up proper system limits and security

## Default Credentials

- PostgreSQL superuser: postgres/postgres
- Replication user: replicator/replicator

## Notes

- Make sure to change default passwords in production
- Adjust PostgreSQL parameters based on your server resources
- Configure firewall rules to allow communication between nodes
- Backup your data before running this playbook 