local function _W(f) local e=setmetatable({}, {__index = _ENV or getfenv()}) if setfenv then setfenv(f, e) end return f(e) or e end

local nixio = require('nixio')

local kasa = _W(function(_ENV, ...)
  local public = {}

  local bit = nixio.bit

  local function to_bytes_32_be(value)
    local t = ""
    for i = 3, 0, -1 do
        t = t .. string.char(bit.band(bit.lshift(value, (i * 8)), 0xff))
    end
    return t
  end
  
  local function encrypt(body)
    local ret = to_bytes_32_be(#body)
    local key = 171
    for i=1, #body do
      t = bit.bxor(key, body:byte(i))
      key = t
      ret = ret .. string.char(t)
    end
  
    return ret
  end
  
  local function decrypt(body)
    local ret = ""
    local key = 171
    for i=1, #body do
      t = bit.bxor(key, body:byte(i))
      key = body:byte(i)
      ret = ret .. string.char(t)
    end
  
    return ret
  end

  local function send(host, cmd)
    local socket = nixio.socket('inet', 'stream')
    socket:connect(host, 9999)
    local buf = encrypt(cmd)
    local bytes = 0, s
    repeat
      s = socket:send(buf, bytesSent)
      bytes = bytes + s
    until bytes >= #buf
  
    buf = socket:recv(4096)
    
    socket:close()
  
    return decrypt(buf:sub(5))
  end

  function public.new(host)
    local ret = {
      host = host,
      command = command
    }
    setmetatable(ret, { __index = public })
    return ret
  end

  function public:setRelayState(state)
    local s = 0
    if state then
      s = 1
    end

    send(self.host, '{"system":{"set_relay_state":{"state":' .. s ..'}}}')
  end

  function public:setNightMode(state)
    local s = 0
    if state then
      s = 1
    end
    
    send(self.host, '{"system":{"set_led_off":{"off":' .. s ..'}}}')
  end

  return public
end)

return kasa
