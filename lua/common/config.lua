--参考 https://github.com/moltin/lua-config-loader
--- Parse a config file into table variables for configuration
-- @author Israel Sotomayor israel@moltin.com

local Config = {}
Config.__index = Config

setmetatable(Config, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

--- Parse a file for some config variables
-- @param path string The path of the conifg file to parse
-- @return table connection parameters
function Config:parse(path)
    local params = {}

    -- Open file
    fp = io.open(path, "r" )

    -- Drop comments
    for line in fp:lines() do
		--print(line)
        line = line:match( "%s*(.+)" )
        if line and line:sub( 1, 1 ) ~= "#" and line:sub( 1, 1 ) ~= ";" then
            option = line:match( "%S+" ):lower()
            value  = line:match( "%S*%s*(.*)" )

            if not value then
                params[option] = true
				--print("true")
            else
                if not value:find( "," ) then
                    params[option] = value
					--print("option:",option)
					--print("value:",value)
                else
					--log = value .. ":"
                    value = value .. ","
                    params[option] = {}
                    for entry in value:gmatch( "%s*(.-)," ) do
                        params[option][#params[option]+1] = entry
						--log = log .. "," .. entry
                    end
					--print(log)
                end
            end
        end
    end
    fp:close()
    return params
end

--- Load environment variables
-- @return table connection parameters
function Config:loadEnvironmentVariables(variables)
    local params = {}
    if variables then
        for _, v in pairs(variables) do
            params[string.lower(v)] = os.getenv(v)
        end
    end
    return params
end

function Config.new()
    local instance = {}
    setmetatable(instance, Config)
    return instance
end

return Config
