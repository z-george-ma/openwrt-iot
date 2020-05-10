require 'nixio'

return function (config, body)
  nixio.fs.unlink('/etc/hosts.filter')

  if body.action == 'enable' then
    nixio.fs.link(config['hostfile'], '/etc/hosts.filter')
  end

  if nixio.fork() == 0 then
    local i = nixio.open("/dev/null", "r")
    local o = nixio.open("/dev/null", "w")

    nixio.dup(i, nixio.stdin)
    nixio.dup(o, nixio.stdout)

    i:close()
    o:close()

    nixio.exec('/etc/init.d/dnsmasq', 'restart')
  else
    return { status = 200 }
  end

end