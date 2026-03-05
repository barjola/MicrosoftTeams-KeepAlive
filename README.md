# Microsoft Teams Keepalive Docker (Multi-Arch)

This project spins up an optimized Docker container for **ARM64** (like Raspberry Pi 4) and **AMD64** (Standard PC/Server) architectures that keeps a Microsoft Teams session constantly active. It prevents your status from changing to "Away" by automatically moving the mouse, and it allows you to send screenshots of the current session via Telegram.

## Features

- 🚀 **Multi-Architecture Support**: Native support for **ARM64** and **AMD64**.
- 🖱️ **Anti-Away (Keepalive)**: An internal script imperceptibly moves the mouse 1 pixel and returns it to its original position every 60 seconds, keeping your status as "Available" at all times.
- 💾 **Session Persistence**: Saves the profile and the active session in a local volume (`./chromium_data`), so you only need to log in once, even after restarting the container.
- 📱 **Telegram Screenshots**: Includes an internal Webhook that takes a screenshot of the virtual screen and sends it to your Telegram bot when called.
- 🏥 **Health Monitoring**: Integrated Docker health check to ensure the services are running correctly.
- 🌐 **Interactive Web VNC Access**: Allows you to access the virtual graphical environment from your standard web browser to log in to Teams and manually complete the 2FA on the first run.

## Prerequisites

- Docker and Docker Compose installed on your system (PC, Server or Raspberry Pi).
- Your own Telegram Bot token and your Chat ID (for the screenshot feature).

## Setup and First Run

1. **Configure Telegram (Optional)**
   Open the `docker-compose.yml` file and add your credentials in the `environment` section:
   ```yaml
   environment:
     - TZ=Europe/Madrid
     - TELEGRAM_BOT_TOKEN=your_token_here
     - TELEGRAM_CHAT_ID=your_chat_id_here
   ```

2. **Build and Start the Container**
   Run the following command in the project directory to build the image and start the services in the background:
   ```bash
   docker compose up -d --build
   ```

3. **Logging in to Teams (First Time)**
   Since Teams requires authentication and frequently 2FA (two-factor authentication), the container exposes remote web access for the initial login:
   - Open a web browser on your regular computer and go to: `http://<YOUR-RASPBERRY-PI-IP>:1144/vnc.html`
   - Click on **Connect**.
   - You will see maxmized Chromium loading Microsoft Teams.
   - Interact using your web keyboard/mouse, enter your email, password, and validate the 2FA if prompted.
   - Once the main Teams interface loads and you click "Keep me signed in", you can close this browser tab.

From this moment on, Chromium will stay alive in the background reporting activity.

## Using the Webhook for Screenshots

To visually check the Teams status on the server at any time, the container listens on port 5000.

Simply make an HTTP GET request (for example, by opening the URL in your regular browser, or with tools like curl/Postman) to this address:

```
http://<YOUR-RASPBERRY-PI-IP>:5000/screenshot
```

The automated internal script will:
1. Take a screenshot of the graphical environment (Xvfb) using `scrot`.
2. Automatically send you the snapshot via Telegram.
3. Respond in your browser/console with a 200 OK status.

## Health Monitoring

The container exposes a health endpoint that returns 200 OK if the webhook server is running:

```
http://<YOUR-RASPBERRY-PI-IP>:5000/health
```
