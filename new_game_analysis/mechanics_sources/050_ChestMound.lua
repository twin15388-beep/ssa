-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Color3_fromRGB_ret = Color3.fromRGB(56, 145, 255);
local LocalPlayer = Players.LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local u1 = {};

local function show(p2: table, p3: number) -- Line: 33
    p2.Alpha = p3;

    for _, v in p2.Fade do
        v.Transparency = 1 - p3;
    end;

    for _, v in p2.Lights do
        v.Enabled = p3 > 0;
    end;
end;

local function track(p4: userdata) -- Line: 43
    -- upvalues: Color3_fromRGB_ret (copy), u1 (copy)
    if not p4:IsA("BasePart") then
        return;
    end;

    p4.Color = Color3_fromRGB_ret;
    p4.Material = Enum.Material.Neon;
    local v5 = {
        Alpha = 0,
        Fade = { p4 },
        Lights = {}
    };

    for _, child in p4:GetChildren() do
        if child:IsA("Decal") or child:IsA("Texture") then
            table.insert(v5.Fade, child);
            child.Color3 = Color3_fromRGB_ret;
        elseif child:IsA("Light") then
            table.insert(v5.Lights, child);
            child.Color = Color3_fromRGB_ret;
        end;
    end;

    u1[p4] = v5;
    v5.Alpha = 0;

    for _, v in v5.Fade do
        v.Transparency = 1;
    end;

    for _, v in v5.Lights do
        v.Enabled = false;
    end;
end;

for _, v in CollectionService:GetTagged("IceveilFootprint") do
    track(v);
end;

CollectionService:GetInstanceAddedSignal("IceveilFootprint"):Connect(track);
CollectionService:GetInstanceRemovedSignal("IceveilFootprint"):Connect(function(p6) -- Line: 65
    -- upvalues: u1 (copy)
    u1[p6] = nil;
end);
local u7 = false;

local function refreshLit() -- Line: 71
    -- upvalues: u7 (ref), Character_info_provider (copy), LocalPlayer (copy)
    u7 = false;

    for _, v in Character_info_provider.getEquippedAccessoryStats(LocalPlayer) do
        if v == "Mushroom Lit Lantern" then
            u7 = true;

            return;
        end;
    end;
end;

local Stats = Data.Inventory.Accessories.Stats;

for _, child in Stats:GetChildren() do
    child.Changed:Connect(refreshLit);
end;

Stats.ChildAdded:Connect(function(p8) -- Line: 84
    -- upvalues: refreshLit (copy), u7 (ref), Character_info_provider (copy), LocalPlayer (copy)
    p8.Changed:Connect(refreshLit);
    u7 = false;

    for _, v in Character_info_provider.getEquippedAccessoryStats(LocalPlayer) do
        if v == "Mushroom Lit Lantern" then
            u7 = true;

            return;
        end;
    end;
end);
u7 = false;

for _, v in Character_info_provider.getEquippedAccessoryStats(LocalPlayer) do
    if v == "Mushroom Lit Lantern" then
        u7 = true;
        break;
    end;
end;

local u9 = nil;

local function onCharacter(p10: userdata) -- Line: 91
    -- upvalues: u9 (ref)
    u9 = p10:WaitForChild("HumanoidRootPart");
end;

LocalPlayer.CharacterAdded:Connect(onCharacter);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 95
    -- upvalues: u9 (ref)
    u9 = nil;
end);

if LocalPlayer.Character ~= nil then
    task.spawn(onCharacter, LocalPlayer.Character);
end;

local u11 = false;
RunService.Heartbeat:Connect(function(p12: number) -- Line: 103
    -- upvalues: u7 (ref), u9 (ref), u11 (ref), u1 (copy)
    local v13;

    if u7 and u9 ~= nil then
        v13 = u9.Position;
    else
        v13 = nil;
    end;

    if v13 == nil and not u11 then
        return;
    end;

    u11 = false;
    local v14 = math.min(p12, 0.1) / 0.6;

    for i, v in u1 do
        local v15 = 0;
        local v16, v17;

        if v13 == nil then
            if v.Alpha ~= 0 then
                v16 = v.Alpha + math.clamp(v15 - v.Alpha, -v14, v14);

                if v16 ~= v.Alpha then
                    v.Alpha = v16;
                    v17 = v;

                    for _, v2 in v.Fade do
                        v2.Transparency = 1 - v16;
                    end;

                    for _, v2 in v17.Lights do
                        v2.Enabled = v16 > 0;
                    end;
                end;

                if v16 > 0 then
                    u11 = true;
                end;
            end;
        else
            local v18 = i.Position - v13;
            local v19 = v18:Dot(v18);

            if v19 < 3600 then
                local v20 = (math.sqrt(v19) - 40) / 20;
                v15 = 1 - math.clamp(v20, 0, 1);
                v16 = v.Alpha + math.clamp(v15 - v.Alpha, -v14, v14);

                if v16 ~= v.Alpha then
                    v.Alpha = v16;
                    v17 = v;

                    for _, v2 in v.Fade do
                        v2.Transparency = 1 - v16;
                    end;

                    for _, v2 in v17.Lights do
                        v2.Enabled = v16 > 0;
                    end;
                end;

                if v16 > 0 then
                    u11 = true;
                end;
            end;

            if v.Alpha ~= 0 then
                v16 = v.Alpha + math.clamp(v15 - v.Alpha, -v14, v14);

                if v16 ~= v.Alpha then
                    v.Alpha = v16;
                    v17 = v;

                    for _, v2 in v.Fade do
                        v2.Transparency = 1 - v16;
                    end;

                    for _, v2 in v17.Lights do
                        v2.Enabled = v16 > 0;
                    end;
                end;

                if v16 > 0 then
                    u11 = true;
                end;
            end;
        end;
    end;
end);