# Developer Documentation

## 1. Environment Setup
To set up the development environment from scratch, follow these steps.

### Prerequisites
* **OS:** Linux (Debian/Ubuntu recommended) or macOS.
* **Tools:** Docker Engine, Docker Compose, Make.

### Configuration Files
The project uses environment variables for sensitive configuration.
1.  Navigate to the source folder: `cd srcs/`
2.  Create the `.env` file from the example:
    ```bash
    cp .env.example .env
    ```
3.  **Edit `.env`:** You must fill in the following variables:
    * `MYSQL_ROOT_PASSWORD`
    * `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`
    * `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`
    * `DOMAIN_NAME`

### Network Configuration (DNS)
The project runs on a custom domain. You must map it to your local machine:
```bash
# Open hosts file
sudo vim /etc/hosts

# Add the following line:
127.0.0.1   hzakharc.42.fr

```

---

## 2. Building and Launching

The project is managed via a `Makefile` located at the root of the repository.

### Build and Start

```bash
make

```

* **Description:** Builds the Docker images (if not built) and starts the containers in detached mode.
* **Docker equivalent:** `docker compose -f srcs/docker-compose.yml up -d --build`

### Build Only

```bash
make build

```

* **Description:** Builds the images without starting the containers.

### Stop and Clean

```bash
make clean

```

* **Description:** Stops containers and removes the Docker network.

### Deep Clean (Reset)

```bash
make fclean

```

* **Description:** Stops containers, deletes images, networks, and **removes all persistent data volumes** from the host.

---

## 3. Container Management

Developers can interact directly with the containers using standard Docker commands.

### View Logs

To debug issues in real-time (e.g., NGINX errors or MariaDB startup logs):

```bash
docker compose -f srcs/docker-compose.yml logs -f

```

### Access Container Shell

To enter a running container for manual inspection:

```bash
# Syntax: docker exec -it <service_name> <shell>
docker exec -it wordpress /bin/bash
docker exec -it mariadb /bin/bash
docker exec -it nginx /bin/bash

```

### Restart a Service

If you change a configuration file (like `nginx.conf`) without rebuilding the whole stack:

```bash
docker compose -f srcs/docker-compose.yml restart nginx

```

---

## 4. Data Persistence

Data is persisted using **Bind Mounts** to the host machine. This ensures data survives even if containers are destroyed.

### Storage Locations

* **Database (MariaDB):**
* **Host Path:** `/home/hzakharc/data/db`
* **Container Path:** `/var/lib/mysql`


* **Website Files (WordPress):**
* **Host Path:** `/home/hzakharc/data/wp`
* **Container Path:** `/var/www/html`



### Persistence Logic

* **MariaDB:** Uses a custom `init-file` strategy in `setup.sh`. On every startup, it enforces SQL user grants (`GRANT ALL...`) to ensure the WordPress user can always connect, even if the container is rebuilt over existing data.
* **WordPress:** The entrypoint script checks for `wp-config.php` in the volume.
* If **Missing**: It downloads WordPress and generates the config.
* If **Present**: It skips installation and starts PHP-FPM immediately.