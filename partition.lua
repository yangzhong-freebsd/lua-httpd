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

local partition = partition or {}

-- TODO: various workarounds needed for specific hardware
partition.styles = {
    {
        title = "GPT (BIOS)",
        value = "GPT:BIOS",
        prefer = function(bootmethod)
            return bootmethod == "BIOS"
        end,
    },
    {
        title = "GPT (UEFI)",
        value = "GPT:UEFI",
        prefer = function(bootmethod)
            return false
        end,
    },
    {
        title = "GPT (BIOS+UEFI)",
        value = "GPT:BIOS+UEFI",
        prefer = function(bootmethod)
            return bootmethod == "UEFI"
        end,
    },
    {
        title = "GPT + Active (BIOS)",
        value = "GPT+ACTIVE:BIOS",
        prefer = function(bootmethod)
            return false
        end,
    },
    {
        title = "GPT + Lenovo Fix (BIOS)",
        value = "GPT+LENOVOFIX:BIOS",
        prefer = function(bootmethod)
            return false
        end,
    },
}

return partition
