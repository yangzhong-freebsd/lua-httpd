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

local distset = distset or {}

local DISTDIR = "/usr/freebsd-dist"

function distset.list(distdir)
    local list = {}
    local f = assert(io.open(distdir .. "/MANIFEST", "r"))
    local text = f:read("*a")
    f:close()
    for line in text:gmatch("([^\n]+)") do
	if line:find("^%s*#") == nil and line:find("^%s*$") == nil then
	    local file, cksm, size, name, desc, sele = 
		line:match('^(.+)\t(%x+)\t(%d+)\t(.*)\t"?([^"]+)"?\t(.*)$')
	    size = tonumber(size)
	    sele = sele == "on"
	    table.insert(list,
			 { file=file,
			   cksm=cksm,
			   size=size,
			   name=name,
			   desc=desc,
			   sele=sele })
	end
    end
    return list
end

return distset
