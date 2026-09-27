-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = {}
};
game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Server_Mouse_Pos = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Server_Mouse_Pos"));
local Combat_Util = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Combat_Util"));
local ImpactSounds = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Utility"):WaitForChild("ImpactSounds"));
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local _ = table.find;
local _ = table.remove;
local Config = require(script.Parent.Config);
local AIM_RADIUS = Config.AIM_RADIUS;
local u2 = typeof;
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local u3 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local _ = math.clamp;

function u1.Hold(p4) -- Line: 23
    -- upvalues: u1 (copy), Server_Mouse_Pos (copy), EffectsEvent (copy), Combat_Util (copy), Config (copy)
    local _ = u1.Id[p4.UserId];

    if p4 ~= nil and p4.Character then
        local Character = p4.Character;
        Server_Mouse_Pos.Create_Pos_Part(Character, script.Name, 10);
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
        Character:WaitForChild("Humanoid");
        EffectsEvent.ToAllInRange(HumanoidRootPart, "SerpentSlash_effs", Character, "Start");
        Combat_Util.Add_air_combo_bp(HumanoidRootPart, nil, Config.HOLD_UPDRAFT_HEIGHT, nil, Config.HOLD_UPDRAFT_DUR);
    end;
end;

local ManuelCancel = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("ManuelCancel"));
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);

function u1.UnHold(u5, u6, p7) -- Line: 44
    -- upvalues: u1 (copy), ManuelCancel (copy), Config (copy), EffectsEvent (copy), Debris (copy), RaycastHelper (copy), AIM_RADIUS (copy), Utility (copy), Server_Mouse_Pos (copy), u2 (copy), u3 (copy), Checker (copy), Combat_Util (copy), DebrisModule (copy), Combat_presets (copy), Character_info_provider (copy), ImpactSounds (copy)
    local u8 = u1.Id[u5.UserId];
    local u9, u10 = ManuelCancel.new(u5, Config.CANCEL_WINDOW);
    local u11 = false;
    local u12 = nil;
    local u13 = nil;
    local u14 = false;
    local u15 = nil;
    u9:Connect(function() -- Line: 52
        -- upvalues: u12 (ref), u14 (ref), EffectsEvent (ref), u5 (copy), u15 (ref), u13 (ref), u1 (ref), u6 (copy), u11 (ref)
        if u12 ~= nil then
            u12:Stop();
            u12 = nil;

            if u14 == false then
                EffectsEvent.ToAllInRange(u5, "SerpentSlash_effs", u5.Character, "Cancel");
            end;
        end;

        if u15 then
            u15:Destroy();
            u15 = nil;
        end;

        if u13 ~= nil then
            u13:Destroy();
            u13 = nil;
        end;

        u1.Cancel(u5, u6);
        u11 = true;
    end);
    task.delay(0.1, function() -- Line: 73
        -- upvalues: u11 (ref), u5 (copy), EffectsEvent (ref), u8 (copy), u1 (ref), Debris (ref), RaycastHelper (ref), u6 (copy), AIM_RADIUS (ref), Utility (ref), Server_Mouse_Pos (ref), Config (ref), u2 (ref), u3 (ref), Checker (ref), Combat_Util (ref), u12 (ref), u13 (ref), DebrisModule (ref), u15 (ref), u14 (ref), Combat_presets (ref), Character_info_provider (ref), ImpactSounds (ref), u9 (copy), u10 (copy)
        if u11 then
            return;
        end;

        if u5 == nil or not u5.Character then
            return;
        end;

        EffectsEvent.ToAllInRange(u5, "SerpentSlash_effs", u5.Character, "Cancel");

        if u8 ~= u1.Id[u5.UserId] then
            return;
        end;

        local Character = u5.Character;
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
        local Humanoid = Character:WaitForChild("Humanoid");

        if HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "air_combo_bp" then
                    Debris:AddItem(child, 0.2);
                end;
            end;
        end;

        local v16, _, _, v17 = RaycastHelper.MaximizeRayServer(Character, HumanoidRootPart.Position, u6, AIM_RADIUS, true, 3);
        local valuesfolder = Utility.getvaluesfolder(Character);
        local v18 = Character:FindFirstChild("PosPart" .. script.Name);

        if v18 ~= nil and (v18.Position - v18:GetAttribute("DefaultPos")).Magnitude > 3 then
            v16 = Server_Mouse_Pos.Clamp(Character, v18.Position, AIM_RADIUS) or v16;
        end;

        local Vector3_new_ret = Vector3.new(HumanoidRootPart.Position.X - v16.X, 0, HumanoidRootPart.Position.Z - v16.Z);

        if Vector3_new_ret.Magnitude < 0.01 then
            local LookVector = HumanoidRootPart.CFrame.LookVector;
            Vector3_new_ret = Vector3.new(-LookVector.X, 0, -LookVector.Z);
        end;

        local v19 = Vector3_new_ret.Magnitude <= 0.01 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit;
        local v20;

        if v17 == nil or not v17:FindFirstChild("HumanoidRootPart") then
            v20 = v16 + Vector3.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0);
        else
            v20 = v17.HumanoidRootPart;
        end;

        EffectsEvent.ToAllInRange(u5, "SerpentSlash_effs", u5.Character, "Shoot", v16);
        wait(Config.SHOOT_IMPACT_DELAY);

        if u11 then
            return;
        end;

        if Character == nil or not Character:FindFirstChild("HumanoidRootPart") then
            return;
        end;

        if v20 ~= nil and u2(v20) == "Instance" then
            v20 = v20.Position;
            v16 = v20 - Vector3.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0);
        end;

        if v20 == nil or u2(v20) ~= "Vector3" then
            return;
        end;

        if Humanoid == nil then
            return;
        end;

        local ModelInRegion = Utility.GetModelInRegion(CFrame.new(v20), Config.IMPACT_HITBOX_SIZE, nil, nil);
        local CFrame_lookAlong = CFrame.lookAlong;
        local v21 = math.random(-3, 3) / 3 * 2;
        local v22 = math.random(-3, 3) / 3 * 2;
        local v23 = CFrame_lookAlong(v20 + Vector3.new(v21, 0, v22), v19);
        local v24 = false;

        for _, v in pairs(ModelInRegion) do
            if v ~= Character then
                local valuesfolder2 = Utility.getvaluesfolder(v);

                if u3.Both(valuesfolder2, {
                    name = "Choosing_1",
                    pv = valuesfolder
                }) ~= true then
                    local v25 = Checker.check_victim(script, Character, v);

                    if v25 == true then
                        v24 = true;
                    elseif v25 == "Blocking" or Checker == "Perfect" then
                        Combat_Util.Block(script, Character, v, Config.IMPACT_BLOCK_BREAK);
                    end;
                end;
            end;
        end;

        if u11 then
            return;
        end;

        if v24 ~= true then
            EffectsEvent.ToAllInRange(u5, "SerpentSlash_effs", u5.Character, "Explode", v16);
            Server_Mouse_Pos.Delete_Pos_Part(Character, script.Name);

            return;
        end;

        EffectsEvent.ToAllInRange(u5, "SerpentSlash_effs", u5.Character, "Success", v16);
        u12 = Humanoid.Animator:LoadAnimation(script.SerpentSlash_Loop);
        u12:Play();
        HumanoidRootPart.CFrame = v23;
        u13 = Instance.new("Attachment");
        u13.Name = "air_combo_bp";
        local AlignPosition = Instance.new("AlignPosition", u13);
        AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
        AlignPosition.Attachment0 = u13;
        AlignPosition.Responsiveness = 45;
        AlignPosition.MaxForce = 10000;
        DebrisModule:AddItem(u13, 3);
        AlignPosition.Position = v23.Position;
        u13.Parent = HumanoidRootPart;
        u15 = Instance.new("BoolValue");
        u15.Name = "pause_gameplay";
        u15.Parent = valuesfolder;
        DebrisModule:AddItem(u15, Config.BITE_LOCK_DUR);
        local BITE_TICK_COUNT = Config.BITE_TICK_COUNT;
        local v26 = false;

        for i = 1, BITE_TICK_COUNT do
            if v26 == true or (u11 or (HumanoidRootPart == nil or Humanoid == nil)) then
                break;
            end;

            u14 = i == BITE_TICK_COUNT;

            if u14 then
                if u12 then
                    u12:Stop();
                    u12 = nil;
                end;

                if Humanoid then
                    local v27 = Humanoid.Animator:LoadAnimation(script.SerpentSlash_Slash);
                    v27:Play();
                    v27:AdjustSpeed(1.35);
                end;

                task.wait(0.07);

                if u11 then
                    break;
                end;
            end;

            local v28 = math.random(-3, 3) / 3;
            local v29 = math.random(0, 3) / 3;
            local v30 = Vector3.new(v28, 0.05, v29) * 2;

            if u14 then
                v30 = HumanoidRootPart.CFrame.lookVector * Config.FINAL_KNOCKBACK + HumanoidRootPart.CFrame.rightVector * Config.FINAL_KNOCKBACK_SIDE;
            end;

            local ModelInRegion2 = Utility.GetModelInRegion(v23, Config.BITE_HITBOX_SIZE, nil, nil);
            local _ = i;
            local v31 = nil;

            for _, v in pairs(ModelInRegion2) do
                if v26 == true then
                    break;
                end;

                if v == Character or v:FindFirstChild("Humanoid") == nil then
                    if v31 ~= nil then
                        ImpactSounds.Play(Character, script.Parent.Name, v31);
                    end;
                else
                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
                    local Humanoid2 = v:FindFirstChild("Humanoid");
                    local v32, _ = Checker.check_victim(script, Character, v);
                    local valuesfolder2 = Utility.getvaluesfolder(v);

                    if u3.Both(valuesfolder2, {
                        name = "Choosing_1",
                        pv = valuesfolder
                    }) ~= true then
                        if HumanoidRootPart2 ~= nil and (Humanoid2 ~= nil and HumanoidRootPart ~= nil) then
                            if v32 == "Perfect" then
                                Combat_Util.Perfect(script, Character, v);
                                v26 = true;
                            elseif v32 == true or v32 == "Blocking" then
                                if v32 == "Blocking" then
                                    Combat_Util.Block(script, Character, v, Config.BITE_BLOCK_BREAK);
                                else
                                    Combat_Util.Add_Strict_Stun(script, Character, valuesfolder2, Config.BITE_STUN);
                                    EffectsEvent.ToAllInRange(u5, "Normal_Sword_Slash_Effect", HumanoidRootPart2);
                                    Combat_Util.Damage(script, Character, v, {
                                        Base = u14 and Config.FINAL_DAMAGE or Config.BITE_TICK_DAMAGE,
                                        Skill = script.Parent.Name
                                    });
                                    v31 = v31 or v;
                                    Combat_Util.Knockback(script, Character, HumanoidRootPart2, v30, u14 and Config.FINAL_KNOCKBACK_DUR or Config.BITE_TICK_KNOCK_DUR);

                                    if u14 == true then
                                        Combat_Util.RagDoll(script, Character, valuesfolder2, Config.FINAL_RAGDOLL);
                                    else
                                        Combat_presets.stop_extra_anims(Humanoid2);
                                        local math_random_ret = math.random(1, 5);
                                        local v33 = Humanoid2.Animator:LoadAnimation(Character_info_provider.get_core_anim(u5, "React_" .. (math_random_ret == 5 and 6 or math_random_ret)));
                                        v33:AdjustSpeed(2.25);
                                        v33:Play();
                                    end;
                                end;
                            end;
                        end;

                        if v31 ~= nil then
                            ImpactSounds.Play(Character, script.Parent.Name, v31);
                        end;
                    end;
                end;
            end;

            task.wait(Config.BITE_TOTAL_DUR / BITE_TICK_COUNT);
        end;

        if u14 ~= true and u11 == false then
            u9:Fire();
            u10();
        end;

        if u12 then
            u12:Stop();
            u12 = nil;
        end;

        if AlignPosition then
            AlignPosition:Destroy();
        end;

        Server_Mouse_Pos.Delete_Pos_Part(Character, script.Name);
    end);
end;

function u1.Cancel(p34) -- Line: 262
    -- upvalues: EffectsEvent (copy), Server_Mouse_Pos (copy)
    local Character = p34.Character;

    if Character then
        EffectsEvent.ToAllInRange(p34, "SerpentSlash_effs", p34.Character, "Cancel");
        Server_Mouse_Pos.Delete_Pos_Part(Character, script.Name);
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "air_combo_bp" then
                    child:Destroy();
                end;
            end;
        end;
    end;
end;

return u1;