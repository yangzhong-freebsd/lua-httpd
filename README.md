# Experimental FreeBSD Installer

## Setup

For testing purposes, I have the server running on an already-installed
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

Finally, edit the files `httpd` and `db.lua`: change the value of the variable
`SRC_DIR` to be the path to this repository, with the trailing slash. Also, edit
`keymap.lua`: change `XAUTHORITY` to point at your .Xauthority file.

Now you should be able to go to localhost on your browser and use the installer
frontend!

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
