local ffi = require ("ffi")
local globle = require("./common/global")
local cutil = ffi.load(g_lua_conf.workdir .. "/lua/lib/libutil.so")
local _M ={}

ffi.cdef[[
	void trim(char* s,char trim_char,int len)
]]

-- trim all char c from s
function _M.trim(s,c)
	local _s = ffi.new("char [?]", #s)
	ffi.copy(_s,s)
	cutil.trim(_s,string.byte(c),#s)
	return ffi.string(_s)
end


return _M
