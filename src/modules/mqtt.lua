local mqtt = require("mosquitto")

return function (config, body)
  local client = mqtt.new()
  client.ON_CONNECT = function()
    client:publish(body.topic, body.payload, body.qos, body.retain)
  end
  client.ON_PUBLISH = function()
    client:disconnect()
  end
  client:connect(config['mqtt_host'])
  client:loop()
  
  return { status = 200 }
end