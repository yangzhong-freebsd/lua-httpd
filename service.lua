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

local service = service or {}

service.menu = {
    {
        name = "local_unbound",
        description = "Local caching validating resolver",
        default = false,
    },
    {
        name = "sshd",
        description = "Secure shell daemon",
        default = true,
    },
    {
        name = "moused",
        description = "PS/2 mouse pointer on console",
        default = false,
    },
    {
        name = "ntpdate",
        description = "Synchronize system and network time at bootime",
        default = false,
    },
    {
        name = "ntpd",
        description = "Synchronize system and network time",
        default = false,
    },
    {
        name = "powerd",
        description = "Adjust CPU frequency dynamically if supported",
        default = false,
    },
    {
        name = "dumpdev",
        description = "Enable kernel crash dumps to /var/crash",
        default = true,
    },
}

return service
