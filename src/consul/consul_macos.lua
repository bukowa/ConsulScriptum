-- macOS only: path resolution and line-ending fixes for the Feral ports. Never loaded on Windows
-- (see consul.io_resolve_path).
--
-- On macOS the game CWD is not the game folder, so relative paths are resolved
-- against the game folder inside the Steam library the game is installed in.

-- Default Steam install folder
local STEAM_ROOT = (os.getenv('HOME') or '/tmp') .. '/Library/Application Support/Steam'

-- Steam app ids and install folder names of the supported games
local games = {
    Rome2 = { appid = "214950", dir = "Total War Rome II" },
    Attila = { appid = "325610", dir = "Total War Attila" },
    TOB = { appid = "712100", dir = "Total War Saga Thrones of Britannia" },
}

-- Cached game root folder
local game_root = nil

--- finds the game root folder, looking up the Steam library the game is installed in.
--- Reads steamapps/libraryfolders.vdf from the default Steam install and falls back
--- to the default Steam library if the game cannot be found there. The result is cached.
--- @tparam table game The entry of games for the current build.
--- @return string The game root folder, with a trailing slash.
local function find_game_root(game)
    if game_root then
        return game_root
    end

    local library = STEAM_ROOT

    pcall(function()
        local f = io.open(STEAM_ROOT .. '/steamapps/libraryfolders.vdf', 'r')
        if not f then
            return
        end
        local current_path = nil
        for line in f:lines() do
            local path = line:match('^%s*"path"%s+"(.-)"%s*$')
            if path then
                current_path = path
            elseif current_path and line:match('^%s*"' .. game.appid .. '"%s+"') then
                library = current_path
                break
            end
        end
        f:close()
    end)

    game_root = library .. '/steamapps/common/' .. game.dir .. '/'
    return game_root
end

--- resolves a relative filename against the game folder.
--- Absolute paths and unknown builds are returned as-is.
--- @tparam string filename The filename (relative or absolute) to resolve.
--- @return string The resolved path.
local function resolve_path(filename)
    local game = games[consul_build]
    if not game or filename:sub(1, 1) == '/' then
        return filename
    end
    return find_game_root(game) .. filename
end

--- converts Windows line endings (CRLF) to Unix (LF) in place.
--- Does nothing if the file is missing or contains no CR.
--- @tparam string filename The filename (relative or absolute) to normalize.
--- @return boolean true if the file was rewritten.
local function normalize_eol(filename)
    local log = consul.new_log("macos:normalize_eol")
    local path = resolve_path(filename)
    log:trace("normalize: " .. filename .. " -> " .. path)
    -- 'r'/'w' are the same as 'rb'/'wb' on POSIX
    local f, err = io.open(path, 'r')
    if not f then
        log:trace("open for read failed: " .. tostring(err))
        return false
    end
    log:trace("opened for read")
    local content = f:read('*a')
    f:close()
    if not content then
        log:trace("read returned nil")
        return false
    end
    local _, cr_count = content:gsub('\r', '\r')
    log:trace("read " .. #content .. " bytes, " .. cr_count .. " CR")
    if cr_count == 0 then
        return false
    end
    local converted = content:gsub('\r\n?', '\n')
    f, err = io.open(path, 'w')
    if not f then
        log:trace("open for write failed: " .. tostring(err))
        return false
    end
    log:trace("opened for write")
    f:write(converted)
    f:close()
    log:trace("written " .. #converted .. " bytes (was " .. #content .. ")")
    return true
end

-- Module return
return {
    resolve_path = resolve_path,
    normalize_eol = normalize_eol,
}
