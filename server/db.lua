-- vim: set et:
-- Minimal web server written in Lua
--
-- Use with inetd, no other dependencies:
-- http    stream  tcp     nowait  root    /usr/local/sbin/httpd      httpd

--
-- Copyright (c) 2016 - 2020 Ryan Moeller <ryan@freqlabs.com>
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

local SRC_DIR = "/home/yang/src/lua-httpd/"

local db = {}

local misc = require("misc")

local db_filename = SRC_DIR .. "db"
local db_file = io.open(db_filename, "r+")

function db.close()
        db_file:close()
end

function db.parse()
        local table = {users = {}}

        db_file:seek("set")
        local contents = db_file:read("*all")
        local lines = misc.splitString(contents, "\n")
        for i, line in ipairs(lines) do
                if (line:match("^user:")) then
                        local username, prop, val = line:match("^[^:]+:([^:]+):([^=]+)=(.*)")
                        if (table.users[username] == nil) then
                                table.users[username] = {}
                        end
                        table.users[username][prop] = val
                else
                        local prop, val = line:match("^([^=]+)=(.*)")
                        table[prop] = val
                end
        end

        return table
end

--Writes key=val to the end of the db.
--If key already exists in the db, we delete that line first.  
function db.update(key, val)
        db.removeMatches("^"..key.."$")
        db_file:seek("end")
        db_file:write(key.."="..val.."\n")
end


--TODO maybe make this faster? it's looping through db twice currently
--Only writes key=val to db if either key doesn't exist, or
--if val is "".
function db.updateIfUnset(key, val)
        local parsed_db = db.parse()
        if (not parsed_db[key] or parsed_db[key] == "") then
                db.update(key, val)
        end
end
function db.getUsersAsList(parsed_db)
        local users = parsed_db.users
        local user_list = {}

        for username, props in pairs(users) do
                local user = {}
                user.username = username
                for key, val in pairs(props) do
                        user[key] = val
                end
                table.insert(user_list, user)
        end

        local function compare_users(this, other)
            return this.username < other.username
        end

        table.sort(user_list, compare_users)

        return user_list
end

--Pass in a regex for the key, and this function will
--remove all lines in the db with matching keys.
function db.removeMatches(regex)
        db_file:seek("set")
        local text = db_file:read("*all")

        db_file:close()
        db_file = io.open(db_filename, "w+")

        local split_list = misc.splitString(text, "\n")
        for _, line in ipairs(split_list) do
               local key = line:match("^([^=]+)")
               if (not key:match(regex)) then
                       db_file:write(line.."\n")
               end
        end
end

return db
