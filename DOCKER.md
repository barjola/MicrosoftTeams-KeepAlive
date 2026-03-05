# Microsoft Teams KeepAlive - Docker

This project and Docker image allow you to keep your Microsoft Teams session always active and reporting activity, preventing your status from changing to "Away".

Ideal for running on a **Standard PC/Server** (AMD64) or **Raspberry Pi 4** (ARM64 architecture), optimized for low resource consumption.

## Key Features

- 🚀 **Optimized**: Chromium configuration tuned for minimal RAM usage.
- 🖱️ **Anti-Away**: Discretely moves the mouse every 60 seconds to simulate real activity.
- 💾 **Persistence**: Saves your profile and session in local volumes so you only need to log in once.
- 📱 **Telegram Screenshots**: Includes a bot that sends screenshots of the active session to verify status remotely.
- 🌐 **Web VNC Access**: Graphical environment accessible from your browser for initial login and 2FA management.
- 👥 **Dual Account Support**: Capability to manage two accounts simultaneously.

## Quick Start with Docker Compose

```yaml
version: '3.8'

services:
  teams-browser:
    image: barjola/microsoft-teams-keepalive:latest
    container_name: teams-keepalive
    restart: unless-stopped
    ports:
      - "1144:1144" # Web VNC Access
      - "5000:5000" # Screenshot/Healthcheck Webhook
    volumes:
      - ./chromium_data/profile1:/data/profile1
    environment:
      - APP_LANG=en-US
      - TELEGRAM_BOT_TOKEN=your_token_here
      - TELEGRAM_CHAT_ID=your_id_here
    shm_size: "512mb"
```

## First Run and Login

1. Start the container: `docker compose up -d`.
2. Access via web: `http://<SERVER-IP>:1144/vnc.html`.
3. Click **Connect** to see the Chromium browser.
4. Log in to Teams normally (enter email, password, and validate MFA if required).
5. Once inside the Teams interface, you can close the VNC tab.

## Screenshots (Webhook)

You can request a screenshot sent directly to your Telegram by making a GET request to:
`http://<SERVER-IP>:5000/screenshot`

---

## Source Code and Documentation
You can find more information, detailed instructions, and the source code in the official GitHub repository:

🔗 **[GitHub: barjola/MicrosoftTeams-KeepAlive](https://github.com/barjola/MicrosoftTeams-KeepAlive)**

Developed by [barjola](https://github.com/barjola)
