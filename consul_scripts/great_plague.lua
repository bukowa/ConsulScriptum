consul.console.clear()
local envx = debug.getfenv(debug.getregistry()[2])
local aX, aY = envx["CampaignUI"]:GetCameraPosition()
local cui = envx["CampaignUI"]

for i = 1, 10000 do
    local offsetX = math.random(-100, 100)
    local offsetY = math.random(-100, 100)
    local markerName = "T" .. i .. "_MOVE"
    consul._game():add_marker(markerName, "settlement_disease", aX + offsetX, aY + offsetY, 2)
end