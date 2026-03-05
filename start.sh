#!/bin/bash
set -e

rm -f /tmp/.X99-lock

echo "Starting Xvfb..."
Xvfb :99 -screen 0 $RESOLUTION -ac -listen tcp &
sleep 2

echo "Starting Fluxbox..."
fluxbox &

echo "Starting x11vnc..."
x11vnc -display :99 -nopw -shared -forever &

echo "Starting noVNC (websockify)..."
websockify --web /usr/share/novnc 1144 localhost:5900 &

echo "Starting mouse mover script..."
./mouse-mover.sh &

echo "Fixing /data permissions..."
sudo chown -R teamsuser:teamsuser /data

echo "Cleaning up possible locked Chromium profiles..."
rm -f /data/SingletonLock /data/SingletonCookie /data/SingletonSocket
rm -f /data/profile1/SingletonLock /data/profile1/SingletonCookie /data/profile1/SingletonSocket
rm -f /data/profile2/SingletonLock /data/profile2/SingletonCookie /data/profile2/SingletonSocket

echo "Starting Webhook server..."
python3 webhook.py &

LANG_FLAG=${APP_LANG:-"en-EN"}
DUAL_MODE=${DUAL_ACCOUNTS:-"false"}

if [ "$DUAL_MODE" = "true" ]; then
    echo "DUAL_ACCOUNTS enabled. Starting two Chromium windows..."
    
    echo "Starting Chromium on Microsoft Teams (Account 1)..."
    chromium --no-sandbox \
             --disable-dev-shm-usage \
             --disable-gpu \
             --disable-software-rasterizer \
             --disable-extensions \
             --disable-background-networking \
             --disable-sync \
             --disable-default-apps \
             --mute-audio \
             --accept-lang="$LANG_FLAG" \
             --lang="$LANG_FLAG" \
             --user-data-dir=/data/profile1 \
             --window-size=640,720 \
             --window-position=0,0 \
             "https://teams.microsoft.com/" &

    echo "Starting Chromium on Microsoft Teams (Account 2)..."
    chromium --no-sandbox \
             --disable-dev-shm-usage \
             --disable-gpu \
             --disable-software-rasterizer \
             --disable-extensions \
             --disable-background-networking \
             --disable-sync \
             --disable-default-apps \
             --mute-audio \
             --accept-lang="$LANG_FLAG" \
             --lang="$LANG_FLAG" \
             --user-data-dir=/data/profile2 \
             --window-size=640,720 \
             --window-position=640,0 \
             "https://teams.microsoft.com/"
else
    echo "Single account mode. Starting one maximized Chromium instance..."
    chromium --no-sandbox \
             --disable-dev-shm-usage \
             --disable-gpu \
             --disable-software-rasterizer \
             --disable-extensions \
             --disable-background-networking \
             --disable-sync \
             --disable-default-apps \
             --mute-audio \
             --accept-lang="$LANG_FLAG" \
             --lang="$LANG_FLAG" \
             --user-data-dir=/data/profile1 \
             --window-size=1280,720 \
             --window-position=0,0 \
             --kiosk \
             "https://teams.microsoft.com/"
fi

