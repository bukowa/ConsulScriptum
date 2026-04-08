-- Minimal LuaFileSystem compatibility shim for docs generation on Windows.
-- It provides the subset used by Penlight/LDoc in this repository.

local lfs = {}

local function normalize(path)
    return tostring(path):gsub("/", "\\")
end

local function quote(path)
    return '"' .. normalize(path):gsub('"', '\\"') .. '"'
end

local function run_read(cmd)
    local p = io.popen(cmd)
    if not p then
        return nil
    end
    local out = p:read("*a")
    p:close()
    if not out then
        return nil
    end
    return (out:gsub("%s+$", ""))
end

local function exists(path)
    local out = run_read('cmd /c if exist ' .. quote(path) .. ' (echo 1)')
    return out == "1"
end

local function is_dir(path)
    local out = run_read('cmd /c if exist ' .. quote(normalize(path) .. "\\NUL") .. ' (echo 1)')
    return out == "1"
end

function lfs.attributes(path, key)
    local attr = {}
    if is_dir(path) then
        attr.mode = "directory"
    elseif exists(path) then
        attr.mode = "file"
        local f = io.open(path, "rb")
        if f then
            local size = f:seek("end")
            f:close()
            attr.size = size or 0
        else
            attr.size = 0
        end
    else
        return nil, "No such file or directory", 2
    end

    attr.access = os.time()
    attr.modification = os.time()
    attr.change = os.time()

    if key ~= nil then
        return attr[key]
    end
    return attr
end

function lfs.symlinkattributes(path, key)
    return lfs.attributes(path, key)
end

function lfs.currentdir()
    local out = run_read("cd")
    if not out or out == "" then
        return nil, "Unable to read current directory", 1
    end
    return out
end

function lfs.chdir(_path)
    -- Lua cannot change the process cwd portably without native support.
    -- LDoc path handling in this project does not rely on chdir side effects.
    return true
end

function lfs.mkdir(path)
    os.execute('cmd /c mkdir ' .. quote(path) .. ' >nul 2>nul')
    return true
end

function lfs.rmdir(path)
    os.execute('cmd /c rmdir ' .. quote(path) .. ' >nul 2>nul')
    if not is_dir(path) then
        return true
    end
    return nil, "Unable to remove directory", 1
end

function lfs.dir(path)
    local p = io.popen('cmd /c dir /b ' .. quote(path))
    if not p then
        error("cannot open directory: " .. tostring(path))
    end

    return function()
        local line = p:read("*l")
        if line == nil then
            p:close()
            return nil
        end
        return line
    end
end

return lfs
