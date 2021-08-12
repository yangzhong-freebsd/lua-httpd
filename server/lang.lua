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
                fr = "Ajouter un utilisateur",
        },
        ["Add users to your system."] = {
                en = "Add users to your system.",
        },
        ["Change"] = {
                en = "Change",
                fr = "Changer",
        },
        ["Change language"] = {
                en = "Change language",
                fr = "Changer la langue",
        },
        ["Choosing a language also allows the installer to pick reasonable default options."] = {
                en = "Choosing a language also allows the installer to pick reasonable default options.",
        },
        ["Configure the network"] = {
                en = "Configure the network",
        },
        ["Configure your keyboard"] = {
                en = "Configure your keyboard",
                fr = "Configurer le clavier",
        },
        ["Configure ZFS"] = {
                en = "Configure ZFS",
                fr = "Configurer ZFS",
        },
        ["Confirm"] = {
                en = "Confirm",
                fr = "Confirmer",
        },
        ["Confirm password"] = {
                en = "Confirm password",
        },
        ["Confirm root password:"] = {
                en = "Confirm root password:",
        },
        ["Delete"] = {
                en = "Delete",
        },
        ["Edit"] = {
                en = "Edit",
                fr = "Modifier",
        },
        ["enter password..."] = {
                en = "enter password...",
        },
        ["Extra distsets:"] = {
                en = "Extra distsets:",
        },
        ["Filesystem"] = {
                en = "Filesystem",
                fr = "Système de fichiers",
        },
        ["Full name"] = {
                en = "Full name",
                fr = "Nom",
        },
        ["Groups"] = {
                en = "Groups",
                fr = "Groupes",
        },
        ["Home"] = {
                en = "Home",
                fr = "Accueil",
        },
        ["Hostname"] = {
                en = "Hostname",
        },
        ["Install"] = {
                en = "Install",
                fr = "Installer",
        },
        ["Install FreeBSD"] = {
                en = "Install FreeBSD",
                fr = "Installer FreeBSD",
                jp = "FreeBSDのインストール"
        },
        ["Keyboard"] = {
                en = "Keyboard",
                fr = "Clavier",
        },
        ["Keyboard layout"] = {
                en = "Keyboard layout",
        },
        ["Keymap"] = {
                en = "Keymap",
                fr = "Disposition du clavier",
        },
        ["Language"] = {
                en = "Language",
                fr = "Langue",
        },
        ["Network"] = {
                en = "Network",
        },
        ["Packages"] = {
                en = "Packages",
                fr = "Pacquets",
        },
        ["Partition Disks: ZFS"] = {
                en = "Partition Disks: ZFS",
        },
        ["Password"] = {
                en = "Password",
                fr = "Mot de passe",
        },
        ["Root password"] = {
                en = "Root password",
                fr = "Mot de passe de utilisateur root",
        },
        ["Select..."] = {
                en = "Select...",
        },
        ["Select installer language"] = {
                en = "Select installer language",
        },
        ["Select language"] = {
                en = "Select language",
                fr = "Choisir la langue",
        },
        ["Select the packages to be installed on your system."] = {
                en = "Select the packages to be installed on your system.",
        },
        ["Settings"] = {
                en = "Settings",
                fr = "Paramètres",
        },
        ["Shell"] = {
                en = "Shell",
        },
        ["System Settings"] = {
                en = "System Settings",
                fr = "Paramètres système",
        },
        ["Timezone"] = {
                en = "Timezone",
                fr = "Fuseau horaire",
        },
        ["Username"] = {
                en = "Username",
        },
        ["Users"] = {
            en = "Users",
            fr = "Utilisateurs",
        },
        ["Variant"] = {
            en = "Variant",
        },
}

lang.languages = {
        en = {
                name = "English",
                keymap_layout = "us",
                keymap_variant = "",
        },
        fr = {
                name = "Français (INCOMPLETE -- FOR TESTING)",
                keymap_layout = "fr",
                keymap_variant = "",
        },
        jp = {
                name = "日本語 (INCOMPLETE -- FOR TESTING)",
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
