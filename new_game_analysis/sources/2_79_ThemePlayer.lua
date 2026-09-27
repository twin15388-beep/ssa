-- Decompiled with Potassium's decompiler.

if ({
    [17047024836] = true
})[game.PlaceId] then
    return;
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ThemePlaylist = require(ReplicatedStorage.CAM.Client.Controllers.ThemePlaylist);
local AreaLocator = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaLocator");
local v1 = require(AreaLocator);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local u2 = false;
local u3 = nil;

local function Tracks(p4: userdata?) -- Line: 16
    local v5 = {};

    if p4 == nil then
        return v5;
    end;

    for _, child in ipairs(p4:GetChildren()) do
        if child:IsA("Sound") then
            table.insert(v5, child);
        end;
    end;

    return v5;
end;

function update(p6: string, p7: string)
    -- upvalues: u2 (ref), AreaLocator (copy), Tracks (copy), u3 (ref), ThemePlaylist (copy)
    local v8 = nil;
    local v9 = nil;
    local v10;

    if u2 then
        v10 = AreaLocator.SoundTracks.DefaultCombatThemes;
        v9 = Tracks(v10);
    else
        v10 = AreaLocator.SoundTracks:FindFirstChild(p6);

        if v10 then
            if p7 ~= p6 then
                v8 = v10:FindFirstChild(p7);

                if v8 ~= nil and v8:IsA("Sound") then
                    v8 = nil;
                end;

                v9 = Tracks(v8);
            end;

            if v8 == nil or #v9 == 0 then
                local v11 = v10:FindFirstChild(p6);

                if v11 ~= nil and not v11:IsA("Sound") then
                    v10 = v11;
                end;

                v9 = Tracks(v10);
            else
                v10 = v8;
            end;
        else
            v10 = v8;
        end;

        if v10 == nil or #v9 == 0 then
            v10 = AreaLocator.SoundTracks.DefaultTracks;
            v9 = Tracks(v10);
        end;
    end;

    if u3 ~= v10 then
        ThemePlaylist.SetPlaylist(v9);
        u3 = v10;
    end;
end;

update(v1.AreaEquipped.Parent, v1.AreaEquipped.Sub);
v1.AreaEquipped.Update:Connect(update);
local LocalPlayer = game.Players.LocalPlayer;

while true do
    while LocalPlayer.Character ~= nil do
        local v12 = InCombat.RegularIncludeAI(LocalPlayer.Character);

        if v12 ~= u2 then
            u2 = v12;
            update(v1.AreaEquipped.Parent, v1.AreaEquipped.Sub);
        end;

        task.wait(0.5);
    end;

    task.wait(2);
end;