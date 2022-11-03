
-- load functions once only and store it
_util = assert(loadfile("util.lua"))()
configHandler = assert(loadfile("configuration.lua"))()
wifiControl = assert(loadfile("wifiControl.lua"))()

dofile("exposedHttpServer.lua")
dofile("dhtReader.lua")

configHandler.checkAndCreateConfig()

-- Loop function
function run()
  if not configHandler.config.main.IS_CONFIGURED then return end
  if configHandler.config.main.IS_CONFIGURED and not wifiControl.is_configured then
    wifiControl.configure()
  end

  if not wifiControl.is_connected then
    return
  end

  for key, value in pairs(configHandler.config.sensors.dht11) do
    print("[" .. key .. "] pin: " .. value.PIN .. ", id:" .. value.ID)
    dhtReader.readFromPin(value.PIN)
  end

end

-- execute run once on startup
run()
-- setting up main loop timer to execute run
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