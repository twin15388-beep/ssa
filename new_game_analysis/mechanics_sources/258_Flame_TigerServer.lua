-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local gameSettings = require(CAM.Global.gameSettings);
local Combat_presets = require(CAM.Global.Combat_presets);
local DebrisModule = require(CAM.DebrisModule);
local Combat_Util = require(SAM.Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(Config.HEAD_ACCEL_TIME, Enum.EasingStyle.Sine);
local TweenInfo_new_ret2 = TweenInfo.new(Config.HEAD_DECEL_TIME, Enum.EasingStyle.Sine);
local u2 = {
    Id = {}
};

function u2.Hold(u3: userdata, p4: vector, p5: table) -- Line: 33
    -- upvalues: EffectsEvent (copy), u2 (copy), Config (copy), Combat_Util (copy), Combat_presets (copy), Utility (copy), Checker (copy), u1 (copy), ImpactSounds (copy), DebrisModule (copy)
    local Character = u3.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    EffectsEvent.ToAllInRange(u3, "Flame Tiger TapVFX", Character, "Start");
    local u6 = u2.Id[u3.UserId];
    p5.startClock = os.clock();
    task.delay(Config.HOLD_DURATION, function() -- Line: 42
        -- upvalues: u2 (ref), u3 (copy), u6 (copy), Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), EffectsEvent (ref), Combat_presets (ref), Utility (ref), Checker (ref), u1 (ref), ImpactSounds (ref), DebrisModule (ref)
        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        local function v11(p7: userdata, p8: any, p9: any) -- Line: 45
            -- upvalues: Combat_Util (ref), Character (ref), Config (ref), RootPart (ref), EffectsEvent (ref), u3 (ref), Combat_presets (ref)
            if p7 then
                local Humanoid = p7:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid.RootPart;

                if p9 == "Blocking" then
                    Combat_Util.Block(script, Character, p7, Config.SLASH_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.LookVector * Config.BLOCKED_KNOCKBACK, 0.4);

                    return;
                end;

                if p9 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p7);

                    return true;
                end;

                if p9 == true then
                    local v10 = RootPart.CFrame.LookVector * Config.SLASH_KNOCKBACK;
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p8, Config.SLASH_STUN);
                    Combat_Util.Damage(script, Character, p7, {
                        Base = Config.SLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, vector.create(v10.X, v10.Y == 0 and 0.1 or v10.Y, v10.Z), 2);
                    Combat_presets.PlayReactAnim(Humanoid);
                end;
            end;
        end;

        local function v16(p12: userdata, p13: any, p14: any) -- Line: 68
            -- upvalues: Combat_Util (ref), Character (ref), Config (ref), RootPart (ref), EffectsEvent (ref), u3 (ref)
            if p12 then
                local RootPart2 = p12:FindFirstChild("Humanoid").RootPart;

                if p14 == "Blocking" then
                    Combat_Util.Block(script, Character, p12, Config.IMPACT_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.LookVector * Config.BLOCKED_KNOCKBACK, 0.4);

                    return;
                end;

                if p14 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p12);

                    return true;
                end;

                if p14 == true then
                    local v15 = RootPart.CFrame.LookVector * Config.IMPACT_KNOCKBACK + vector.create(0, Config.IMPACT_KNOCKUP, 0);
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p13, Config.IMPACT_STUN);
                    Combat_Util.Damage(script, Character, p12, {
                        Base = Config.IMPACT_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v15, 0.4);
                    Combat_Util.RagDoll(script:GetDescendants(), Character, p13, Config.IMPACT_RAGDOLL);
                end;
            end;
        end;

        task.wait(Config.SLASH1_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Slash", 1);
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.SLASH_HITBOX_OFFSET,
            hitboxSize = Config.SLASH_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v11,

            After = function(p17, p18) -- Line: 105, Name: After
                -- upvalues: ImpactSounds (ref), Character (ref)
                if p17 then
                    ImpactSounds.Play(Character, script.Parent.Name, p18[1]);
                end;
            end
        });
        task.wait(Config.SLASH2_AT - Config.SLASH1_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Slash", 2);
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.SLASH_HITBOX_OFFSET,
            hitboxSize = Config.SLASH_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v11,

            After = function(p19, p20) -- Line: 122, Name: After
                -- upvalues: ImpactSounds (ref), Character (ref)
                if p19 then
                    ImpactSounds.Play(Character, script.Parent.Name, p20[1]);
                end;
            end
        });
        task.wait(Config.SLASH3_AT - Config.SLASH2_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Slash", 3);
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.SLASH_HITBOX_OFFSET,
            hitboxSize = Config.SLASH_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v11,

            After = function(p21, p22) -- Line: 138, Name: After
                -- upvalues: ImpactSounds (ref), Character (ref)
                if p21 then
                    ImpactSounds.Play(Character, script.Parent.Name, p22[1]);
                end;
            end
        });
        task.wait(Config.SLASH4_AT - Config.SLASH3_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Slash", 4);
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.SLASH_HITBOX_OFFSET,
            hitboxSize = Config.SLASH_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v11,

            After = function(p23, p24) -- Line: 154, Name: After
                -- upvalues: ImpactSounds (ref), Character (ref)
                if p23 then
                    ImpactSounds.Play(Character, script.Parent.Name, p24[1]);
                end;
            end
        });
        task.wait(Config.HEAD_AT - Config.SLASH4_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        local v25 = script.TigerHead:Clone();
        v25.Parent = workspace.Debree;
        v25.TouchPart:Destroy();
        v25.Name = `{Character.Name}'s Flame Tiger Head`;
        local Weld = Instance.new("Weld", v25.RootPart);
        Weld.Part0 = RootPart;
        Weld.Part1 = v25.RootPart;
        Weld.C1 = CFrame.Angles(0, 3.141592653589793, 0);
        v25.AnimationController.Animator:LoadAnimation(script.FinalHeadANim):Play(nil, nil, 1.95);
        DebrisModule:AddItem(v25, Config.HOLD_HEAD_LIFETIME);
        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Jump", nil, v25);
        task.wait(Config.SLAM_AT - Config.HEAD_AT);

        if u2.Id[u3.UserId] ~= u6 then
            return;
        end;

        EffectsEvent.ToAllInRange(u3, "Flame Tiger HoldVFX", Character, "Slam", nil, nil, RootPart.CFrame * Config.IMPACT_VFX_OFFSET);
        Utility.CreateHitbox({
            TreeDestruction = true,
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.IMPACT_HITBOX_OFFSET,
            hitboxSize = Config.IMPACT_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v16,

            After = function(p26, p27) -- Line: 186, Name: After
                -- upvalues: ImpactSounds (ref), Character (ref)
                if p26 then
                    ImpactSounds.Play(Character, script.Parent.Name, p27[1]);
                end;
            end
        });
    end);
end;

function u2.UnHold(u28: userdata, u29: vector, u30: table) -- Line: 195
    -- upvalues: Utility (copy), u2 (copy), ManuelCancel (copy), Config (copy), EffectsEvent (copy), Checker (copy), gameSettings (copy), Combat_Util (copy), DebrisModule (copy), TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), u1 (copy), ImpactSounds (copy)
    local Character = u28.Character;

    if u30.TouchedConnection ~= nil then
        u30.TouchedConnection:Disconnect();
        u30.TouchedConnection = nil;
    end;

    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    local v31 = os.clock() - u30.startClock;
    local vector_create_ret = vector.create(u29.X, RootPart.Position.Y, u29.Z);
    local u32 = Utility.SafeLookAt(RootPart.Position, vector_create_ret, RootPart.CFrame);
    local u33 = u2.Id[u28.UserId];
    local v34, v35 = ManuelCancel.new(u28, 3);
    v34:Connect(function() -- Line: 214
        -- upvalues: u33 (ref), u2 (ref), u28 (copy), u29 (copy), u30 (copy)
        u33 = -1;
        u2.Cancel(u28, u29, u30);
    end);
    local v36 = workspace.Debree:FindFirstChild((`{Character.Name}'s Flame Tiger Head`));

    if v36 ~= nil then
        v36:Destroy();
    end;

    if v31 < Config.HOLD_DURATION then
        task.delay(0.2, function() -- Line: 226
            -- upvalues: u2 (ref), u28 (copy), u33 (ref), EffectsEvent (ref), Character (copy)
            if u2.Id[u28.UserId] ~= u33 then
                return;
            end;

            EffectsEvent.ToAllInRange(u28, "Flame Tiger TapVFX", Character, "Jump");
        end);
        local u37 = script.TigerHead:Clone();
        u37:PivotTo(u32 * CFrame.Angles(0, 3.141592653589793, 0));
        u37.Parent = workspace.Debree;
        u37.Name = `{Character.Name}'s Flame Tiger Head`;
        u37.RootPart:SetNetworkOwner(u28);
        local v38 = u37.AnimationController.Animator:LoadAnimation(script.TigerAnim);
        local Attachment = Instance.new("Attachment", u37.RootPart);
        local LinearVelocity = Instance.new("LinearVelocity");
        LinearVelocity.Parent = Attachment;
        LinearVelocity.Attachment0 = Attachment;
        LinearVelocity.MaxForce = 200000;
        local u39 = {};
        local u40 = {};
        local u41 = {};
        u30.TouchedConnection = u37.TouchPart.Touched:Connect(function(p42) -- Line: 248
            -- upvalues: u2 (ref), u28 (copy), u33 (ref), u32 (copy), Config (ref), Utility (ref), Character (copy), u40 (copy), Checker (ref), u41 (copy), gameSettings (ref), Combat_Util (ref), u37 (copy), u39 (copy)
            if u2.Id[u28.UserId] ~= u33 then
                return;
            end;

            if (p42.Position - u32.Position).Magnitude > Config.TAP_HEAD_SPEED * Config.TAP_CATCH_DURATION + 25 then
                return;
            end;

            if p42:IsDescendantOf(workspace.Humanoids) then
                local v43 = Utility.find_character_from_descendant(p42);

                if v43 == nil or v43 == Character then
                    return;
                end;

                if u40[v43] ~= nil then
                    return;
                end;

                local v44 = Checker.check_victim(script, Character, v43);

                if v44 == nil then
                    return;
                end;

                if v44 == "Blocking" or v44 == "Perfect" then
                    local os_clock_ret = os.clock();
                    local v45 = u41[v43];

                    if v45 ~= nil and os_clock_ret < v45 then
                        return;
                    end;

                    u41[v43] = os_clock_ret + gameSettings.default_touched_cooldown;

                    if v44 == "Perfect" then
                        Combat_Util.Perfect(script, Character, v43);

                        return;
                    end;

                    Combat_Util.Block(script, Character, v43, Config.CATCH_BLOCK_BREAK);

                    return;
                end;

                u40[v43] = true;
                local v46 = v43:FindFirstChild("HumanoidRootPart") or v43.PrimaryPart;
                local v47 = Utility.CreateOuwWeld(u37.TouchPart, v46, CFrame.new(0, -5, 8.5), 1.5);
                local valuesfolder = Utility.getvaluesfolder(v43);
                local v48 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.TAP_CARRY_PAUSE_GAMEPLAY);
                Combat_Util.Cancel(script, valuesfolder);
                table.insert(u39, { v43, v47, v48 });
            end;
        end);
        DebrisModule:AddItem(u37.TouchPart, Config.TAP_CATCH_DURATION);
        TweenService:Create(LinearVelocity, TweenInfo_new_ret, {
            VectorVelocity = u32.LookVector * Config.TAP_HEAD_SPEED
        }):Play();
        v38:Play(0);
        v38.TimePosition = 0.45;
        DebrisModule:AddItem(u37, Config.TAP_HEAD_LIFETIME);
        task.wait(0.35 + (Config.HOLD_DURATION - v31));

        if u2.Id[u28.UserId] == u33 then
            EffectsEvent.ToAllInRange(u28, "Flame Tiger TapVFX", Character, "Release", u37);
        end;

        task.delay(Config.HEAD_DECEL_DELAY, function() -- Line: 301
            -- upvalues: LinearVelocity (copy), TweenService (ref), TweenInfo_new_ret2 (ref)
            if LinearVelocity ~= nil and LinearVelocity.Parent ~= nil then
                TweenService:Create(LinearVelocity, TweenInfo_new_ret2, {
                    VectorVelocity = Vector3.new(0, 0, 0)
                }):Play();
            end;
        end);
        task.wait(Config.TAP_BITE_DELAY);

        if u30.TouchedConnection ~= nil then
            u30.TouchedConnection:Disconnect();
            u30.TouchedConnection = nil;
        end;

        if u2.Id[u28.UserId] ~= u33 then
            return;
        end;

        local v49 = u32 * Config.BITE_HITBOX_OFFSET;
        u37.TouchPart:Destroy();
        task.wait();
        local u50 = {};

        for _, v in ipairs(u39) do
            v[2]:Destroy();
            v[3]:Destroy();
            table.insert(u50, v[1]);
        end;

        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = v49,
            hitboxSize = Config.BITE_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            targets = u50,

            hitDetected = function(p51: userdata, p52: any, p53: any) -- Line: 329, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u50 (copy), u32 (copy), EffectsEvent (ref), u28 (copy)
                if p51 then
                    local RootPart2 = p51:FindFirstChild("Humanoid").RootPart;

                    if p53 == "Blocking" or p53 == "Perfect" then
                        Combat_Util.Block(script, Character, p51, Config.BITE_BLOCK_BREAK);

                        return;
                    end;

                    if p53 == true then
                        if table.find(u50, p51) == nil then
                            table.insert(u50, p51);
                        end;

                        local v54 = u32.LookVector * Config.BITE_KNOCKBACK + vector.create(0, Config.BITE_KNOCKUP, 0);
                        Combat_Util.AddStun(script, Character, p52, Config.BITE_STUN, true);
                        Combat_Util.Damage(script, Character, p51, {
                            Base = Config.BITE_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.Knockback(script, Character, RootPart2, v54, Config.BITE_KNOCKBACK_DURATION);
                        EffectsEvent.ToAllInRange(u28, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    end;
                end;
            end
        });
        EffectsEvent.ToAllInRange(u28, "Flame Tiger TapVFX", Character, "Bite", v49);
        task.wait(Config.TAP_DIVE_DELAY);

        if u2.Id[u28.UserId] ~= u33 then
            return;
        end;

        local v55 = u32 * Config.DIVE_HITBOX_OFFSET;
        EffectsEvent.ToAllInRange(u28, "Flame Tiger TapVFX", Character, "Dive", v55);
        Utility.CreateHitbox({
            TreeDestruction = true,
            caster = Character,
            hitboxCFrame = v55,
            hitboxSize = Config.DIVE_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            targets = u50,

            hitDetected = function(p56: userdata, p57: any, p58: any) -- Line: 365, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u32 (copy), EffectsEvent (ref), u28 (copy)
                if p56 then
                    local RootPart2 = p56:FindFirstChild("Humanoid").RootPart;

                    if p58 == "Blocking" or p58 == "Perfect" then
                        Combat_Util.Block(script, Character, p56, Config.DIVE_BLOCK_BREAK);

                        return;
                    end;

                    if p58 == true then
                        local v59 = u32.LookVector * Config.DIVE_KNOCKBACK + vector.create(0, Config.DIVE_KNOCKUP, 0);
                        EffectsEvent.ToAllInRange(u28, "Normal_Sword_Slash_Effect", RootPart2, -1);
                        Combat_Util.AddStun(script, Character, p57, Config.DIVE_STUN, true);
                        Combat_Util.Damage(script, Character, p56, {
                            Base = Config.DIVE_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.Knockback(script, Character, RootPart2, v59, 0.2);
                        Combat_Util.RagDoll(script, Character, p57, Config.DIVE_RAGDOLL);
                    end;
                end;
            end,

            After = function(p60, p61) -- Line: 384, Name: After
                -- upvalues: ImpactSounds (ref), Character (copy)
                if p60 then
                    ImpactSounds.Play(Character, script.Parent.Name, p61[1]);
                end;
            end
        });
    end;

    v35();
end;

function u2.Cancel(p62: userdata, p63: vector, p64: table) -- Line: 393
    if p64.TouchedConnection ~= nil then
        p64.TouchedConnection:Disconnect();
        p64.TouchedConnection = nil;
    end;

    local v65 = workspace.Debree:FindFirstChild((`{p62.Name}'s Flame Tiger Head`));

    if v65 ~= nil then
        v65:Destroy();
    end;
end;

return u2;