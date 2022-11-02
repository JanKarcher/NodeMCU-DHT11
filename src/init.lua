-- load util once only and store it
_util = assert(loadfile("util.lua"))()

-- load configuration once only and store it
configHandler = assert(loadfile("configuration.lua"))()
configHandler.checkAndCreateConfig()


dofile("wifiControl.lua")

dofile("exposedHttpServer.lua")
dofile("dhtReader.lua")

-- initial wifi connection
wifi.sta.config({ssid=configHandler.config.wifi.SSID, pwd=configHandler.config.wifi.PASSWORD})


-- Loop function
function run()
  if wifiControl.is_connected == true then
    print("Connection to wifi is available")
  else
    print("No wifi connection, reconnecting...")
    wifi.sta.connect()
  end

  for key, value in pairs(configHandler.config.sensors.dht11) do
    print("pin: " .. value.pin .. ", id:" .. value.id)
    dhtReader.readFromPin(value.pin)
  end

end


-- setting up main loop timer
local mainLoop = tmr.create()
if mainLoop:alarm(configHandler.config.main.MAIN_LOOP_INTERVALL, tmr.ALARM_AUTO,
 function()
  run()
 end)
then
    print("mainloop timer created successful.")
else
    print("error on mainloop timer creation.")
end