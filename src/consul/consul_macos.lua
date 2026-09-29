-- macOS only: path resolution for the Feral ports. Only loaded when
-- consul_os is "MACOS" (see consul.io_resolve_path).
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

-- Module return
return {
    resolve_path = resolve_path,
}
