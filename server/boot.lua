-- vim: set et sw=4:
--
-- Copyright (c) 2020 Ryan Moeller <ryan@freqlabs.com>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

local boot = boot or {}

function boot.howto()
    local f = io.popen("sysctl -n debug.boothowto", "r")
    local text = f:read("*a")
    f:close()
    local howto = tonumber(text)
    return {
        autoboot   = howto == 0,
        askname    = howto & 0x00000001 ~= 0,
        single     = howto & 0x00000002 ~= 0,
        nosync     = howto & 0x00000004 ~= 0,
        halt       = howto & 0x00000008 ~= 0,
        initname   = howto & 0x00000010 ~= 0,
        dfltroot   = howto & 0x00000020 ~= 0,
        kdb        = howto & 0x00000040 ~= 0,
        rdonly     = howto & 0x00000080 ~= 0,
        dump       = howto & 0x00000100 ~= 0,
        miniroot   = howto & 0x00000200 ~= 0,
        -- mysterious empty slot --
        verbose    = howto & 0x00000800 ~= 0,
        serial     = howto & 0x00001000 ~= 0,
        cdrom      = howto & 0x00002000 ~= 0,
        poweroff   = howto & 0x00004000 ~= 0,
        gdb        = howto & 0x00008000 ~= 0,
        mute       = howto & 0x00010000 ~= 0,
        selftest   = howto & 0x00020000 ~= 0,
        reserved1  = howto & 0x00040000 ~= 0,
        reserved2  = howto & 0x00080000 ~= 0,
        pause      = howto & 0x00100000 ~= 0,
        reroot     = howto & 0x00200000 ~= 0,
        powercycle = howto & 0x00400000 ~= 0,
        -- more empty slots --
        probe      = howto & 0x10000000 ~= 0,
        multiple   = howto & 0x20000000 ~= 0,
        bootinfo   = howto & 0x40000000 ~= 0,
    }
end

function boot.method()
    local f = io.popen("sysctl -n machdep.bootmethod", "r")
    local text = f:read("*a")
    f:close()
    local bootmethod = text:match("([^\n]+)")
    return bootmethod
end

return boot
