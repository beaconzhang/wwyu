local redis = require("resty.redis")
local global = require("./common/global")
local lock = require("resty.lock")
local util = require("./common/util")

local _M = {}

function _M.get_client()
	local redis_client = redis:new()
	local ok, err = redis_client:connect(g_lua_conf.redis_host, g_lua_conf.redis_port)
	if not ok then
		util.log_error("get redis client failed error redis_host:"..g_lua_conf.redis_host .. " redis_port:"..g_lua_conf.redis_port.." error message:"..err)
	end
	ok, err = red:set_keepalive(g_lua_conf.max_idle_timeout,g_lua_conf.pool_size)
	return redis_client
end

function redis_set(key,value)
	local redis_client = _M.get_client()
	local ok, err = redis_client:set(key,value)
	if not ok then
		util.log_error("redis set error key:" .. key .. " value:" .. value .. " error:"..err)
	end
	return err
end


function redis_get(key)
	local redis_client = _M.get_client()
	local ok, err = redis_client:get(key)
	if not ok then
		util.log_error("redis get error key:" .. key .. " error:"..err)
	end
	return ok
end

function redis_expire(key,expire_time)
	local redis_client = _M.get_client()
	local ok,err = redis_client:expire(key,expire_time)
	if not ok then
		util.log_error("redis expire error key:" .. key .. "expire_time:" .. expire_time .. " error:"..err)
	end
	return ok
end

--参数格式为{{key,value},{key,value}, ... }
function redis_set_pipe(argv)
	local redis_client = _M.get_client()
	local 
end

