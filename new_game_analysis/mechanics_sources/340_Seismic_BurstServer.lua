-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
require(CAM.Global.Combat_presets);
require(CAM.DebrisModule);
require(SAM.Utility.SkillStorage);
local Combat_Util = require(SAM.Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local u3 = script;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("ManuelCancel"));

function u2.Hold(u4: userdata, p5: vector, p6: table) -- Line: 42
    -- upvalues: u2 (copy), Utility (copy), EffectsEvent (copy), Config (copy), u1 (copy), Checker (copy), u3 (copy)
    local Character = u4.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    Humanoid:FindFirstChild("Animator");
    local u7 = u2.Id[u4.UserId];
    local valuesfolder = Utility.getvaluesfolder(Character);
    task.delay(0.05, function() -- Line: 54
        -- upvalues: u7 (copy), u2 (ref), u4 (copy), EffectsEvent (ref), Character (copy)
        if u7 ~= u2.Id[u4.UserId] then
            return;
        end;

        EffectsEvent.ToAllInRange(u4, "Seismic BurstVFX", Character, "Start");
        task.wait(0.2);

        if u7 ~= u2.Id[u4.UserId] then
            return;
        end;

        EffectsEvent.ToAllInRange(u4, "Seismic BurstVFX", Character, "DustTrail");
    end);
    local v8 = false;

    while true do
        if u7 ~= u2.Id[u4.UserId] or v8 ~= false then
            return;
        end;

        local ModelInRegion = Utility.GetModelInRegion(RootPart.CFrame * Config.DASH_HITBOX_OFFSET, Config.DASH_HITBOX_SIZE, nil, nil, false);

        for _, v in pairs(ModelInRegion) do
            if v8 == true then
                break;
            end;

            if v ~= Character then
                local valuesfolder2 = Utility.getvaluesfolder(v);

                if u1.Both(valuesfolder2, {
                    name = "Choosing_1",
                    pv = valuesfolder
                }) ~= true and Checker.check_victim(u3, Character, v) ~= nil then
                    if u2.Id[u4.UserId] == u7 then
                        EffectsEvent.ToClient(u4, "force_skill_actions_server", script.Parent.Name, "UnHold", nil);
                        v8 = true;
                    end;

                    break;
                end;
            end;
        end;

        task.wait(0.1);
    end;
end;

function u2.UnHold(p9: userdata, p10: vector, p11: table) -- Line: 83
    -- upvalues: EffectsEvent (copy), Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), ImpactSounds (copy)
    local Character = p9.Character;

    if Character == nil then
        return;
    end;

    p11.Cancelled = false;
    EffectsEvent.ToAllInRange(p9, "Seismic BurstVFX", Character, "Slash");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local ModelInRegion = Utility.GetModelInRegion(Character.HumanoidRootPart.CFrame * Config.SLASH_HITBOX_OFFSET, Config.SLASH_HITBOX_SIZE, nil, nil, false);
    local v12 = false;
    local v13 = nil;

    for _, v in pairs(ModelInRegion) do
        if v12 == true then
            break;
        end;

        if v ~= p9.Character and v:FindFirstChild("Humanoid") ~= nil then
            local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");
            local Humanoid = v:FindFirstChild("Humanoid");
            local v14, _ = Checker.check_victim(script, Character, v);
            local valuesfolder2 = Utility.getvaluesfolder(v);

            if u1.Both(valuesfolder2, {
                name = "Choosing_1",
                pv = valuesfolder
            }) ~= true then
                local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart ~= nil and (Humanoid ~= nil and HumanoidRootPart2 ~= nil) then
                    if v14 == "Blocking" then
                        Combat_Util.Block(script, Character, v, Config.SLASH_BLOCK_BREAK);
                    elseif v14 == "Perfect" then
                        Combat_Util.Perfect(script, Character, v);
                        v12 = true;
                    elseif v14 == true then
                        EffectsEvent.ToAllInRange(p9, "Normal_Sword_Slash_Effect", HumanoidRootPart, -1);
                        Combat_Util.RagDoll(script, Character, valuesfolder2, Config.SLASH_RAGDOLL);
                        Combat_Util.Add_Strict_Stun(script, Character, valuesfolder2, Config.SLASH_STUN);
                        Combat_Util.Damage(script, Character, v, {
                            Base = Config.SLASH_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        local v15 = HumanoidRootPart2.CFrame.lookVector * Config.SLASH_KNOCKBACK;
                        Combat_Util.Knockback(script, Character, HumanoidRootPart, Vector3.new(v15.X, 0, v15.Z), Config.SLASH_KNOCKBACK_DURATION);
                        v13 = v13 or v;
                    end;
                end;
            end;
        end;
    end;

    if v13 ~= nil then
        ImpactSounds.Play(Character, script.Parent.Name, v13);
    end;
end;

function u2.Cancel(p16: userdata, p17: vector, p18: table) -- Line: 127
    -- upvalues: u2 (copy), EffectsEvent (copy)
    local Character = p16.Character;

    if Character == nil then
        return;
    end;

    u2.Id[p16.UserId] = 3;
    EffectsEvent.ToAllInRange(p16, "Seismic BurstVFX", Character, "Cancel");
end;

return u2;