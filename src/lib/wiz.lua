local function _W(f) local e=setmetatable({}, {__index = _ENV or getfenv()}) if setfenv then setfenv(f, e) end return f(e) or e end

local nixio = require('nixio')

local wiz = _W(function(_ENV, ...)
  local public = {}

  local function send(host, cmd)
    local socket = nixio.socket('inet', 'dgram')
    socket:sendto(cmd, host, 38899)
    socket:close()
  end

  function public.new(host)
    local ret = {
      host = host
    }
    setmetatable(ret, { __index = public })
    return ret
  end

  function public:setState(state)
    send(self.host, '{"method":"setPilot","params":{"state":' .. tostring(state) .. '}}')
  end


  function public:setScene(sceneId)
    send(self.host, '{"method":"setPilot","params":{"state":true,"sceneId":' .. sceneId .. '}}')
  end

  return public
end)

return wiz
