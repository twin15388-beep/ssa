-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local DungeonQuestCredit = require(ServerStorage.SAM.Utility.DungeonQuestCredit);
local u1 = { "Double Jump", "Wall Climb" };

local function getSwitchsFolder() -- Line: 12
    local ParkourTraining = workspace.Map.DetachedMaps:FindFirstChild("ParkourTraining");

    if ParkourTraining then
        ParkourTraining = ParkourTraining:FindFirstChild("Switchs");
    end;

    if ParkourTraining and ParkourTraining:IsA("Folder") then
        return ParkourTraining;
    end;

    return nil;
end;

return {
    PromptsEnabled = false,

    Do = function(p2: userdata, p3: userdata, p4: table, p5: userdata) -- Line: 19, Name: Do
        -- upvalues: Character_info_provider (copy), u1 (copy)
        local v6, _ = Character_info_provider.HasUnlockedSkills(p2, u1);

        if not v6 then
            return;
        end;

        local ParkourTraining = workspace.Map.DetachedMaps:FindFirstChild("ParkourTraining");

        if ParkourTraining ~= nil then
            local v7 = Vector3.new(1, 1, 1) * (1 / 0);
            local v8 = Vector3.new(1, 1, 1) * (-1 / 0);

            for _, v in ParkourTraining:QueryDescendants("BasePart") do
                v7 = v7:Min(v.Position);
                v8 = v8:Max(v.Position);
            end;

            p5:SetAttribute("LeashCenter", (v7 + v8) / 2);
            p5:SetAttribute("LeashRadius", (v8 - v7).Magnitude / 2 + 100);

            return true;
        end;
    end,

    StateChanged = function(p9: userdata, p10: userdata, p11: table, p12: userdata?) -- Line: 38, Name: StateChanged
        if typeof(p12) ~= "Instance" or not p12:IsA("Model") then
            return;
        end;

        local ParkourTraining = workspace.Map.DetachedMaps:FindFirstChild("ParkourTraining");

        if ParkourTraining then
            ParkourTraining = ParkourTraining:FindFirstChild("Switchs");
        end;

        if not (ParkourTraining and ParkourTraining:IsA("Folder")) then
            ParkourTraining = nil;
        end;

        if ParkourTraining == nil or not p12:IsDescendantOf(ParkourTraining) then
            return;
        end;

        if p10 then
            p10 = p10.PrimaryPart;
        end;

        if p10 == nil then
            return;
        end;

        if (p10.Position - p12:GetPivot().Position).Magnitude > 20 then
            return;
        end;

        p11.PulledSwitches = p11.PulledSwitches or {};
        p11.PulledSwitches[p12] = true;
    end,

    Stop = function(p13: userdata, p14: userdata, p15: table) -- Line: 52, Name: Stop
        -- upvalues: DungeonQuestCredit (copy)
        local v16 = false;

        if p14 ~= nil then
            local PrimaryPart = p14.PrimaryPart;

            if PrimaryPart ~= nil then
                local Final = workspace.Map.DetachedMaps.ParkourTraining:FindFirstChild("Final");
                v16 = Final ~= nil and vector.magnitude(PrimaryPart.Position - Final.Position) <= 75 and true or v16;
            end;
        end;

        local v17 = false;
        local ParkourTraining = workspace.Map.DetachedMaps:FindFirstChild("ParkourTraining");

        if ParkourTraining then
            ParkourTraining = ParkourTraining:FindFirstChild("Switchs");
        end;

        if not (ParkourTraining and ParkourTraining:IsA("Folder")) then
            ParkourTraining = nil;
        end;

        if ParkourTraining ~= nil then
            local v18 = #ParkourTraining:GetChildren();
            local v19 = 0;

            if p15.PulledSwitches then
                for _ in p15.PulledSwitches do
                    v19 = v19 + 1;
                end;
            end;

            if v18 > 0 then
                v17 = v18 <= v19;
            else
                v17 = false;
            end;
        end;

        if v16 and v17 then
            DungeonQuestCredit(p13, "Parkour Dungeon", "Complete");
            local v20 = tonumber(p13:GetAttribute("Hearts")) or 0;
            local v21 = tonumber(p13:GetAttribute("MaxHearts")) or 0;

            if v20 > 0 and v20 < v21 then
                p13:SetAttribute("Hearts", v20 + 1);
            end;
        end;

        return true, v16 and v17;
    end
};