#!/usr/libexec/flua

local misc = require("misc")
local network = network or {}

local function getInterfaceDesc(interface)
	if (interface:match("(%a+)(%d+)")) then
		local name, num = interface:match("(%a+)(%d+)")
		local desc = io.popen("sysctl -n dev."..name.."."..num..".%desc 2>/dev/null"):read()
		return desc
	end
	return nil
end

function network.getInterfaces()
	local interfaces = {}
	
	local ifconfig_output = io.popen("ifconfig -l"):read()
	for _, intf in ipairs(misc.splitString(ifconfig_output, " ")) do
		if (not (intf == "lo0") and
			not (os.execute("ifconfig -g wlan | grep -wq " .. intf))) then
			interface = {
				name = intf,
				desc = getInterfaceDesc(intf),
				wireless = false,
			}
			if (interface.desc) then
				table.insert(interfaces, interface)
			end
		end
	end

	local wireless_interfaces = io.popen("sysctl -in net.wlan.devices"):read()
	for _, intf in ipairs(misc.splitString(wireless_interfaces, " ")) do
		interface = {
			name = intf,
			desc = getInterfaceDesc(intf),
			wireless = true,
		}
		if (interface.desc) then
			table.insert(interfaces, interface)
		end
	end

	return interfaces
end

local function checkIPv4()
	local output = os.execute("sysctl -N kern.features.inet > /dev/null 2>&1")
	network.ipv4 = output
	output = os.execute("sysctl -N kern.features.inet6 > /dev/null 2>&1")
	network.ipv6 = output
end

function network.scanWireless() -- (interface)
	local networks = {}
	local one, two = os.execute("wpa_cli scan >/dev/null 2>&1")
	os.execute("sleep 5")
	for line in io.popen("wpa_cli scan_result"):lines() do
		if line:match("(.*)\t(.*)\t(.*)\t(.*)\t(.*)") then
			local bssid, frequency, signal_level, flags, ssid = line:match("(.*)\t(.*)\t(.*)\t(.*)\t(.*)")
			local n = {
				bssid = bssid,
				frequency = frequency,
				signal_level = signal_level,
				flags = flags,
				ssid = ssid,
			}

			table.insert(networks, n)
		end
	end

	return networks
end

function network.connectWireless(network, password)
	local wpa_sup_path = "/etc/wpa_supplicant.conf"
	local wpa_sup = io.open(wpa_sup_path, "w+")

	wpa_sup:write("ctrl_interface=/var/run/wpa_supplicant\n")
	wpa_sup:write("eapol_version=2\n")
	wpa_sup:write("ap_scan=1\n")
	wpa_sup:write("fast_reauth=1\n")

	wpa_sup:write("network={\n")
	wpa_sup:write("\tpriority=0\n")
	wpa_sup:write("\tkey_mgmt=NONE\n")
	wpa_sup:write("}\n")

	--TODO support things other than PSK
	wpa_sup:write("network={\n")
	wpa_sup:write("\tssid=\""..network.."\"\n")
	wpa_sup:write("\tscan_ssid=0\n")
	wpa_sup:write("\tpsk=\""..password.."\"\n")
	wpa_sup:write("\tpriority=5\n")
	wpa_sup:write("}\n")
	wpa_sup:close()

	os.execute("wpa_cli reconfigure")
end

checkIPv4()

return network
