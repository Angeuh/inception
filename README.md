*This project has been created as part of the 42 curriculum by llarrey.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small but fully functional web infrastructure using **Docker** and **Docker Compose**, entirely from scratch — without using pre-built images from Docker Hub (except for Alpine or Debian base images).

The infrastructure consists of three services running in isolated containers:

| Service | Role |
|---|---|
| **NGINX** | Reverse proxy / TLS termination (port 443 only) |
| **WordPress** | PHP-FPM application server |
| **MariaDB** | database backend |

Each service runs in its own dedicated container, built from a custom `Dockerfile`. All containers communicate through a private Docker network "network_inception", and persistent data is stored using Docker volumes.

### Design Choices

#### Virtual Machines vs Docker
Virtual Machines emulate a full hardware stack and run a complete OS kernel — they are heavy, slow to boot, and resource-intensive. Docker containers, on the other hand, share the host kernel and are isolated at the process level using Linux namespaces and cgroups. This makes them lightweight, fast to start, and ideal for running isolated services like a web stack. For this project, Docker is the obvious choice for efficiency and reproducibility.

#### Secrets vs Environment Variables
Environment variables are simple to use but are visible to any process in the container and can be accidentally leaked in logs or Docker inspect output. Docker Secrets (used via `docker secret` or mounted as files in `/run/secrets/`) are stored in a temporary in-memory filesystem and only accessible to authorized services. For sensitive data like database passwords, using secrets is the safer approach and is what this project implements.

#### Docker Network vs Host Network
With the **host network**, the container shares the host's network stack directly — no isolation, no port mapping. With a **Docker network** (bridge mode), each container gets its own virtual network interface and communicates with other containers via container names as hostnames. This project uses a custom bridge network so that containers are isolated from the host and from each other, communicating only through defined service names.

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- `make` available
- A `.env` file and secrets configured (see `DEV_DOC.md`)
- Domain name `llarrey.42.fr` pointing to `127.0.0.1` in `/etc/hosts`

### Installation & Execution

```bash

# Set up your .env file and secrets (see DEV_DOC.md)

# Build and start the full infrastructure
make

# Stop and remove containers
make down

# Clean everything (containers, volumes, images)
make fclean
```

The website will be available at: **https://llarrey.42.fr**

> ⚠️ NGINX only accepts HTTPS (port 443). HTTP access is not exposed.

---

## Resources

### Documentation & References

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [NGINX beginner's guide](https://nginx.org/en/docs/beginners_guide.html)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)

### Use of AI

AI (Claude by Anthropic) was used during this project for the following tasks:

- **Debugging**: Helping identify misconfigurations in Dockerfiles and the docker-compose.yml (e.g., volume permissions, PHP-FPM socket paths), mostly miswritten variables names.
- **Concept clarification**: Explaining differents concepts and finding answer to potential edge-case or to clarify some parts of documentations

