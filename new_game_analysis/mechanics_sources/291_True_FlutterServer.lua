-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local SAM = ServerStorage:WaitForChild("SAM");
local Global = CAM:WaitForChild("Global");
local Services = SAM:WaitForChild("Services");
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local AppliedTicks = require(Global.Subsets.Gameplay.AppliedTicks);
local Clans = require(CAM.Clans);
require(CAM:FindFirstChild("DebrisModule"));
local ServerClientPortal = require(ReplicatedStorage2.CAM.Global.ServerClientPortal);
local RaycastHelper = require(ReplicatedStorage2.CAM.Global.RaycastHelper);
local Config = require(script.Parent.Config);
local u2 = script;
local u6 = {
    Id = {},

    Hold = function(p3: userdata, p4: any, p5: any) -- Line: 39, Name: Hold
        -- upvalues: EffectsEvent (copy)
        local Character = p3.Character;

        if not Character then
            return;
        end;

        if not Character:FindFirstChild("HumanoidRootPart") then
            return;
        end;

        if not Character:FindFirstChild("Animator", true) then
            return;
        end;

        EffectsEvent.ToAllInRange(p3, "True_Flutter_VFX", Character, "Hold");
        p5.Clock = os.clock();
    end
};

function u6.UnHold(u7: userdata, u8: any, u9: any) -- Line: 52
    -- upvalues: u6 (copy), ManuelCancel (copy), Config (copy), ServerClientPortal (copy), EffectsEvent (copy), Combat_Util (copy), u2 (copy), Clans (copy), Utility (copy), AppliedTicks (copy), Combat_presets (copy), Checker (copy), u1 (copy), ImpactSounds (copy), RaycastHelper (copy)
    local Character = u7.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local Animator = Character:FindFirstChild("Animator", true);

    if not Animator then
        return;
    end;

    local air_combo_bp = HumanoidRootPart:FindFirstChild("air_combo_bp");

    if air_combo_bp then
        air_combo_bp:Destroy();
    end;

    local u10 = u6.Id[u7.UserId];
    local v11, u12 = ManuelCancel.new(u7, Config.UNHOLD_CANCEL_WINDOW);
    v11:Connect(function() -- Line: 68
        -- upvalues: u10 (ref), u6 (ref), u7 (copy), u8 (copy), u9 (copy), u12 (copy)
        u10 = -1;
        u6.Cancel(u7, u8, u9);
        u12();
    end);
    u9.Value_Table = {};
    local v13 = Config.WINDUP - (os.clock() - u9.Clock);

    if v13 > 0 then
        task.wait(v13);

        if u6.Id[u7.UserId] ~= u10 then
            return;
        end;
    end;

    local u14 = false;
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.RANGE_CHECK_HITBOX_OFFSET,
        hitboxSize = Config.RANGE_CHECK_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p15: userdata, p16: any, p17: any, p18: any) -- Line: 84
            -- upvalues: u14 (ref), ServerClientPortal (ref), u7 (copy), Animator (copy), u9 (copy), u6 (ref), u10 (ref), EffectsEvent (ref), Character (copy), Combat_Util (ref), HumanoidRootPart (copy), u2 (ref), Config (ref), Clans (ref), Utility (ref), AppliedTicks (ref), Combat_presets (ref), Checker (ref), u1 (ref), ImpactSounds (ref)
            if p15 and (p17 == true or (p17 == "Blocking" or p17 == "Perfect")) and u14 == false then
                u14 = true;
                ServerClientPortal.ToClient(u7, script.Parent.Name, true);
                local v19 = Animator:LoadAnimation(script["In Range"]);
                v19:Play();
                table.insert(u9.Value_Table, v19);

                if u6.Id[u7.UserId] ~= u10 then
                    return;
                end;

                EffectsEvent.ToAllInRange(u7, "True_Flutter_VFX", Character, "Uppercut");
                Combat_Util.Add_air_combo_bp(HumanoidRootPart, HumanoidRootPart);
                Utility.CreateHitbox({
                    caster = Character,
                    hitboxCFrame = HumanoidRootPart.CFrame * Config.UPPERCUT_HITBOX_OFFSET,
                    hitboxSize = Config.UPPERCUT_HITBOX_SIZE,
                    checker = Checker,
                    hitPriorityHandler = {
                        data = "Choosing_1",
                        callback = u1.Exists
                    },

                    hitDetected = function(p20: userdata, p21: any, p22: any) -- Line: 97
                        -- upvalues: Combat_Util (ref), u2 (ref), Character (ref), Config (ref), HumanoidRootPart (ref), EffectsEvent (ref), u7 (ref), Clans (ref), Utility (ref), AppliedTicks (ref), Combat_presets (ref)
                        if p20 then
                            local Humanoid = p20:FindFirstChild("Humanoid");
                            local RootPart = Humanoid.RootPart;

                            if p22 == "Blocking" then
                                Combat_Util.Block(u2, Character, p20, Config.UPPERCUT_BLOCK_BREAK);
                                Combat_Util.Add_air_combo_bp(RootPart, HumanoidRootPart);

                                return;
                            end;

                            if p22 == "Perfect" then
                                Combat_Util.Perfect(u2, Character, p20);

                                return;
                            end;

                            if p22 == true then
                                EffectsEvent.ToAllInRange(u7, "Normal_Sword_Slash_Effect", RootPart, -1);
                                Combat_Util.Add_air_combo_bp(RootPart, HumanoidRootPart);
                                Combat_Util.Damage(u2, Character, p20, {
                                    Base = Config.UPPERCUT_DAMAGE,
                                    Skill = script.Parent.Name
                                });
                                Combat_Util.AddStun(u2, Character, p21, Config.UPPERCUT_STUN);

                                if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                                    local v23 = Utility.AddValue(p21, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                                    v23:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                                    v23:SetAttribute("Skill", script.Parent.Name);
                                end;

                                if Humanoid then
                                    local math_random_ret = math.random(1, 4);
                                    Combat_presets.PlayReactAnim(Humanoid, math_random_ret);
                                end;
                            end;
                        end;
                    end,

                    After = function(p24, p25) -- Line: 137, Name: After
                        -- upvalues: ImpactSounds (ref), Character (ref)
                        if p24 then
                            ImpactSounds.Play(Character, script.Parent.Name, p25[1]);
                        end;
                    end
                });
                task.wait(Config.UPPERCUT_CLEANUP_AT);

                if u6.Id[u7.UserId] ~= u10 then
                    return;
                end;

                if u9.Value_Table then
                    for _, v in u9.Value_Table do
                        v:Destroy();
                    end;
                end;
            end;

            return u14;
        end
    });

    if u14 == false then
        ServerClientPortal.ToClient(u7, script.Parent.Name, false);
        task.wait(Config.DASH_WINDUP);

        if u6.Id[u7.UserId] ~= u10 then
            return;
        end;

        local CFrame2 = HumanoidRootPart.CFrame;

        if u6.Id[u7.UserId] ~= u10 then
            return;
        end;

        local v26 = vector.normalize(u8 - CFrame2.Position) * Config.MAX_DASH_DISTANCE;
        local CFrame_new_ret = CFrame.new(CFrame2.Position, CFrame2.Position + v26);
        local v27 = workspace:Raycast(CFrame2.Position, v26, RaycastHelper.Crater);
        local MAX_DASH_DISTANCE = Config.MAX_DASH_DISTANCE;
        local v28;

        if v27 then
            local v29 = v27.Position - CFrame2.Position;
            MAX_DASH_DISTANCE = vector.magnitude(v29);
            v28 = CFrame2.Position + vector.normalize(v29) * MAX_DASH_DISTANCE;
        else
            v28 = CFrame2.Position + v26;
        end;

        local v30 = CFrame.new(v28) * CFrame_new_ret.Rotation;
        local u31 = {};
        local u32 = nil;

        local function v38(u33: userdata, u34: any, p35: any, p36: any) -- Line: 201
            -- upvalues: u31 (copy), Combat_Util (ref), u2 (ref), Character (copy), Config (ref), EffectsEvent (ref), u7 (copy), Combat_presets (ref), u32 (ref), Checker (ref), ImpactSounds (ref), Clans (ref), Utility (ref), AppliedTicks (ref)
            if u33 and table.find(u31, u33) == nil then
                table.insert(u31, u33);
                local Humanoid = u33:FindFirstChild("Humanoid");
                local RootPart = Humanoid.RootPart;

                if p35 == "Perfect" then
                    Combat_Util.Perfect(u2, Character, u33);

                    return;
                end;

                if p35 == "Blocking" then
                    Combat_Util.Block(u2, Character, u33, Config.DASH_BLOCK_BREAK);

                    return;
                end;

                if p35 == true then
                    EffectsEvent.ToAllInRange(u7, "Normal_Sword_Slash_Effect", RootPart, -1);
                    Combat_Util.AddStun(u2, Character, u34, Config.DASH_STUN);
                    Combat_Util.Knockback(u2, Character, RootPart, vector.create(0, Config.DASH_KNOCKUP, 0), Config.DASH_EXPLOSION_AT);

                    if Humanoid then
                        Combat_presets.PlayReactAnim(Humanoid, 6);
                    end;

                    if u32 == nil then
                        u32 = u33;
                    end;

                    task.delay(Config.DASH_EXPLOSION_AT, function() -- Line: 223
                        -- upvalues: Checker (ref), u2 (ref), Character (ref), u33 (copy), EffectsEvent (ref), u7 (ref), RootPart (copy), Combat_Util (ref), Config (ref), u32 (ref), ImpactSounds (ref), Clans (ref), Utility (ref), u34 (copy), AppliedTicks (ref)
                        if Checker.check_victim(u2, Character, u33) ~= nil then
                            EffectsEvent.ToAllInRange(u7, "True_Flutter_VFX", Character, "Explosion", { RootPart.CFrame });
                            Combat_Util.Damage(u2, Character, u33, {
                                Base = Config.DASH_DAMAGE,
                                Skill = script.Parent.Name
                            });

                            if u33 == u32 then
                                ImpactSounds.Play(Character, script.Parent.Name, u33);
                            end;

                            if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                                local v37 = Utility.AddValue(u34, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                                v37:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                                v37:SetAttribute("Skill", script.Parent.Name);
                            end;

                            Combat_Util.RagDoll(u2, Character, u34, Config.DASH_RAGDOLL);
                        end;
                    end);
                end;
            end;
        end;

        local Vector3_new_ret = Vector3.new(Config.DASH_HITBOX_WIDTH, Config.DASH_HITBOX_HEIGHT, MAX_DASH_DISTANCE + Config.DASH_HITBOX_EXTRA_LENGTH);
        local v39 = Utility.SafeLookAt(CFrame2.Position, v30.Position, CFrame2) * CFrame.new(0, 0, -(MAX_DASH_DISTANCE / 2 + 3));
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = v39,
            hitboxSize = Vector3_new_ret,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v38,
            extraArgs = v39
        });
        EffectsEvent.ToAllInRange(u7, "True_Flutter_VFX", Character, "Dash", { CFrame2, v30 });
        task.delay(0.6, function() -- Line: 263
            -- upvalues: u9 (copy)
            if u9.Value_Table then
                for _, v in u9.Value_Table do
                    v:Destroy();
                end;
            end;
        end);
    end;
end;

function u6.Cancel(p40, p41, p42) -- Line: 272
    -- upvalues: EffectsEvent (copy)
    if not p40 then
        return;
    end;

    local Character = p40.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    EffectsEvent.ToAllInRange(p40, "True_Flutter_VFX", Character, "Cancel");

    if p42.Value_Table then
        for _, v in p42.Value_Table do
            if v:IsA("AnimationTrack") then
                v:Stop();
                v:Destroy();
            else
                v:Destroy();
            end;
        end;
    end;

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

return u6;