# WIP not ready yet

# NodeMCU-DHT11
Software that enables a NodeMCU to read data from a DHT11 sensor and send it via HTTP requests to a webserver.

## Firmware requirements
The required firmware was build using: https://nodemcu-build.com/
The modules included are:
- crypto
- DHT
- file
- GPIO
- HTTP
- net
- node
- timer
- UART
- WiFi

## Configuration
After uploading the software to your NodeMCU you have to set a couple of configuration.
You can set those a couple of ways:

1. Reset the NodeMCU (which creates a dummy config) download the `config.cfg`, reupload it and reset.
2. Edit the field on the serial console and execute `configHandler.saveConfiguration()` once you're done.

The options you need to set:
- `config.wifi.SSID` - The name of the wifi station to connect to.
- `config.wifi.PASSWORD` - The password to authenticate to the station.
- `config.crypto.KEY` - The key used to encrypt the HTTP bodies. Please chose a strong one. Encrypt everything!
- `config.sensors.dht11.NAME` - Where NAME is what you would like the sensor to be named. A primary one is created by default. You can add multiple sensors.
- `config.sensors.dht11.PIN` - Where PIN is the digital out your dht11 is connected to. For primary this is 6.
- `config.sensors.dht11.ID` - An unique ID of your dht11 is connected to. For primary this is 1.
- `config.main.IS_CONFIGURED` - While this is set to `false` no logic is executed. Set this to `true` once you have everything configured!