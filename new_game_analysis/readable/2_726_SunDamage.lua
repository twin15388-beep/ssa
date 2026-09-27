-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local Lighting = game:GetService("Lighting");
local SignalFunction = require(ReplicatedStorage:WaitForChild("Communication"):WaitForChild("ServerAndClient"):WaitForChild("Signals"):WaitForChild("SignalFunction"));
local Utility = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local MinigameSettings = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("MinigameSettings"));
local PlayerStatResolver = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerStatResolver"));
local v1 = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Worlds")).ById[game.PlaceId];

if v1 == nil or v1.SunDamage ~= true then
    return;
end;

local LocalPlayer = Players.LocalPlayer;
local Race = Utility.GetData(LocalPlayer, true):WaitForChild("Race");
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace:WaitForChild("Map"), workspace.Terrain };
local u2 = false;

local function setInSun(p3: boolean) -- Line: 74
    -- upvalues: u2 (ref), SignalFunction (copy)
    if p3 == u2 then
        return;
    end;

    local success, result = pcall(SignalFunction.ToServer, "SunDamage", p3);

    if success and result == true then
        u2 = p3;
    end;
end;

repeat
    while Race.Value ~= "Demon" do
        if u2 ~= false then
            local success, result = pcall(SignalFunction.ToServer, "SunDamage", false);

            if success and result == true then
                u2 = false;
            end;
        end;

        if u2 then
            task.wait(1);
        else
            Race.Changed:Wait();
        end;
    end;

    task.wait(1);
until Race.Value == "Demon";

if MinigameSettings.Get("NoSunDamage") == true then
    if u2 ~= false then
        local success, result = pcall(SignalFunction.ToServer, "SunDamage", false);

        if success and result == true then
            u2 = false;
        end;
    end;

    continue;
elseif LocalPlayer:GetAttribute("Situation") == "Sunless" or LocalPlayer:GetAttribute("SecondarySituation") == "Sunless" then
    if u2 ~= false then
        local success, result = pcall(SignalFunction.ToServer, "SunDamage", false);

        if success and result == true then
            u2 = false;
        end;
    end;

    continue;
else
    local v4 = false;
    local Character = LocalPlayer.Character;
    local v5;

    if Character == nil then
        v5 = nil;
    else
        v5 = Character:FindFirstChild("HumanoidRootPart") or nil;
    end;

    local v6;

    if Character == nil then
        v6 = nil;
    else
        v6 = Character:FindFirstChild("Head") or nil;
    end;

    local v7;

    if Character == nil then
        v7 = nil;
    else
        v7 = Character:FindFirstChildOfClass("Humanoid") or nil;
    end;

    if v5 ~= nil and (v7 ~= nil and (v7.Health > 0 and (Character:FindFirstChildOfClass("ForceField") == nil and PlayerStatResolver.GetStat(LocalPlayer, "Sun Immunity") ~= true))) then
        local SunDirection = Lighting:GetSunDirection();

        if SunDirection.Y > 0 then
            local v8 = workspace:Raycast((v6 or v5).Position, SunDirection * 20000, RaycastParams_new_ret) ~= nil;

            if v8 then
                for _, v in CollectionService:GetTagged("Damaging_Trees") do
                    if v:IsA("BasePart") and (v.Position - v5.Position).Magnitude <= 60 then
                        v8 = false;
                    end;
                end;
            end;

            v4 = not v8;
        end;
    end;

    if v4 ~= u2 then
        local success, result = pcall(SignalFunction.ToServer, "SunDamage", v4);

        if success and result == true then
            u2 = v4;
        end;
    end;

    continue;
end;