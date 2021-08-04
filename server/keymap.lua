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

local XAUTHORITY = "/home/yang/.Xauthority"

local misc = require("misc")

local keymap = keymap or {}

keymap.VT = "/usr/share/vt/keymaps"
keymap.SYSCONS = "/usr/share/syscons/keymaps"

function keymap.index(path)
    local index = {}
    local menu = {}
    local font = {}
    local f = assert(io.open(path .. "/INDEX.keymaps", "r"))
    local text = f:read("*a")
    f:close()
    for line in text:gmatch("([^\n]+)") do
        if line:find("^%s*#") == nil and line:find("^%s*$") == nil then
            local layout, lang, desc = line:match("(.*):(.*):(.*)")
            if lang == "" then
                lang = "en"
            end
            if layout == "MENU" then
                menu[lang] = desc
            elseif layout == "FONT" then
                font[lang] = desc
            else
                local list = index[lang] or {}
                local file = path .. "/" .. layout
                table.insert(list, { file=file, desc=desc })
                index[lang] = list
            end
        end
    end
    return index, menu, font
end

function keymap.setKeymap(layout, variant)
        if (variant == "") then
                os.execute("XAUTHORITY="..XAUTHORITY.." setxkbmap -display :0 " .. layout) --This is a hack. TODO: figure out how to do this better
        else
                os.execute("XAUTHORITY="..XAUTHORITY.." setxkbmap -display :0 " .. layout .. " -variant " .. variant)
        end
end

--keymap.XList = {{layout, desc}, ...}
--keymap.XMap = {layout = {{variant, desc}, ...}, ...}

function getXKeymaps()
    local list = {}
    local map = {}
    local f = assert(io.open("/usr/local/share/X11/xkb/rules/xorg.lst", "r"))

    local state = "";
    for line in f:lines() do
        if (line:sub(1, 1) == "!") then
            state = line:sub(3);
        elseif (state == "layout") then
            local layout, desc = line:match("(%a+)%s+(.+)")
            if (layout and desc) then
                table.insert(list, {layout=layout, desc=desc})
                map[layout] = {{variant="", desc="(none)"}}
            end
        elseif (state == "variant") then
            local variant, layout, desc = line:match("(%g+)%s+(%a+): (.+)")
            if (layout and variant and desc) then
                table.insert(map[layout], {variant=variant, desc=desc})
            end
        end
    end

    local function compareLayouts(this, other)
        return this.desc < other.desc
    end

    table.sort(list, compareLayouts)
    keymap.XList = list
    keymap.XMap = map
end

function keymap.getCurrentLayout()
        local data_file = io.popen("XAUTHORITY="..XAUTHORITY.." setxkbmap -display :0 -query")

        for line in data_file:lines() do
                local layout = line:match("layout:%s+(.*)")
                if (layout) then
                        return layout
                end
        end

        return ""
end

function keymap.getCurrentVariant()
        local data_file = io.popen("XAUTHORITY="..XAUTHORITY.." setxkbmap -display :0 -query")

        for line in data_file:lines() do
                local variant = line:match("variant:%s+(.*)")
                if (variant) then
                        return variant
                end
        end

        return ""
end

function keymap.prettyPrint(layout, variant)
        local layout_desc, variant_desc

        for _, map in ipairs(keymap.XList) do
                if (map.layout == layout) then
                        layout_desc = map.desc
                        variant_desc = keymap.XMap[layout].desc
                        break
                end
        end
        for _, var in ipairs(keymap.XMap[layout]) do
                if (var.variant == variant) then
                        variant_desc = var.desc
                        break
                end
        end

        if (variant ~= "") and variant then
                return layout_desc .. " - " .. variant_desc
        else
                return layout_desc
        end
end

getXKeymaps()

return keymap
