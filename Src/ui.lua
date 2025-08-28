local __modules = null

local __cache = {}  

local function __load(name)
    if __cache[name] ~= nil then
        return __cache[name]
    end
    local src = __modules[name]
    if not src then
        error("Module not found: "..tostring(name))
    end
    local chunk, err = loadstring(src, "="..name)
    if not chunk then
        error("loadstring error for "..name..": "..tostring(err))
    end
    local env = getfenv and getfenv(1) or _ENV
    if setfenv then setfenv(chunk, env) end
    local result = chunk()
    __cache[name] = result
    return result
end

local function require(path)
    path = path:gsub("\\\\","/")
    if __modules[path] then
        return __load(path)
    end
    if __modules[path..".lua"] then
        return __load(path..".lua")
    end
    if __modules[path..".luau"] then
        return __load(path..".luau")
    end
    path = path:gsub("^src/",""):gsub("^Src/","")
    if __modules[path] then
        return __load(path)
    end
    if __modules[path..".lua"] then
        return __load(path..".lua")
    end
    if __modules[path..".luau"] then
        return __load(path..".luau")
    end
    error("require: cannot resolve "..tostring(path))
end

return __load("Themes/Quiet Light.luau")
