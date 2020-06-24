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

return keymap
