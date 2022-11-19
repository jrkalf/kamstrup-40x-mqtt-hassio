#!/usr/bin/with-contenv bashio

echo "Hello world!"
export mqtt_host="$(bashio::config 'mqtt_host')"
export mqtt_port="$(bashio::config 'mqtt_port')"
export mqtt_username="$(bashio::config 'mqtt_username')"
export mqtt_password="$(bashio::config 'mqtt_password')"
export mqtt_authentication="$(bashio::config 'mqtt_authentication')"
export serialdevice="$(bashio::config 'serial_device')"
export pollinterval="$(bashio::config 'poll_interval')"

cd /opt/kamstrup
echo "Modifying config..."
sed -i "s/host: .*/host: $(bashio::config 'mqtt_host')/g" config.yaml
sed -i "s/port: .*/port: $(bashio::config 'mqtt_port')/g" config.yaml
sed -i "s/username: .*/username: $(bashio::config 'mqtt_username')/g" config.yaml
sed -i "s/password: .*/password: $(bashio::config 'mqtt_password')/g" config.yaml
sed -i "s/authentication: .*/authentication: $(bashio::config 'mqtt_authentication')/g" config.yaml
sed -i "s|com_port: .*|com_port: $(bashio::config 'serial_device')|g" config.yaml
sed -i "s/poll_interval: .*/poll_interval: $(bashio::config 'poll_interval')/g" config.yaml

echo "Starting Daemon..."
/usr/bin/python3 /opt/kamstrup/daemon.py
