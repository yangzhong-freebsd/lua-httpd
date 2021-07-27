#!/usr/libexec/flua

local SRC_DIR = "/home/yang/src/lua-httpd/"

local db = require("db")

local outfile = assert(io.open(SRC_DIR.."installscript", "w"))

function make_write(line, file)
	return "echo '"..line.."' >> "..file.."\n"
end

function main()
	local parsed_db = db.parse()

	local users = db.getUsersAsList(parsed_db)

	outfile:write("PACKAGES=\"kernel base\"\n")
	outfile:write("OTHER_PACKAGES=\"vim-console sudo git\"\n")
	outfile:write("export ZFSBOOT_VDEV_TYPE="..parsed_db.zfs_filesystem.."\n")
	outfile:write("export ZFSBOOT_DISKS=\""..parsed_db.zfs_disks.."\"\n")
	outfile:write("export nonInteractive=\"YES\"\n")
	outfile:write("\n")
	outfile:write("#!/bin/sh\n")

	--TODO for all user-input parameters, need to escape any single quotes inside. Also change to use make_write
	outfile:write("echo 'hostname="..parsed_db.hostname.."' >> /etc/rc.conf\n")
	outfile:write("echo 'zfs_enable=\"YES\"' >> /etc/rc.conf\n") --TODO: check that this is really necessary
	outfile:write("echo '"..parsed_db.root_password.."' | pw usermod root -h 0\n")

	for _, user in ipairs(users) do
		local groups = user.groups:gsub(" ", ",")
		outfile:write("echo '"..user.password.."' | pw useradd -n "..user.username.." -c '"..user.full_name.."' -s "..user.shell.." -G "..groups.." -m -h 0\n")
	end

	--TODO this should only run when we're configuring a wireless network 
	--TODO add create_args_wlan0, wlans_lo0 lines to rc.conf, like in bsdinstall
	--wait, lo is not what I want. I can't see the right interface after installing. need to see...
	outfile:write(make_write("ctrl_interface=/var/run/wpa_supplicant", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("eapol_version=2", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("ap_scan=1", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("fast_reauth=1", "/etc/wpa_supplicant.conf"))

	outfile:write(make_write("network={", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("    ssid=\""..parsed_db.network.."\"", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("    scan_ssid=0", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("    psk=\""..parsed_db.network_password.."\"", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("    priority=5", "/etc/wpa_supplicant.conf"))
	outfile:write(make_write("}", "/etc/wpa_supplicant.conf"))

	outfile:write(make_write("wlans_"..parsed_db.network_interface.."=\"wlan0\"", "/etc/rc.conf"))
	outfile:write(make_write("ifconfig_wlan0=\"up scan WPA DHCP\"", "/etc/rc.conf"))
	outfile:write(make_write("ifconfig_wlan0_ipv6=\"inet6 accept_rtadv\"", "/etc/rc.conf"))
	outfile:write(make_write("create_args_wlan0=\"country CA regdomain FCC\"", "/etc/rc.conf"))

	outfile:write(make_write("search "..parsed_db.resolv_search, "/etc/resolv.conf"))
	outfile:write(make_write("nameserver "..parsed_db.resolv_nameserver, "/etc/resolv.conf"))

end

main()
