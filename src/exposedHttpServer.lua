
httpserver = require("httpserver")


requestHandler = function(request, response)
  print("Received Request", request.method, request.url, node.heap())

  handleConfigGET = function(self)
    local configAsJSON = _util._printT(configHandler.config)
    local configEncrypted = crypto.encrypt("AES-ECB", configHandler.config.crypto.KEY, configAsJSON)
    local responseBody = '{config:"' .. configEncrypted .. '"}'

    -- reply
    setSuccessAndHeader(self)
    response:send(responseBody)
    response:finish()
  end

  handleSensorsGET = function(self)
    local configAsJSON = _util._printT(configHandler.config.sensors)

    -- reply
    setSuccessAndHeader(self)
    response:send(configAsJSON)
    response:finish()

  end

  setSuccessAndHeader = function(self)
    response:send(nil, 200)
    response:send_header("Content-Type", "application/json")
    response:send_header("Connection", "close")
  end

  setFailureAndHeader = function(self, responseCode, message)
    response:send(nil, responseCode)
    response:send_header("Content-Type", "text/plain")
    response:send_header("Connection", "close")
    response:send(message)
    response:finish()
  end

  -- setup handler of headers, if any
  request.onheader = function(self, name, value) -- luacheck: ignore
    print("Received Header", name, value)
  end

  -- setup handler of body, if any
  request.ondata = function(self, chunk) -- luacheck: ignore
    print("Received Body", chunk and #chunk, node.heap())
    if not chunk then

      -- handle GET requests
      if request.method == "GET" then
        if request.url == "/config" then
          handleConfigGET(self)
          return
        end
        if request.url == "/sensors" then
          handleSensorsGET(self)
          return
        end
      end

      setFailureAndHeader(self, 404, "endpoint not found.")

    end
  end
end


httpserver.createServer(80, requestHandler)