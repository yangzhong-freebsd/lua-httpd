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

local filesystem = filesystem or {}

-- TODO: minimum requirements (in js)
filesystem.formats = {
    {
        title = "UFS (concat)",
        value = "UFS:CONCAT",
        default = false,
    },
    {
        title = "UFS (mirror)",
        value = "UFS:MIRROR",
        default = false,
    },
    {
        title = "UFS (raid5)",
        value = "UFS:RAID5",
        default = false,
    },
    {
        title = "UFS (stripe)",
        value = "UFS:STRIPE",
        default = false,
    },
    {
        title = "ZFS (mirror)",
        value = "ZFS:MIRROR",
        default = true,
    },
    {
        title = "ZFS (raidz1)",
        value = "ZFS:RAIDZ1",
        default = false,
    },
    {
        title = "ZFS (raidz2)",
        value = "ZFS:RAIDZ2",
        default = false,
    },
    {
        title = "ZFS (stripe)",
        value = "ZFS:STRIPE",
        default = false,
    },
}

filesystem.zfs_formats = {
    {
        title = "Stripe",
        value = "ZFS:STRIPE",
        default = true,
        min_disks = 1,
    },
    {
        title = "Mirror",
        value = "ZFS:MIRROR",
        default = false,
        min_disks = 2,
    },
    {
        title = "RAID-Z1",
        value = "ZFS:RAIDZ1",
        default = false,
        min_disks = 3,
    },
    {
        title = "RAID-Z2",
        value = "ZFS:RAIDZ2",
        default = false,
        min_disks = 4,
    },
}

return filesystem
