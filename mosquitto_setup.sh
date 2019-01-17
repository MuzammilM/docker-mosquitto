# Create a mosquitto instance with authentication enabled.
# Update mosquitto config within mosquitto/config/mosquitto.conf and restart docker container.
# Author: MuzammilM
ufw allow 1883
ufw allow 9001
read -rp"Enter username: " -e USERNAME
mkdir -p mosquitto/config mosquitto/log mosquitto/data
chown -R 1883:1883 mosquitto
echo "Creating mosquitto password file for user "$USERNAME
touch mosquitto/config/passwd && sudo chown 1883:1883 mosquitto/config/passwd && docker run -it -v ${PWD}/mosquitto/config/passwd:/passwd eclipse-mosquitto:1.5 mosquitto_passwd -b passwd $USERNAME
echo "Creating default mosquitto configuration file"
docker run -it eclipse-mosquitto:1.5 cat /mosquitto/config/mosquitto.conf > mosquitto/config/mosquitto.conf
docker run -d -it -p 1883:1883 -p 9001:9001 -v ${PWD}/mosquitto/config/mosquitto.conf:/mosquitto/config/mosquitto.conf -v ${PWD}/mosquitto/config/passwd:/mosquitto/config/password -v ${PWD}/mosquitto/data:/mosquitto/data -v ${PWD}/mosquitto/log:/mosquitto/log eclipse-mosquitto:1.5
