local _M = {}

local json = require("cjson")
local c_lua = require("./common/c_lua")
local globle = require("./common/globle")

function string:split(sep)  
    local sep, fields = sep or ":", {}  
    local pattern = string.format("([^%s]+)", sep)  
    self:gsub(pattern, function (c) fields[#fields + 1] = c end)  
    return fields  
end  


function obj_string(obj)
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then
		lua = json.encode(obj)
		lua = c_lua.trim(lua,"\n")
	else
		ngx.log(ngx.ERR,g_lua_conf.log_delimit,debug.getinfo(1).name,\
		g_lua_conf.log_delimit,debug.getinfo(1).currentline,\
		g_lua_conf.log_delimit,"not recongise obj type",g_lua_conf.log_delimit)
		return ""
	end
	return lua
end

function log_error(message,func,line)
	ngx.log(ngx.ERR,g_lua_conf.log_delimit,func,g_lua_conf.log_delimit,\
	obi_string(message),g_lua_conf.log_delimit)
end
	

return _M
