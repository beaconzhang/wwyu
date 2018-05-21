local _M = {}

local moongoo = require("resty.moongoo")
local cbson = require("cbson")
local globle = require("./common/global")
local util = require("./common/util")
--如果觉得此luadriver性能不行，需要自己封装c/c++客户端
--改进地方：
--	1）连接池
--	2）batch处理
--	3）
-- 模块说明
-- 提供lua mongdb的封装，不关心存储的db、collection、数据，\
-- 传入参数是table方式，其中key表示字段
-- 参考 https://github.com/isage/lua-resty-moongoo
function get_client(url)
	url = url or g_lua_conf.mongdb_url
	local mg, err = moongoo.new(url)
	if not err then
		util.log_error("connect "+url+" error",\
		debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
	return mg
end

function get_col(db,collection)
	local col = mg:db(db):collection(collection)
	if not col then
		util.log_error("connect db:"+db+" collection:"+collection+" error",\
		debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
	return col
end

--tbls是table的array
--ids是对应的主键的array
function col_insert(tbls):
	local col = get_client()
	local ids, err = col:insert(tbls)
	if not err then
		util.log_error("insert "+util.obj_string(tbls)+" error",\
		debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
	return ids
end

--使用长变参数
--tbl_query 是查询table，tbl_field 目前猜测是返回字段
function col_find_one(tbl_query,tbl_field)
	local col = get_client()
	local doc, err = col:find_one(tbl_query,tbl_field)
	if not err then
		util.log_error("find query:"+util.obj_string(tbl_query)+\
		" tbl_field:"+util.obj_string(tbl_field)+"error",\
		debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
	return doc
end

function col_update(query,update,flags)
	local col = get_client()
	local doc, err = col:update(query,update,flags)
	if not err then
		util.log_error("find query:"+util.obj_string(query)+\
		" update:"+util.obj_string(update)+" flags"+util.obj_string(flags)\
		+"error",debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
	return doc
end

function col_remove(query,single)
	local col = get_client()
	local status, err = col:remove(query,single)
	if not err then
		util.log_error("find query:"+util.obj_string(query)+\
		" single:"+util.obj_string(single)+"error",\
		debug.getinfo(1).name,debug.getinfo(1).currentline)
		return nil
	end
end

function close(mg)
	mg:close()
end

return _M
