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
        ["Add user"] = {
                en = "Add user",
        },
        ["Change"] = {
                en = "Change",
        },
        ["Change language"] = {
                en = "Change language",
        },
        ["Choosing a language also allows the installer to pick reasonable default options."] = {
                en = "Choosing a language also allows the installer to pick reasonable default options.",
        },
        ["Configure the network"] = {
                en = "Configure the network",
        },
        ["Configure your keyboard"] = {
                en = "Configure your keyboard",
        },
        ["Configure ZFS"] = {
                en = "Configure ZFS",
        },
        ["Confirm"] = {
                en = "Confirm",
        },
        ["confirm password..."] = {
                en = "confirm password...",
        },
        ["Confirm root password:"] = {
                en = "Confirm root password:",
        },
        ["Delete"] = {
                en = "Delete",
        },
        ["Edit"] = {
                en = "Edit",
        },
        ["enter password..."] = {
                en = "enter password...",
        },
        ["Extra distsets:"] = {
                en = "Extra distsets:",
        },
        ["Full name"] = {
                en = "Full name",
        },
        ["Groups"] = {
                en = "Groups",
        },
        ["Hostname:"] = {
                en = "Hostname:",
        },
        ["Install"] = {
                en = "Install",
        },
        ["Install FreeBSD"] = {
                en = "Install FreeBSD",
                fr = "Installer FreeBSD",
                jp = "FreeBSDのインストール"
        },
        ["Keymap:"] = {
                en = "Keymap:",
        },
        ["Partition Disks: ZFS"] = {
                en = "Partition Disks: ZFS",
        },
        ["Password"] = {
                en = "Password",
        },
        ["Root password:"] = {
                en = "Root password:",
        },
        ["Select..."] = {
                en = "Select...",
        },
        ["Select a keyboard layout:"] = {
                en = "Select a keyboard layout:",
        },
        ["Select installer language"] = {
                en = "Select installer language",
        },
        ["Shell"] = {
                en = "Shell",
        },
        ["Username"] = {
                en = "Username",
        },
}

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
