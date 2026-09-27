-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local Crow = require(ReplicatedStorage.Items.Misc.Crow);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local CrowHandler = require(ServerStorage.SAM.Services.CrowHandler);
local u1 = { "Cancel", "Stun", "CombatStun", "Strict_Stun" };
local script_Parent = script.Parent;
local u2 = {};

local function shout(p3: userdata, p4: string) -- Line: 33
    -- upvalues: SignalEvent (copy), Crow (copy)
    SignalEvent.ToClient(p3, "NpcNotify", {
        Text = "CAHH!!",
        Icon = Crow.Icon,
        Sound = p4
    });
end;

local u5 = {};
local u6 = {};

local function resolveAnimator(p7: userdata, p8: table) -- Line: 59
    -- upvalues: CrowHandler (copy)
    if p8.animator ~= nil then
        return p8.animator;
    end;

    local v9 = CrowHandler.Model(p7);
    local v10;

    if v9 == nil then
        v10 = nil;
    else
        v10 = v9:FindFirstChild("Humanoid") or nil;
    end;

    local v11;

    if v10 == nil then
        v11 = nil;
    else
        v11 = v10:FindFirstChildOfClass("Animator") or nil;
    end;

    p8.animator = v11;

    return p8.animator;
end;

local function playCrowAnim(p12: userdata, p13: table, p14: string) -- Line: 67
    -- upvalues: CrowHandler (copy), script_Parent (copy)
    local v15;

    if p13.animator == nil then
        local v16 = CrowHandler.Model(p12);
        local v17;

        if v16 == nil then
            v17 = nil;
        else
            v17 = v16:FindFirstChild("Humanoid") or nil;
        end;

        local v18;

        if v17 == nil then
            v18 = nil;
        else
            v18 = v17:FindFirstChildOfClass("Animator") or nil;
        end;

        p13.animator = v18;
        v15 = p13.animator;
    else
        v15 = p13.animator;
    end;

    if v15 == nil or p13.currentAnimName == p14 then
        return;
    end;

    local v19 = script_Parent:FindFirstChild(p14);

    if v19 == nil then
        warn((`Crow: no "{p14}" Animation under {script_Parent:GetFullName()} -- the crow will hold its default pose`));

        return;
    end;

    for _, v in v15:GetPlayingAnimationTracks() do
        v:Stop();
    end;

    local v20 = v15:LoadAnimation(v19);
    v20.Looped = true;
    v20.Priority = Enum.AnimationPriority.Idle;
    v20:Play();
    p13.currentTrack = v20;
    p13.currentAnimName = p14;
end;

local function raceAllowsCrow(p21: userdata) -- Line: 95
    -- upvalues: Utility (copy)
    local Data = Utility.GetData(p21);

    if Data then
        Data = Data:FindFirstChild("Race");
    end;

    if Data then
        Data = Data.Value;
    end;

    return Data == "Slayer" and true or Data == "Hybrid";
end;

local function despawnCrow(p22: userdata, p23: userdata?) -- Line: 103
    -- upvalues: u5 (copy), playCrowAnim (copy), CrowHandler (copy), SignalEvent (copy), Crow (copy)
    local v24 = u5[p22];

    if v24 == nil then
        return;
    end;

    u5[p22] = nil;

    if v24.cancelDestroy then
        v24.cancelDestroy();
    end;

    if v24.charConn then
        v24.charConn:Disconnect();
    end;

    if v24.animPortal then
        v24.animPortal:Destroy();
    end;

    playCrowAnim(p22, v24, "fly");
    CrowHandler.Despawn(p22, p23 or p22.Character);
    SignalEvent.ToClient(p22, "NpcNotify", {
        Text = "CAHH!!",
        Sound = "PS2crowLEAVE",
        Icon = Crow.Icon
    });
end;

function u2.check(p25: userdata, p26: userdata, p27: table, p28: string) -- Line: 126
    -- upvalues: u6 (copy), Utility (copy)
    if (u6[p25] or 0) > os.clock() then
        return false;
    end;

    local Data = Utility.GetData(p25);

    if Data then
        Data = Data:FindFirstChild("Race");
    end;

    if Data then
        Data = Data.Value;
    end;

    return Data == "Slayer" and true or Data == "Hybrid";
end;

function u2.Equipped(u29: userdata, u30: userdata, p31: table, p32: string) -- Line: 133
    -- upvalues: u5 (copy), CrowHandler (copy), despawnCrow (copy), SignalEvent (copy), Crow (copy), ServerClientPortal (copy), playCrowAnim (copy), ManuelCancel (copy), u1 (copy)
    if u5[u29] ~= nil then
        if CrowHandler.Model(u29) ~= nil then
            return;
        end;

        despawnCrow(u29, u30);
    end;

    if u30 == nil or u30:FindFirstChild("HumanoidRootPart") == nil then
        return;
    end;

    CrowHandler.Spawn(u29, u30);
    SignalEvent.ToClient(u29, "NpcNotify", {
        Text = "CAHH!!",
        Sound = "PS2crowCAW",
        Icon = Crow.Icon
    });
    local u33 = {};
    u5[u29] = u33;
    local v34 = ServerClientPortal.Create(u29, "CrowAnim", -1);
    u33.animPortal = v34;
    v34:Connect(function(p35: string) -- Line: 154
        -- upvalues: playCrowAnim (ref), u29 (copy), u33 (copy)
        if p35 == "idle" or p35 == "fly" then
            playCrowAnim(u29, u33, p35);
        end;
    end);
    playCrowAnim(u29, u33, "fly");
    local v36, v37 = ManuelCancel.new(u29, -1, u1);
    u33.cancelDestroy = v37;

    if v36 then
        v36:Connect(function() -- Line: 168
            -- upvalues: despawnCrow (ref), u29 (copy), u30 (copy)
            despawnCrow(u29, u30);
        end);
    end;

    u33.charConn = u29.CharacterRemoving:Connect(function() -- Line: 175
        -- upvalues: despawnCrow (ref), u29 (copy), u30 (copy)
        despawnCrow(u29, u30);
    end);
end;

function u2.UnEquipped(p38: userdata, p39: userdata, p40: table, p41: string) -- Line: 180
    -- upvalues: despawnCrow (copy), u6 (copy), gameSettings (copy)
    despawnCrow(p38, p39);
    u6[p38] = os.clock() + gameSettings.crowEquipCooldown;
end;

function u2.MouseDown(p42: userdata, p43: userdata, p44: table, p45: string) -- Line: 187
end;

function u2.MouseUp(p46: userdata, p47: userdata, p48: table, p49: string) -- Line: 192
end;

function u2.Dismiss(p50: userdata) -- Line: 198
    -- upvalues: despawnCrow (copy)
    despawnCrow(p50, p50.Character);
end;

function u2.DisposePlayer(p51: userdata) -- Line: 204
    -- upvalues: u2 (copy), u6 (copy)
    u2.Dismiss(p51);
    u6[p51] = nil;
end;

return u2;