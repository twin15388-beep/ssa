-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Archives = require(ReplicatedStorage.CAM.Client.Modules.Archives);
local WorldBosses = require(ReplicatedStorage.CAM.Client.Modules.WorldBosses);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local CenterNotification = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("Notifications"):WaitForChild("CenterNotification");
local RegionIcon = BunchaIcons.RegionIcon;

local function toast(p1: string, p2: string?) -- Line: 31
    -- upvalues: CenterNotification (copy)
    CenterNotification:Fire("NewItem", {
        Amount = 1,
        IsNew = true,
        Name = p1,
        Icon = p2
    });
end;

Archives.Connect("Bosses", function(p3: table) -- Line: 41
    -- upvalues: WorldBosses (copy), CenterNotification (copy)
    if #p3 ~= 1 then
        return;
    end;

    local v4 = WorldBosses.ByCode(p3[1]);

    if v4 == nil then
        return;
    end;

    CenterNotification:Fire("NewItem", {
        Amount = 1,
        IsNew = true,
        Name = v4.Name,
        Icon = v4.Icon
    });
end);
Archives.Connect("Regions", function(p5: table) -- Line: 49
    -- upvalues: RegionIcon (copy), CenterNotification (copy)
    if #p5 ~= 1 then
        return;
    end;

    CenterNotification:Fire("NewItem", {
        Amount = 1,
        IsNew = true,
        Name = p5[1],
        Icon = RegionIcon
    });
end);