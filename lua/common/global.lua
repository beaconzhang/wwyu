--只支持key-value格式，不支持嵌套，支持链表，以逗号隔开
local Config = require("./common/config")

local config =Config:new()
local conf_path = "/home/yuzhengtian/project/hqmovie/conf/lua.conf"

g_lua_conf = config:parse(conf_path)



--for test
--for key,value in pairs(g_lua_conf) do
--	print(key)
--	print(value)
--end

