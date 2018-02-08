local json = require 'cjson'
local config = require 'iot.config'

function handle_request(env)
  local len = tonumber(env.CONTENT_LENGTH) or 0
  local read = coroutine.wrap(function()
    while len > 0 
    do
      local rlen, rbuf = uhttpd.recv(4096)
      if rlen >= 0 then
        len = len - rlen
        coroutine.yield(rbuf)
      else
        return nil
      end
    end
    return nil
  end)

  local name = env['REQUEST_URI']:match('.*/(.*)$')
  local module = config[name]

  if module ~= nil and env['REQUEST_METHOD'] == 'POST' then
    local buf = {}, s
    repeat
      s = read()
      if s ~= nil then
        buf[#buf+1] = s
      end
    until s ~= nil

    local rawBody = table.concat(buf)

    local body = json.decode(rawBody)

    if body.key ~= module.config.key then
      uhttpd.send("Status: 401 \r\n\r\n")
      return
    end

    local res = module.handler(module.config, body)

    uhttpd.send('Status: ' .. res.status .. ' \r\n')
    uhttpd.send("Content-Type: application/json\r\n\r\n")
    uhttpd.send(json.encode(res.body))
    return
  end

  uhttpd.send("Status: 404 \r\n\r\n")
end
