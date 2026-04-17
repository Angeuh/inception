# USER_DOC.md — User Documentation

This document explains how an end user or administrator can interact with the Inception infrastructure.

---

## Services Provided

The stack exposes the following services:

| Service | Description | Access |
|---|---|---|
| **WordPress** | A fully functional CMS website | https://llarrey.42.fr |
| **WordPress Admin** | Administration dashboard | https://llarrey.42.fr/wp-admin |
| **MariaDB** | Database (internal only, not exposed publicly) | Internal container only |
| **NGINX** | Reverse proxy handling all HTTPS traffic | Port 443 |

---

## Starting and Stopping the Project

### Start the infrastructure

```bash
make
```

This will build all Docker images and start all containers in the background.

### Stop the infrastructure

```bash
make down
```

This stops and removes the containers, but **preserves volumes and data**.

### Full cleanup

```bash
make fclean
```

This removes containers, images, and **all volumes** including the database and WordPress files.

---

## Accessing the Website

1. Make sure `llarrey.42.fr` resolves to your machine. Add the following line to `/etc/hosts` if not already present:

```
127.0.0.1   llarrey.42.fr
```

2. Open your browser and navigate to:

```
https://llarrey.42.fr
```

> The site uses a **self-signed TLS certificate**. Your browser will show a security warning — this is expected. Accept the exception to proceed.

### Accessing the Admin Panel

Navigate to:

```
https://llarrey.42.fr/wp-admin
```

Log in with the WordPress admin credentials (see the section below).

---

## Credentials

Credentials are stored as **Docker secrets** in the `secrets/` directory at the root of the project. They are mounted as files inside containers at `/run/secrets/`.

| Secret file | Contents |
|---|---|
| `secrets/db_password.txt` | MariaDB user password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/wp_admin_password.txt` | WordPress admin password |
| `secrets/wp_user_password.txt` | WordPress regular user password |

The WordPress admin username and other non-sensitive settings are defined in the `.env` file at the project root.

---

## Checking That Services Are Running

### View running containers

```bash
docker ps
```

All three containers (`nginx`, `wordpress`, `mariadb`) should appear with status `Up`.

### View logs for a specific service

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Check NGINX is serving correctly

```bash
curl -k https://llarrey.42.fr
```

There should be an HTML response from WordPress.

### Check MariaDB is up

```bash
docker exec -it mariadb bash
mariadb -u root -p wordpress
```
-u means root user
-p is for wordpress database

Enter the root password from `secrets/db_root_password.txt`.
