# openwrt-iot
IoT support for OpenWRT based router

## Overview
OpenWRT-IoT is an open-source project to convert your OpenWRT router into a home automation platform. It exposes webhooks that can be integrated with IFTTT/Google Home/Alexa Echo/etc.

## Prerequisites
1. OpenWRT powered router
2. Incoming http(s) access to the router from internet. You may need to set up NAT for http(s) service to be accessible from internet
3. DO NOT use LuCI together with openwrt-iot, as it will get exposed to internet too

## Get started
1. Install dependencies  
*# opkg update && opkg install uhttpd uhttpd-mod-lua uhttpd-mod-tls luci-lib-nixio libuci-lua lua-cjson libmosquitto lua-mosquitto*

2. Copy all files in src/ to /usr/lib/lua/iot/

3. Add the following lines into /etc/config/uhttpd
```
        option lua_prefix       /iot
        option lua_handler      /usr/lib/lua/iot/sgi/uhttpd.lua
```

4. Create /etc/config/iot with the following content
```
# webfilter module to enable / disable web filter
config module webfilter
    option 'key' 'some random string' # user generated key for webhook authentication
    option 'hosts_default' '/etc/hosts.default'
    option 'hosts_filter' '/etc/hosts.filter'

# service module to start / stop Linux services
config module service
    option 'key' 'some random string' # user generated key for webhook authentication
```

5. (optional, recommended) Get a public domain name and SSL certificate for uhttpd

6. Restart uhttpd  
*# /etc/init.d/uhttpd enable && /etc/init.d/uhttpd start*

7. Integration with IFTTT
In IFTTT actions, use webhook with the format like this:  
*POST* `https://your_host/iot/webfilter`
```
{
  "key": "the key in /etc/config/iot",
  "action": "enable"
}
```

## Modules
### Web filter
Turn on / off web filters based on host files and dnsmasq. Please refer to src/modules/webfilter.lua.

#### Setup
First install and set up dnsmasq on OpenWRT router.  
Configure DNS server to point to dnsmasq.  
Rename /etc/hosts to /etc/hosts.default.  
Download the hosts file from https://github.com/StevenBlack/hosts and save as /etc/hosts.filter  

#### Configuration
Add the following line to /etc/config/iot
```
config module webfilter
    option 'key' 'abcd' # user generated key for webhook authentication
    option 'hosts_default' '/etc/hosts.default'
    option 'hosts_filter' '/etc/hosts.filter'
```

#### Webhook
*POST* `https://your_host/iot/webfilter`
```
{
  "key": "abcd", // the key specified in the config
  "action": "enable" // enable or disable
}
```

### Service
Turn on / off Linux services. Please refer to src/modules/service.lua.

#### Configuration
Add the following line to /etc/config/iot
```
config module service
    option 'key' 'abcd' # user generated key for webhook authentication
```

#### Webhook
*POST* `https://your_host/iot/webfilter`
```
{
  "key": "abcd", // the key specified in the config
  "action": "start", // start/stop/restart
  "name": "openvpn" // service name, e.g. openvpn
}
```

## Contributing
If you would like to request a feature or suggest a module, please [open a new issue](https://github.com/z-george-ma/openwrt-iot/issues/new) against this repository.

When contributing to this repository, it is highly recommended to first discuss the change you wish to make via Github Issue. Pull requests are welcomed. In general, we follow the "fork-and-pull" Git workflow.
