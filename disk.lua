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

local disk = disk or {}

local function kern_disks()
    local f = io.popen("sysctl -n kern.disks | xargs -n1;" ..
                       "ggatel list;" ..
                       "mdconfig -l | xargs -n1;",
                       "r")
    local text = f:read("*a")
    f:close()
    return text
end

local function diskinfo(dev)
    local f = io.popen("diskinfo -v "..dev .. " 2>/dev/null", "r")
    local text = f:read("*a")
    f:close()
    return text
end

function disk.info()
    local disks = {}

    for dev in kern_disks():gmatch("([^ \n]+)") do
        local disk = {}

        for line in diskinfo(dev):gmatch("([^\n]+)") do
            if line:find("#") then
                local value, field = line:match("^\t([^\t]+)\t+# (.*)$")

                local size_human = field:match("mediasize in bytes %((.*)%)")
                if size_human then
                        disk["mediasize in bytes"] = value
                        disk["mediasize in bytes human"] = size_human
                else
                        disk[field] = value
                end
            end
        end
        disks[dev] = disk
    end
    return disks
end

--TODO: make this use the real disk names
function disk.prettyPrintDisks(disk_str)
        return disk_str
end

return disk
