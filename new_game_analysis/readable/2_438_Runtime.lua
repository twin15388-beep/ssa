-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;
local u6 = {};

local function c(p7: userdata) -- Line: 11
    -- upvalues: u6 (copy)
    table.insert(u6, p7);
end;

local function cleanup() -- Line: 15
    -- upvalues: u6 (copy)
    for _, v in u6 do
        v:Disconnect();
    end;
end;

local u8 = nil;
u8 = script_Parent:BindToMessage("Setup", function(p9, p10, p11) -- Line: 22
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u8 (ref)
    u1 = p9;
    u2 = p10;
    u3 = p11;
    u4 = require(p11);
    u5 = true;
    u8:Disconnect();
end);

repeat
    task.wait();
until u5;

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u12 = u4.new();
local Dependencies = u3.Dependencies;
require(Dependencies.Debug.DebugUi);
require(Dependencies.Config);
local Utilities = require(Dependencies.Utilities);
local OverlayEvent = u3:WaitForChild("OverlayEvent");
local _ = {
    Begin = function(...) -- Line: 52, Name: Begin
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Begin", ...);
    end,

    End = function(...) -- Line: 55, Name: End
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("End", ...);
    end,

    Text = function(...) -- Line: 58, Name: Text
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Text", ...);
    end
};
shared.FrameCounter = 0;
script_Parent.Name = `{u1.Name} - {u12.ID}`;
u12:LoadObject(u1);
local u13 = false;

for _, v in u2 do
    u12:LoadRawCollider(v[1], v[2]);
end;

local v15 = CollectionService:GetInstanceAddedSignal("SmartCollider"):Connect(function(p14: userdata) -- Line: 111
    -- upvalues: u1 (ref), Utilities (copy), u12 (copy)
    if not p14:IsA("BasePart") then
        return;
    end;

    local Attribute = p14:GetAttribute("ColliderKey");
    local Attribute2 = u1:GetAttribute("ColliderKey");

    if tostring(Attribute) ~= tostring(Attribute2) then
        return;
    end;

    u12:LoadRawCollider(Utilities.GetCollider(p14), p14);
end);
table.insert(u6, v15);
local v16 = script_Parent:BindToMessage("Destroy", function() -- Line: 128
    -- upvalues: u13 (ref)
    u13 = true;
end);
table.insert(u6, v16);
local v19 = RunService.Heartbeat:ConnectParallel(function(p17) -- Line: 132
    -- upvalues: u12 (copy), u13 (ref), u6 (copy), script_Parent (copy)
    local v18 = shared;
    v18.FrameCounter = v18.FrameCounter + 1;

    if shared.FrameCounter > 131072 then
        shared.FrameCounter = 0;
    end;

    u12:StepBoneTrees(p17);

    if not (u12.ShouldDestroy or u13) then
        return;
    end;

    u12:Destroy();
    task.synchronize();

    for _, v in u6 do
        v:Disconnect();
    end;

    script_Parent:Destroy();
end);
table.insert(u6, v19);