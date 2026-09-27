-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local BarKeepup = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Minigames.BarKeepup);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local faye = require(ReplicatedStorage.Packages.faye);
local LocalPlayer = Players.LocalPlayer;
local v1 = {};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.BruteForceAllSlow = true;
RaycastParams_new_ret.FilterDescendantsInstances = {};

local function refreshWaterParams() -- Line: 34
    -- upvalues: CollectionService (copy), RaycastParams_new_ret (copy)
    local v2 = {};

    for _, v in CollectionService:GetTagged("SwimParts") do
        table.insert(v2, v.Parent or v);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v2;

    return #v2 > 0;
end;

v1.MouseParams = RaycastParams_new_ret;
local u3 = false;

function v1.check(p4: userdata, p5: string) -- Line: 52
    -- upvalues: u3 (ref), Checker (copy), LocalPlayer (copy)
    return u3 and true or (Checker.check(LocalPlayer) and true or false);
end;

local u6 = nil;
local u7 = nil;

local function closeBite() -- Line: 80
    -- upvalues: u7 (ref), LocalPlayer (copy)
    local v8 = u7;
    u7 = nil;

    if v8 ~= nil then
        v8:Destroy();
    end;

    LocalPlayer:SetAttribute("FishingBite", nil);
end;

local function onBite(u9, u10) -- Line: 89
    -- upvalues: u7 (ref), LocalPlayer (copy), faye (copy), closeBite (copy), BarKeepup (copy)
    local v11 = u7;
    u7 = nil;

    if v11 ~= nil then
        v11:Destroy();
    end;

    LocalPlayer:SetAttribute("FishingBite", nil);
    local v12 = faye.new();
    u7 = v12;
    LocalPlayer:SetAttribute("FishingBite", true);
    local u13 = false;

    local function report(p14: boolean) -- Line: 95
        -- upvalues: u13 (ref), u9 (copy), u10 (copy), closeBite (ref)
        if u13 then
            return;
        end;

        u13 = true;

        if u9.__Active then
            u9:Server(u10, p14 == true);
        end;

        task.defer(closeBite);
    end;

    BarKeepup(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Misc"), {
        Thread = v12,
        Stop = report
    });
end;

local function establishBiteLink() -- Line: 124
    -- upvalues: u6 (ref), ServerClientPortal (copy), u7 (ref), LocalPlayer (copy), u3 (ref), establishBiteLink (copy), onBite (copy)
    if u6 ~= nil and u6.__Active then
        u6:Destroy();
    end;

    local u15 = ServerClientPortal.Link("FishingRod", -1);
    u6 = u15;
    u15:OnDestroyed(function() -- Line: 130
        -- upvalues: u6 (ref), u15 (copy), u7 (ref), LocalPlayer (ref), u3 (ref), establishBiteLink (ref)
        if u6 == u15 then
            u6 = nil;
        end;

        local v16 = u7;
        u7 = nil;

        if v16 ~= nil then
            v16:Destroy();
        end;

        LocalPlayer:SetAttribute("FishingBite", nil);

        if u3 then
            establishBiteLink();
        end;
    end);
    u15:Connect(function(p17, p18) -- Line: 139
        -- upvalues: onBite (ref), u15 (copy), u7 (ref), LocalPlayer (ref)
        if p17 == "Bite" then
            onBite(u15, p18);

            return;
        end;

        if p17 == "BiteCancel" then
            local v19 = u7;
            u7 = nil;

            if v19 ~= nil then
                v19:Destroy();
            end;

            LocalPlayer:SetAttribute("FishingBite", nil);
        end;
    end);
end;

function v1.Equipped(p20: userdata, p21: string) -- Line: 148
    -- upvalues: u3 (ref), refreshWaterParams (copy), establishBiteLink (copy)
    u3 = true;
    refreshWaterParams();
    establishBiteLink();
end;

function v1.UnEquipped(p22: userdata?, p23: string?) -- Line: 154
    -- upvalues: u3 (ref), u6 (ref), u7 (ref), LocalPlayer (copy)
    u3 = false;
    local v24 = u6;
    u6 = nil;

    if v24 ~= nil and v24.__Active then
        v24:Destroy();
    end;

    local v25 = u7;
    u7 = nil;

    if v25 ~= nil then
        v25:Destroy();
    end;

    LocalPlayer:SetAttribute("FishingBite", nil);
end;

return v1;