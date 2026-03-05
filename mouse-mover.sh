DUAL_MODE=${DUAL_ACCOUNTS:-"false"}

echo "Mouse mover started. Waiting 30s before first movement..."
sleep 30

while true; do
    if [ "$DUAL_MODE" = "true" ]; then
        # Move over Account 1 (Left window)
        xdotool mousemove 310 350
        xdotool mousemove_relative 20 20
        sleep 1
        
        # Move over Account 2 (Right window)
        xdotool mousemove 950 350
        xdotool mousemove_relative 20 20
    else
        # Move to center of single screen (Account 1)
        xdotool mousemove 630 350
        xdotool mousemove_relative 20 20
    fi
    
    # Wait 60 seconds before next check
    sleep 60
done
