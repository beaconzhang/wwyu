local _M = {}

local json = require("cjson")

function trim(obj)
	
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

		
	


function error_log(message,tbl)
	
end

return _M
