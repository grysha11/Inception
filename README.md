# Inception

*This project has been created as part of the 42 curriculum by hzakharc.*

## Description
Inception is a System Administration project designed to introduce the basics of **Docker** and **Docker Compose**. The goal is to set up a complete, small-scale infrastructure composed of different services running in docker containers.

Instead of using ready-made images, this project requires building custom Docker images from the penultimate stable version of Debian (Bookworm).

**Tech stack:**
* **NGINX:** The entry point with TLS v1.3.
* **WordPress + PHP-FPM:** The mighty wordpress.
* **MariaDB:** Default wordpress storage.

All services communicate over a dedicated Docker network and restart automatically in case of failure.

## Instructions

### Prerequisites
* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* Make
```bash
#if you are on debian/ubuntu
sudo apt-get install build-essential
```

### Installation & Execution

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/grysha11/Inception.git inception
    cd inception
    ```

2.  **Environment Configuration:**
    Create a `.env` file in the `srcs/` directory. You can use the provided example as a template:
    ```bash
    cp srcs/.env.example srcs/.env
    ```
    *Fill in the required variables (DB passwords, WP admin credentials, etc.).*

3.  **Host Configuration:**
    The project uses a custom domain `hzakharc.42.fr`. You must map this to your local machine:
    ```bash
    sudo vim /etc/hosts
    # Add this line:
    127.0.0.1   hzakharc.42.fr
    ```

4.  **Run the Project:**
    Use the Makefile at the root to build and start the application:
    ```bash
    make
    ```
    *This will create the necessary data directories in `/home/hzakharc/data`, build the images, and start the containers.*

5.  **Access:**
    Open your browser and navigate to: `https://hzakharc.42.fr`
    *(Accept the self-signed certificate warning)*.

### Commands
* `make` or `make run`: Build and start the containers in the background.
* `make build`: Build the images without starting.
* `make clean`: Stop and remove containers and networks.
* `make fclean`: Deep clean (removes containers, networks, images, and volumes).
* `make re`: Rebuild and restart everything from scratch.

---

## Project Description

This section explains the core concepts used in this project.

### 1. Virtual Machines vs Docker
* **Virtual Machines (VMs):** Emulate physical hardware. Goes through the full layer of virtualization. Each VM runs a full Operating System (Kernel + User Space) on top of a Hypervisor. Almost independently from the host machine essentially only using hardware of it. This provides strong isolation but consumes significant resources (RAM/CPU) and takes a loong time to boot.
* **Docker (Containers):** Utilizes OS-level virtualization. Containers runs on top of machine's Linux Kernel but have isolated user spaces binaries and libraries. This makes them extremely lightweight, fast to start, and portable compared to VMs. So it's docker is dealing with one very annoying problem known as "Well, it works on my machine".

### 2. Secrets vs Environment Variables
* **Environment Variables:** The simplest way to pass configuration (like passwords) to containers. They are easy to use but can be insecure if someone inspects the container (`docker inspect`), as values are visible in plain text.
* **Docker Secrets:** A more secure method where sensitive data is stored in encrypted files mounted into the container (usually at `/run/secrets/`). This prevents passwords from leaking in logs or inspection commands. I didn't use any secrets in my project because I didn't see any place where I can utilize them.

### 3. Docker Network vs Host Network
* **Host Network:** The container shares the IP address and port space of the host machine. This gives no isolation; if two services need port 80, they conflict.
* **Docker Network (Bridge):** Creates an isolated private network. Containers get their own internal IP addresses and can communicate using DNS (Service Names) without exposing internal ports (like 3306 or 9000) to the outside world.

### 4. Docker Volumes vs Bind Mounts
* **Docker Volumes:** Managed by Docker and stored in a specific part of the host filesystem (`/var/lib/docker/volumes/`). They are the preferred mechanism for persisting data.
* **Bind Mounts:** Map a specific file or directory on the host machine (e.g., `/home/user/data`) to a path inside the container.
    * I use **Bind Mounts** (via driver options in Compose) to strictly map database and website data to `/home/hzakharc/data`. This ensures data persists even if containers are destroyed.

---

## Resources

### Documentation
* [Docker Documentation](https://docs.docker.com/)
* [Docker course](https://www.boot.dev/courses/learn-docker)

## AI usage
* Basically instead of googling everything I would ask AI to explain me a lot of the concepts.