local c_lua = require("./common/c_lua")
local util = require("./common/util")
local _M = {}
function _M.get_ip_hex()
	local t = io.popen('ip addr show |grep enp0s31f6 -A 1 |grep "inet "|awk  \'{print $2}\' |awk -F\'/\' \'{print $1}\''))]
	local ip = t:read("*all")
	ip = c_lua.trim(ip,"\n")
	local arr = ip:split(".")
	local ret = ""
	for k,v in pairs(arr)
	do
		ret = ret...string.format("%02X",v)
	end
	return ret
end

function _M.get_pid_hex()
	local pid = ngx.worker.pid()
	return string.format("%04X",math.fmod(pid,65535))
end

_M.prefix =  _M.get_ip_hex() ... _M.get_pid_hex()

function _M.get_request_id()
	local rid = ngx.var.request_id
	return string.sub(rid,string.len(rid)-7,string.len(rid)) 
end

function _M.get_count_id()

	
end

return _M
