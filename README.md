# Experimental FreeBSD Installer

Building on the work of [lua-httpd](https://gitlab.com/freqlabs/lua-httpd/-/tree/freebsd-install).

## Setup

The easiest way to try out the installer is to use the [Live ISO builder](https://github.com/yangzhong-freebsd/ISO) that has the installer pre-configured in it.

Or, for testing purposes, I have the server running on an already-installed
system. I would suggest not to set this up on an important computer as the
server runs as root. To set up (as you can see, it's currently very rough):

Clone this repository, and make an empty file named `db` in it.

Configure inetd, then restart it:
`/etc/inetd.conf`
```conf
http    stream  tcp     nowait  root    {location of this repository}/httpd      httpd
```

Prepare the log file:
```sh
touch /var/log/httpd.log
```

Finally, edit the file `httpd`: change the value of the variable
`SRC_DIR` to be the path to this repository, with the trailing slash. Also change
`XAUTHORITY` to point at your .Xauthority file.

Now you should be able to go to localhost on your browser and use the installer
frontend!

## Problems and future plans

1. Currently, the network selector only supports wireless interfaces with WPA2. 
2. The partitioner is also very basic and only supports ZFS.
3. bsdinstall offers many different ways to configure partitions, one way being to open a terminal and manually do it. This works because bsdinstall does the partitioning immediately after partitions have been configured. In the experimental installer, the partitioning options get written to the configuration file, and everything is done at the end, all at once. It doesn't seem possible to offer the manual partitioning option while keeping this property of the experimental installer. 
4. Because the keymap configurator in the installer sets keymap on demand, it sets the X keymap but not the console one. I intend to add the option to install a graphical environment in the installer, but haven't done that work yet. So, if you change the layout, it'll be set for the rest of the installation process, but not in the final installed system which boots to the console. There does not seem to be a straightforward way to map X keymap/variant options to console keymap layouts.

<!--
# Pure Lua httpd

## Name

httpd.lua - simple HTTP server library with zero dependencies (except inetd)

## Synposis

Install httpd.lua in your package.path.

Write an executable server script, for example:
`/usr/local/bin/httpd`
```lua
#!/usr/bin/env lua

local httpd = require("httpd")
local server = httpd.create_server("/var/log/httpd.log")
server:add_route("GET", "/", function(request)
    return { status=200, reason="ok", body="hello, world!" }
end)
server:run(true)
```

Configure inetd:
`/etc/inetd.conf`
```conf
http    stream  tcp     nowait  www    /usr/local/bin/httpd      httpd
```

Prepare the log file:
```sh
touch /var/log/httpd.log
chown www /var/log/httpd.log
```

## Description

I didn't feel like cross-compiling a bunch of stuff for a MIPS router I
have.  It has Lua interpreter on it, and I like Lua, so I wrote this.
-->
