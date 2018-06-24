local upload = require "resty.upload"
local cjson = require "cjson"
local global = require("./common/global")
local util = require("./common/util")
local uuid = require("./common/uuid")

function parse_multipart_form_data()
	local form, err = upload:new(g_lua_conf.chunk_size)
	if not form then
	    util.log_error(err)
	    ngx.exit(500)
	end
	form:set_timeout(g_lua_conf.req_timeout) -- 1 sec
	local head = ""
	local body = ""
	local ret = {}
	while true do
	    local typ, res, err = form:read()
	    if not typ then
			req_id = uuid.get_uuid()
	        ngx.say("failed to read: requies_id:", req_id)
			util.log_error(req_id..":"..err)
	        return
	    end
		if typ == "header" then
			head = res
		elseif typ == "body" then
			body = body .. res
		elseif typ == "part_end" then
			key = nil
			for k,v in pairs(head) do
				key = string.match(v,'="(%w+)')
				if  key then
					break;
				end
			end
			ret[key] = body
			ngx.say("key:",key,"\tvalue:",body,"<br>")
			head=""
			body=""
		elseif typ == "eof" then
			break
		else
			util.log_error("not recognition typ:"..typ)
		end

	end
	util.log_error(ret)
end

parse_multipart_form_data()
