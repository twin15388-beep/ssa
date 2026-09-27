-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game.Players.LocalPlayer;
local u1 = { "Map", "DetachedMaps", "ParkourTraining" };
local u2 = nil;

local function strippedNow() -- Line: 71
    -- upvalues: LocalPlayer (copy), Platform_Handler (copy)
    local Attribute = LocalPlayer:GetAttribute("Device");

    if Attribute == nil then
        return Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad() == true;
    end;

    return (Attribute == "Mobile" or Attribute == "Xbox") and true or Attribute == "Playstation";
end;

local function stripped() -- Line: 81
    -- upvalues: u2 (ref), LocalPlayer (copy), Platform_Handler (copy)
    if u2 ~= nil then
        return u2;
    end;

    local Attribute = LocalPlayer:GetAttribute("Device");
    local v3;

    if Attribute == nil then
        v3 = Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad() == true;
    else
        if Attribute ~= "Mobile" and Attribute ~= "Xbox" then
            return Attribute == "Playstation";
        end;

        v3 = true;
    end;

    return v3;
end;

local function remembered(p4: userdata) -- Line: 97
    return p4:GetAttribute("HazardCanTouch") ~= nil;
end;

local function remember(p5: userdata) -- Line: 101
    if p5:GetAttribute("HazardCanTouch") ~= nil then
        return;
    end;

    p5:SetAttribute("HazardTransparency", p5.Transparency);
    p5:SetAttribute("HazardCanCollide", p5.CanCollide);
    p5:SetAttribute("HazardCanTouch", p5.CanTouch);
end;

local function forget(p6: userdata) -- Line: 108
    p6:SetAttribute("HazardTransparency", nil);
    p6:SetAttribute("HazardCanCollide", nil);
    p6:SetAttribute("HazardCanTouch", nil);
end;

local function armBrick(p7: userdata, p8: boolean) -- Line: 115
    if not p8 then
        if p7:GetAttribute("HazardCanTouch") == nil then
            p7:SetAttribute("HazardTransparency", p7.Transparency);
            p7:SetAttribute("HazardCanCollide", p7.CanCollide);
            p7:SetAttribute("HazardCanTouch", p7.CanTouch);
        end;

        p7.CanTouch = false;

        return;
    end;

    if p7:GetAttribute("HazardCanTouch") == nil then
        return;
    end;

    p7.CanTouch = p7:GetAttribute("HazardCanTouch");
    p7:SetAttribute("HazardTransparency", nil);
    p7:SetAttribute("HazardCanCollide", nil);
    p7:SetAttribute("HazardCanTouch", nil);
end;

local function showSpike(p9: userdata, p10: boolean) -- Line: 127
    if not p10 then
        if p9:GetAttribute("HazardCanTouch") == nil then
            p9:SetAttribute("HazardTransparency", p9.Transparency);
            p9:SetAttribute("HazardCanCollide", p9.CanCollide);
            p9:SetAttribute("HazardCanTouch", p9.CanTouch);
        end;

        p9.Transparency = 1;
        p9.CanCollide = false;
        p9.CanTouch = false;

        return;
    end;

    if p9:GetAttribute("HazardCanTouch") == nil then
        return;
    end;

    p9.Transparency = p9:GetAttribute("HazardTransparency");
    p9.CanCollide = p9:GetAttribute("HazardCanCollide");
    p9.CanTouch = p9:GetAttribute("HazardCanTouch");
    p9:SetAttribute("HazardTransparency", nil);
    p9:SetAttribute("HazardCanCollide", nil);
    p9:SetAttribute("HazardCanTouch", nil);
end;

local function apply(p11: string, p12: userdata) -- Line: 145
    -- upvalues: u2 (ref), LocalPlayer (copy), Platform_Handler (copy), armBrick (copy), showSpike (copy)
    if p12:GetAttribute("Ignore") == true then
        return;
    end;

    local v13;

    if u2 == nil then
        local Attribute = LocalPlayer:GetAttribute("Device");

        if Attribute == nil then
            v13 = Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad() == true;
        else
            v13 = (Attribute == "Mobile" or Attribute == "Xbox") and true or Attribute == "Playstation";
        end;
    else
        v13 = u2;
    end;

    local v14 = not v13;
    local v15;

    if p11 == "KillBricks" then
        v15 = armBrick;
    else
        v15 = showSpike;
    end;

    if p12:IsA("BasePart") then
        v15(p12, v14);
    end;

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("BasePart") then
            v15(descendant, v14);
        end;
    end;
end;

local function hazardOf(p16: userdata, p17: userdata) -- Line: 160
    while p17 ~= nil and p17.Parent ~= p16 do
        p17 = p17.Parent;
    end;

    return p17;
end;

local u18 = {};

local function sweepAll() -- Line: 171
    -- upvalues: u18 (copy), apply (copy)
    for i, v in u18 do
        local v19 = i;

        for _, child in v:GetChildren() do
            apply(v19, child);
        end;
    end;
end;

local function findMap() -- Line: 179
    -- upvalues: u1 (copy)
    local v20 = workspace;

    for _, v in u1 do
        v20 = v20:WaitForChild(v, 30);

        if v20 == nil then
            return nil;
        end;
    end;

    return v20;
end;

local function watch(p21: userdata, u22: string) -- Line: 189
    -- upvalues: u18 (copy), apply (copy)
    if u18[u22] ~= nil then
        return;
    end;

    local u23 = p21:WaitForChild(u22, 30);

    if u23 == nil then
        return;
    end;

    u18[u22] = u23;
    u23.DescendantAdded:Connect(function(p24: userdata) -- Line: 197
        -- upvalues: u23 (copy), apply (ref), u22 (copy)
        while p24 ~= nil and p24.Parent ~= u23 do
            p24 = p24.Parent;
        end;

        if p24 ~= nil then
            apply(u22, p24);
        end;
    end);

    for _, child in u23:GetChildren() do
        apply(u22, child);
    end;
end;

local function ready() -- Line: 211
    -- upvalues: u18 (copy)
    local v25;

    if u18.KillBricks == nil then
        v25 = false;
    else
        v25 = u18.Spikes ~= nil;
    end;

    return v25;
end;

local u26 = false;
task.spawn(function() -- Line: 216, Name: setup
    -- upvalues: u18 (copy), u26 (ref), findMap (copy), watch (copy)
    local v27;

    if u18.KillBricks == nil then
        v27 = false;
    else
        v27 = u18.Spikes ~= nil;
    end;

    if v27 or u26 then
        return;
    end;

    u26 = true;
    local v28 = findMap();

    if v28 ~= nil then
        watch(v28, "KillBricks");
        watch(v28, "Spikes");
    end;

    u26 = false;
end);
Platform_Handler.Platform.Changed.Event:Connect(sweepAll);
LocalPlayer:GetAttributeChangedSignal("Device"):Connect(sweepAll);
local valuesfolder = Utility.getvaluesfolder(LocalPlayer, true);
local u29 = nil;
valuesfolder.ChildAdded:Connect(function(u30: userdata) -- Line: 240
    -- upvalues: u29 (ref), u2 (ref), LocalPlayer (copy), Platform_Handler (copy), u18 (copy), u26 (ref), findMap (copy), watch (copy), sweepAll (copy)
    if u30.Name ~= "Training" or u30:GetAttribute("Type") ~= "Parkour Dungeon" then
        return;
    end;

    u29 = u30;
    local Attribute = LocalPlayer:GetAttribute("Device");
    local v31;

    if Attribute == nil then
        v31 = Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad() == true;
    else
        v31 = (Attribute == "Mobile" or Attribute == "Xbox") and true or Attribute == "Playstation";
    end;

    u2 = v31;
    task.spawn(function() -- Line: 245
        -- upvalues: u18 (ref), u26 (ref), findMap (ref), watch (ref), u29 (ref), u30 (copy), sweepAll (ref)
        local v32;

        if u18.KillBricks == nil then
            v32 = false;
        else
            v32 = u18.Spikes ~= nil;
        end;

        if not (v32 or u26) then
            u26 = true;
            local v33 = findMap();

            if v33 ~= nil then
                watch(v33, "KillBricks");
                watch(v33, "Spikes");
            end;

            u26 = false;
        end;

        if u29 ~= u30 then
            return;
        end;

        sweepAll();
    end);
end);
valuesfolder.ChildRemoved:Connect(function(p34: userdata) -- Line: 252
    -- upvalues: u29 (ref), u2 (ref), sweepAll (copy)
    if p34 ~= u29 then
        return;
    end;

    u29 = nil;
    u2 = nil;
    sweepAll();
end);