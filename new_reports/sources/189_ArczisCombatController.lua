-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local Debris = game:GetService("Debris");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local ArczisCombat = ReplicatedStorage:WaitForChild("ArczisCombat", 10);

if not ArczisCombat then
    return;
end;

local Remotes = ArczisCombat:WaitForChild("Remotes", 10);

if not Remotes then
    return;
end;

local CombatEvent = Remotes:WaitForChild("CombatEvent", 10);
local BlockEvent = Remotes:WaitForChild("BlockEvent", 10);
Remotes:WaitForChild("HitReactionEvent", 10);
local ClashEvent = Remotes:WaitForChild("ClashEvent", 10);
local CombatConfig = require(ArczisCombat:WaitForChild("CombatConfig", 10));
local u1 = nil;
local u2 = {};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = false;
local u8 = false;
local u9 = false;
local u10 = false;
local u11 = false;
local u12 = false;
local u13 = false;
local u14 = nil;
local u15 = {};
local u16 = nil;
local u17 = nil;
local u18 = 0;
local u19 = false;
local u20 = 1;
local u21 = nil;
local u22 = 0;

local function disconnectToolConnections() -- Line: 57
    -- upvalues: u2 (copy)
    for _, v in ipairs(u2) do
        if v then
            v:Disconnect();
        end;
    end;

    table.clear(u2);
end;

local function stopTrack(p23, p24) -- Line: 66
    -- upvalues: u15 (copy)
    local v25 = u15[p23];

    if v25 and v25.IsPlaying then
        v25:Stop(p24 or 0.1);
    end;
end;

local function playTrack(p26, p27) -- Line: 73
    -- upvalues: u15 (copy)
    local v28 = u15[p26];

    if v28 then
        if not v28.IsPlaying then
            v28:Play(p27 or 0.08);
        end;

        return v28;
    end;
end;

local function stopMovement() -- Line: 83
    -- upvalues: u15 (copy)
    local Walk = u15.Walk;

    if Walk and Walk.IsPlaying then
        Walk:Stop(0.1);
    end;

    local Run = u15.Run;

    if Run and Run.IsPlaying then
        Run:Stop(0.1);
    end;
end;

local function stopAttacks() -- Line: 88
    -- upvalues: u15 (copy)
    local Punch1 = u15.Punch1;

    if Punch1 and Punch1.IsPlaying then
        Punch1:Stop(0.05);
    end;

    local Punch2 = u15.Punch2;

    if Punch2 and Punch2.IsPlaying then
        Punch2:Stop(0.05);
    end;

    local Punch2Alt = u15.Punch2Alt;

    if Punch2Alt and Punch2Alt.IsPlaying then
        Punch2Alt:Stop(0.05);
    end;

    local Heavy = u15.Heavy;

    if Heavy and Heavy.IsPlaying then
        Heavy:Stop(0.05);
    end;
end;

local function clearTracks() -- Line: 95
    -- upvalues: u15 (copy)
    for _, v in pairs(u15) do
        pcall(function() -- Line: 97
            -- upvalues: v (copy)
            v:Stop(0);
            v:Destroy();
        end);
    end;

    table.clear(u15);
end;

local function loadTrack(p29, p30, p31, p32) -- Line: 105
    -- upvalues: u5 (ref), u15 (copy)
    if not (u5 and p30) then
        return;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = p30;
    local success, result = pcall(function() -- Line: 109
        -- upvalues: u5 (ref), Animation (copy)
        return u5:LoadAnimation(Animation);
    end);
    Animation:Destroy();

    if success and result then
        result.Priority = p31 or Enum.AnimationPriority.Action;
        result.Looped = p32 == true;
        u15[p29] = result;
    end;
end;

local function loadAnimations() -- Line: 120
    -- upvalues: clearTracks (copy), CombatConfig (copy), loadTrack (copy)
    clearTracks();
    local Animations = CombatConfig.Animations;
    loadTrack("Walk", Animations.CombatWalk, Enum.AnimationPriority.Movement, true);
    loadTrack("Run", Animations.CombatRun, Enum.AnimationPriority.Movement, true);
    loadTrack("Punch1", Animations.M1_Punch1, Enum.AnimationPriority.Action2, false);
    loadTrack("Punch2", Animations.M1_Punch2, Enum.AnimationPriority.Action2, false);
    loadTrack("Punch2Alt", Animations.M1_Punch2Alt, Enum.AnimationPriority.Action2, false);
    loadTrack("Heavy", Animations.HeavyPunch, Enum.AnimationPriority.Action2, false);
    loadTrack("Block", Animations.Block, Enum.AnimationPriority.Action3, true);
    loadTrack("BlockHit", Animations.BlockHit, Enum.AnimationPriority.Action4, false);
    loadTrack("GuardBreak", Animations.GuardBreak, Enum.AnimationPriority.Action4, false);
    loadTrack("HitReactionM1_1", Animations.HitReactionM1_1, Enum.AnimationPriority.Action4, false);
    loadTrack("HitReactionM1_2", Animations.HitReactionM1_2, Enum.AnimationPriority.Action4, false);
    loadTrack("ClashLoop", Animations.ClashLoop, Enum.AnimationPriority.Action4, true);
    loadTrack("ClashWin", Animations.ClashWin, Enum.AnimationPriority.Action4, false);
    loadTrack("Equip", Animations.Equip, Enum.AnimationPriority.Action3, false);
end;

local function getBool(p33) -- Line: 139
    -- upvalues: u3 (ref)
    local v34 = u3 and u3:FindFirstChild(p33);
    local v35 = v34 and v34:IsA("BoolValue") and v34.Value == true;

    return v35;
end;

local function syncState() -- Line: 144
    -- upvalues: u8 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref)
    local v36 = u3 and u3:FindFirstChild("IsBlocking");
    local v37 = v36 and v36:IsA("BoolValue") and v36.Value == true;
    u8 = v37;
    local v38 = u3 and u3:FindFirstChild("IsStunned");
    local v39 = v38 and v38:IsA("BoolValue") and v38.Value == true;
    u10 = v39;
    local v40 = u3 and u3:FindFirstChild("IsGuardBroken");
    local v41 = v40 and v40:IsA("BoolValue") and v40.Value == true;
    u11 = v41;
    local v42 = u3 and u3:FindFirstChild("IsAttacking");
    local v43 = v42 and v42:IsA("BoolValue") and v42.Value == true;
    u9 = v43;
    local v44 = u3 and u3:FindFirstChild("IsInClash");
    local v45 = v44 and v44:IsA("BoolValue") and v44.Value == true;
    u12 = v45;
end;

local function enoughStamina(p46) -- Line: 152
    -- upvalues: LocalPlayer (copy), CombatConfig (copy)
    local v47 = tonumber(LocalPlayer:GetAttribute("Stamina")) or 0;
    local v48;

    if p46 <= v47 then
        v48 = CombatConfig.MinStaminaToAct <= v47;
    else
        v48 = false;
    end;

    return v48;
end;

local function canAct() -- Line: 157
    -- upvalues: u7 (ref), u3 (ref), u4 (ref), u8 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref), u13 (ref)
    if not (u7 and (u3 and (u4 and u4.Health > 0))) then
        return false;
    end;

    if u3:GetAttribute("ActionLocked") == true or (u3:GetAttribute("Hibernating") == true or u3:GetAttribute("Ragdolled") == true) then
        return false;
    end;

    local v49 = u3 and u3:FindFirstChild("IsBlocking");
    local v50 = v49 and v49:IsA("BoolValue") and v49.Value == true;
    u8 = v50;
    local v51 = u3 and u3:FindFirstChild("IsStunned");
    local v52 = v51 and v51:IsA("BoolValue") and v51.Value == true;
    u10 = v52;
    local v53 = u3 and u3:FindFirstChild("IsGuardBroken");
    local v54 = v53 and v53:IsA("BoolValue") and v53.Value == true;
    u11 = v54;
    local v55 = u3 and u3:FindFirstChild("IsAttacking");
    local v56 = v55 and v55:IsA("BoolValue") and v55.Value == true;
    u9 = v56;
    local v57 = u3 and u3:FindFirstChild("IsInClash");
    local v58 = v57 and v57:IsA("BoolValue") and v57.Value == true;
    u12 = v58;

    return not (u9 or (u8 or u10 or (u11 or u12))) and not u13;
end;

local function destroyClashUI() -- Line: 170
    -- upvalues: u17 (ref), u16 (ref), LocalPlayer (copy)
    if u17 then
        u17:Cancel();
        u17 = nil;
    end;

    if u16 and u16.Name == "ClashLockpick" then
        local Click = u16:FindFirstChild("Click");

        if Click and Click:IsA("Sound") then
            Click:Stop();
        end;

        u16:Destroy();
    end;

    u16 = nil;
    local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

    if ClashUI then
        ClashUI.Enabled = false;
    end;
end;

local function updateClashUI(p59, p60, p61) -- Line: 187
    -- upvalues: LocalPlayer (copy), CombatConfig (copy), u17 (ref), TweenService (copy)
    local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

    if ClashUI then
        ClashUI = ClashUI:FindFirstChild("CombatStats");
    end;

    if ClashUI then
        ClashUI = ClashUI:FindFirstChild("Barra");
    end;

    if ClashUI then
        ClashUI = ClashUI:FindFirstChild("CARREGAMENTO");
    end;

    if ClashUI then
        local v62 = tonumber(p61) or (tonumber(CombatConfig.ClashBarMaxLead) or 18);
        local math_max_ret = math.max(1, v62);
        local v63 = 0.5 + ((tonumber(p59) or 0) - (tonumber(p60) or 0)) / (math_max_ret * 2);
        local math_clamp_ret = math.clamp(v63, 0, 1);
        local UDim2_new_ret = UDim2.new(math_clamp_ret, 0, 1, 0);

        if u17 then
            u17:Cancel();
        end;

        u17 = TweenService:Create(ClashUI, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2_new_ret
        });
        u17:Play();
    end;
end;

local function createClashUI() -- Line: 209
    -- upvalues: destroyClashUI (copy), LocalPlayer (copy), u16 (ref), UserInputService (copy), updateClashUI (copy)
    destroyClashUI();
    local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

    if ClashUI then
        u16 = ClashUI;
        ClashUI.Enabled = true;
        local CombatStats = ClashUI:FindFirstChild("CombatStats");

        if CombatStats and CombatStats:IsA("GuiObject") then
            CombatStats.Visible = true;
        end;

        if CombatStats then
            CombatStats = CombatStats:FindFirstChild("Barra");
        end;

        if CombatStats and CombatStats:IsA("GuiObject") then
            CombatStats.Visible = true;
        end;

        if CombatStats then
            CombatStats = CombatStats:FindFirstChild("TextLabel");
        end;

        if CombatStats then
            local v64 = UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled;

            if UserInputService.TouchEnabled then
                CombatStats.Text = "TAP THE SCREEN!";
            elseif v64 then
                CombatStats.Text = "PRESS R2!";
            else
                CombatStats.Text = "PRESS M1!";
            end;
        end;

        updateClashUI(0, 0);
    end;
end;

local function resetCombatLocal() -- Line: 239
    -- upvalues: u8 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), destroyClashUI (copy), u15 (copy)
    u8 = false;
    u10 = false;
    u11 = false;
    u12 = false;
    u13 = false;
    u14 = nil;
    destroyClashUI();
    local Walk = u15.Walk;

    if Walk and Walk.IsPlaying then
        Walk:Stop(0.1);
    end;

    local Run = u15.Run;

    if Run and Run.IsPlaying then
        Run:Stop(0.1);
    end;

    local Punch1 = u15.Punch1;

    if Punch1 and Punch1.IsPlaying then
        Punch1:Stop(0.05);
    end;

    local Punch2 = u15.Punch2;

    if Punch2 and Punch2.IsPlaying then
        Punch2:Stop(0.05);
    end;

    local Punch2Alt = u15.Punch2Alt;

    if Punch2Alt and Punch2Alt.IsPlaying then
        Punch2Alt:Stop(0.05);
    end;

    local Heavy = u15.Heavy;

    if Heavy and Heavy.IsPlaying then
        Heavy:Stop(0.05);
    end;

    local Block = u15.Block;

    if Block and Block.IsPlaying then
        Block:Stop(0.05);
    end;

    local ClashLoop = u15.ClashLoop;

    if ClashLoop and ClashLoop.IsPlaying then
        ClashLoop:Stop(0.05);
    end;
end;

local function onEquipped() -- Line: 254
    -- upvalues: u7 (ref), u3 (ref), LocalPlayer (copy), u4 (ref), u6 (ref), u5 (ref), loadAnimations (copy), u14 (ref), u12 (ref), u15 (copy), u8 (ref), u10 (ref), u11 (ref), u13 (ref), destroyClashUI (copy), CombatEvent (copy)
    if u7 then
        return;
    end;

    u3 = LocalPlayer.Character;
    local v65 = u3 and u3:FindFirstChildOfClass("Humanoid");
    u4 = v65;
    local v66 = u3 and u3:FindFirstChild("HumanoidRootPart");
    u6 = v66;

    if not (u4 and u6) then
        return;
    end;

    u5 = u4:FindFirstChildOfClass("Animator");

    if not u5 then
        u5 = Instance.new("Animator");
        u5.Parent = u4;
    end;

    loadAnimations();
    local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");
    local v67 = u14;

    if not v67 then
        if ClashUI then
            v67 = ClashUI:GetAttribute("ActiveClashId");
        else
            v67 = ClashUI;
        end;
    end;

    local v68 = typeof(v67) == "string";

    if v68 then
        u12 = true;
        u14 = v67;

        if ClashUI then
            ClashUI.Enabled = true;
        end;

        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.05);
        end;
    else
        u8 = false;
        u10 = false;
        u11 = false;
        u12 = false;
        u13 = false;
        u14 = nil;
        destroyClashUI();
        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.05);
        end;

        local ClashLoop = u15.ClashLoop;

        if ClashLoop and ClashLoop.IsPlaying then
            ClashLoop:Stop(0.05);
        end;
    end;

    u7 = true;
    CombatEvent:FireServer("Equip", true);

    if not v68 then
        local Equip = u15.Equip;

        if Equip and not Equip.IsPlaying then
            Equip:Play(0.05);
        end;
    end;
end;

local function onUnequipped() -- Line: 294
    -- upvalues: u7 (ref), u8 (ref), BlockEvent (copy), CombatEvent (copy), LocalPlayer (copy), u14 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref), u15 (copy), u13 (ref), destroyClashUI (copy), clearTracks (copy)
    if not u7 then
        return;
    end;

    if u8 then
        BlockEvent:FireServer(false);
    end;

    u7 = false;
    CombatEvent:FireServer("Equip", false);

    local function preserveActiveClash() -- Line: 304
        -- upvalues: LocalPlayer (ref), u14 (ref), u8 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref), u15 (ref)
        local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");
        local v69 = u14;

        if not v69 then
            if ClashUI then
                v69 = ClashUI:GetAttribute("ActiveClashId");
            else
                v69 = ClashUI;
            end;
        end;

        local v70 = u3 and u3:FindFirstChild("IsBlocking");
        local v71 = v70 and v70:IsA("BoolValue") and v70.Value == true;
        u8 = v71;
        local v72 = u3 and u3:FindFirstChild("IsStunned");
        local v73 = v72 and v72:IsA("BoolValue") and v72.Value == true;
        u10 = v73;
        local v74 = u3 and u3:FindFirstChild("IsGuardBroken");
        local v75 = v74 and v74:IsA("BoolValue") and v74.Value == true;
        u11 = v75;
        local v76 = u3 and u3:FindFirstChild("IsAttacking");
        local v77 = v76 and v76:IsA("BoolValue") and v76.Value == true;
        u9 = v77;
        local v78 = u3 and u3:FindFirstChild("IsInClash");
        local v79 = v78 and v78:IsA("BoolValue") and v78.Value == true;
        u12 = v79;

        if not u12 and typeof(v69) ~= "string" then
            return false;
        end;

        u12 = true;
        u14 = v69;
        u8 = false;

        if ClashUI then
            ClashUI.Enabled = true;
        end;

        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.05);
        end;

        return true;
    end;

    if preserveActiveClash() then
        return;
    end;

    task.delay(0.15, function() -- Line: 323
        -- upvalues: u7 (ref), preserveActiveClash (copy), u8 (ref), u10 (ref), u11 (ref), u12 (ref), u13 (ref), u14 (ref), destroyClashUI (ref), u15 (ref), clearTracks (ref)
        if u7 or preserveActiveClash() then
            return;
        end;

        u8 = false;
        u10 = false;
        u11 = false;
        u12 = false;
        u13 = false;
        u14 = nil;
        destroyClashUI();
        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.05);
        end;

        local ClashLoop = u15.ClashLoop;

        if ClashLoop and ClashLoop.IsPlaying then
            ClashLoop:Stop(0.05);
        end;

        clearTracks();
    end);
end;

local function syncEquippedFromTool() -- Line: 330
    -- upvalues: LocalPlayer (copy), u1 (ref), u7 (ref), onEquipped (copy)
    local Character = LocalPlayer.Character;

    if not (u1 and (Character and u1.Parent == Character)) then
        return false;
    end;

    if not u7 then
        onEquipped();
    end;

    return u7;
end;

local u80 = nil;

local function bindTool(u81) -- Line: 343
    -- upvalues: u1 (ref), u7 (ref), onUnequipped (copy), disconnectToolConnections (copy), u2 (copy), onEquipped (copy), u80 (ref), LocalPlayer (copy)
    if not (u81 and (u81:IsA("Tool") and u81.Name == "Fists")) then
        return;
    end;

    if u81 == u1 then
        return;
    end;

    if u7 then
        onUnequipped();
    end;

    disconnectToolConnections();
    u1 = u81;
    table.insert(u2, u1.Equipped:Connect(onEquipped));
    table.insert(u2, u1.Unequipped:Connect(onUnequipped));
    table.insert(u2, u1.Activated:Connect(function() -- Line: 355
        -- upvalues: u80 (ref)
        if u80 then
            u80();
        end;
    end));
    table.insert(u2, u1.AncestryChanged:Connect(function(p82, p83) -- Line: 360
        -- upvalues: u1 (ref), u81 (copy), onUnequipped (ref)
        if p83 == nil and u1 == u81 then
            onUnequipped();
            u1 = nil;
        end;
    end));

    if u1.Parent == LocalPlayer.Character then
        task.defer(onEquipped);
    end;
end;

local function findFists() -- Line: 372
    -- upvalues: LocalPlayer (copy), bindTool (copy)
    local Character = LocalPlayer.Character;
    local Backpack = LocalPlayer:FindFirstChild("Backpack");

    if Character then
        Character = Character:FindFirstChild("Fists");
    end;

    if not Character and Backpack then
        Character = Backpack:FindFirstChild("Fists");
    end;

    if Character then
        bindTool(Character);
    end;
end;

u80 = function() -- Line: 384
    -- upvalues: LocalPlayer (copy), u1 (ref), u7 (ref), onEquipped (copy), canAct (copy), CombatConfig (copy), u18 (ref), u15 (copy), u20 (ref), u19 (ref), u21 (ref), u22 (ref), u9 (ref), CombatEvent (copy), u8 (ref), u3 (ref), u10 (ref), u11 (ref), u12 (ref)
    local Character = LocalPlayer.Character;

    if u1 and (Character and (u1.Parent == Character and not u7)) then
        onEquipped();
    end;

    if canAct() then
        local M1StaminaCost = CombatConfig.M1StaminaCost;
        local v84 = tonumber(LocalPlayer:GetAttribute("Stamina")) or 0;
        local v85;

        if M1StaminaCost <= v84 then
            v85 = CombatConfig.MinStaminaToAct <= v84;
        else
            v85 = false;
        end;

        if v85 then
            if os.clock() - u18 < CombatConfig.M1Cooldown then
                return;
            end;

            u18 = os.clock();
            local Walk = u15.Walk;

            if Walk and Walk.IsPlaying then
                Walk:Stop(0.1);
            end;

            local Run = u15.Run;

            if Run and Run.IsPlaying then
                Run:Stop(0.1);
            end;

            local v86 = u20;
            u20 = u20 == 1 and 2 or 1;
            local u87;

            if v86 == 1 then
                u87 = "Punch1";
            else
                u19 = not u19;
                u87 = u19 and "Punch2" or "Punch2Alt";
            end;

            u21 = u87;
            u22 = os.clock();
            local u88 = u22;
            u9 = true;
            local Punch1 = u15.Punch1;

            if Punch1 and Punch1.IsPlaying then
                Punch1:Stop(0.05);
            end;

            local Punch2 = u15.Punch2;

            if Punch2 and Punch2.IsPlaying then
                Punch2:Stop(0.05);
            end;

            local Punch2Alt = u15.Punch2Alt;

            if Punch2Alt and Punch2Alt.IsPlaying then
                Punch2Alt:Stop(0.05);
            end;

            local Heavy = u15.Heavy;

            if Heavy and Heavy.IsPlaying then
                Heavy:Stop(0.05);
            end;

            local v89 = u15[u87];

            if v89 and not v89.IsPlaying then
                v89:Play(0.03);
            end;

            CombatEvent:FireServer("M1", workspace:GetServerTimeNow());
            task.delay(0.7, function() -- Line: 416
                -- upvalues: u21 (ref), u87 (ref), u22 (ref), u88 (copy), u15 (ref), u8 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref)
                if u21 == u87 and u22 == u88 then
                    u21 = nil;
                    local Punch12 = u15.Punch1;

                    if Punch12 and Punch12.IsPlaying then
                        Punch12:Stop(0.05);
                    end;

                    local Punch22 = u15.Punch2;

                    if Punch22 and Punch22.IsPlaying then
                        Punch22:Stop(0.05);
                    end;

                    local Punch2Alt2 = u15.Punch2Alt;

                    if Punch2Alt2 and Punch2Alt2.IsPlaying then
                        Punch2Alt2:Stop(0.05);
                    end;

                    local Heavy2 = u15.Heavy;

                    if Heavy2 and Heavy2.IsPlaying then
                        Heavy2:Stop(0.05);
                    end;

                    local v90 = u3 and u3:FindFirstChild("IsBlocking");
                    local v91 = v90 and v90:IsA("BoolValue") and v90.Value == true;
                    u8 = v91;
                    local v92 = u3 and u3:FindFirstChild("IsStunned");
                    local v93 = v92 and v92:IsA("BoolValue") and v92.Value == true;
                    u10 = v93;
                    local v94 = u3 and u3:FindFirstChild("IsGuardBroken");
                    local v95 = v94 and v94:IsA("BoolValue") and v94.Value == true;
                    u11 = v95;
                    local v96 = u3 and u3:FindFirstChild("IsAttacking");
                    local v97 = v96 and v96:IsA("BoolValue") and v96.Value == true;
                    u9 = v97;
                    local v98 = u3 and u3:FindFirstChild("IsInClash");
                    local v99 = v98 and v98:IsA("BoolValue") and v98.Value == true;
                    u12 = v99;
                end;
            end);
        end;
    end;
end;

local function startBlock() -- Line: 425
    -- upvalues: LocalPlayer (copy), u1 (ref), u7 (ref), onEquipped (copy), u8 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref), u13 (ref), CombatConfig (copy), BlockEvent (copy), u15 (copy)
    local Character = LocalPlayer.Character;

    if u1 and (Character and (u1.Parent == Character and not u7)) then
        onEquipped();
    end;

    if not u7 then
        return;
    end;

    local v100 = u3 and u3:FindFirstChild("IsBlocking");
    local v101 = v100 and v100:IsA("BoolValue") and v100.Value == true;
    u8 = v101;
    local v102 = u3 and u3:FindFirstChild("IsStunned");
    local v103 = v102 and v102:IsA("BoolValue") and v102.Value == true;
    u10 = v103;
    local v104 = u3 and u3:FindFirstChild("IsGuardBroken");
    local v105 = v104 and v104:IsA("BoolValue") and v104.Value == true;
    u11 = v105;
    local v106 = u3 and u3:FindFirstChild("IsAttacking");
    local v107 = v106 and v106:IsA("BoolValue") and v106.Value == true;
    u9 = v107;
    local v108 = u3 and u3:FindFirstChild("IsInClash");
    local v109 = v108 and v108:IsA("BoolValue") and v108.Value == true;
    u12 = v109;

    if u9 or (u11 or (u12 or u13)) then
        return;
    end;

    if u10 then
        local v110 = u3 and u3:FindFirstChild("CanBlockWhileStunned");
        local v111 = v110 and v110:IsA("BoolValue") and v110.Value == true;

        if not v111 then
            return;
        end;
    end;

    local MinStaminaToAct = CombatConfig.MinStaminaToAct;
    local v112 = tonumber(LocalPlayer:GetAttribute("Stamina")) or 0;
    local v113;

    if MinStaminaToAct <= v112 then
        v113 = CombatConfig.MinStaminaToAct <= v112;
    else
        v113 = false;
    end;

    if not v113 then
        return;
    end;

    u8 = true;
    BlockEvent:FireServer(true);
    local Walk = u15.Walk;

    if Walk and Walk.IsPlaying then
        Walk:Stop(0.1);
    end;

    local Run = u15.Run;

    if Run and Run.IsPlaying then
        Run:Stop(0.1);
    end;

    local Block = u15.Block;

    if not Block or Block.IsPlaying then
        return;
    end;

    Block:Play(0.08);
end;

local function stopBlock() -- Line: 438
    -- upvalues: u8 (ref), BlockEvent (copy), u15 (copy)
    if not u8 then
        return;
    end;

    u8 = false;
    BlockEvent:FireServer(false);
    local Block = u15.Block;

    if Block and Block.IsPlaying then
        Block:Stop(0.1);
    end;
end;

local function sendClashPress() -- Line: 445
    -- upvalues: LocalPlayer (copy), u14 (ref), u12 (ref), ClashEvent (copy)
    local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");
    local v114 = u14;

    if not v114 then
        if ClashUI then
            v114 = ClashUI:GetAttribute("ActiveClashId");
        else
            v114 = ClashUI;
        end;
    end;

    if typeof(v114) ~= "string" then
        return false;
    end;

    u14 = v114;
    u12 = true;

    if ClashUI then
        ClashUI:SetAttribute("LocalPressCount", (tonumber(ClashUI:GetAttribute("LocalPressCount")) or 0) + 1);
    end;

    ClashEvent:FireServer("ButtonPress", v114);

    return true;
end;

UserInputService.InputBegan:Connect(function(p115, p116) -- Line: 459
    -- upvalues: UserInputService (copy), sendClashPress (copy), u7 (ref), u80 (ref), startBlock (copy)
    if (p115.UserInputType == Enum.UserInputType.MouseButton1 or UserInputService.TouchEnabled and p115.UserInputType == Enum.UserInputType.Touch) and sendClashPress() then
        return;
    end;

    if not u7 then
        return;
    end;

    if p116 then
        return;
    end;

    local v117;

    if p115.UserInputType == Enum.UserInputType.MouseButton1 then
        v117 = true;
    else
        v117 = UserInputService.TouchEnabled and p115.UserInputType == Enum.UserInputType.Touch;
    end;

    local v118 = p115.UserInputType == Enum.UserInputType.MouseButton2;

    if v117 then
        u80();

        return;
    end;

    if v118 then
        startBlock();
    end;
end);
UserInputService.InputEnded:Connect(function(p119) -- Line: 480
    -- upvalues: u8 (ref), BlockEvent (copy), u15 (copy)
    if p119.UserInputType == Enum.UserInputType.MouseButton2 then
        if not u8 then
            return;
        end;

        u8 = false;
        BlockEvent:FireServer(false);
        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.1);
        end;
    end;
end);

local function gamepadBlockAction(p120, p121) -- Line: 501
    -- upvalues: LocalPlayer (copy), u1 (ref), u7 (ref), onEquipped (copy), startBlock (copy), u8 (ref), BlockEvent (copy), u15 (copy)
    local Character = LocalPlayer.Character;

    if u1 and (Character and (u1.Parent == Character and not u7)) then
        onEquipped();
    end;

    if not u7 then
        return Enum.ContextActionResult.Pass;
    end;

    if p121 == Enum.UserInputState.Begin then
        startBlock();
    elseif (p121 == Enum.UserInputState.End or p121 == Enum.UserInputState.Cancel) and u8 then
        u8 = false;
        BlockEvent:FireServer(false);
        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.1);
        end;
    end;

    return Enum.ContextActionResult.Sink;
end;

ContextActionService:BindActionAtPriority("ArczisFistsGamepadAttack", function(p122, p123) -- Line: 486, Name: gamepadAttackAction
    -- upvalues: sendClashPress (copy), LocalPlayer (copy), u1 (ref), u7 (ref), onEquipped (copy), u80 (ref)
    if p123 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Sink;
    end;

    if sendClashPress() then
        return Enum.ContextActionResult.Sink;
    end;

    local Character = LocalPlayer.Character;

    if u1 and (Character and (u1.Parent == Character and not u7)) then
        onEquipped();
    end;

    if not u7 then
        return Enum.ContextActionResult.Pass;
    end;

    u80();

    return Enum.ContextActionResult.Sink;
end, false, 3000, Enum.KeyCode.ButtonR2);
ContextActionService:BindActionAtPriority("ArczisFistsGamepadBlock", gamepadBlockAction, false, 3000, Enum.KeyCode.ButtonL2);
ContextActionService:BindActionAtPriority("ArczisClashGamepadPress", function(p124, p125) -- Line: 514, Name: gamepadClashAction
    -- upvalues: sendClashPress (copy)
    if p125 == Enum.UserInputState.Begin and sendClashPress() then
        return Enum.ContextActionResult.Sink;
    end;

    return Enum.ContextActionResult.Pass;
end, false, 4000, Enum.KeyCode.ButtonA);

local function playPunchHitEffect(p126, p127) -- Line: 543
    -- upvalues: ReplicatedStorage (copy), Debris (copy)
    if typeof(p126) ~= "Vector3" or typeof(p127) ~= "Vector3" then
        return;
    end;

    local Efeitos = ReplicatedStorage:FindFirstChild("Efeitos");

    if Efeitos then
        Efeitos = Efeitos:FindFirstChild("Hit");
    end;

    if Efeitos then
        Efeitos = Efeitos:FindFirstChild("Hit");
    end;

    if not (Efeitos and Efeitos:IsA("BasePart")) then
        return;
    end;

    local v128 = p127.Magnitude > 0.001 and p127.Unit or Vector3.new(0, 0, -1);
    local v129 = Efeitos:Clone();
    v129.Name = "PunchHitEffect";
    v129.Anchored = true;
    v129.CanCollide = false;
    v129.CanTouch = false;
    v129.CanQuery = false;
    v129.CFrame = CFrame.lookAt(p126, p126 + v128);
    v129.Parent = workspace;
    local v130 = 0;

    for _, descendant in ipairs(v129:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            local v131 = tonumber(descendant:GetAttribute("EmitCount")) or 5;
            local math_max_ret = math.max(1, v131);
            local v132 = tonumber(descendant:GetAttribute("EmitDelay")) or 0;
            local math_max_ret2 = math.max(0, v132);
            v130 = math.max(v130, math_max_ret2 + descendant.Lifetime.Max);

            if math_max_ret2 > 0 then
                task.delay(math_max_ret2, function() -- Line: 568
                    -- upvalues: descendant (copy), math_max_ret (copy)
                    if descendant.Parent then
                        descendant:Emit(math_max_ret);
                    end;
                end);
            else
                descendant:Emit(math_max_ret);
            end;
        end;
    end;

    Debris:AddItem(v129, (math.max(0.15, v130 + 0.1)));
end;

CombatEvent.OnClientEvent:Connect(function(p133, p134, p135) -- Line: 580
    -- upvalues: playPunchHitEffect (copy), u7 (ref), u9 (ref), u15 (copy), u19 (ref), u20 (ref), u21 (ref), u22 (ref)
    if p133 == "HitEffect" then
        playPunchHitEffect(p134, p135);

        return;
    end;

    if not u7 then
        return;
    end;

    if p133 ~= "PlayAttack" then
        if p133 == "NoStamina" then
            u20 = u20 == 1 and 2 or 1;
            u21 = nil;
            local Punch1 = u15.Punch1;

            if Punch1 and Punch1.IsPlaying then
                Punch1:Stop(0.05);
            end;

            local Punch2 = u15.Punch2;

            if Punch2 and Punch2.IsPlaying then
                Punch2:Stop(0.05);
            end;

            local Punch2Alt = u15.Punch2Alt;

            if Punch2Alt and Punch2Alt.IsPlaying then
                Punch2Alt:Stop(0.05);
            end;

            local Heavy = u15.Heavy;

            if Heavy and Heavy.IsPlaying then
                Heavy:Stop(0.05);
            end;

            u9 = false;
        end;

        return;
    end;

    u9 = true;
    local Block = u15.Block;

    if Block and Block.IsPlaying then
        Block:Stop(0.05);
    end;

    local Walk = u15.Walk;

    if Walk and Walk.IsPlaying then
        Walk:Stop(0.1);
    end;

    local Run = u15.Run;

    if Run and Run.IsPlaying then
        Run:Stop(0.1);
    end;

    local v136 = (p134 == "Heavy" or p134 == "SuperPunch") and "Heavy" or (p135 == 1 and "Punch1" or (u19 and "Punch2" or "Punch2Alt"));
    u20 = p135 == 1 and 2 or 1;
    local v137;

    if u21 == nil then
        v137 = false;
    else
        v137 = os.clock() - u22 <= 0.45;
    end;

    if v137 and (p134 ~= "SuperPunch" and v136 == u21) then
        u21 = nil;

        return;
    end;

    local Punch1 = u15.Punch1;

    if Punch1 and Punch1.IsPlaying then
        Punch1:Stop(0.05);
    end;

    local Punch2 = u15.Punch2;

    if Punch2 and Punch2.IsPlaying then
        Punch2:Stop(0.05);
    end;

    local Punch2Alt = u15.Punch2Alt;

    if Punch2Alt and Punch2Alt.IsPlaying then
        Punch2Alt:Stop(0.05);
    end;

    local Heavy = u15.Heavy;

    if Heavy and Heavy.IsPlaying then
        Heavy:Stop(0.05);
    end;

    local v138 = u15[v136];

    if v138 and not v138.IsPlaying then
        v138:Play(0.03);
    end;

    u21 = nil;
end);
BlockEvent.OnClientEvent:Connect(function(p139) -- Line: 618
    -- upvalues: u7 (ref), u8 (ref), u11 (ref), u10 (ref), u15 (copy)
    if not u7 then
        return;
    end;

    if p139 == "GuardBreak" then
        u8 = false;
        u11 = true;
        u10 = true;
        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.03);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local GuardBreak = u15.GuardBreak;

        if GuardBreak and not GuardBreak.IsPlaying then
            GuardBreak:Play(0.03);
        end;
    elseif p139 == "NoStamina" or (p139 == "GuardBroken" or p139 == "CannotBlock") then
        u8 = false;
        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.1);
        end;
    end;
end);
ClashEvent.OnClientEvent:Connect(function(p140, p141, p142, p143) -- Line: 633
    -- upvalues: StarterGui (copy), u3 (ref), LocalPlayer (copy), u4 (ref), u6 (ref), u5 (ref), u15 (copy), loadTrack (copy), CombatConfig (copy), u12 (ref), u14 (ref), createClashUI (copy), updateClashUI (copy), u13 (ref), destroyClashUI (copy), u10 (ref), u8 (ref), u11 (ref)
    if p140 == "ClashStart" then
        pcall(function() -- Line: 635
            -- upvalues: StarterGui (ref)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
        end);
        u3 = LocalPlayer.Character;
        local v144 = u3 and u3:FindFirstChildOfClass("Humanoid");
        u4 = v144;
        local v145 = u3 and u3:FindFirstChild("HumanoidRootPart");
        u6 = v145;

        if u4 then
            u5 = u4:FindFirstChildOfClass("Animator") or u4:FindFirstChild("Animator");

            if u5 and not u15.ClashLoop then
                loadTrack("ClashLoop", CombatConfig.Animations.ClashLoop, Enum.AnimationPriority.Action4, true);
                loadTrack("ClashWin", CombatConfig.Animations.ClashWin, Enum.AnimationPriority.Action4, false);
            end;
        end;

        u12 = true;
        u14 = p142;
        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        local Punch1 = u15.Punch1;

        if Punch1 and Punch1.IsPlaying then
            Punch1:Stop(0.05);
        end;

        local Punch2 = u15.Punch2;

        if Punch2 and Punch2.IsPlaying then
            Punch2:Stop(0.05);
        end;

        local Punch2Alt = u15.Punch2Alt;

        if Punch2Alt and Punch2Alt.IsPlaying then
            Punch2Alt:Stop(0.05);
        end;

        local Heavy = u15.Heavy;

        if Heavy and Heavy.IsPlaying then
            Heavy:Stop(0.05);
        end;

        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.03);
        end;

        local ClashLoop = u15.ClashLoop;

        if ClashLoop and not ClashLoop.IsPlaying then
            ClashLoop:Play(0.03);
        end;

        createClashUI();
        local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

        if ClashUI then
            ClashUI:SetAttribute("ActiveClashId", u14);
            ClashUI:SetAttribute("LocalPressCount", 0);
        end;
    else
        if p140 == "UpdatePresses" then
            updateClashUI(p141 or 0, p142 or 0, p143);

            return;
        end;

        if p140 == "ClashWin" then
            pcall(function() -- Line: 662
                -- upvalues: StarterGui (ref)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
            end);
            u12 = false;
            u13 = true;
            u14 = nil;
            local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

            if ClashUI then
                ClashUI:SetAttribute("ActiveClashId", nil);
            end;

            local ClashLoop = u15.ClashLoop;

            if ClashLoop and ClashLoop.IsPlaying then
                ClashLoop:Stop(0.03);
            end;

            local ClashWin = u15.ClashWin;

            if ClashWin and not ClashWin.IsPlaying then
                ClashWin:Play(0.03);
            end;

            local ClashUI2 = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("CombatStats");
            end;

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("Barra");
            end;

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("TextLabel");
            end;

            if ClashUI2 then
                ClashUI2.Text = "YOU WIN!";
            end;

            task.delay(CombatConfig.ClashWinPunchDelay + 0.4, function() -- Line: 675
                -- upvalues: u13 (ref)
                u13 = false;
            end);
            task.delay(1, destroyClashUI);

            return;
        end;

        if p140 == "ClashLose" then
            pcall(function() -- Line: 680
                -- upvalues: StarterGui (ref)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
            end);
            u12 = false;
            u10 = true;
            u14 = nil;
            local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

            if ClashUI then
                ClashUI:SetAttribute("ActiveClashId", nil);
            end;

            local ClashLoop = u15.ClashLoop;

            if ClashLoop and ClashLoop.IsPlaying then
                ClashLoop:Stop(0.03);
            end;

            local ClashUI2 = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("CombatStats");
            end;

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("Barra");
            end;

            if ClashUI2 then
                ClashUI2 = ClashUI2:FindFirstChild("TextLabel");
            end;

            if ClashUI2 then
                ClashUI2.Text = "YOU LOSE!";
            end;

            task.delay(1, destroyClashUI);

            return;
        end;

        if p140 == "ClashCancel" then
            pcall(function() -- Line: 694
                -- upvalues: StarterGui (ref)
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
            end);
            local ClashUI = LocalPlayer.PlayerGui:FindFirstChild("ClashUI");

            if ClashUI then
                ClashUI:SetAttribute("ActiveClashId", nil);
            end;

            u8 = false;
            u10 = false;
            u11 = false;
            u12 = false;
            u13 = false;
            u14 = nil;
            destroyClashUI();
            local Walk = u15.Walk;

            if Walk and Walk.IsPlaying then
                Walk:Stop(0.1);
            end;

            local Run = u15.Run;

            if Run and Run.IsPlaying then
                Run:Stop(0.1);
            end;

            local Punch1 = u15.Punch1;

            if Punch1 and Punch1.IsPlaying then
                Punch1:Stop(0.05);
            end;

            local Punch2 = u15.Punch2;

            if Punch2 and Punch2.IsPlaying then
                Punch2:Stop(0.05);
            end;

            local Punch2Alt = u15.Punch2Alt;

            if Punch2Alt and Punch2Alt.IsPlaying then
                Punch2Alt:Stop(0.05);
            end;

            local Heavy = u15.Heavy;

            if Heavy and Heavy.IsPlaying then
                Heavy:Stop(0.05);
            end;

            local Block = u15.Block;

            if Block and Block.IsPlaying then
                Block:Stop(0.05);
            end;

            local ClashLoop = u15.ClashLoop;

            if ClashLoop and ClashLoop.IsPlaying then
                ClashLoop:Stop(0.05);
            end;
        end;
    end;
end);
RunService.RenderStepped:Connect(function() -- Line: 701
    -- upvalues: u7 (ref), u4 (ref), u6 (ref), u8 (ref), u3 (ref), u10 (ref), u11 (ref), u9 (ref), u12 (ref), u13 (ref), u15 (copy), LocalPlayer (copy)
    if not (u7 and (u4 and u6)) then
        return;
    end;

    local v146 = u3 and u3:FindFirstChild("IsBlocking");
    local v147 = v146 and v146:IsA("BoolValue") and v146.Value == true;
    u8 = v147;
    local v148 = u3 and u3:FindFirstChild("IsStunned");
    local v149 = v148 and v148:IsA("BoolValue") and v148.Value == true;
    u10 = v149;
    local v150 = u3 and u3:FindFirstChild("IsGuardBroken");
    local v151 = v150 and v150:IsA("BoolValue") and v150.Value == true;
    u11 = v151;
    local v152 = u3 and u3:FindFirstChild("IsAttacking");
    local v153 = v152 and v152:IsA("BoolValue") and v152.Value == true;
    u9 = v153;
    local v154 = u3 and u3:FindFirstChild("IsInClash");
    local v155 = v154 and v154:IsA("BoolValue") and v154.Value == true;
    u12 = v155;

    if u9 or (u10 or (u11 or (u12 or u13))) then
        local Walk = u15.Walk;

        if Walk and Walk.IsPlaying then
            Walk:Stop(0.1);
        end;

        local Run = u15.Run;

        if Run and Run.IsPlaying then
            Run:Stop(0.1);
        end;

        return;
    end;

    if not u8 then
        local Block = u15.Block;

        if Block and Block.IsPlaying then
            Block:Stop(0.08);
        end;

        local AssemblyLinearVelocity = u6.AssemblyLinearVelocity;

        if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude <= 1 then
            local Walk = u15.Walk;

            if Walk and Walk.IsPlaying then
                Walk:Stop(0.1);
            end;

            local Run = u15.Run;

            if Run and Run.IsPlaying then
                Run:Stop(0.1);

                return;
            end;
        elseif LocalPlayer:GetAttribute("IsSprinting") == true then
            local Walk = u15.Walk;

            if Walk and Walk.IsPlaying then
                Walk:Stop(0.08);
            end;

            local Run = u15.Run;

            if Run and not Run.IsPlaying then
                Run:Play(0.12);

                return;
            end;
        else
            local Run = u15.Run;

            if Run and Run.IsPlaying then
                Run:Stop(0.08);
            end;

            local Walk = u15.Walk;

            if Walk and not Walk.IsPlaying then
                Walk:Play(0.12);

                return;
            end;
        end;

        return;
    end;

    local Walk = u15.Walk;

    if Walk and Walk.IsPlaying then
        Walk:Stop(0.1);
    end;

    local Run = u15.Run;

    if Run and Run.IsPlaying then
        Run:Stop(0.1);
    end;

    local Block = u15.Block;

    if not Block or Block.IsPlaying then
        return;
    end;

    Block:Play(0.08);
end);

local function watchCharacter(p156) -- Line: 727
    -- upvalues: bindTool (copy), findFists (copy)
    p156.ChildAdded:Connect(function(p157) -- Line: 728
        -- upvalues: bindTool (ref)
        if p157:IsA("Tool") and p157.Name == "Fists" then
            bindTool(p157);
        end;
    end);
    task.defer(findFists);
end;

local function watchBackpack(p158) -- Line: 736
    -- upvalues: bindTool (copy), findFists (copy)
    p158.ChildAdded:Connect(function(p159) -- Line: 737
        -- upvalues: bindTool (ref)
        if p159:IsA("Tool") and p159.Name == "Fists" then
            bindTool(p159);
        end;
    end);
    task.defer(findFists);
end;

LocalPlayer.CharacterAdded:Connect(function(p160) -- Line: 745
    -- upvalues: u7 (ref), onUnequipped (copy), u3 (ref), bindTool (copy), findFists (copy)
    if u7 then
        onUnequipped();
    end;

    u3 = p160;
    p160.ChildAdded:Connect(function(p161) -- Line: 728
        -- upvalues: bindTool (ref)
        if p161:IsA("Tool") and p161.Name == "Fists" then
            bindTool(p161);
        end;
    end);
    task.defer(findFists);
end);
LocalPlayer.ChildAdded:Connect(function(p162) -- Line: 753
    -- upvalues: bindTool (copy), findFists (copy)
    if p162:IsA("Backpack") then
        p162.ChildAdded:Connect(function(p163) -- Line: 737
            -- upvalues: bindTool (ref)
            if p163:IsA("Tool") and p163.Name == "Fists" then
                bindTool(p163);
            end;
        end);
        task.defer(findFists);
    end;
end);

if LocalPlayer.Character then
    u3 = LocalPlayer.Character;
    u3.ChildAdded:Connect(function(p164) -- Line: 728
        -- upvalues: bindTool (copy)
        if p164:IsA("Tool") and p164.Name == "Fists" then
            bindTool(p164);
        end;
    end);
    task.defer(findFists);
end;

local v165 = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack", 5);

if v165 then
    v165.ChildAdded:Connect(function(p166) -- Line: 737
        -- upvalues: bindTool (copy)
        if p166:IsA("Tool") and p166.Name == "Fists" then
            bindTool(p166);
        end;
    end);
    task.defer(findFists);
end;

local Character = LocalPlayer.Character;
local Backpack = LocalPlayer:FindFirstChild("Backpack");

if Character then
    Character = Character:FindFirstChild("Fists");
end;

if not Character and Backpack then
    Character = Backpack:FindFirstChild("Fists");
end;

if Character then
    bindTool(Character);
end;