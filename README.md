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
