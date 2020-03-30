-- Minimal web server written in Lua
--
-- Use with inetd, no other dependencies:
-- http    stream  tcp     nowait  www    /usr/local/sbin/httpd      httpd

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
--

local M = {}

M.VERSION = '0.0.1'


-- HTTP-message = start-line
--                *( header-field CRLF )
--                CRLF
--                [ message-body ]
--
-- The server reads HTTP-messages from stdin and parses the data in order
-- to route and dispatch to a handler for processing.
--
-- The server state is a waiting state. So if server.state == START_LINE,
-- we're looking for a start line next.
local ServerState = {
   START_LINE = 0,
   HEADER_FIELD = 1
}


-- start-line = request-line / status-line
-- request-line = method SP request-target SP HTTP-version CRLF
-- method = token
local function parse_start_line(method, line)
   local pattern = "^" .. method .. " (%g+) (HTTP/1.1)\r$"

   return string.match(line, pattern)
end


local function decode(s)
   local function char(hex)
      return string.char(tonumber(hex, 16))
   end

   s = string.gsub(s, "+", " ")
   s = string.gsub(s, "%%(%x%x)", char)
   s = string.gsub(s, "\r\n", "\n")

   return s
end


--[[
local function encode(s)
   local function hex(char)
      return string.format("%%%02X", string.byte(char))
   end

   s = string.gsub(s, "\n", "\r\n")
   s = string.gsub(s, "([^%w %-%_%.%~])", hex)
   s = string.gsub(s, " ", "+")
   return s
end
]]--


local function parse_request_query(query)
   local params = {}

   local function parse(kv)
      local encoded_key, encoded_value = string.match(kv, "^(.*)=(.*)$")
      if encoded_key ~= nil then
         local key = decode(encoded_key)
         local value = decode(encoded_value)
         local param = params[key] or {}
         table.insert(param, value)
         params[key] = param
      end
   end

   string.gsub(query, "([^;&]+)", parse)

   return params
end


local function parse_request_path(s)
   local encoded_path, encoded_query = string.match(s, "^(.*)%?(.*)$")
   if encoded_path == nil then
      return decode(s), {}
   end

   local path = decode(encoded_path)
   local params = parse_request_query(encoded_query)

   return path, params
end


local methods = {
   "GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE"
}

local function handle_start_line(server, line)
   -- Try to match each known method.
   for _, method in ipairs(methods) do
      local rawpath, version = parse_start_line(method, line)

      if rawpath ~= nil then
         local path, params = parse_request_path(rawpath)
         server.request = {
            method = method,
            path = path,
            params = params,
            version = version,
            headers = {},
            cookies = {}
         }

         return ServerState.HEADER_FIELD
      end
   end

   -- No known methods matched.
   server.log:write("Invalid start-line in request.\n")

   return ServerState.START_LINE
end


-- expects a server table and a response table
-- example response table:
-- { status=404, reason="not found", headers={}, cookies={},
--   body="404 Not Found" }
local function write_http_response(server, response)
   local output = server.output

   local status = response.status
   local reason = response.reason
   local headers = response.headers or {}
   local cookies = response.cookies or {}
   local body = response.body

   if type(body) == "string" then
      headers['Content-Length'] = #body
   end

   local statusline = string.format("HTTP/1.1 %03d %s\r\n", status, reason)
   output:write(statusline)

   for name, value in pairs(headers) do
      local header = string.format("%s: %s\r\n", name, value)
      output:write(header)
   end

   for name, value in pairs(cookies) do
      local cookie = string.format("Set-Cookie: %s=%s\r\n", name, value)
      output:write(cookie)
   end

   output:write("\r\n")

   if type(body) == "string" then
      output:write(body)
   elseif type(body) == "function" then
      output:flush()
      body(output)
   end
end


--[[
-- Log some debugging info
local function debug_server(server)
   local log = server.log
   local request = server.request
   local handlers = server.handlers[request.method]

   log:write("#server.handlers = " .. tostring(#server.handlers) .. "\n")
   log:write("#handlers = " .. tostring(#handlers) .. "\n")
   log:write(request.method .. "\n")
   if request.path ~= nil then
      log:write(request.path, "\n")
   end
   for k, v in pairs(request.headers) do
      log:write("> " .. k .. ": ")
      for k1, v1 in pairs(v) do
         log:write(k1, "->")
         for _, v2 in ipairs(v1) do
            log:write(v2 .. ", ")
         end
         log:write("; ")
      end
      log:write("\n")
   end
   for k, v in pairs(request.params) do
      log:write(k .. " = ")
      for _, v in ipairs(v) do
         log:write(v .. ", ")
      end
      log:write("\n")
   end
end
]]--


local function handle_request(server)
   local request = server.request
   local handlers = server.handlers[request.method]

   --debug_server(server)

   -- Try to service the request.
   local response = { status=404, reason="Not Found", body="not found" }
   for _, location in ipairs(handlers) do
      local pattern, handler = table.unpack(location)
      local matches = { string.match(request.path, pattern) }
      if #matches > 0 then
         request.matches = matches
         response = handler(request)
         break
      end
   end

   write_http_response(server, response)

   -- Close all open file handles and exit to complete the response.
   os.exit()
end


local function method_expects_body(method)
   return method == "POST" or method == "PUT"
end


local function handle_message_body(server, content_length)
   local body = ""
   repeat
      local buf = server.input:read(content_length - #body)
      if buf then
         body = body .. buf
      else
         server.log:write("body shorter than specified content length\n")
         break
      end
   until #body == content_length

   if server.verbose then
      server.log:write("content length = ", content_length, "\n")
      server.log:write(body, "\n")
   end
   server.request.body = body
   handle_request(server)
end


local function handle_blank_line(server)
   local request = server.request
   local method = request.method
   local content_length_header = request.headers['content-length']

   if method_expects_body(method) and content_length_header then
      local values = content_length_header.list
      local value = values[#values]
      local content_length = tonumber(value)
      if content_length then
         return handle_message_body(server, content_length)
      else
         server.log:write("invalid content-length\n")
      end
   end
   return handle_request(server)
end


local function set_cookie(server, cookie)
   -- Browsers do not send cookie attributes in requests.
   local name, value = string.match(cookie, "(.+)=(.*)")
   local cookie = server.request.cookies[name] or {}
   table.insert(cookie, value)
   server.request.cookies[name] = cookie
end


local function parse_header_value(header, value)
   local function parse(attrib)
      local key, value = string.match(attrib, "^%s*(.*)=(.*)%s*$")
      if key then
         local attrval = header.dict[key] or {}
         table.insert(attrval, value)
         header.dict[key] = attrval
      else
         table.insert(header.list, attrib)
      end
   end

   string.gsub(value, "([^;]+)", parse)

   return header
end


local function update_header(server, name, value)
   local headers = server.request.headers
   -- Header may be repeated to form a list.
   local header = headers[name] or { dict={}, list={} }
   headers[name] = parse_header_value(header, value)
end


local function parse_header_field(line)
   return string.match(line, "^(%g+):%s*(.*)%s*\r$")
end


local function handle_header_field(server, line)
   if line == "\r" then
      -- When there are no headers left we get just a blank line.
      return handle_blank_line(server)
   else
      local name, value = parse_header_field(line)

      if name then
         -- Header field names are case-insensitive.
         local lname = string.lower(name)
         if lname == "cookie" then
            set_cookie(server, value)
         else
            update_header(server, lname, value)
         end
      else
         server.log:write("Ignoring invalid header: ", line, "\n")
      end

      -- Look for more headers.
      return ServerState.HEADER_FIELD
   end
end


local function handle_request_line(server, line)
   local state = server.state

   if state == ServerState.START_LINE then
      return handle_start_line(server, line)

   elseif state == ServerState.HEADER_FIELD then
      return handle_header_field(server, line)

   else
      return ServerState.START_LINE

   end
end


function M.create_server(logfile)
   local server = {
      state = ServerState.START_LINE,
      log = io.open(logfile, "a"),
      input = io.input(),
      output = io.output(),
      handlers = {
         -- handlers is a map of method => { location, location, ... }
         -- locations are matched in the order given, first match wins
         -- a location is an ordered list of { pattern, handler }
         -- pattern is a Lua pattern for string matching the path
         -- handler is a function(request) returning a response table
         GET = {},
         HEAD = {},
         POST = {},
         PATCH = {},
         PUT = {},
         DELETE = {},
         CONNECT = {},
         OPTIONS = {},
         TRACE = {}
      }
   }
   server.log:setvbuf("no")

   function server:add_route(method, pattern, handler)
      table.insert(self.handlers[method], { pattern, handler })
   end

   function server:run(verbose)
      self.verbose = verbose
      for line in self.input:lines() do
         if verbose then
            self.log:write(line, "\n")
         end
         self.state = handle_request_line(self, line)
      end
   end

   return server
end

return M
