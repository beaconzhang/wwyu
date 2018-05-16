local _M = {}

local moongoo = require("resty.moongoo")
local cbson = require("cbson")
-- 模块说明
-- 提供lua mongdb的封装，不关心存储的db、collection、数据，传入参数是table方式，其中key表示字段
function client(url)
	url = url or "mongodb://127.0.0.1:27017/"
	
	
end

return _M
