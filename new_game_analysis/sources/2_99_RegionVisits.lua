-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AreaLocator = require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

local function report(p1: string, p2: string?) -- Line: 25
    -- upvalues: SignalEvent (copy)
    if p1 ~= nil and p1 ~= "" then
        SignalEvent.ToServer("VisitRegion", p1);
    end;

    if p2 ~= nil and (p2 ~= "" and p2 ~= p1) then
        SignalEvent.ToServer("VisitRegion", p2);
    end;
end;

AreaLocator.AreaEquipped.Update:Connect(function(p3: string, p4: string) -- Line: 36
    -- upvalues: SignalEvent (copy)
    if p3 ~= nil and p3 ~= "" then
        SignalEvent.ToServer("VisitRegion", p3);
    end;

    if p4 ~= nil and (p4 ~= "" and p4 ~= p3) then
        SignalEvent.ToServer("VisitRegion", p4);
    end;
end);
local Parent = AreaLocator.AreaEquipped.Parent;
local Sub = AreaLocator.AreaEquipped.Sub;

if Parent ~= nil and Parent ~= "" then
    SignalEvent.ToServer("VisitRegion", Parent);
end;

if Sub ~= nil and (Sub ~= "" and Sub ~= Parent) then
    SignalEvent.ToServer("VisitRegion", Sub);
end;

Players.LocalPlayer.CharacterAdded:Connect(function(p5: userdata) -- Line: 42
    -- upvalues: AreaLocator (copy), SignalEvent (copy)
    p5:WaitForChild("HumanoidRootPart");
    local Parent2 = AreaLocator.AreaEquipped.Parent;
    local Sub2 = AreaLocator.AreaEquipped.Sub;

    if Parent2 ~= nil and Parent2 ~= "" then
        SignalEvent.ToServer("VisitRegion", Parent2);
    end;

    if Sub2 ~= nil and (Sub2 ~= "" and Sub2 ~= Parent2) then
        SignalEvent.ToServer("VisitRegion", Sub2);
    end;
end);