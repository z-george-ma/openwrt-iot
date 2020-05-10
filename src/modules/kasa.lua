local kasa = require('iot/lib/kasa')
local json = require 'cjson'

return function (config, body)
  local k = kasa.new(config['ip'])
  local ret

  if body.action == 'turn on' then
    ret= json.decode(k:setRelayState(true))
  else if body.action == 'turn off' then
    ret= json.decode(k:setRelayState(false))
  end


  return { status = 200, body = ret }
end