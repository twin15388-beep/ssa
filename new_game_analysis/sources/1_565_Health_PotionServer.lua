-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local Item = require(ServerStorage.SAM.Services.Removers.Item);
local v1 = {};
local u2 = {
    ["Health Potion"] = "HealthActivated",
    ["Health Elixir"] = "HealthActivated",
    ["Health Regen Potion"] = "HealthActivated",
    ["Health Regen Elixir"] = "HealthActivated",
    ["Stamina Regen Potion"] = "StaminaActivated",
    ["Stamina Regen Elixir"] = "StaminaActivated"
};
local u3 = {
    Default = 25,
    ["Health Elixir"] = 60
};
local u4 = {
    Default = 10,
    ["Health Regen Elixir"] = 20,
    ["Stamina Regen Elixir"] = 20,
    ["Underwater Breathing Potion"] = 120
};
local u5 = {
    Default = 3,
    ["Underwater Breathing Potion"] = 1
};
local u6 = {
    ["Health Regen Potion"] = "Health Regen Speed",
    ["Stamina Regen Potion"] = "Stamina Regen Speed",
    ["Health Regen Elixir"] = "Health Regen Speed",
    ["Stamina Regen Elixir"] = "Stamina Regen Speed",
    ["Underwater Breathing Potion"] = "Breath Duration Factor"
};

local function tune(p7: table, p8: string) -- Line: 62
    return p7[p8] or p7.Default;
end;

local function playPotionSound(p9: userdata, p10: string) -- Line: 70
    -- upvalues: DebrisModule (copy)
    local v11 = script:FindFirstChild(p10);

    if v11 == nil then
        return;
    end;

    local HumanoidRootPart = p9:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local v12 = v11:Clone();
    v12.Parent = HumanoidRootPart;
    v12:Play();
    DebrisModule:AddItem(v12, 0);
end;

local function giveReward(p13: userdata, p14: userdata, p15: string) -- Line: 83
    -- upvalues: u2 (copy), EffectsEvent (copy), u6 (copy), Utility (copy), PlayerStatResolver (copy), u4 (copy), u5 (copy), u3 (copy)
    local v16 = u2[p15];

    if v16 then
        EffectsEvent.ToAllInRange(p13.Character, "TickActivated", p13.Character, v16);
    end;

    local v17 = u6[p15];

    if v17 == nil then
        if p14.Health <= p14.MaxHealth then
            local v18 = u3;
            p14.Health = math.clamp(p14.Health + (v18[p15] or v18.Default), 0, p14.MaxHealth);
        end;

        return true;
    end;

    local valuesfolder = Utility.getvaluesfolder(p13);

    if valuesfolder == nil then
        return false;
    end;

    PlayerStatResolver.Invalidate(p13, v17);
    local v19 = u4;
    local v20 = u5;
    Utility.AddTimedValue(valuesfolder, v17, v19[p15] or v19.Default, "NumberValue", v20[p15] or v20.Default);

    return true;
end;

local function cancelCleanup(p21: userdata, p22: table) -- Line: 111
    local CapWeld = p21:FindFirstChild("CapWeld", true);

    if CapWeld ~= nil and (CapWeld.Parent and CapWeld.Parent:FindFirstChild("Cap")) then
        local HandWeld = CapWeld.Parent.Cap:FindFirstChild("HandWeld");

        if p22.IsLast then
            CapWeld.Parent.Cap.CanCollide = false;
        elseif HandWeld then
            HandWeld.Part0 = nil;
        end;

        CapWeld.Part1 = CapWeld.Parent.Cap;
    end;

    p22.Thread = nil;
end;

function v1.MouseDown(u23: userdata, u24: userdata, u25: table, u26: string) -- Line: 127
    -- upvalues: Checker (copy), Utility (copy), ManuelCancel (copy), cancelCleanup (copy), playPotionSound (copy), Item (copy), giveReward (copy), DebrisModule (copy)
    if not Checker.check(u23) then
        return;
    end;

    if u25.Thread ~= nil then
        return;
    end;

    local CapWeld = u24:FindFirstChild("CapWeld", true);

    if CapWeld == nil then
        return;
    end;

    local Parent = CapWeld.Parent;

    if Parent == nil then
        return;
    end;

    local Data = Utility.GetData(u23);

    if Data == nil then
        return;
    end;

    local v27 = Data.Inventory.Inventory:FindFirstChild(u26);

    if v27 == nil then
        return;
    end;

    u25.IsLast = v27:FindFirstChild("Amount") == nil and true or v27.Amount.Value <= 1;
    local v28, u29 = ManuelCancel.new(u23, 5);
    v28:Connect(function() -- Line: 145
        -- upvalues: u25 (copy), cancelCleanup (ref), u24 (copy)
        if u25.Thread then
            task.cancel(u25.Thread);
        end;

        cancelCleanup(u24, u25);
    end);
    u25.Thread = task.spawn(function() -- Line: 152
        -- upvalues: Checker (ref), u24 (copy), u29 (copy), CapWeld (copy), playPotionSound (ref), Parent (copy), u25 (copy), Item (ref), u23 (copy), u26 (copy), giveReward (ref), DebrisModule (ref)
        task.wait(0.3);

        if Checker.check_victim(script, u24, u24) == nil then
            u29();

            return;
        end;

        CapWeld.Part1 = nil;
        playPotionSound(u24, "PS2potionOPEN");
        local Cap = Parent:FindFirstChild("Cap");

        if u25.IsLast then
            if Cap then
                Cap.CanCollide = true;
            end;
        else
            local LeftHand = u24:FindFirstChild("LeftHand");

            if Cap then
                Cap = Cap:FindFirstChild("HandWeld");
            end;

            if LeftHand and Cap then
                Cap.Part0 = LeftHand;
            end;
        end;

        task.wait(0.9500000000000001);

        if Checker.check_victim(script, u24, u24) == nil then
            u29();

            return;
        end;

        playPotionSound(u24, "PS2potionDRINK");
        task.wait(0.19999999999999996);

        if Checker.check_victim(script, u24, u24) == nil then
            u29();

            return;
        end;

        task.wait(0.3999999999999999);

        if Checker.check_victim(script, u24, u24) == nil then
            u29();

            return;
        end;

        if not Item(u23, u26, nil, nil, "Consumed") then
            u29();

            return;
        end;

        local v30 = u24:FindFirstChildOfClass("Humanoid");

        if v30 == nil or v30.Health <= 0 then
            u29();

            return;
        end;

        if giveReward(u23, v30, u26) then
            playPotionSound(u24, "PS2potionADMINISTER");
        end;

        u29();
        u25.Thread = nil;

        if not u25.IsLast then
            task.wait(0.5);
            local Cap2 = Parent:FindFirstChild("Cap");

            if Cap2 then
                Cap2 = Cap2:FindFirstChild("HandWeld");
            end;

            if Cap2 then
                Cap2.Part0 = nil;
            end;

            if CapWeld.Parent and CapWeld.Parent:FindFirstChild("Cap") then
                CapWeld.Part1 = CapWeld.Parent.Cap;
            end;

            return;
        end;

        if not Parent.Parent then
            return;
        end;

        Parent.Parent = workspace.Debree;
        task.wait(0.5);

        if Checker.check_victim(script, u24, u24) == nil then
            return;
        end;

        local PrimaryPart = u24.PrimaryPart;

        if PrimaryPart == nil then
            return;
        end;

        local Weld = Parent:FindFirstChild("Weld");

        if Weld == nil then
            return;
        end;

        local Part1 = Weld.Part1;

        if Part1 == nil then
            return;
        end;

        local CFrame = PrimaryPart.CFrame;

        for _, child in ipairs(Parent:GetChildren()) do
            if child:IsA("BasePart") then
                child:SetNetworkOwner(u23);
            end;
        end;

        Weld:Destroy();
        playPotionSound(u24, "PS2potionTHROW");
        local Attachment = Instance.new("Attachment", Part1);
        local LinearVelocity = Instance.new("LinearVelocity", Attachment);
        LinearVelocity.Attachment0 = Attachment;
        LinearVelocity.VectorVelocity = CFrame.LookVector * -20 + CFrame.UpVector * 5;
        DebrisModule:AddItem(Parent, 2);
        task.wait(0.3);
        Attachment:Destroy();
        Part1.CanCollide = true;
    end);
end;

function v1.MouseUp(p31: userdata, p32: userdata, p33: table) -- Line: 263
    -- upvalues: cancelCleanup (copy)
    if p33.Thread then
        task.cancel(p33.Thread);
        cancelCleanup(p32, p33);
    end;
end;

return v1;