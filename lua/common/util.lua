local _M = {}

local json = require("cjson")
local c_lua = require("./common/c_lua")
local globle = require("./common/global")

function _M.obj_string(obj)
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
			ngx.log(ngx.ERR,g_lua_conf.log_delimit,debug.getinfo(1).name,
			g_lua_conf.log_delimit,debug.getinfo(1).currentline,
			g_lua_conf.log_delimit,"not recongise obj type",g_lua_conf.log_delimit)
			return ""
	end
	return lua
end

function _M.log_error(message)
	ngx.log(ngx.ERR,g_lua_conf.log_delimit,_M.obj_string(message),g_lua_conf.log_delimit)
end
	

return _M
