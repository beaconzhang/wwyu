local ffi = require("ffi")
ffi.cdef[[
	void trim(char*,char,int);
]]
util = ffi.load("/home/yuzhengtian/project/hqmovie/lua/lib/libutil.so")

s="fhd fh    f"
_s = ffi.new("char[?]",#s)
ffi.copy(_s,s)
util.trim(_s,string.byte(' '),#s)
print(ffi.string(_s))
