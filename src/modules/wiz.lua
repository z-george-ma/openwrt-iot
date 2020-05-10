local wiz = require('iot/lib/wiz')
local json = require 'cjson'

return function (config, body)
  local w = wiz.new(config['ip'])

  local ret

  if body.action == 'turn on' then
    ret= json.decode(w:setState(true))
  else if body.action == 'turn off' then
    ret= json.decode(w:setState(false))
  end

  return { status = 200, body = ret }
end