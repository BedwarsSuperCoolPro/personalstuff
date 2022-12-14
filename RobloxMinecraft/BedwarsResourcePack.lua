repeat task.wait() until game:IsLoaded()
syn.queue_on_teleport("loadstring(game:HttpGet(\"https://raw.githubusercontent.com/BedwarsSuperCoolPro/personalstuff/main/RobloxMinecraft/BedwarsResourcePack.lua\"))()")
if game.GameId ~= 2619619496 or game.PlaceId == 6872265039 then
    return 
end
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local repstorage = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local bedwars = {
    ["soundslist"] = require(repstorage.TS.sound["game-sound"]).GameSound,
    ["footstepsounds"] = require(repstorage.TS.sound["footstep-sounds"]),
    ["items"] = debug.getupvalue(require(repstorage.TS.item["item-meta"]).getItemMeta, 1)
}

local betterisfile = function(path)
    local succ, err = pcall(function()
        return readfile(path)
    end)
    return succ and err ~= nil 
end

local function getassetfunc(path)
    if not betterisfile(path) then
        task.spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = "Downloading file "..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0.3 
            textlabel.TextSize = 30
            textlabel.Font = Enum.Font.SourceSans
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = game:GetService("CoreGui").RobloxGui 
            repeat task.wait() until betterisfile(path)
            textlabel:Remove()
        end)
        local req = syn.request({
            Url = "https://raw.githubusercontent.com/BedwarsSuperCoolPro/personalstuff/main/RobloxMinecraft/"..path,
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    return getsynasset(path)
end

local function downloadassets(path2)
    local json = syn.request({
        Url = "https://api.github.com/repos/BedwarsSuperCoolPro/personalstuff/contents/RobloxMinecraft/"..path2,
        Method = "GET"
    })
    local decodedjson = http:JSONDecode(json.Body)
    for i2,v2 in pairs(decodedjson) do
        if v2["type"] == "file" then
            getassetfunc(path2.."/"..v2["name"])
        end
    end
end

if isfolder("bedwars") == false then
	makefolder("bedwars")
end
downloadassets("bedwars")
if isfolder("bedwars/sounds") == false then
	makefolder("bedwars/sounds")
end
downloadassets("bedwars/sounds")
if isfolder("bedwars/sounds/footstep") == false then
	makefolder("bedwars/sounds/footstep")
end
downloadassets("bedwars/sounds/footstep")

for i,v in pairs(bedwars["footstepsounds"]["FootstepSounds"]) do
    if betterisfile("bedwars/sounds/footstep/"..tostring(i).."-1.mp3") then
        v["walk"][1] = getassetfunc("bedwars/sounds/footstep/"..tostring(i).."-1.mp3")
        v["walk"][2] = getassetfunc("bedwars/sounds/footstep/"..tostring(i).."-2.mp3")
        v["run"][1] = getassetfunc("bedwars/sounds/footstep/"..tostring(i).."-3.mp3")
        v["run"][2] = getassetfunc("bedwars/sounds/footstep/"..tostring(i).."-4.mp3")
    end
end
bedwars["footstepsounds"]["BlockFootstepSound"][4] = "WOOL"
bedwars["footstepsounds"]["BlockFootstepSound"]["WOOL"] = 4
bedwars["footstepsounds"]["FootstepSounds"][4] = {
    ["walk"] = {getassetfunc("bedwars/sounds/footstep/4-1.mp3"), getassetfunc("bedwars/sounds/footstep/4-2.mp3")},
    ["run"] = {getassetfunc("bedwars/sounds/footstep/4-3.mp3"), getassetfunc("bedwars/sounds/footstep/4-4.mp3")}
}
for i,v in pairs(bedwars["items"]) do
    if tostring(i):match("wool") then
        v.footstepSound = bedwars["footstepsounds"]["BlockFootstepSound"]["WOOL"]
    end
end
for i,v in pairs(listfiles("bedwars/sounds")) do
    local str = tostring(tostring(v):gsub('bedwars/sounds\\', ""):gsub(".mp3", ""))
    local item = bedwars["soundslist"][str]
    if item then
        bedwars["soundslist"][str] = getassetfunc(v)
    end
end 
