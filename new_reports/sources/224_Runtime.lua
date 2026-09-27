-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local u1 = nil;
local u2 = {};

local function c(p3: userdata) -- Line: 6
    -- upvalues: u2 (copy)
    table.insert(u2, p3);
end;

local function cleanup() -- Line: 10
    -- upvalues: u2 (copy)
    for _, v in u2 do
        v:Disconnect();
    end;
end;

local u4 = {};
local u5 = {};
local v9 = script_Parent:BindToMessage("Setup", function(p6, p7, p8) -- Line: 21
    -- upvalues: u1 (ref), u4 (copy)
    u1 = p8;
    table.insert(u4, { p6, p7 });
end);
table.insert(u2, v9);
local v11 = script_Parent:BindToMessage("Free", function(p10) -- Line: 27
    -- upvalues: u5 (copy)
    table.insert(u5, p10);
end);
table.insert(u2, v11);

repeat
    task.wait();
until u1;

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local u12 = require(u1);
local Dependencies = u1.Dependencies;
local DebugUi = require(Dependencies.Debug.DebugUi);
local u13 = nil;
local Config = require(u1.Config);
local Utilities = require(Dependencies.Utilities);
local u14 = RunService:IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG;
local OverlayEvent = u1:WaitForChild("OverlayEvent");
local u15 = false;
local u16 = {};
local u17 = {};
local u18 = {
    Begin = function(...) -- Line: 53, Name: Begin
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Begin", ...);
    end,

    End = function(...) -- Line: 56, Name: End
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("End", ...);
    end,

    Text = function(...) -- Line: 59, Name: Text
        -- upvalues: OverlayEvent (copy)
        OverlayEvent:Fire("Text", ...);
    end
};
shared.FrameCounter = 0;

if u14 then
    u13 = require(Dependencies.Iris);

    if not u13.HasInit() then
        u13 = u13.Init();
    end;
end;

local u19;

if u14 then
    u19 = {
        DRAW_BONE = u13.State(false),
        DRAW_PHYSICAL_BONE = u13.State(false),
        DRAW_ROOT_PART = u13.State(false),
        DRAW_BOUNDING_BOX = u13.State(false),
        DRAW_AXIS_LIMITS = u13.State(false),
        DRAW_COLLIDERS = u13.State(false),
        DRAW_COLLIDER_INFLUENCE = u13.State(false),
        DRAW_COLLIDER_AWAKE = u13.State(false),
        DRAW_COLLIDER_BROADPHASE = u13.State(false),
        DRAW_FILL_COLLIDERS = u13.State(false),
        DRAW_CONTACTS = u13.State(false),
        DRAW_ROTATION_LIMITS = u13.State(false),
        DRAW_ACCELERATION_INFO = u13.State(false)
    };
    u13:Connect(function() -- Line: 94
        -- upvalues: u16 (copy), DebugUi (copy), u13 (ref), u19 (ref)
        for _, v in u16 do
            if v.Object:GetAttribute("Debug") ~= nil then
                DebugUi(u13, v.Physics, u19);
            end;
        end;
    end);
else
    u19 = nil;
end;

local function AddRoot(p20: userdata, p21: any) -- Line: 103
    -- upvalues: u12 (copy), u16 (copy), u17 (copy)
    local v22 = u12.new();
    v22:LoadObject(p20);

    for _, v in p21 do
        v22:LoadRawCollider(v[1], v[2]);
    end;

    local v23 = {
        Object = p20,
        Physics = v22
    };
    table.insert(u16, v23);
    u17[p20] = v23;
end;

local function RemoveRoot(p24: number) -- Line: 118
    -- upvalues: u16 (copy), u17 (copy)
    local v25 = u16[p24];
    u17[v25.Object] = nil;
    table.remove(u16, p24);
    v25.Physics:Destroy();
end;

local v29 = CollectionService:GetInstanceAddedSignal("SmartCollider"):Connect(function(p26: userdata) -- Line: 127
    -- upvalues: u16 (copy), Utilities (copy)
    if not p26:IsA("BasePart") then
        return;
    end;

    local v27 = tostring(p26:GetAttribute("ColliderKey"));
    local v28 = nil;

    for _, v in u16 do
        if v27 == tostring(v.Object:GetAttribute("ColliderKey")) then
            v28 = v28 or Utilities.GetCollider(p26);
            v.Physics:LoadRawCollider(v28, p26);
        end;
    end;
end);
table.insert(u2, v29);
local v31 = CollectionService:GetInstanceRemovedSignal("SmartCollider"):Connect(function(p30: userdata) -- Line: 146
    -- upvalues: u16 (copy)
    for _, v in u16 do
        for _, v2 in v.Physics.ColliderObjects do
            if v2:GetObject() == p30 then
                v2.Destroyed = true;
            end;
        end;
    end;
end);
table.insert(u2, v31);
local v32 = script_Parent:BindToMessage("Destroy", function() -- Line: 156
    -- upvalues: u15 (ref)
    u15 = true;
end);
table.insert(u2, v32);
local v41 = RunService.Heartbeat:ConnectParallel(function(p33) -- Line: 160
    -- upvalues: u15 (ref), u4 (copy), u5 (copy), u16 (copy), u14 (copy), u17 (copy), u2 (copy), AddRoot (copy), u19 (ref), u18 (copy)
    local v34 = shared;
    v34.FrameCounter = v34.FrameCounter + 1;

    if shared.FrameCounter > 131072 then
        shared.FrameCounter = 0;
    end;

    local v35 = u15 or (#u4 ~= 0 and true or #u5 ~= 0);

    for _, v in u16 do
        if v.Physics:StepParallel(p33) or v.Physics.ShouldDestroy then
            v35 = true;
        end;
    end;

    local v36 = false;

    if u14 then
        for _, v in u16 do
            if v.Object:GetAttribute("Debug") ~= nil then
                v36 = true;
                break;
            end;
        end;
    end;

    if not (v35 or v36) then
        return;
    end;

    task.synchronize();

    for _, v in u16 do
        v.Physics:ApplyPending();
    end;

    for i = #u16, 1, -1 do
        local v37;

        if u15 or u16[i].Physics.ShouldDestroy then
            local v38 = u16[i];
            u17[v38.Object] = nil;
            table.remove(u16, i);
            v38.Physics:Destroy();
            v37 = i;
        else
            v37 = i;
        end;
    end;

    if u15 then
        for _, v in u2 do
            v:Disconnect();
        end;

        return;
    end;

    for _, v in u4 do
        AddRoot(v[1], v[2]);
    end;

    table.clear(u4);

    for _, v in u5 do
        local v39 = u17[v];

        if v39 then
            v39 = table.find(u16, v39);
        end;

        if v39 then
            local v40 = u16[v39];
            u17[v40.Object] = nil;
            table.remove(u16, v39);
            v40.Physics:Destroy();
        end;
    end;

    table.clear(u5);

    if not v36 then
        return;
    end;

    for _, v in u16 do
        if v.Object:GetAttribute("Debug") ~= nil then
            v.Physics:DrawDebug(u19.DRAW_COLLIDERS:get(), u19.DRAW_CONTACTS:get(), u19.DRAW_PHYSICAL_BONE:get(), u19.DRAW_BONE:get(), u19.DRAW_AXIS_LIMITS:get(), u19.DRAW_ROOT_PART:get(), u19.DRAW_FILL_COLLIDERS:get(), u19.DRAW_COLLIDER_INFLUENCE:get(), u19.DRAW_COLLIDER_AWAKE:get(), u19.DRAW_COLLIDER_BROADPHASE:get(), u19.DRAW_BOUNDING_BOX:get(), u19.DRAW_ROTATION_LIMITS:get(), u19.DRAW_ACCELERATION_INFO:get());
            v.Physics:DrawOverlay(u18);
        end;
    end;
end);
table.insert(u2, v41);