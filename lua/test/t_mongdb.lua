local moongoo = require("resty.moongoo")
local cbson = require("cbson")

local mg, err = moongoo.new("mongodb://127.0.0.1/")
if err then
      ngx.say(tostring(err))
  end
ngx.say(type(mg))
local col = mg:db("test"):collection("test")

--Insert document
local ids, err = col:insert({ foo = "bar"})
if err then
      ngx.say(tostring(err))
end
-- Find document
local doc, err = col:find_one({ foo = "bar"})
if err then
      ngx.say(tostring(err))
end
ngx.say(doc.foo)

-- Update document
local doc, err = col:update({ foo = "bar"}, { baz = "yada",foo = "bar"})
if err then
      ngx.say(tostring(err))
end
ngx.say(type(doc),tostring(doc))

local doc, err = col:find_one({ foo = "bar"})
if err then
      ngx.say(tostring(err))
end
ngx.say(type(doc)," ",doc.foo," ",doc.baz)

-- Remove document
local status, err = col:remove({ baz = "yada"})

-- Close connection or put in OpenResty connection pool

mg:close()
