local c_lua = require("./common/c_lua")
local util = require("./common/util")
local _M = {}
-- -------- ---- -------- -------- ---------- ----
--|        |    |        |        |          |    |
--|   ip   |pid |request |connect |   time   |rand|
--|        |    |        |        |          |    |
-- -------- ---- -------- -------- ---------- ----
--    8       4     8        6         12      4
function _M.get_ip_hex()
	local t = io.popen('ip addr show |grep enp0s31f6 -A 1 |grep "inet "|awk  \'{print $2}\' |awk -F\'/\' \'{print $1}\'')
	local ip = t:read("*all")
	ip = c_lua.trim(ip,"\n")
	local arr = ip:split(".")
	local ret = ""
	for k,v in pairs(arr)
	do
		ret = ret..string.format("%02X",v)
	end
	return ret
end

function _M.get_pid_hex()
	local pid = ngx.worker.pid()
	return string.format("%04X",math.fmod(pid,65536))
end

_M.prefix =  _M.get_ip_hex() .. _M.get_pid_hex()

function _M.get_request_id()
	local rid = ngx.var.request_id
	return string.sub(rid,string.len(rid)-7,string.len(rid)) 
end

function _M.get_connenct_id()
	local connect_id = ngx.var.connect;
	local request_id = ngx.var.connection_requests;
	return string.format("%04X%02X",math.fmod(connect_id,65536),math.fmod(request_id,256))
end

function _M.get_time()
	local tm = ngx.var.request_time
	return string.format("%012X",math.fmod(tonumber(tm*1000,281474976710656)))
end

function _M.get_rnd()
	return string.format("%04X",math.random(0,65535))
end

function _M.get_uuid()
	return _M.prefix .. _M.get_request_id() ..  _M.get_connenct_id() .. _M.get_time() ..  _M.get_rnd()
end

return _M
