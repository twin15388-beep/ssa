-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local EmotesInfo = require(ReplicatedStorage.CAM.Global.EmotesInfo);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local u1 = RunService:IsServer();
local u2 = {
    Ended = simplesignal.new(),
    Interrupted = simplesignal.new()
};
local u3 = {};

local function half(p4: string) -- Line: 189
    -- upvalues: u3 (copy), u1 (copy)
    local v5 = u3[p4];

    if v5 ~= nil then
        return v5 or nil;
    end;

    local v6 = script:FindFirstChild(p4);
    local v7;

    if v6 == nil then
        v7 = nil;
    else
        local v8;

        if u1 then
            v8 = p4 .. "Server";
        else
            v8 = p4;
        end;

        v7 = v6:FindFirstChild(v8);
    end;

    local v9;

    if v7 == nil or not v7:IsA("ModuleScript") then
        v9 = false;
    else
        v9 = require(v7);
    end;

    u3[p4] = v9;

    return u3[p4] or nil;
end;

local u10 = setmetatable({}, {
    __mode = "k"
});

local function callHalf(p11: string, p12: string, p13: userdata, p14: userdata, p15: table) -- Line: 204
    -- upvalues: half (copy), u1 (copy)
    local v16 = half(p11);
    local v17;

    if v16 == nil then
        v17 = nil;
    else
        v17 = v16[p12];
    end;

    if v17 == nil then
        return;
    end;

    if u1 then
        v17(p13, p14, p15);

        return;
    end;

    v17(p14, p15);
end;

local function asset(p18: string, p19: string) -- Line: 216
    local v20 = script:FindFirstChild(p18);

    if v20 == nil then
        return nil;
    end;

    return v20:FindFirstChild(p19, true);
end;

local function sound(p21: string, p22: string) -- Line: 220
    local v23 = script:FindFirstChild(p21);
    local v24;

    if v23 == nil then
        v24 = nil;
    else
        v24 = v23:FindFirstChild(p22, true);
    end;

    if v24 == nil or not v24:IsA("Sound") then
        return nil;
    end;

    return v24;
end;

function u2.Wear(p25: userdata, p26: string) -- Line: 237
    local v27 = script:FindFirstChild(p26);
    local v28;

    if v27 == nil then
        v28 = nil;
    else
        v28 = v27:FindFirstChild("Model", true);
    end;

    if v28 == nil or not v28:IsA("Model") then
        return nil;
    end;

    local WeldTo = v28:FindFirstChild("WeldTo");
    local v29;

    if WeldTo == nil or not WeldTo:IsA("StringValue") then
        v29 = nil;
    else
        v29 = p25:FindFirstChild(WeldTo.Value);
    end;

    if v29 == nil or not v29:IsA("BasePart") then
        return nil;
    end;

    local v30 = v28:Clone();
    local v31 = v30:FindFirstChildOfClass("Motor6D") or v30:FindFirstChildOfClass("Weld");

    if v31 == nil then
        v30:Destroy();

        return nil;
    end;

    v31.Part0 = v29;
    v30.Parent = p25;

    return v30;
end;

local u32 = {};

local function vfx(p33: string) -- Line: 256
    -- upvalues: u32 (copy), ReplicatedStorage (copy)
    local v34 = u32[p33];

    if v34 == nil then
        local Effects = ReplicatedStorage:FindFirstChild("Effects");
        local v35;

        if Effects == nil then
            v35 = nil;
        else
            v35 = Effects:FindFirstChild(p33 .. "VFX", true);
        end;

        if v35 == nil then
            v34 = false;
        else
            v34 = v35.Name;
        end;

        u32[p33] = v34;
    end;

    return v34 or nil;
end;

local function fireVfx(p36: table, p37: userdata, p38: string?) -- Line: 268
    -- upvalues: u32 (copy), ReplicatedStorage (copy), EffectsEvent (copy)
    local Name = p36.Name;
    local v39 = u32[Name];

    if v39 == nil then
        local Effects = ReplicatedStorage:FindFirstChild("Effects");
        local v40;

        if Effects == nil then
            v40 = nil;
        else
            v40 = Effects:FindFirstChild(Name .. "VFX", true);
        end;

        if v40 == nil then
            v39 = false;
        else
            v39 = v40.Name;
        end;

        u32[Name] = v39;
    end;

    local v41 = v39 or nil;

    if v41 == nil or p37.Parent == nil then
        return;
    end;

    p36.VfxFired = true;

    if p38 == nil then
        EffectsEvent.ToAllInRange(p37, v41, p37);

        return;
    end;

    EffectsEvent.ToAllInRange(p37, v41, p37, p38);
end;

local function cueSound(p42: table, p43: string, p44: userdata) -- Line: 283
    -- upvalues: DebrisModule (copy)
    local v45 = script:FindFirstChild(p43);
    local v46;

    if v45 == nil then
        v46 = nil;
    else
        v46 = v45:FindFirstChild("Sound", true);
    end;

    if v46 == nil or not v46:IsA("Sound") then
        v46 = nil;
    end;

    if v46 == nil then
        return;
    end;

    local v47 = v46:Clone();
    v47.Looped = false;
    v47.Parent = p44;
    v47:Play();
    DebrisModule:AddItem(v47, 0);

    if p42.Sounds ~= nil then
        table.insert(p42.Sounds, v47);
    end;
end;

local function loopSound(p48: table, p49: string, p50: userdata) -- Line: 306
    local v51 = script:FindFirstChild(p49);
    local v52;

    if v51 == nil then
        v52 = nil;
    else
        v52 = v51:FindFirstChild("SoundLooped", true);
    end;

    if v52 == nil or not v52:IsA("Sound") then
        v52 = nil;
    end;

    if v52 == nil or p48.Sounds == nil then
        return;
    end;

    local v53 = v52:Clone();
    v53.Looped = true;
    v53.Parent = p50;
    v53:Play();
    table.insert(p48.Sounds, v53);
end;

local function startSound(p54: table, p55: string, p56: userdata, p57: boolean, p58: boolean) -- Line: 315
    -- upvalues: DebrisModule (copy)
    local v59 = {};
    p54.Sounds = v59;
    local v60;

    if p58 then
        v60 = nil;
    else
        local v61 = script:FindFirstChild(p55);

        if v61 == nil then
            v60 = nil;
        else
            v60 = v61:FindFirstChild("Sound", true);
        end;

        if v60 == nil or not v60:IsA("Sound") then
            v60 = nil;
        end;
    end;

    if v60 ~= nil then
        local v62 = v60:Clone();
        v62.Looped = false;
        v62.Parent = p56;
        v62:Play();
        DebrisModule:AddItem(v62, 0);
        table.insert(v59, v62);
    end;

    if not p57 then
        return;
    end;

    if p58 then
        p54.SoundOnCue = true;

        return;
    end;

    local v63 = script:FindFirstChild(p55);
    local v64;

    if v63 == nil then
        v64 = nil;
    else
        v64 = v63:FindFirstChild("SoundLooped", true);
    end;

    if v64 == nil or not v64:IsA("Sound") then
        v64 = nil;
    end;

    if v64 ~= nil then
        if p54.Sounds == nil then
            return;
        end;

        local v65 = v64:Clone();
        v65.Looped = true;
        v65.Parent = p56;
        v65:Play();
        table.insert(p54.Sounds, v65);
    end;
end;

local function endPlay(p66: userdata, p67: string, p68: boolean?, p69: boolean?) -- Line: 357
    -- upvalues: u10 (copy), EmotesInfo (copy), TweenService (copy), DebrisModule (copy), u1 (copy), u32 (copy), ReplicatedStorage (copy), EffectsEvent (copy), half (copy), u2 (copy)
    local v70 = u10[p66];

    if v70 == nil then
        return;
    end;

    local v71 = EmotesInfo[v70.Name];
    local v72;

    if p67 == "Cancel" then
        v72 = not p69;

        if v72 then
            if v71 == nil or (v71.Cancelling ~= false or v71.Duration == nil) then
                v72 = false;
            else
                v72 = v71.Duration >= 0;
            end;
        end;
    else
        v72 = false;
    end;

    if v70.Locks ~= nil then
        for _, v in v70.Locks do
            v:Destroy();
        end;

        v70.Locks = nil;
    end;

    if v70.Breaks ~= nil then
        for _, v in v70.Breaks do
            v:Disconnect();
        end;

        v70.Breaks = nil;
    end;

    if v72 then
        return;
    end;

    u10[p66] = nil;
    v70.Ended = true;

    if v70.Unwatch ~= nil then
        v70.Unwatch();
    end;

    if v70.Prop ~= nil then
        v70.Prop:Destroy();
        v70.Prop = nil;
    end;

    if v70.Sounds ~= nil then
        for _, v in v70.Sounds do
            TweenService:Create(v, TweenInfo.new(0.3), {
                Volume = 0
            }):Play();
            DebrisModule:AddItem(v, 0.3);
        end;

        v70.Sounds = nil;
    end;

    local Character = p66.Character;

    if Character ~= nil then
        if u1 and (v71 ~= nil and (v71.HasState and v70.VfxFired)) then
            local Name = v70.Name;
            local v73 = u32[Name];

            if v73 == nil then
                local Effects = ReplicatedStorage:FindFirstChild("Effects");
                local v74;

                if Effects == nil then
                    v74 = nil;
                else
                    v74 = Effects:FindFirstChild(Name .. "VFX", true);
                end;

                if v74 == nil then
                    v73 = false;
                else
                    v73 = v74.Name;
                end;

                u32[Name] = v73;
            end;

            local v75 = v73 or nil;

            if v75 ~= nil and Character.Parent ~= nil then
                v70.VfxFired = true;
                EffectsEvent.ToAllInRange(Character, v75, Character, "Cancel");
            end;
        end;

        local Storage = v70.Storage;
        local v76 = half(v70.Name);
        local v77;

        if v76 == nil then
            v77 = nil;
        else
            v77 = v76[p67];
        end;

        if v77 ~= nil then
            if u1 then
                v77(p66, Character, Storage);
            else
                v77(Character, Storage);
            end;
        end;
    end;

    if p68 then
        u2.Interrupted:Fire(p66, v70.Name);
    end;

    u2.Ended:Fire(p66, v70.Name, p67);
end;

local function begin(u78: userdata, p79: string) -- Line: 414
    -- upvalues: EmotesInfo (copy), u2 (copy), endPlay (copy), u10 (copy), u1 (copy), Utility (copy), startSound (copy), u32 (copy), ReplicatedStorage (copy), EffectsEvent (copy), half (copy), ManuelCancel (copy), RunService (copy)
    local v80 = EmotesInfo[p79];

    if v80 == nil then
        return false;
    end;

    local Character = u78.Character;
    local v81;

    if Character == nil then
        v81 = nil;
    else
        v81 = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character == nil or v81 == nil then
        return false;
    end;

    if not u2.Free(u78) then
        return false;
    end;

    if not u2.Owned(u78) then
        return false;
    end;

    endPlay(u78, "Cancel", nil, true);
    local u82 = {
        Name = p79,
        Storage = {}
    };
    u10[u78] = u82;

    if v80.Lock ~= nil and u1 then
        local valuesfolder = Utility.getvaluesfolder(Character);
        u82.Locks = { Utility.AddValue(valuesfolder, "WalkSpeed", v80.Lock, "NumberValue", 0) };
    end;

    if u1 then
        startSound(u82, p79, v81, v80.Duration ~= nil, v80.SoundOnCue == true);
        u82.Prop = u2.Wear(Character, p79);
        local u83 = v80.HasState and "Do" or nil;

        if v80.VfxCue == nil then
            if v80.VfxDelay == nil or v80.VfxDelay <= 0 then
                local Name = u82.Name;
                local v84 = u32[Name];

                if v84 == nil then
                    local Effects = ReplicatedStorage:FindFirstChild("Effects");
                    local v85;

                    if Effects == nil then
                        v85 = nil;
                    else
                        v85 = Effects:FindFirstChild(Name .. "VFX", true);
                    end;

                    if v85 == nil then
                        v84 = false;
                    else
                        v84 = v85.Name;
                    end;

                    u32[Name] = v84;
                end;

                local v86 = v84 or nil;

                if v86 ~= nil and Character.Parent ~= nil then
                    u82.VfxFired = true;

                    if u83 == nil then
                        EffectsEvent.ToAllInRange(Character, v86, Character);
                    else
                        EffectsEvent.ToAllInRange(Character, v86, Character, u83);
                    end;
                end;
            else
                task.delay(v80.VfxDelay, function() -- Line: 445
                    -- upvalues: u82 (copy), Character (copy), u83 (copy), u32 (ref), ReplicatedStorage (ref), EffectsEvent (ref)
                    if u82.Ended then
                        return;
                    end;

                    local v87 = u82;
                    local v88 = Character;
                    local v89 = u83;
                    local Name = v87.Name;
                    local v90 = u32[Name];

                    if v90 == nil then
                        local Effects = ReplicatedStorage:FindFirstChild("Effects");
                        local v91;

                        if Effects == nil then
                            v91 = nil;
                        else
                            v91 = Effects:FindFirstChild(Name .. "VFX", true);
                        end;

                        if v91 == nil then
                            v90 = false;
                        else
                            v90 = v91.Name;
                        end;

                        u32[Name] = v90;
                    end;

                    local v92 = v90 or nil;

                    if v92 ~= nil then
                        if v88.Parent == nil then
                            return;
                        end;

                        v87.VfxFired = true;

                        if v89 == nil then
                            EffectsEvent.ToAllInRange(v88, v92, v88);

                            return;
                        end;

                        EffectsEvent.ToAllInRange(v88, v92, v88, v89);
                    end;
                end);
            end;
        end;
    end;

    local Storage = u82.Storage;
    local v93 = half(p79);
    local v94;

    if v93 == nil then
        v94 = nil;
    else
        v94 = v93.Do;
    end;

    if v94 ~= nil then
        if u1 then
            v94(u78, Character, Storage);
        else
            v94(Character, Storage);
        end;
    end;

    if v80.Duration == nil then
        u10[u78] = nil;
        local Locks = u82.Locks;

        if Locks ~= nil and v80.Lock ~= nil then
            local v95, u96 = ManuelCancel.new(u78, v80.Lock);
            v95:Connect(function() -- Line: 463
                -- upvalues: Locks (copy), u96 (copy)
                for _, v in Locks do
                    v:Destroy();
                end;

                u96();
            end);
        end;

        return true;
    end;

    local v97, v98 = ManuelCancel.new(u78, -1);
    u82.Unwatch = v98;
    v97:Connect(function() -- Line: 476
        -- upvalues: u10 (ref), u78 (copy), u82 (copy), endPlay (ref)
        if u10[u78] ~= u82 then
            return;
        end;

        endPlay(u78, "Stop", true);
    end);

    if not u1 then
        local v99 = {};
        u82.Breaks = v99;

        local function breakOut() -- Line: 500
            -- upvalues: u10 (ref), u78 (copy), u82 (copy), u2 (ref)
            if u10[u78] ~= u82 then
                return;
            end;

            u2.Cancel();
        end;

        local u100 = Character:FindFirstChildOfClass("Humanoid");
        table.insert(v99, RunService.PostSimulation:Connect(function() -- Line: 505
            -- upvalues: u100 (copy), u10 (ref), u78 (copy), u82 (copy), u2 (ref), Character (copy)
            if u100 == nil or u100.MoveDirection.Magnitude <= 0 then
                local SHC = Character:FindFirstChild("SHC");

                if SHC ~= nil and (SHC:IsA("StringValue") and SHC.Value ~= "") then
                    if u10[u78] ~= u82 then
                        return;
                    end;

                    u2.Cancel();
                end;

                return;
            end;

            if u10[u78] ~= u82 then
                return;
            end;

            u2.Cancel();
        end));
    end;

    if v80.Duration >= 0 then
        task.delay(v80.Duration + (u1 and 1 or 0), function() -- Line: 519
            -- upvalues: u10 (ref), u78 (copy), u82 (copy), endPlay (ref)
            if u10[u78] ~= u82 then
                return;
            end;

            endPlay(u78, "Stop");
        end);
    end;

    return true;
end;

function u2.Exists(p101: string) -- Line: 527
    -- upvalues: EmotesInfo (copy)
    return EmotesInfo[p101] ~= nil;
end;

function u2.OnPodium(p102: userdata) -- Line: 534
    local v103;

    if workspace:GetAttribute("MinigameState") == "Victory" then
        v103 = p102:GetAttribute("PvPVictory") ~= nil;
    else
        v103 = false;
    end;

    return v103;
end;

function u2.Free(p104: userdata) -- Line: 540
    -- upvalues: u2 (copy), Checker (copy)
    return u2.OnPodium(p104) or Checker.check(p104);
end;

function u2.Owned(p105: userdata) -- Line: 546
    -- upvalues: Shop (copy)
    return Shop.OwnsGamepassListing(p105, "Emotes");
end;

if u1 then
    function u2.Do(p106: userdata, p107: string) -- Line: 552
        -- upvalues: begin (copy)
        return begin(p106, p107);
    end;

    function u2.Stop(p108: userdata) -- Line: 555
        -- upvalues: endPlay (copy)
        endPlay(p108, "Stop");
    end;

    function u2.Cancel(p109: userdata) -- Line: 558
        -- upvalues: endPlay (copy)
        endPlay(p109, "Cancel");
    end;

    function u2.Fire(p110: userdata) -- Line: 563
        -- upvalues: u10 (copy), EmotesInfo (copy), cueSound (copy), u32 (copy), ReplicatedStorage (copy), EffectsEvent (copy)
        local v111 = u10[p110];
        local Character = p110.Character;

        if v111 == nil or Character == nil then
            return;
        end;

        local os_clock_ret = os.clock();

        if v111.LastCue ~= nil and os_clock_ret - v111.LastCue < 0.1 then
            return;
        end;

        v111.LastCue = os_clock_ret;
        local v112 = EmotesInfo[v111.Name];
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        local v113;

        if v112 == nil then
            v113 = false;
        else
            v113 = v112.SoundOnCue == true and true or v112.CueOnLoop == true;
        end;

        if v113 and (HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart")) then
            cueSound(v111, v111.Name, HumanoidRootPart);

            if v111.SoundOnCue then
                v111.SoundOnCue = nil;
                local v114 = script:FindFirstChild(v111.Name);
                local v115;

                if v114 == nil then
                    v115 = nil;
                else
                    v115 = v114:FindFirstChild("SoundLooped", true);
                end;

                if v115 == nil or not v115:IsA("Sound") then
                    v115 = nil;
                end;

                if v115 ~= nil and v111.Sounds ~= nil then
                    local v116 = v115:Clone();
                    v116.Looped = true;
                    v116.Parent = HumanoidRootPart;
                    v116:Play();
                    table.insert(v111.Sounds, v116);
                end;
            end;
        end;

        local v117 = v112 ~= nil and v112.HasState and "Do" or nil;
        local Name = v111.Name;
        local v118 = u32[Name];

        if v118 == nil then
            local Effects = ReplicatedStorage:FindFirstChild("Effects");
            local v119;

            if Effects == nil then
                v119 = nil;
            else
                v119 = Effects:FindFirstChild(Name .. "VFX", true);
            end;

            if v119 == nil then
                v118 = false;
            else
                v118 = v119.Name;
            end;

            u32[Name] = v118;
        end;

        local v120 = v118 or nil;

        if v120 ~= nil then
            if Character.Parent == nil then
                return;
            end;

            v111.VfxFired = true;

            if v117 == nil then
                EffectsEvent.ToAllInRange(Character, v120, Character);

                return;
            end;

            EffectsEvent.ToAllInRange(Character, v120, Character, v117);
        end;
    end;

    function u2.Playing(p121: userdata) -- Line: 586
        -- upvalues: u10 (copy)
        local v122 = u10[p121];

        if v122 == nil then
            return nil;
        end;

        return v122.Name;
    end;

    return u2;
end;

local LocalPlayer = Players.LocalPlayer;

function u2.Display(p123: string) -- Line: 595
    -- upvalues: half (copy)
    local v124 = half(p123);

    if v124 == nil or v124.Display == nil then
        return nil, nil;
    end;

    return v124.Display();
end;

function u2.Do(p125: string) -- Line: 600
    -- upvalues: begin (copy), LocalPlayer (copy), SignalEvent (copy)
    if not begin(LocalPlayer, p125) then
        return false;
    end;

    SignalEvent.ToServer("EmoteAction", p125, "Do");

    return true;
end;

function u2.Stop() -- Line: 605
    -- upvalues: u10 (copy), LocalPlayer (copy), endPlay (copy), SignalEvent (copy)
    if u10[LocalPlayer] == nil then
        return;
    end;

    endPlay(LocalPlayer, "Stop");
    SignalEvent.ToServer("EmoteAction", nil, "Stop");
end;

function u2.Cancel() -- Line: 610
    -- upvalues: u10 (copy), LocalPlayer (copy), endPlay (copy), SignalEvent (copy)
    if u10[LocalPlayer] == nil then
        return;
    end;

    endPlay(LocalPlayer, "Cancel");
    SignalEvent.ToServer("EmoteAction", nil, "Cancel");
end;

function u2.Fire() -- Line: 617
    -- upvalues: u10 (copy), LocalPlayer (copy), SignalEvent (copy)
    if u10[LocalPlayer] == nil then
        return;
    end;

    SignalEvent.ToServer("EmoteAction", nil, "Fire");
end;

function u2.Playing() -- Line: 621
    -- upvalues: u10 (copy), LocalPlayer (copy)
    local v126 = u10[LocalPlayer];

    if v126 == nil then
        return nil;
    end;

    return v126.Name;
end;

LocalPlayer.CharacterRemoving:Connect(function() -- Line: 628
    -- upvalues: endPlay (copy), LocalPlayer (copy)
    endPlay(LocalPlayer, "Cancel", nil, true);
end);

return u2;