*This project has been created as part of the 42 curriculum by epinaud.*

---

## Description

The **Inception** project is an introduction to system administration using Docker. The main goal is to discover containerization by setting up a small infrastructure of multiple services inside personal virtual machines (or a virtual machine provided for the evaluation), adhering to specific rules and best practices.

### Overview of Services
* **NGINX**: Acts as the single entry point (reverse proxy) configured exclusively with TLSv1.2 or TLSv1.3.
* **WordPress + PHP-FPM**: The website content management system running PHP FastCGI Process Manager without NGINX bundled inside the same container.
* **MariaDB**: The relational database management system for WordPress data storage.

### Use of Docker & Sources Included
This project uses custom Dockerfiles built from a stable base image (typically `debian:Bookworm` or `alpine`) rather than pre-built application images from Docker Hub (except for the base OS). Every service is built from scratch using Makefiles and Docker Compose to orchestrate the lifecycle of the containers, ensuring isolation, reproducibility, and modularity.

### Main Design Choices
* **Custom Dockerfiles**: Written manually to install and configure each service precisely as required.
* **Docker Compose**: Used to manage multi-container deployment, environment configurations, networks, and persistent volumes cleanly.
* **Volume Persistence**: Database and website files are stored through Docker named volumes to ensure data survives container restarts.

### Technical Comparisons

#### Virtual Machines vs Docker
* **Virtual Machines (VMs)** virtualize full hardware stacks, including a heavy guest operating system and virtualized hardware, leading to higher resource consumption and slower startup times.
* **Docker** containerizes only the application and its dependencies, sharing the host machine's kernel. This makes containers lightweight, highly portable, and nearly instantaneous to start.

#### Secrets vs Environment Variables
* **Environment Variables** are easily exposed through logs, process listings (`ps`), or inspect commands, making them less secure for sensitive data like passwords.
* **Docker Secrets** (or secure file-mounting practices) securely inject sensitive data (like database passwords) directly into containers without exposing them in plaintext configuration files or environment lists.

#### Docker Network vs Host Network
* **Docker Network** creates a private, isolated virtual bridge network allowing containers to securely communicate with each other using container names as hostnames while shielding them from the outside world.
* **Host Network** removes network isolation between the container and the host, binding container ports directly to the host network stack, which increases security risks.

#### Docker Volumes vs Bind Mounts
* **Docker Volumes** are entirely managed and stored by Docker within the host's filesystem (`/var/lib/docker/volumes/`), offering optimal performance and safety managed natively by the Docker daemon.
* **Bind Mounts** depend on the host machine's specific directory structure and file permissions, making them more fragile and dependent on the underlying host environment.

---

## Instructions

### Prerequisites
* A UNIX-like operating system (Linux or macOS).
* `Docker` and `Docker Compose` installed.
* Administrative privileges (sudo access) to manage Docker services.

### Installation & Execution
1. Clone the repository into your local machine:
   ```bash
   git clone <repository-url> inception
   cd inception

2. Configure your domain name and environment variables in the `.env` file (make sure to point your domain to `localhost` inside your `/etc/hosts` file):
   ```bash
   sudo echo "127.0.0.1 <login>.42.fr" >> /etc/hosts
   ```

3. Build and launch the project using the Makefile:
   ```bash
   make
   ```

4. Access the website via curl / w3m or your Web Browser if you got a graphical OS:
   ```text
   w3m https://<login>.42.fr
   ```

### Useful Makefile Commands
* `make` or `make up`: Build and start all containers in the background.
* `make down`: Stop and remove all containers.
* `make clean`: Stop containers and remove volumes, images, and networks (full cleanup).
* `make re`: Rebuild the entire project from scratch.

---

## Resources

### Documentation & References
* [Official Docker Documentation](https://docs.docker.com/)
* [NGINX Documentation](https://nginx.org/en/docs/)
* [MariaDB Knowledge Base](https://mariadb.com/kb/)
* [WordPress Developer Resources](https://developer.wordpress.org/)

### AI Usage Disclosure
* **Tasks & Parts**: AI was utilized to help structure the comparative analysis (VMs vs Docker, Secrets vs Env, etc.), optimize Dockerfile syntax for efficiency, and troubleshoot NGINX SSL configuration blocks. It was not used to compose the README section which was meticulously crafted by the author who obviously has so much time to waste :)  All code implementations, configuration debugging, and final setups were manually reviewed, tested, and validated.
