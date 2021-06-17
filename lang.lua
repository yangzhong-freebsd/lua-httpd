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

local lang = lang or {}

lang.translations = {
        ["Install FreeBSD"] = {
                en = "Install FreeBSD",
                fr = "Installer FreeBSD",
                jp = "FreeBSDのインストール"
        },
        ["Change language"] = {
                en = "Change language",
        },
        ["Configure your keyboard"] = {
                en = "Configure your keyboard",
        },
        ["Configure the network"] = {
                en = "Configure the network",
        },
        ["Configure ZFS"] = {
                en = "Configure ZFS",
        },

        ["Partition Disks: ZFS"] = {
                en = "Partition Disks: ZFS",
        },
}

--TODO: add other defaults (keymap, locale, etc) to each language

lang.languages = {
        en = {
                name = "English",
                keymap_layout = "us",
                keymap_variant = "",
        },
        fr = {
                name = "Français",
                keymap_layout = "fr",
                keymap_variant = "",
        },
        jp = {
                name = "日本語",
                keymap_layout = "jp",
                keymap_variant = "",
        },
}

--Add a metatable to all the string translations, so that
--if a translation does not exist it defaults to English.
local metatable = {}
metatable.__index = function(table, key)
        return table.en
end

for _, table in pairs(lang.translations) do
        setmetatable(table, metatable)
end

setmetatable(lang.languages, metatable)

return lang
