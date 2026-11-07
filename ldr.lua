local BASE = "https://raw.githubusercontent.com/h-anima/other/main/Games/"
local GAMES = {
    [7633926880]      = "7633926880.luau",
    [114234929420007] = "114234929420007.luau",
}
local key   = GAMES[game.PlaceId] or GAMES[game.GameId]
local label = string.format("Place %d", game.PlaceId)
if not key then
    warn("[XENOX] No script registered for " .. label)
    warn("[XENOX] This game isn't in the GAMES table yet.")
    return
end
local url = BASE .. key
local ok, src = pcall(game.HttpGet, game, url)
if not ok or type(src) ~= "string" or #src == 0 then
    warn("[XENOX] Failed to download " .. key)
    return
end
if #src < 500 and src:lower():find("<!doctype", 1, true) then
    warn("[XENOX] " .. key .. " returned HTML — check the BASE URL is correct.")
    return
end
local fn, err = loadstring(src)
if not fn then
    warn("[XENOX] Compile error in " .. key .. ": " .. tostring(err))
    return
end
local ran, runErr = pcall(fn)
if not ran then
    warn("[XENOX] Runtime error in " .. key .. ": " .. tostring(runErr))
end
