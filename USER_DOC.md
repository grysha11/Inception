# User Documentation

## 1. Service Overview
This project sets up a complete web infrastructure composed of three interacting services.

* **NGINX:** The secure gateway to your website. It handles SSL encryption (HTTPS) and directs traffic to the correct internal service.
* **WordPress:** The website engine. This is where you create content, manage users, and edit your site's appearance.
* **MariaDB:** The database. It securely stores all your website data, including posts, comments, and user credentials.

## 2. Managing the Project
We use `make` to automate the startup and shutdown procedures. Run these commands from the root of the repository:

### Start the Project
```bash
make

```

* **What it does:** Downloads dependencies, builds the Docker images, and starts all services in the background.
* **First run:** The first launch may take a minute as it compiles the images from scratch.

### Stop the Project

```bash
make clean

```

* **What it does:** Stops the running containers and removes the Docker network.
* **Note:** Your data (posts, accounts) is **preserved** on your hard drive even after stopping.

### Reset (Fresh Start)

```bash
make re

```

* **What it does:** Performs a full clean and restarts the project. Use this if the services are behaving unexpectedly.

---

## 3. Accessing the Website

Once the project is running:

### The Website

* **URL:** [https://hzakharc.42.fr](https://hzakharc.42.fr)
* **Security Warning:** Because this project uses a self-signed certificate, your browser will warn you that the connection is not private. You must **Accept the Risk** or click **Proceed** to view the site.

### Administration Panel

* **URL:** [https://hzakharc.42.fr/wp-admin](https://hzakharc.42.fr/wp-admin)
* **Usage:** Log in here to access the WordPress Dashboard, where you can configure the site and manage users.

---

## 4. Locating Credentials

For security, passwords and usernames are **not** displayed in this documentation. They are stored in a .env file.

* **File Location:** `srcs/.env`
* **How to View:**
Run the following command in your terminal:
```bash
cat srcs/.env

```


* **WordPress Admin:** Look for `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD`.
* **Database Root:** Look for `MYSQL_ROOT_PASSWORD`.



---

## 5. Verifying Service Status

To ensure everything is running correctly, use the Docker command line tool.

1. **Check Running Containers:**
```bash
docker ps

```


You should see three containers listed in the output:
* `nginx` (Port 443)
* `wordpress` (Port 9000)
* `mariadb` (Port 3306)


2. **Troubleshooting:**
* If a container is missing or you see `Restarting...` under the Status column, you can view the logs for errors:
```bash
docker logs <container_name>
# Example: docker logs wordpress
```