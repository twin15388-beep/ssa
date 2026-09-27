-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local u2 = {
    Id = {}
};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local RaycastHelper = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("RaycastHelper"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Combat_Util = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Combat_Util"));
local ImpactSounds = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Utility"):WaitForChild("ImpactSounds"));
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);

function u2.Hold(u3) -- Line: 16
    -- upvalues: u2 (copy), EffectsEvent (copy)
    local u4 = u2.Id[u3.UserId];

    if u3 == nil then
        return;
    end;

    local Character = u3.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    Character:SetAttribute("SkillStartupLocation", HumanoidRootPart.Position);
    task.delay(0.05, function() -- Line: 24
        -- upvalues: u2 (ref), u3 (copy), u4 (copy), EffectsEvent (ref), Character (copy)
        if u2.Id[u3.UserId] == u4 then
            EffectsEvent.ToAllInRange(u3, "TwinHeadedReptile_effs", Character, "Start");
        end;
    end);
end;

require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("Cutscene_camera_handler"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };

function u2.UnHold(u5: any, p6: vector) -- Line: 37
    -- upvalues: Utility (copy), Config (copy), RaycastParams_new_ret (copy), EffectsEvent (copy), u2 (copy), Checker (copy), u1 (copy), Combat_Util (copy), RaycastHelper (copy), DebrisModule (copy), ImpactSounds (copy)
    if u5 == nil then
        return;
    end;

    local Character = u5.Character;

    if Character == nil then
        return;
    end;

    local Attribute = Character:GetAttribute("SkillStartupLocation");
    Character:SetAttribute("SkillStartupLocation", nil);
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local air_combo_bp = HumanoidRootPart:FindFirstChild("air_combo_bp");

    if air_combo_bp then
        air_combo_bp:Destroy();
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local Unit = (p6 - HumanoidRootPart.Position).Unit;
    local Vector3_new_ret = Vector3.new(Unit.X, 0, Unit.Z);
    local CFrame_lookAlong_ret = CFrame.lookAlong(Attribute, Vector3_new_ret);
    local v7 = workspace:Raycast(CFrame_lookAlong_ret.Position, CFrame_lookAlong_ret.LookVector * Config.DASH_RAY_RANGE, RaycastParams_new_ret);
    local v8 = CFrame_lookAlong_ret * Config.DASH_GOAL_OFFSET;

    if v7 then
        v8 = CFrame.lookAlong(v7.Position, Vector3_new_ret);
    end;

    EffectsEvent.ToAllInRange(u5, "TwinHeadedReptile_effs", Character, "Dash", Vector3_new_ret, Attribute, v8.Position);
    local u9 = false;
    local u10 = HumanoidRootPart.CFrame * CFrame.new(0, 0, -15);
    local u11 = u2.Id[u5.UserId];
    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        return;
    end;

    local DASH_BLOCK_BREAK = Config.DASH_BLOCK_BREAK;
    local FINISH_DAMAGE = Config.FINISH_DAMAGE;
    task.spawn(function() -- Line: 69
        -- upvalues: Config (ref), u9 (ref), u10 (ref), HumanoidRootPart (copy), Utility (ref), Character (copy), Checker (ref), u1 (ref), valuesfolder (copy), Combat_Util (ref), DASH_BLOCK_BREAK (copy), u11 (copy), u2 (ref), u5 (copy), Humanoid (copy), RaycastHelper (ref), EffectsEvent (ref), Vector3_new_ret (ref), Attribute (copy), DebrisModule (ref), ImpactSounds (ref), FINISH_DAMAGE (copy)
        local v12 = {};
        local v13 = {};

        for i = 1, Config.DASH_SCAN_TICKS do
            task.wait(Config.DASH_SCAN_TICK);

            if u9 == true then
                break;
            end;

            u10 = HumanoidRootPart.CFrame * Config.DASH_HITBOX_OFFSET;
            local ModelInRegion = Utility.GetModelInRegion(u10, Config.DASH_HITBOX_SIZE, nil, nil);
            local _ = i;

            for _, v in pairs(ModelInRegion) do
                if v ~= Character and (v:FindFirstChild("Humanoid") ~= nil and table.find(v12, v) == nil) then
                    table.insert(v12, v);
                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
                    local Humanoid2 = v:FindFirstChild("Humanoid");
                    local v14, _ = Checker.check_victim(script, Character, v);
                    local valuesfolder2 = Utility.getvaluesfolder(v);

                    if u1.Both(valuesfolder2, {
                        name = "Choosing_1",
                        pv = valuesfolder
                    }) ~= true then
                        local HumanoidRootPart3 = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart2 ~= nil and (Humanoid2 ~= nil and HumanoidRootPart3 ~= nil) then
                            if v14 == true then
                                u9 = true;
                                table.insert(v13, v);
                            elseif v14 == "Blocking" or v14 == "Perfect" then
                                Combat_Util.Block(script, Character, v, DASH_BLOCK_BREAK);
                            end;
                        end;
                    end;
                end;
            end;

            if u9 == true then
                break;
            end;
        end;

        if #v13 > 0 and (Character ~= nil and (u11 == u2.Id[u5.UserId] and Humanoid ~= nil)) then
            u10 = RaycastHelper.ResolveGrabPin(HumanoidRootPart.Position, u10, Config.GRAB_WALL_CLEARANCE);
            EffectsEvent.ToAllInRange(u5, "TwinHeadedReptile_effs", Character, "Success", Vector3_new_ret, Attribute);
            Humanoid.Animator:LoadAnimation(script.Reptile_Attacker):Play(0);
            local BoolValue = Instance.new("BoolValue");
            BoolValue.Name = "pause_gameplay";
            BoolValue.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue, Config.GRAB_LOCK_DUR);
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Massless = true;
            Part.Transparency = 1;
            Part.CFrame = u10;
            Part.CanCollide = false;
            Part.Parent = workspace.Debree;
            DebrisModule:AddItem(Part, Config.GRAB_LOCK_DUR);
            local Weld = Instance.new("Weld");
            Weld.Part0 = Part;
            Weld.Part1 = HumanoidRootPart;
            local v15 = u10 * Config.GRAB_VICTIM_OFFSET;
            local BoolValue2 = Instance.new("BoolValue");
            BoolValue2.Name = "iframe";
            BoolValue2.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue2, Config.GRAB_LOCK_DUR);
            local BoolValue3 = Instance.new("BoolValue");
            BoolValue3.Name = "noragdoll";
            BoolValue3.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue3, Config.GRAB_LOCK_DUR);
            Weld.Parent = Part;
            DebrisModule:AddItem(Weld, Config.GRAB_LOCK_DUR);
            local u16 = nil;

            for _, v in pairs(v13) do
                if Checker.check_victim(script, Character, v) ~= nil then
                    game.Players:GetPlayerFromCharacter(v);
                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart2 ~= nil then
                        local Humanoid2 = v:FindFirstChild("Humanoid");

                        if Humanoid2 ~= nil then
                            if u16 == nil then
                                u16 = v;
                            end;

                            Humanoid2:LoadAnimation(script.Reptile_Victim):Play(0);
                            local valuesfolder2 = Utility.getvaluesfolder(v);
                            local BoolValue4 = Instance.new("BoolValue");
                            BoolValue4.Name = "pause_gameplay";
                            BoolValue4.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue4, Config.GRAB_VICTIM_DUR);
                            local StringValue = Instance.new("StringValue");
                            StringValue.Name = "iframe";
                            StringValue.Value = valuesfolder.Name;
                            StringValue.Parent = valuesfolder2;
                            DebrisModule:AddItem(StringValue, Config.GRAB_VICTIM_DUR);
                            local BoolValue5 = Instance.new("BoolValue");
                            BoolValue5.Name = "noragdoll";
                            BoolValue5.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue5, Config.GRAB_VICTIM_DUR);
                            local Part2 = Instance.new("Part");
                            Part2.Anchored = true;
                            Part2.Transparency = 1;
                            Part2.Massless = true;
                            Part2.CFrame = v15;
                            Part2.CanCollide = false;
                            Part2.Parent = workspace.Debree;
                            DebrisModule:AddItem(Part2, Config.GRAB_LOCK_DUR);
                            local Weld2 = Instance.new("Weld");
                            Weld2.Part0 = HumanoidRootPart2;
                            Weld2.Part1 = Part2;
                            Weld2.Parent = Part2;
                            task.spawn(function() -- Line: 192
                                -- upvalues: Config (ref), HumanoidRootPart2 (copy), Checker (ref), Character (ref), v (copy), Combat_Util (ref), u16 (ref), ImpactSounds (ref)
                                for i = 1, Config.BITE_TICK_COUNT do
                                    if HumanoidRootPart2 == nil then
                                        return;
                                    end;

                                    if Checker.check_victim(script, Character, v) ~= nil and Character then
                                        Combat_Util.Damage(script, Character, v, {
                                            Base = Config.BITE_TICK_DAMAGE,
                                            Skill = script.Parent.Name
                                        });

                                        if v == u16 then
                                            ImpactSounds.Play(Character, script.Parent.Name, v);
                                        end;
                                    end;

                                    task.wait(Config.BITE_TICK);
                                    local _ = i;
                                end;
                            end);
                            task.spawn(function() -- Line: 205
                                -- upvalues: HumanoidRootPart2 (copy), Config (ref), Weld2 (copy), BoolValue5 (copy), Utility (ref), v (copy), Checker (ref), Character (ref), Combat_Util (ref), FINISH_DAMAGE (ref), u16 (ref), ImpactSounds (ref)
                                if HumanoidRootPart2 == nil then
                                    return;
                                end;

                                task.wait(Config.GRAB_VICTIM_DUR);

                                if Weld2 then
                                    Weld2:Destroy();
                                end;

                                if BoolValue5 then
                                    BoolValue5:Destroy();
                                end;

                                task.wait();
                                local valuesfolder3 = Utility.getvaluesfolder(v);

                                if HumanoidRootPart2 == nil then
                                    return;
                                end;

                                if Checker.check_victim(script, Character, v) ~= nil and Character then
                                    Combat_Util.AddStun(script, Character, valuesfolder3, Config.FINISH_STUN);
                                    Combat_Util.RagDoll(script, Character, valuesfolder3, Config.FINISH_RAGDOLL);
                                    Combat_Util.Damage(script, Character, v, {
                                        Base = FINISH_DAMAGE,
                                        Skill = script.Parent.Name
                                    });

                                    if v == u16 then
                                        ImpactSounds.Play(Character, script.Parent.Name, v);
                                    end;

                                    Combat_Util.RagDoll(script, Character, valuesfolder3, Config.FINISH_RAGDOLL);
                                end;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function u2.Cancel(p17) -- Line: 231
    -- upvalues: EffectsEvent (copy)
    if p17 == nil then
        return;
    end;

    local Character = p17.Character;

    if Character == nil then
        return;
    end;

    Character:SetAttribute("SkillStartupLocation", nil);
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "TwinHeadedReptile_effs", Character, "Cancel");
end;

return u2;