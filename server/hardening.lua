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

local hardening = hardening or {}

hardening.menu = {
    {
        name = "hide_uids",
        description = "Hide processes running as other users",
    },
    {
        name = "hide_gids",
        description = "Hide processes running as other groups",
    },
    {
        name = "hide_jail",
        description = "Hide processes running in jails",
    },
    {
        name = "read_msgbuf",
        description =
            "Disable reading kernel message buffer for unprivileged users",
    },
    {
        name = "proc_debug",
        description =
            "Disable process debugging facilities for unprivileged users",
    },
    {
        name = "random_pid",
        description = "Randomize the PID of newly created processes",
    },
    {
        name = "clear_tmp",
        description = "Clean the /tmp filesystem on system startup",
    },
    {
        name = "disable_syslogd",
        description =
            "Disable opening Syslogd network socket (disables remote logging)",
    },
    {
        name = "disable_sendmail",
        description = "Disable Sendmail service",
    },
    {
        name = "secure_console",
        description = "Enable console password prompt",
    },
    {
        name = "disable_ddtrace",
        description = "Disallow DTrace destructive-mode",
    },
}

return hardening
