#!/bin/bash

echo "Starting Android Emulator on Back4app..."

# Setup virtual display
Xvfb :0 -screen 0 1024x768x24 &
export DISPLAY=:0

# Wait for Xvfb to start
sleep 2

# Start noVNC web interface
websockify --web /usr/share/novnc/ 6080 localhost:5900 &

# Create AVD jika belum ada
if [ ! -d /root/.android/avd/pixel_4.avd ]; then
    echo "Creating AVD..."
    echo "no" | avdmanager create avd \
        -n pixel_4 \
        -k "system-images;android-25;google_apis;x86" \
        -d "pixel_4" \
        --force
fi

# Start emulator dengan options rendah resource
echo "Starting Emulator..."
emulator \
    -avd pixel_4 \
    -no-window \
    -no-boot-anim \
    -no-audio \
    -gpu swiftshader \
    -memory 1024 \
    -cores 1 \
    -netdelay none \
    -netspeed full \
    -skip-adb-auth \
    -verbose \
    -qemu &

# Wait for emulator to start
echo "Waiting for emulator to boot..."
adb wait-for-device

# Check if emulator is ready
while [ "`adb shell getprop sys.boot_completed | tr -d '\r' `" != "1" ]; do
    sleep 5
    echo "Still waiting for boot completion..."
done

echo "Android Emulator is ready!"
echo "Web interface available at: http://localhost:6080"

# Keep container running
tail -f /dev/null
