require 'uci'

local M = {}

local cursor = uci.cursor()

local modulePath = cursor.get('iot', 'common', 'modules') or '/usr/lib/lua/iot/modules/'

cursor:foreach("iot", "module", function(s)
  local name = s['.name']
  M[name] = {}
  M[name].config = s
  M[name].handler = loadfile(modulePath .. name .. '.lua')()
end)                                                        
                        
return M
