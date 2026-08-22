# Developer Documentation - Inception

This document provides technical guidelines for developers working on the Inception infrastructure project.

---

## 1. Environment Setup

### Prerequisites
* **OS**: A Unix-based system (Linux recommended, e.g., Debian).
* **Software**: 
  * Docker Engine (version 20.10+ recommended)
  * Docker Compose (v2.x recommended)
  * `make` utility

### Configuration Files
The project relies on a combinaison of `.env` files injected into containers and Docker secrets to securely store passwords.
1. Create a `.env` file based on the provided template.
2. Ensure mandatory variables are defined (e.g., `MYSQL_DATABASE`, `MYSQL_USER`, `DOMAIN_NAME`, `WP_ADMIN_NAME`, `WP_ADMIN_EMAIL`, `WP_USER_NAME`, `WP_USER_EMAIL`, `WP_DB_HOST=mariadb:3306`, `SITE_TITLE`).
3. Set your secret passwords within the following files : `mysql_pwd.txt`  `mysql_root_pwd.txt`  `wp_admin_pwd.txt`  `wp_usr_pwd.txt`

### Secrets Management
Sensitive information (database passwords, root passwords) must not be hardcoded in Dockerfiles.
* **Implementation**: The project uses environment variable injection for credentials. Ensure your local `.env` file is added to `.gitignore` to prevent sensitive credentials from being committed to the repository.

---

## 2. Building and Launching

The project is orchestrated using a `Makefile` that wraps standard `docker compose` commands.

* **Initial Build and Start**:
  Run the following command to build images and spin up the containers:
  ```bash
  make
  ```
  This triggers `docker-compose up -d --build`.

* **Stopping the Project**:
  To stop containers while preserving data (the built images, volumes and network):
  ```bash
  make stop
  ```

---

## 3. Managing Containers and Volumes

### Container Management
Use `docker-compose` directly for granular control:
* **View container status**: `docker compose ps`
* **View container logs**: `docker compose logs -f <service_name>`
* **Execute commands in a container**: `docker-compose exec <service_name> /bin/bash`

### Volume Management
To clean up the environment (useful for full re-installs):
* **Remove containers and volumes**: `make clean`
  * *Warning: This will delete all persistent data in the databases.*
* **Inspect volumes**: `docker volume ls` and `docker volume inspect <volume_name>`

---

## 4. Data Persistence

The project ensures data persistence by using Docker named volumes as required by project specifications.

* **Storage Type**: **Docker Named Volumes** are used to guarantee isolation and proper data management managed directly by the Docker daemon (bind mounts are not used).
* **Persistence Mechanism**: 
  * Volumes are declared in the `docker-compose.yml` file and mapped to the required internal container paths (e.g., `/var/lib/mysql` for MariaDB and `/var/lib/mysql` for WordPress).
  * **Lifecycle**: Data persists even if containers are stopped or removed. Only running `make clean` or explicitly pruning volumes (`docker volume prune`) will result in data loss.
