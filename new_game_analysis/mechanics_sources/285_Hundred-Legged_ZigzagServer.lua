-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("RunService");
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local SAM = ServerStorage:WaitForChild("SAM");
local Global = CAM:WaitForChild("Global");
local Services = SAM:WaitForChild("Services");
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ServerClientPortal = require(Global.ServerClientPortal);
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
local AppliedTicks = require(Global.Subsets.Gameplay.AppliedTicks);
local Clans = require(CAM.Clans);
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local StatTypes = require(CAM.Global.Types.StatTypes);
local Config = require(script.Parent.Config);
ReplicatedStorage:FindFirstChild("Assets"):FindFirstChild("Animations");
local u2 = {
    Id = {}
};
local u3 = script.Parent.Name .. "Hold";

local function lock(p4: userdata, p5, p6: number?, p7: string?) -- Line: 38
    -- upvalues: DebrisModule (copy)
    p4:PivotTo(p5);
    local v8;

    if p7 then
        v8 = workspace.Debree:FindFirstChild(p7);
    else
        v8 = p7;
    end;

    if not v8 then
        v8 = script.LOCK:Clone();
        v8.Name = p7 or "LOCK";
        v8.Parent = workspace.Debree;
        v8.Transparency = 1;
    end;

    v8:PivotTo(p5);

    if p6 then
        DebrisModule:AddItem(v8, p6);
    end;

    local Weld = v8.Weld;
    Weld.Part0 = v8;
    Weld.Part1 = p4;

    return v8;
end;

function u2.Hold(u9: userdata, p10: any, u11: any) -- Line: 61
    -- upvalues: u2 (copy), Utility (copy), Config (copy), StatTypes (copy), EffectsEvent (copy), DebrisModule (copy), Combat_Util (copy), Clans (copy), AppliedTicks (copy), Combat_presets (copy), ServerClientPortal (copy), u3 (copy), Checker (copy), u1 (copy)
    if u9 == nil or (u9.Character == nil or (u9.Character.PrimaryPart == nil or u9.Character:FindFirstChild("Humanoid") == nil)) then
        return;
    end;

    local Character = u9.Character;
    local Humanoid = Character.Humanoid;
    local RootPart = Humanoid.RootPart;
    local Animator = Humanoid.Animator;
    local u12 = u2.Id[u9.UserId];
    local valuesfolder = Utility.getvaluesfolder(Character);
    u11.Unheld = false;
    u11.Value_Table = {};
    local v13 = Utility.AddValue(valuesfolder, Config.STAMINA_DRAIN_VALUE);
    v13:AddTag(StatTypes.ValueStatTag);
    v13:SetAttribute(StatTypes.StatToAttribute("Stamina Drain Rate"), Config.STAMINA_DRAIN_RATE);
    table.insert(u11.Value_Table, v13);
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "pause_gameplay";
    BoolValue.Parent = valuesfolder;
    table.insert(u11.Value_Table, BoolValue);
    local BoolValue2 = Instance.new("BoolValue");
    BoolValue2.Name = "skill_stand_still";
    BoolValue2.Parent = valuesfolder;
    table.insert(u11.Value_Table, BoolValue2);
    EffectsEvent.ToAllInRange(u9, "Hundred-Legged_Zigzag_VFX", Character, "Dashing", Config.WINDUP);
    local u14 = Animator:LoadAnimation(script["Miss Start"]);
    u14:Play();
    table.insert(u11.Value_Table, u14);
    task.delay(Config.DASH_CAMSUBJECT_AT, function() -- Line: 110
        -- upvalues: u12 (copy), u2 (ref), u9 (copy), u11 (copy), Character (copy), valuesfolder (copy)
        if u12 ~= u2.Id[u9.UserId] then
            return;
        end;

        if u11.Unheld == true then
            return;
        end;

        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Value = Character:FindFirstChild("UpperTorso");
        ObjectValue.Name = "camsubject";
        ObjectValue.Parent = valuesfolder;
        table.insert(u11.Value_Table, ObjectValue);
    end);
    u11.InWindup = true;
    task.wait(Config.WINDUP);
    u11.InWindup = nil;

    if u11.Value_Table == nil then
        return;
    end;

    local u15 = Utility.SafeLookAt(RootPart.Position, Vector3.new(p10.X, RootPart.Position.Y, p10.Z), RootPart.CFrame);
    local u16 = 0;

    local function v27(u17: userdata, u18: any, p19: any, p20: any) -- Line: 250
        -- upvalues: u16 (ref), Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), DebrisModule (ref), Utility (ref), EffectsEvent (ref), u9 (copy), Combat_presets (ref), Clans (ref), AppliedTicks (ref), u2 (ref), u12 (copy), u11 (copy), ServerClientPortal (ref), u3 (ref), valuesfolder (copy)
        if u17 then
            local Humanoid2 = u17:FindFirstChild("Humanoid");
            local RootPart2 = Humanoid2.RootPart;

            if p19 == "Blocking" or p19 == "Perfect" and u16 > 0 then
                Combat_Util.Block(script, Character, u17, Config.DASH_BLOCK_BREAK);

                return;
            end;

            if p19 == "Perfect" then
                if u16 == 0 then
                    Combat_Util.Perfect(script, Character, u17);

                    return true;
                end;
            elseif p19 == true then
                u16 = u16 + 1;
                local v21 = RootPart;
                local CFrame = RootPart.CFrame;
                local DASH_HIT_LOCK_DURATION = Config.DASH_HIT_LOCK_DURATION;
                v21:PivotTo(CFrame);
                local u22 = nil;

                if not u22 then
                    u22 = script.LOCK:Clone();
                    u22.Name = "LOCK";
                    u22.Parent = workspace.Debree;
                    u22.Transparency = 1;
                end;

                u22:PivotTo(CFrame);

                if DASH_HIT_LOCK_DURATION then
                    DebrisModule:AddItem(u22, DASH_HIT_LOCK_DURATION);
                end;

                local Weld = u22.Weld;
                Weld.Part0 = u22;
                Weld.Part1 = v21;

                for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                    Utility.AddValue(u18, v, Config.DASH_HIT_LOCK_DURATION);
                end;

                if u16 == 1 then
                    EffectsEvent.ToAllInRange(u9, "Hundred-Legged_Zigzag_VFX", Character, "Miss Success");
                end;

                local math_random_ret = math.random(1, 4);
                Combat_presets.PlayReactAnim(Humanoid2, math_random_ret, 1.5);
                task.delay(Config.DASH_HIT_AT, function() -- Line: 279
                    -- upvalues: RootPart (ref), RootPart2 (copy), Combat_Util (ref), Character (ref), u17 (copy), Config (ref), u22 (ref), u18 (copy), Clans (ref), Utility (ref), AppliedTicks (ref)
                    if RootPart == nil or (RootPart.Parent == nil or (RootPart2 == nil or RootPart2.Parent == nil)) then
                        return;
                    end;

                    Combat_Util.Damage(script, Character, u17, {
                        Base = Config.DASH_HIT_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    task.wait(Config.DASH_FINISHER_DELAY);

                    if RootPart == nil or (RootPart.Parent == nil or (RootPart2 == nil or RootPart2.Parent == nil)) then
                        return;
                    end;

                    local v23 = RootPart.CFrame.LookVector * Config.DASH_FINISHER_KNOCKBACK;

                    if u22 ~= nil then
                        u22:Destroy();
                        u22 = nil;
                    end;

                    Combat_Util.Add_Strict_Stun(script, Character, u18, Config.DASH_FINISHER_STUN);
                    Combat_Util.Damage(script, Character, u17, {
                        Base = Config.DASH_FINISHER_DAMAGE,
                        Skill = script.Parent.Name
                    });

                    if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                        local v24 = Utility.AddValue(u18, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                        v24:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                        v24:SetAttribute("Skill", script.Parent.Name);
                    end;

                    Combat_Util.RagDoll(script, Character, u18, Config.DASH_FINISHER_RAGDOLL);
                    Combat_Util.Knockback(script, Character, RootPart2, v23, Config.DASH_FINISHER_KNOCKBACK_DUR);
                end);

                if u16 == 1 then
                    if u2.Id[u9.UserId] == u12 then
                        EffectsEvent.ToClient(u9, "force_skill_actions_server", script.Parent.Name, "Cancel", nil, false);
                    end;

                    task.delay(0.4, function() -- Line: 308
                        -- upvalues: u11 (ref)
                        if u11.Value_Table == nil then
                            return;
                        end;

                        for _, v in u11.Value_Table do
                            v:Destroy();
                        end;

                        u11.Unheld = nil;
                        u11.Value_Table = nil;
                    end);
                    u11.Unheld = true;
                    ServerClientPortal.ToClient(u9, u3, 2);
                    local Animator2 = Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                    if Animator2 then
                        Animator2:LoadAnimation(script["Miss End"]):Play();
                    end;

                    local v25 = RootPart;
                    local CFrame2 = RootPart.CFrame;
                    local DASH_HIT_LOCK_DURATION2 = Config.DASH_HIT_LOCK_DURATION;
                    v25:PivotTo(CFrame2);
                    local v26 = nil;

                    if not v26 then
                        v26 = script.LOCK:Clone();
                        v26.Name = "LOCK";
                        v26.Parent = workspace.Debree;
                        v26.Transparency = 1;
                    end;

                    v26:PivotTo(CFrame2);

                    if DASH_HIT_LOCK_DURATION2 then
                        DebrisModule:AddItem(v26, DASH_HIT_LOCK_DURATION2);
                    end;

                    local Weld2 = v26.Weld;
                    Weld2.Part0 = v26;
                    Weld2.Part1 = v25;

                    for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                        Utility.AddValue(valuesfolder, v, Config.DASH_HIT_LOCK_DURATION);
                    end;
                end;
            end;
        end;
    end;

    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.GRAB_HITBOX_OFFSET,
        hitboxSize = Config.GRAB_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(u28: userdata, u29: any, p30: any, p31: any) -- Line: 130
            -- upvalues: u16 (ref), Utility (ref), Config (ref), u12 (copy), u2 (ref), u9 (copy), Character (copy), DebrisModule (ref), u11 (copy), u15 (copy), u14 (copy), EffectsEvent (ref), RootPart (copy), Combat_Util (ref), Clans (ref), AppliedTicks (ref), valuesfolder (copy)
            if u28 then
                local RootPart2 = u28:FindFirstChild("Humanoid").RootPart;

                if p30 == true then
                    u16 = u16 + 1;

                    for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                        Utility.AddValue(u29, v, Config.GRAB_DURATION - Config.WINDUP);
                    end;

                    task.delay(Config.GRAB_CAMSUBJECT_AT - Config.WINDUP, function() -- Line: 143
                        -- upvalues: u12 (ref), u2 (ref), u9 (ref), Character (ref), u29 (copy), DebrisModule (ref), Config (ref), u11 (ref)
                        if u12 ~= u2.Id[u9.UserId] then
                            return;
                        end;

                        local ObjectValue = Instance.new("ObjectValue");
                        ObjectValue.Value = Character:FindFirstChild("UpperTorso");
                        ObjectValue.Name = "camsubject";
                        ObjectValue.Parent = u29;
                        DebrisModule:AddItem(ObjectValue, Config.GRAB_CAMSUBJECT_DUR);
                        table.insert(u11.Value_Table, ObjectValue);
                    end);
                    local v32 = u15;
                    local v33 = Config.GRAB_DURATION - Config.WINDUP;
                    RootPart2:PivotTo(v32);
                    local u34 = nil;

                    if not u34 then
                        u34 = script.LOCK:Clone();
                        u34.Name = "LOCK";
                        u34.Parent = workspace.Debree;
                        u34.Transparency = 1;
                    end;

                    u34:PivotTo(v32);

                    if v33 then
                        DebrisModule:AddItem(u34, v33);
                    end;

                    local Weld = u34.Weld;
                    Weld.Part0 = u34;
                    Weld.Part1 = RootPart2;
                    table.insert(u11.Value_Table, u34);
                    local Animator2 = u28:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                    if Animator2 then
                        local u35 = Animator2:LoadAnimation(script["Grab Victim"]);
                        u35:Play(nil, nil, 0.01);
                        task.delay(Config.GRAB_VICTIM_ANIM_RESUME_AT - Config.WINDUP, function() -- Line: 163
                            -- upvalues: u35 (copy)
                            u35:AdjustSpeed(1);
                        end);
                    end;

                    if u16 == 1 then
                        u14:Stop();
                        EffectsEvent.ToAllInRange(u9, "Hundred-Legged_Zigzag_VFX", Character, "Grab", Config.WINDUP);
                    end;

                    task.delay(Config.GRAB_SLASH_AT - Config.WINDUP, function() -- Line: 173
                        -- upvalues: RootPart2 (copy), RootPart (ref), Combat_Util (ref), Character (ref), u28 (copy), Config (ref), u34 (ref), u29 (copy), Clans (ref), Utility (ref), AppliedTicks (ref)
                        if RootPart2 == nil or (RootPart2.Parent == nil or (RootPart == nil or RootPart.Parent == nil)) then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u28, {
                            Base = Config.GRAB_SLASH_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        task.wait(Config.GRAB_THRUST_DELAY);

                        if RootPart2 == nil or (RootPart2.Parent == nil or (RootPart == nil or RootPart.Parent == nil)) then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u28, {
                            Base = Config.GRAB_THRUST_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        task.wait(Config.GRAB_FINISHER_DELAY);

                        if RootPart2 == nil or (RootPart2.Parent == nil or (RootPart == nil or RootPart.Parent == nil)) then
                            return;
                        end;

                        local v36 = RootPart.CFrame.LookVector * Config.GRAB_FINISHER_KNOCKBACK;

                        if u34 ~= nil then
                            u34:Destroy();
                            u34 = nil;
                        end;

                        Combat_Util.AddStun(script, Character, u29, Config.GRAB_FINISHER_STUN, true);
                        Combat_Util.Damage(script, Character, u28, {
                            Base = Config.GRAB_FINISHER_DAMAGE,
                            Skill = script.Parent.Name
                        });

                        if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                            local v37 = Utility.AddValue(u29, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                            v37:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                            v37:SetAttribute("Skill", script.Parent.Name);
                        end;

                        Combat_Util.RagDoll(script, Character, u29, Config.GRAB_FINISHER_RAGDOLL);
                        Combat_Util.Knockback(script, Character, RootPart2, v36, Config.GRAB_FINISHER_KNOCKBACK_DUR);
                    end);

                    if u16 == 1 then
                        if u2.Id[u9.UserId] == u12 then
                            EffectsEvent.ToClient(u9, "force_skill_actions_server", script.Parent.Name, "Cancel", nil, false);
                        end;

                        u11.Unheld = true;
                        task.delay(Config.GRAB_SLASH_AT + Config.GRAB_THRUST_DELAY + 0.55 - Config.WINDUP, function() -- Line: 210
                            -- upvalues: u11 (ref)
                            if u11.Value_Table == nil then
                                return;
                            end;

                            for _, v in u11.Value_Table do
                                v:Destroy();
                            end;

                            u11.Unheld = nil;
                            u11.Value_Table = nil;
                        end);
                        local Animator3 = Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                        if Animator3 then
                            local v38 = Animator3:LoadAnimation(script["Grab User"]);
                            v38:Play();
                            v38.TimePosition = Config.WINDUP;
                            table.insert(u11.Value_Table, v38);
                        end;

                        local v39 = RootPart;
                        local v40 = u15;
                        local v41 = Config.GRAB_DURATION - Config.WINDUP;
                        v39:PivotTo(v40);
                        local v42 = nil;

                        if not v42 then
                            v42 = script.LOCK:Clone();
                            v42.Name = "LOCK";
                            v42.Parent = workspace.Debree;
                            v42.Transparency = 1;
                        end;

                        v42:PivotTo(v40);

                        if v41 then
                            DebrisModule:AddItem(v42, v41);
                        end;

                        local Weld2 = v42.Weld;
                        Weld2.Part0 = v42;
                        Weld2.Part1 = v39;

                        for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                            Utility.AddValue(valuesfolder, v, Config.GRAB_DURATION - Config.WINDUP);
                        end;

                        task.delay(Config.GRAB_CAMSUBJECT_AT - Config.WINDUP, function() -- Line: 232
                            -- upvalues: RootPart (ref), Character (ref), valuesfolder (ref), DebrisModule (ref), Config (ref), u11 (ref)
                            if RootPart == nil or RootPart.Parent == nil then
                                return;
                            end;

                            local ObjectValue = Instance.new("ObjectValue");
                            ObjectValue.Value = Character:FindFirstChild("UpperTorso");
                            ObjectValue.Name = "camsubject";
                            ObjectValue.Parent = valuesfolder;
                            DebrisModule:AddItem(ObjectValue, Config.GRAB_CAMSUBJECT_DUR);
                            table.insert(u11.Value_Table, ObjectValue);
                        end);
                    end;
                end;
            end;
        end
    });

    if u16 == 0 and (u11.Unheld == false and u12 == u2.Id[u9.UserId]) then
        u14:Stop();
        ServerClientPortal.ToClient(u9, u3, 1);

        while u12 == u2.Id[u9.UserId] and (u11.Unheld == false and RootPart.Parent ~= nil) do
            Utility.CreateHitbox({
                visualize = false,
                caster = Character,
                hitboxCFrame = RootPart.CFrame * Config.DASH_HITBOX_OFFSET,
                hitboxSize = Config.DASH_HITBOX_SIZE,
                checker = Checker,
                hitPriorityHandler = {
                    data = "Choosing_1",
                    callback = u1.Exists
                },
                hitDetected = v27
            });
            task.wait(0.1);
        end;
    end;

    if u11.Unheld then
        return true;
    end;
end;

function u2.UnHold(p43, p44, p45) -- Line: 379
    -- upvalues: u2 (copy)
    while p45.InWindup do
        task.wait();
    end;

    u2.Cancel(p43, p44, p45);
end;

function u2.Cancel(p46, p47, p48) -- Line: 386
    -- upvalues: EffectsEvent (copy)
    if p48.Unheld == true then
        return;
    end;

    if p48.Value_Table ~= nil then
        for _, v in p48.Value_Table do
            if v:IsA("AnimationTrack") then
                v:Stop();
                v:Destroy();
            else
                v:Destroy();
            end;
        end;
    end;

    p48.Value_Table = nil;
    p48.Unheld = nil;

    if not p46 then
        return;
    end;

    local Character = p46.Character;

    if not Character then
        return;
    end;

    EffectsEvent.ToAllInRange(p46, "Hundred-Legged_Zigzag_VFX", Character, "Cancel");
end;

return u2;