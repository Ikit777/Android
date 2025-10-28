FROM budtmo/docker-android:nougat-7.1

# Nonaktifkan hardware acceleration untuk Back4app
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
ENV ANDROID_EMULATOR_OPTS="-no-accel -gpu swiftshader -no-audio"
ENV DISPLAY=:0

# Setup untuk environment tanpa KVM
ENV QEMU_AUDIO_DRV=none
ENV ANDROID_EMULATOR_SKIN=768x1280

# Reduce resource usage
ENV ANDROID_AVD_DEVICE="pixel_4"
ENV ANDROID_AVD_ABI="google_apis/x86"

# Install additional dependencies untuk Back4app
RUN apt-get update && apt-get install -y \
    xvfb \
    pulseaudio \
    && rm -rf /var/lib/apt/lists/*

# Create startup script
COPY start-emulator.sh /root/start-emulator.sh
RUN chmod +x /root/start-emulator.sh

# Expose port untuk web interface
EXPOSE 6080 5554 5555

CMD ["/root/start-emulator.sh"]
