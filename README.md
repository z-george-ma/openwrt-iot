# openwrt-iot
IoT support for OpenWRT based router

## Overview
OpenWRT-IoT is an open-source project to convert your OpenWRT router into a home automation platform. It exposes webhooks that can be integrated with IFTTT/Google Home/Alexa Echo/etc.

## Prerequisites
1. OpenWRT powered router
2. Public http(s) access to the router. You may need to set up DNAT for http(s) service to be accessible from internet

## Get started
1. Configure uhttp
Typical OpenWRT setup already includes *uhttpd* and *luci* related package e.g. *luci-lib-nixio*. In order to make OpenWRT-IoT work with *luci*, add the following section to */etc/config/uhttpd*

```
config uhttpd 'iot'
# replace 0.0.0.0 with your router LAN IP if you don't want exposing the http service to internet
        list listen_http '0.0.0.0:88'
# https will require a valid SSL certificate
        list listen_https '0.0.0.0:443'
        option redirect_https '0'
        option home '/web'
        option rfc1918_filter '1'
        option max_requests '3'
        option max_connections '100'
# valid SSL certificate.
        option cert '/etc/uhttpd.crt'
        option key '/etc/uhttpd.key'
        option cgi_prefix '/cgi-bin'
        option script_timeout '60'
        option network_timeout '30'
        option http_keepalive '20'
        option tcp_keepalive '1'
        option no_dirlists '1'
        option ubus_prefix '/ubus'
```

Note: https will require *libuhttpd-mbedtls* to be installed.

2. Restart *uhttpd* to apply new configuration
```
/etc/init.d/uhttpd restart
```

3. Install additional dependencies  
OpenWRT-IoT requires additional dependencies

```
opkg update && opkg install lua-cjson libuci-lua
```

4. Copy all files under src/ to /usr/lib/lua/iot/

5. Create */web/cgi-bin* folder and copy *cgi-bin/iot* over (with execute permission)

6. Setup OpenWRT-IoT configuration file in */etc/config/iot*. Example configuration can be found at *config/iot*

7. Integration with IFTTT and enjoy
In IFTTT actions, use webhook with the format like this:  
*POST* `https://your_host/cgi-bin/iot`
```
{
  "service": "kasa"
  "key": "secret",
  "action": "turn on"
}
```

## Modules 
### Ad blocker
Turn on / off ad blocker. Please refer to src/modules/adblocker.lua.

#### Setup
With default Luci OpenWRT installation, in Network -> DHCP and DNS -> Resolv and Hosts Files, add Additional Hosts files as */etc/hosts.filter*

Download the hosts file from https://github.com/StevenBlack/hosts and save as /etc/hosts.adblocker  

#### Configuration
Refer to example in *config/iot*

#### Webhook
*POST* `https://your_host/cgi-bin/iot`
```
{
  "service": "adblocker",
  "key": "secret", // the key specified in the config
  "action": "enable" // enable | disable
}
```

### Linux Service
Turn on / off Linux services. Please refer to src/modules/openwrt.lua.

#### Configuration
Refer to example in *config/iot*

#### Webhook
*POST* `https://your_host/cgi-bin/iot`
```
{
  "service": "service",
  "key": "secret", // the key specified in the config
  "action": "start", // start/stop/restart
  "name": "openvpn" // service name, e.g. openvpn
}
```

### Kasa smart switch
Control TP-Link Kasa smart switches. Please refer to src/modules/kasa.lua.

#### Configuration
Refer to example in *config/iot*

#### Webhook
*POST* `https://your_host/cgi-bin/iot`
```
{
  "service": "kasa",
  "key": "secret", // the key specified in the config
  "action": "turn on" // turn on | turn off
}
```

### Philips WiZ smart light
Control TP-Link Kasa smart switches. Please refer to src/modules/kasa.lua.

#### Configuration
Refer to example in *config/iot*

#### Webhook
*POST* `https://your_host/cgi-bin/iot`
```
{
  "service": "wiz",
  "key": "secret", // the key specified in the config
  "action": "turn on" // turn on | turn off
}
```

## Contributing
If you would like to request a feature or suggest a module, please [open a new issue](https://github.com/z-george-ma/openwrt-iot/issues/new) against this repository.

When contributing to this repository, it is highly recommended to first discuss the change you wish to make via Github Issue. Pull requests are welcomed. In general, we follow the "fork-and-pull" Git workflow.
