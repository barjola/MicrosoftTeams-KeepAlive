echo "Mouse mover started. Waiting 30s before first movement..."
sleep 30

while true; do
    # Click Account 1 (Left window: 1280x720 split, center is roughly X:320, Y:360)
    xdotool mousemove 320 360
    xdotool click 3   # Right click
    sleep 0.5
    xdotool key Escape # Close context menu
    sleep 1
    
    # Click Account 2 (Right window: center is roughly X:960, Y:360)
    xdotool mousemove 960 360
    xdotool click 3   # Right click
    sleep 0.5
    xdotool key Escape # Close context menu
    
    # Wait 60 seconds before next check
    sleep 60
done
