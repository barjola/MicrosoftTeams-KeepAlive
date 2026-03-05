FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    fluxbox \
    chromium \
    xdotool \
    scrot \
    python3 \
    python3-requests \
    sudo \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m -s /bin/bash teamsuser \
    && echo "teamsuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER teamsuser
WORKDIR /home/teamsuser

COPY --chown=teamsuser:teamsuser start.sh /home/teamsuser/start.sh
COPY --chown=teamsuser:teamsuser mouse-mover.sh /home/teamsuser/mouse-mover.sh
COPY --chown=teamsuser:teamsuser webhook.py /home/teamsuser/webhook.py
RUN chmod +x /home/teamsuser/start.sh /home/teamsuser/mouse-mover.sh

ENV DISPLAY=:99
ENV RESOLUTION=1280x720x24

EXPOSE 1144 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

CMD ["./start.sh"]
