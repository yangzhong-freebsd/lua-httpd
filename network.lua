#!/usr/libexec/flua

local misc = require("misc")
local network = network or {}

local function getInterfaces()
	local interfaces = io.popen("ifconfig -l"):read()
	for _, interface in ipairs(misc.splitString(interfaces, " ")) do
		if (not (interface == "lo0") and
			not (os.execute("ifconfig -g wlan | grep -wq " .. interface))) then
			print(interface)
		end
	end
end

getInterfaces()

return network
