
wifiControl = {}

wifiControl.is_connected = false
wifiControl.is_configured = false

-- Define WiFi station event callbacks
local wifi_connect_event = function(T)
    print("Connection to AP("..T.SSID..") established!")
    print("Waiting for IP address...")
    if wifiControl.disconnect_ct ~= nil then
        wifiControl.disconnect_ct = nil
    end
end

local wifi_got_ip_event = function(T)
    -- Note: Having an IP address does not mean there is internet access!
    -- Internet connectivity can be determined with net.dns.resolve().
    print("Wifi connection is ready! IP address is: "..T.IP)
    wifiControl.is_connected = true
end

local wifi_disconnect_event = function(T)
    if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
        --the station has disassociated from a previously connected AP
        return
    end
    -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
    local total_tries = configHandler.config.wifi.CONNECT_RETRIES
    print("\nWiFi connection to AP("..T.SSID..") has failed!")

    --There are many possible disconnect reasons, the following iterates through
    --the list and returns the string corresponding to the disconnect reason.
    for key,val in pairs(wifi.eventmon.reason) do
        if val == T.reason then
        print("Disconnect reason: "..val.."("..key..")")
        break
        end
    end

    if wifiControl.disconnect_ct == nil then
        wifiControl.disconnect_ct = 1
    else
        wifiControl.disconnect_ct = wifiControl.disconnect_ct + 1
    end
    if wifiControl.disconnect_ct < total_tries then
        print("Retrying connection...(attempt "..(wifiControl.disconnect_ct+1).." of "..total_tries..")")
    else
        wifi.sta.disconnect()
        print("Aborting connection to AP!")
        wifiControl.disconnect_ct = nil
        wifiControl.is_connected = false
    end
end

wifiControl.configure = function ()
    -- Register WiFi Station event callbacks
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

    wifi.setmode(wifi.STATION)

    wifi.sta.config({ssid=configHandler.config.wifi.SSID, pwd=configHandler.config.wifi.PASSWORD})

    wifiControl.is_configured = true
end

return wifiControl