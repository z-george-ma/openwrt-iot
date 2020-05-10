require 'nixio'

return function (config, body)
  if nixio.fork() == 0 then
    local i = nixio.open("/dev/null", "r")
    local o = nixio.open("/dev/null", "w")

    nixio.dup(i, nixio.stdin)
    nixio.dup(o, nixio.stdout)

    i:close()
    o:close()

    nixio.exec('/etc/init.d/' .. body.name:gsub('[/%.]',''), body.action)
  else
    return { status = 200 }
  end
end