local ffi = require ("ffi")
local _M ={}

ffi.cdef[[
	void trim(char* s,char trim_char,int len)
]]

-- trim all char c from s
function trim(s,c)
	local _s = ffi.new("char [?]", #s)
	ffi.copy(_s,s)
	ffi.trim(_s,string.byte(c),#s)
	return ffi.string(_s)
end


return _M