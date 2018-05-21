local _M = {}
local d_mongdb = require("./driver/mongdb/z_mongdb")
local util = require("./common/util")

function check_arg(tbl)
	if not tbl["_id"] or not tbl["area"] or not tbl["name"] then
		return false
	end
	return true
end
--db:area
--collection:movie
--如果存在则不进行任何操作，否则进行插入
--插入前需要字段验证，如果_id、area、name字段为空，则不进行任何操作
function create_movie(tbl)
	if not check_arg(tbl) then
		util.log_error(util.obj_string(tbl),debug.getinfo(1).name,\
		debug.getinfo(1).currentline)
		return false
	end
	return d_mongdb.col_insert(tbl);
end

return _M
