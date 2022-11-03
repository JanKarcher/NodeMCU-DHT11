configHandler = {}

confFile = "/FLASH/conf.cfg"

configHandler.config = {}

-- saves the configHandler.config into the configFile given
configHandler.saveConfiguration = function()
  file.open(confFile, "w+")
  file.putcontents(confFile,"return " .. _util._printT(configHandler.config))
  file.flush()
end

-- loads the configHandler.config from the configFile
configHandler.loadConfiguration = function()
  file.open(confFile)
  local content = file.getcontents(confFile)
  configHandler.config = assert(loadstring(content))()
end

-- functions checks if a config is stored in the flash storage.
-- If not it creates a default one and saves it
configHandler.checkAndCreateConfig = function()
  if(file.exists(confFile)) then
    configHandler.loadConfiguration()
  else
    -- create default configuration
    configHandler.config.wifi = {}
    configHandler.config.wifi.CONNECT_RETRIES = 150
    configHandler.config.wifi.SSID = ""
    configHandler.config.wifi.PASSWORD = ""

    configHandler.config.main = {}
    configHandler.config.main.IS_CONFIGURED = false
    configHandler.config.main.MAIN_LOOP_INTERVALL = 1000 * 30

    configHandler.config.crypto = {}
    configHandler.config.crypto.KEY = ""

    configHandler.config.sensors = {}
    configHandler.config.sensors.dht11 = {
      primary = {
        PIN = 6, -- pin
        ID = 1  -- id
      }
    }

    configHandler.saveConfiguration()
  end
end

return configHandler