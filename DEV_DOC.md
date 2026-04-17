# DEV_DOC.md — Developer Documentation

This document describes how a developer can set up, build, and manage the Inception infrastructure from scratch.

---

## Prerequisites

Make sure the following tools are installed on your machine:

- **Docker** (v20.10+)
- **Docker Compose** (v2+)
- **make**
- **openssl** (for generating the TLS certificate)

---

## Project Structure

```
inception/
├── Makefile
├── .env                        # Environment variables (not committed)
├── secrets/                    # Docker secrets (not committed)
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
├── srcs/
│   ├── docker-compose.yml
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   └── conf/
│       └── mariadb/
│           ├── Dockerfile
│           └── conf/
└── README.md
```

---

## Environment Setup

### 1. Configure the `.env` file

Create a `.env` file at the root of the project with the following variables:

```env
DOMAIN_NAME=llarrey.42.fr

# MariaDB
DB_NAME=wordpress
DB_USER=wp_user

# WordPress
WP_TITLE=Inception
WP_ADMIN_USER=llarrey
WP_ADMIN_EMAIL=llarrey@student.42.fr
WP_USER=visitor
WP_USER_EMAIL=visitor@example.com
```

> Passwords must **not** be stored in `.env` — they go in `secrets/`.

### 2. Create the secrets

```bash
mkdir -p secrets
echo "your_db_password"       > secrets/db_password.txt
echo "your_db_root_password"  > secrets/db_root_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password"  > secrets/wp_user_password.txt
```

Make sure these files are listed in `.gitignore` or are not pushed:

```
secrets/
```

### 3. Add the domain to `/etc/hosts`

```bash
add "127.0.0.1   llarrey.42.fr" in /etc/hosts
```

---

## Building and Launching the Project

### Build and start all services

```bash
make
```

This runs `docker compose up --build -d` from the `srcs/` directory.

### Stop services (keep volumes)

```bash
make down
```

### Rebuild a single service

```bash
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up -d wordpress
```

---

## Useful Container Management Commands

### List running containers

```bash
docker ps
```

### Open a shell in a container

```bash
docker exec -it nginx sh
docker exec -it wordpress sh
docker exec -it mariadb sh
```

### View real-time logs

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

### Inspect a volume

```bash
docker volume inspect srcs_wp_data
docker volume inspect srcs_db_data
```

### Remove all stopped containers, unused images and networks

```bash
docker system prune -a
```

---

## Data Persistence

Data is stored in two named Docker volumes:

| Volume | Mounted in | Contents |
|---|---|---|
| `srcs_db_data` | `/var/lib/mysql` (mariadb) | MariaDB database files |
| `srcs_wp_data` | `/var/www/html` (wordpress + nginx) | WordPress source files |

These volumes are stored on the host at:

```
/home/llarrey/inception/srcs/requirements/mariadb/data
/home/llarrey/inception/srcs/requirements/wordpress/data
```

> Volume data **persists** across `make down`. Only `make fclean` will delete it.

To manually inspect volume contents on the host:

```bash
ls /home/llarrey/inception/srcs/requirements/mariadb/data
ls /home/llarrey/inception/srcs/requirements/wordpress/data
```

---

## TLS Certificate

NGINX requires a self-signed TLS certificate. It is generated automatically during the NGINX image build using `openssl`:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx.key \
  -out /etc/ssl/certs/nginx.crt \
  -subj "/CN=llarrey.42.fr"
```

NGINX is configured to only accept **TLSv1.2** and **TLSv1.3** connections on port **443**.
