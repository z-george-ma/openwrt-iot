require 'iot.sgi.http'
local json = require 'cjson'
local config = require 'iot.config'

return function (env)
  if http.request.method == 'POST' then
    local body = json.decode(http.request.body)
    local module = config[body.service:gsub('[/%.]','')]

    if module == nil or body.key ~= module.config.key then
      http.response.status(401)
      http.response.send('')
      return
    end

    local res = module.handler(module.config, body)

    http.response.status(res.status)
    http.response.header("Content-Type", "application/json")
    http.response.send(json.encode(res.body))
    return
  end

  http.response.status(404)
  http.response.send('')
end
