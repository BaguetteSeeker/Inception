# User Documentation - Inception

Welcome to the **Inception** project user guide. This document explains how to use, access, and manage the services provided by this infrastructure stack.

---

## 1. Overview of Services

The infrastructure consists of three containerized services working together to host a secure WordPress website:

* **NGINX**: Acts as the secure single entry point (reverse proxy) for the website. It handles incoming secure traffic over HTTPS using TLSv1.2 or TLSv1.3 and forwards requests to WordPress.
* **WordPress + PHP-FPM**: The Content Management System (CMS) that generates the web pages dynamically using PHP.
* **MariaDB**: The relational database management system where WordPress stores all its posts, pages, and user data.

---

## 2. Starting and Stopping the Project

The project is managed using a `Makefile` located at the root of the repository.

* **Start the Stack**:
  To build (if needed) and run all services in the background, open your terminal at the root directory and run:
  ```bash
  make
  ```

* **Stop the Stack**:
  To safely stop all running containers without losing data, run:
  ```bash
  make down
  ```

---

## 3. Accessing the Website and Administration Panel

* **Public Website**: 
  Open your web browser and navigate to your assigned domain (replace `<login>` with your 42 username):
  ```text
  https://<login>.42.fr
  ```
  *(Note: Since this uses a self-signed SSL certificate, your browser may show a security warning. You can safely proceed by clicking "Advanced" and then "Proceed to localhost/domain".)*

* **WordPress Administration Panel**:
  To log into the WordPress dashboard to manage posts, themes, and settings, go to:
  ```text
  https://<login>.42.fr/wp-admin
  ```

---

## 4. Locating and Managing Credentials

Sensitive configuration parameters, credentials, and database keys are stored securely using environment variables.

* **Location of Configuration**:
  * Environment variables are defined in the `.env` file located at the root of the project repository.
* **Key Credentials Managed**:
  * **Database credentials**: Database name, user, password, and root password.
  * **WordPress credentials**: Admin user, admin password, and admin email.
* **Important Note**: Never share your `.env` file or commit it to public version control systems.

---

## 5. Checking Service Health and Status

To ensure all containers are running properly and communicating without errors, you can use the following commands:

* **Check Container Status**:
  ```bash
  docker-compose ps
  ```
  All three services (`nginx`, `wordpress`, `mariadb`) should show a status of `Up` or `running`.

* **View Real-Time Logs**:
  If you suspect an issue with a specific service, you can check its logs by running:
  ```bash
  docker-compose logs -f <service_name>
  ```
  *(Replace `<service_name>` with `nginx`, `wordpress`, or `mariadb`)*
