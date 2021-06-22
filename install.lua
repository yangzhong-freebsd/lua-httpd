#!/usr/libexec/flua

local SRC_DIR = "/home/yang/src/lua-httpd/"

local db = require("db")

local outfile = assert(io.open(SRC_DIR.."installscript", "w"))

function main()
	local parsed_db = db.parse()

	local users = db.getUsersAsList(parsed_db)

	outfile:write("DISTRIBUTIONS=\""..parsed_db.distsets.."\"\n")
	outfile:write("export ZFSBOOT_VDEV_TYPE="..parsed_db.zfs_filesystem.."\n")
	outfile:write("export ZFSBOOT_DISKS=\""..parsed_db.zfs_disks.."\"\n")
	outfile:write("export nonInteractive=\"YES\"\n")
	outfile:write("\n")
	outfile:write("#!/bin/sh\n")

	--TODO for all user-input parameters, need to escape any single quotes inside
	outfile:write("echo 'hostname="..parsed_db.hostname.."' >> /etc/rc.conf\n")
	outfile:write("echo 'zfs_enable=\"YES\"' >> /etc/rc.conf\n") --TODO: check that this is really necessary
	outfile:write("echo '"..parsed_db.root_password.."' | pw usermod root -h 0\n")

	for _, user in ipairs(users) do
		outfile:write("echo '"..user.password.."' | pw useradd -n "..user.username.." -c '"..user.full_name.."' -s "..user.shell.." -m -h 0\n")
	end
end

main()
