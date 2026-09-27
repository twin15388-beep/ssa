-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local Debris = game:GetService("Debris");
game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local u2 = {
    Id = {}
};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Combat_Util = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Combat_Util"));
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Config = require(script.Parent.Config);

function u2.Hold(u3) -- Line: 15
    -- upvalues: u2 (copy), Utility (copy), EffectsEvent (copy)
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
    Utility.getvaluesfolder(Character);
    task.delay(0.05, function() -- Line: 25
        -- upvalues: u2 (ref), u3 (copy), u4 (copy), EffectsEvent (ref), HumanoidRootPart (copy), Character (copy)
        if u2.Id[u3.UserId] == u4 then
            EffectsEvent.ToAllInRange(HumanoidRootPart, "SlitheringSerpent_effs", Character, "Start");
        end;
    end);
end;

local GRAB_DAMAGE_FRAMES = Config.GRAB_DAMAGE_FRAMES;
local CharGrabPosCorrector = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);
local Cutscene_camera_handler = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("Cutscene_camera_handler"));

function u2.UnHold(u5: any, p6: vector) -- Line: 38
    -- upvalues: Utility (copy), Config (copy), EffectsEvent (copy), DebrisModule (copy), u2 (copy), Checker (copy), u1 (copy), Combat_Util (copy), RaycastHelper (copy), CharGrabPosCorrector (copy), Cutscene_camera_handler (copy), Debris (copy), GRAB_DAMAGE_FRAMES (copy)
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

    Utility.getvaluesfolder(Character);
    local Unit = (p6 - HumanoidRootPart.Position).Unit;
    local Vector3_new_ret = Vector3.new(Unit.X, Unit.Y, Unit.Z);
    local v7 = CFrame.lookAlong(HumanoidRootPart.Position, Vector3_new_ret) * Config.DASH_GOAL_OFFSET;
    EffectsEvent.ToAllInRange(HumanoidRootPart, "SlitheringSerpent_effs", Character, "Dash", nil, Vector3_new_ret, Attribute, v7.Position);
    local valuesfolder = Utility.getvaluesfolder(Character);
    local StringValue = Instance.new("StringValue");
    StringValue.Name = "Transparent";
    StringValue.Value = script.Parent.Name;
    StringValue.Parent = valuesfolder;
    DebrisModule:AddItem(StringValue, Config.DASH_WINDOW);
    local u8 = false;
    local u9 = nil;
    local u10 = u2.Id[u5.UserId];
    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        return;
    end;

    local DASH_BLOCK_BREAK = Config.DASH_BLOCK_BREAK;
    task.spawn(function() -- Line: 80
        -- upvalues: Config (ref), u8 (ref), u9 (ref), HumanoidRootPart (copy), Vector3_new_ret (ref), Utility (ref), Character (copy), Checker (ref), u1 (ref), valuesfolder (copy), Combat_Util (ref), DASH_BLOCK_BREAK (copy), StringValue (copy), u10 (copy), u2 (ref), u5 (copy), Humanoid (copy), RaycastHelper (ref), EffectsEvent (ref), CharGrabPosCorrector (ref), DebrisModule (ref), Cutscene_camera_handler (ref), Debris (ref), GRAB_DAMAGE_FRAMES (ref)
        local v11 = {};
        local v12 = {};

        for i = 1, Config.DASH_SCAN_TICKS do
            task.wait(Config.DASH_SCAN_TICK);

            if u8 == true then
                break;
            end;

            u9 = CFrame.lookAlong(HumanoidRootPart.Position, Vector3_new_ret) * Config.DASH_HITBOX_OFFSET;
            local ModelInRegion = Utility.GetModelInRegion(u9, Config.DASH_HITBOX_SIZE, nil, nil);
            local _ = i;

            for _, v in pairs(ModelInRegion) do
                if v ~= Character and (v:FindFirstChild("Humanoid") ~= nil and table.find(v11, v) == nil) then
                    table.insert(v11, v);
                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
                    local Humanoid2 = v:FindFirstChild("Humanoid");
                    local v13, _ = Checker.check_victim(script, Character, v);
                    local valuesfolder2 = Utility.getvaluesfolder(v);

                    if u1.Both(valuesfolder2, {
                        name = "Choosing_1",
                        pv = valuesfolder
                    }) ~= true then
                        local HumanoidRootPart3 = Character:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart2 ~= nil and (Humanoid2 ~= nil and HumanoidRootPart3 ~= nil) then
                            if v13 == true then
                                u8 = true;
                                table.insert(v12, v);
                            elseif v13 == "Blocking" or v13 == "Perfect" then
                                Combat_Util.Block(script, Character, v, DASH_BLOCK_BREAK);
                            end;
                        end;
                    end;
                end;
            end;

            if u8 == true then
                break;
            end;
        end;

        if StringValue and StringValue:IsDescendantOf(valuesfolder) then
            StringValue:Destroy();
        end;

        if #v12 > 0 and (Character ~= nil and (u10 == u2.Id[u5.UserId] and Humanoid ~= nil)) then
            local Vector3_new_ret2 = Vector3.new(Vector3_new_ret.X, 0, Vector3_new_ret.Z);
            local v14;

            if Vector3_new_ret2.Magnitude > 0.01 then
                v14 = Vector3_new_ret2.Unit;
            else
                v14 = HumanoidRootPart.CFrame.LookVector;
            end;

            local v15 = workspace:Raycast(u9.Position + Vector3.new(0, 8, 0), Vector3.new(0, -60, 0), RaycastHelper.Crater);
            local v16;

            if v15 == nil then
                v16 = u9.Position;
            else
                v16 = v15.Position + Vector3.new(0, 3, 0);
            end;

            u9 = CFrame.lookAlong(v16, v14);
            u9 = RaycastHelper.ResolveGrabPin(HumanoidRootPart.Position, u9, Config.GRAB_WALL_CLEARANCE);
            local table_clone_ret = table.clone(v12);
            table.insert(table_clone_ret, u5.Character);
            EffectsEvent.ToAllInRange(HumanoidRootPart, "SlitheringSerpent_effs", Character, "Success", table_clone_ret);
            local v17 = Humanoid.Animator:LoadAnimation(script.SlitheringSerpent_Attacker);
            v17:Play(0);
            CharGrabPosCorrector.Do(Character, v17, nil, Character);
            local BoolValue = Instance.new("BoolValue");
            BoolValue.Name = "pause_gameplay";
            BoolValue.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue, Config.GRAB_LOCK_DUR);
            local Part = Instance.new("Part");
            Part.Anchored = true;
            Part.Massless = true;
            Part.Transparency = 1;
            Part.CFrame = u9;
            Part.CanCollide = false;
            Part.Parent = workspace.Debree;
            DebrisModule:AddItem(Part, Config.GRAB_LOCK_DUR);
            local Weld = Instance.new("Weld");
            Weld.Part0 = Part;
            Weld.Part1 = HumanoidRootPart;
            local v18 = u9;
            local v19 = script.CameraRig:Clone();
            v19.RootPart.RootPart.Part0 = HumanoidRootPart;
            v19.Parent = workspace.Debree;
            v19.AnimationController:LoadAnimation(script.SlitheringSerpent_Camera):Play();
            Cutscene_camera_handler.Regular(u5, v19.Bone);
            local BoolValue2 = Instance.new("BoolValue");
            BoolValue2.Name = "iframe";
            BoolValue2.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue2, Config.GRAB_LOCK_DUR);
            local BoolValue3 = Instance.new("BoolValue");
            BoolValue3.Name = "noragdoll";
            BoolValue3.Parent = valuesfolder;
            DebrisModule:AddItem(BoolValue3, Config.GRAB_LOCK_DUR);
            DebrisModule:AddItem(v19, Config.GRAB_RELEASE_AT);
            Weld.Parent = Part;
            DebrisModule:AddItem(Weld, Config.GRAB_LOCK_DUR);
            local NumberValue = Instance.new("NumberValue");
            NumberValue.Name = "FOV";
            NumberValue.Value = Config.GRAB_FOV;
            NumberValue.Parent = valuesfolder;
            Debris:AddItem(NumberValue, Config.GRAB_LOCK_DUR);

            for _, v in pairs(v12) do
                if Checker.check_victim(script, Character, v) ~= nil then
                    local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(v);

                    if PlayerFromCharacter ~= nil then
                        Cutscene_camera_handler.Regular(PlayerFromCharacter, v19.Bone);
                    end;

                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart2 ~= nil then
                        local Humanoid2 = v:FindFirstChild("Humanoid");

                        if Humanoid2 ~= nil then
                            local v20 = Humanoid2:LoadAnimation(script.SlitheringSerpent_Victim);
                            v20:Play(0);
                            local valuesfolder2 = Utility.getvaluesfolder(v);
                            local NumberValue2 = Instance.new("NumberValue");
                            NumberValue2.Name = "FOV";
                            NumberValue2.Value = Config.GRAB_FOV;
                            NumberValue2.Parent = valuesfolder2;
                            Debris:AddItem(NumberValue2, Config.GRAB_LOCK_DUR);
                            CharGrabPosCorrector.Do(v, v20, nil, Character);
                            local BoolValue4 = Instance.new("BoolValue");
                            BoolValue4.Name = "pause_gameplay";
                            BoolValue4.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue4, Config.GRAB_LOCK_DUR);
                            local StringValue2 = Instance.new("StringValue");
                            StringValue2.Name = "iframe";
                            StringValue2.Value = valuesfolder.Name;
                            StringValue2.Parent = valuesfolder2;
                            DebrisModule:AddItem(StringValue2, Config.GRAB_LOCK_DUR);
                            local BoolValue5 = Instance.new("BoolValue");
                            BoolValue5.Name = "noragdoll";
                            BoolValue5.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue5, Config.GRAB_LOCK_DUR);
                            local Part2 = Instance.new("Part");
                            Part2.Anchored = true;
                            Part2.Transparency = 1;
                            Part2.Massless = true;
                            Part2.CFrame = v18;
                            Part2.CanCollide = false;
                            Part2.Parent = workspace.Debree;
                            DebrisModule:AddItem(Part2, Config.GRAB_VICTIM_WELD_DUR);
                            local Weld2 = Instance.new("Weld");
                            Weld2.Part0 = HumanoidRootPart2;
                            Weld2.Part1 = Part2;
                            Weld2.Parent = Part2;
                            task.spawn(function() -- Line: 250
                                -- upvalues: GRAB_DAMAGE_FRAMES (ref), HumanoidRootPart2 (copy), Checker (ref), Character (ref), v (copy), Combat_Util (ref)
                                for _, v2 in ipairs(GRAB_DAMAGE_FRAMES) do
                                    local v21, v22 = next(v2);
                                    task.wait(v21);

                                    if HumanoidRootPart2 == nil then
                                        return;
                                    end;

                                    if Checker.check_victim(script, Character, v) ~= nil and Character then
                                        Combat_Util.Damage(script, Character, v, {
                                            Base = v22,
                                            Skill = script.Parent.Name
                                        });
                                    end;
                                end;
                            end);
                            task.spawn(function() -- Line: 263
                                -- upvalues: HumanoidRootPart2 (copy), Config (ref), Weld2 (copy), BoolValue5 (copy), Utility (ref), v (copy), Checker (ref), Character (ref), Combat_Util (ref)
                                if HumanoidRootPart2 == nil then
                                    return;
                                end;

                                task.wait(Config.GRAB_RELEASE_AT);

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
                                end;
                            end);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function u2.Cancel(p23) -- Line: 287
    -- upvalues: Utility (copy), EffectsEvent (copy)
    if p23 == nil then
        return;
    end;

    local Character = p23.Character;

    if Character == nil then
        return;
    end;

    Character:SetAttribute("SkillStartupLocation", nil);
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);

    for _, child in pairs(valuesfolder:GetChildren()) do
        if child.Name == "Transparent" and child.Value == script.Parent.Name then
            child:Destroy();
        end;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "SlitheringSerpent_effs", Character, "Cancel");
end;

return u2;