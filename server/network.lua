-- vim: set et sw=4:

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

local function checkIPv4()
    local output = os.execute("sysctl -N kern.features.inet > /dev/null 2>&1")
    network.ipv4 = output
    output = os.execute("sysctl -N kern.features.inet6 > /dev/null 2>&1")
    network.ipv6 = output
end

network.temp_file = "/tmp/lua-httpd"

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

function network.isWireless(interface)
    local wireless_interfaces = io.popen("sysctl -in net.wlan.devices"):read()
    for _, intf in ipairs(misc.splitString(wireless_interfaces, " ")) do
        if (interface == intf) then
            return true
        end
    end
    return false
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

function network.startDaemon()
    os.execute("pkill wpa_cli") --TODO is this really okay???
    if (network.action_file) then
        network.action_file:close()
    end
    network.action_file = io.popen("wpa_cli -a "..SRC_DIR.."action-script -B > "..network.temp_file.." 2>&1", "r")
end

function network.status_from_command()
    return io.popen("wpa_cli status"):read("a") --TODO these should probably be closed?
end

function network.status_from_file()
        local the_file = io.open(network.temp_file)

        -- This is either "CONNECTED\n", "DISCONNECTED\n", "TEMP-DISABLED\n", "\n".
        local status = the_file:read("*all")
        status = status:gsub("%s+", "")
        the_file:close()

        -- Clear the status file when we reach a 'final' state, so the next
        -- connection attempt doesn't get confused.
        if (status == "TEMP-DISABLED" or status == "CONNECTED") then
                io.open(network.temp_file, "w"):close()
        end

        return status
end

function network.connectWireless(network, password)
    local add_network_output = io.popen("wpa_cli add_network", "r")
    local network_id = 0
    for line in add_network_output:lines() do
        local match = line:match("^%d+$")
        if (match) then
                network_id = match
        end
    end
    os.execute("echo 'set_network "..network_id.." ssid \""..network.."\"' | wpa_cli")
    os.execute("echo 'set_network "..network_id.." psk \""..password.."\"' | wpa_cli")
    os.execute("wpa_cli select_network "..network_id)
    os.execute("wpa_cli reconnect")
end

checkIPv4()

return network
