local redis = require("resty.redis")
local global = require("./common/global")
local lock = require("resty.lock")
local util = require("./common/util")

redis_client = nil

function get_client()
	local lock, err = resty_lock:new("d_redis")
	if not lock then
		util.log_error("lock d_redis errir
	
end
