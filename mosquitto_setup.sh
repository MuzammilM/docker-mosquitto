# Create a mosquitto instance with authentication enabled.
# Update mosquitto config within mosquitto/config/mosquitto.conf and restart docker container.
# Author: MuzammilM
ERROR="\033[0;31m"
WARN="\033[0;33m"
SUCCESS="\033[0;32m"
DEFAULT="\033[0;37m"
reset=`tput sgr0`

read -rp"Enter username: " -e USERNAME
sudo ufw allow 1883
sudo ufw allow 9001
sudo ufw allow 22
sudo ufw --force enable
mkdir -p mosquitto/config mosquitto/log mosquitto/data
chown -R 1883:1883 mosquitto
echo -e "${SUCCESS}Creating mosquitto password file for user ${reset}"$USERNAME
touch mosquitto/config/passwd && sudo chown 1883:1883 mosquitto/config/passwd && docker run -it -v ${PWD}/mosquitto/config/passwd:/passwd eclipse-mosquitto:1.5 mosquitto_passwd -c passwd $USERNAME
echo "Creating default mosquitto configuration file"
docker run -it eclipse-mosquitto:1.5 cat /mosquitto/config/mosquitto.conf > mosquitto/config/mosquitto.conf
chmod 644 mosquitto/config/passwd
echo -e "persistence true\npersistence_file mosquitto.db\npersistence_location /mosquitto/data\nlog_dest file /mosquitto/log/mosquitto.log\npassword_file /mosquitto/config/password" >> mosquitto/config/mosquitto.conf
docker run --restart=always -d -it -p 1883:1883 -p 9001:9001 -v ${PWD}/mosquitto/config/mosquitto.conf:/mosquitto/config/mosquitto.conf -v ${PWD}/mosquitto/config/passwd:/mosquitto/config/password -v ${PWD}/mosquitto/data:/mosquitto/data -v ${PWD}/mosquitto/log:/mosquitto/log eclipse-mosquitto:1.5
