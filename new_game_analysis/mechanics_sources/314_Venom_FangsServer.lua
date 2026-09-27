-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = {}
};
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Server_Mouse_Pos"));
local Combat_Util = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Combat_Util"));
local ImpactSounds = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Utility"):WaitForChild("ImpactSounds"));
local u2 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local Config = require(script.Parent.Config);
local AIM_RADIUS = Config.AIM_RADIUS;
game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = table.find;
local _ = table.remove;
local _ = Vector3.new;
local _ = tick;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Value = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.AppliedTicks).ByName.Venom.Value;
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local _ = table.find;
local _ = table.remove;

function u1.Hold(p3, p4, p5) -- Line: 28
    -- upvalues: EffectsEvent (copy)
    local Character = p3.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    Character:FindFirstChild("Humanoid");
    p5.startpos = HumanoidRootPart.Position;
    EffectsEvent.ToAllInRange(p3, "VenomFangs_effs", p3.Character, "Start");
end;

local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);

function u1.UnHold(u6, p7, p8) -- Line: 41
    -- upvalues: u1 (copy), Utility (copy), Config (copy), RaycastHelper (copy), AIM_RADIUS (copy), EffectsEvent (copy), ManuelCancel (copy), Checker (copy), u2 (copy), Combat_Util (copy), ImpactSounds (copy), DebrisModule (copy), Value (copy)
    if u6.Character == nil then
        return;
    end;

    local u9 = u1.Id[u6.UserId];
    local Character = u6.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil or (Humanoid == nil or p7 == nil) then
        return;
    end;

    local air_combo_bp = HumanoidRootPart:FindFirstChild("air_combo_bp");

    if air_combo_bp then
        air_combo_bp:Destroy();
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local u10 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.CAST_LOCK_DUR);
    local Position = HumanoidRootPart.Position;
    local v11, _, _, _ = RaycastHelper.MaximizeRayServer(Character, Position, p7, AIM_RADIUS, true, 5, 7, 3);
    local unit = (v11 - Position).unit;
    EffectsEvent.ToAllInRange(u6, "VenomFangs_effs", u6.Character, "Teleport", p8.startpos, v11, unit);
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NOMouvementlines";
    BoolValue.Parent = valuesfolder;
    local v12, u13 = ManuelCancel.new(u6, Config.CANCEL_WINDOW);
    v12:Connect(function() -- Line: 65
        -- upvalues: u1 (ref), u6 (copy), u10 (ref)
        u1.Cancel(u6);
        u1.Id[u6.UserId] = -1;
        u10:Destroy();
    end);
    task.wait(Config.TELEPORT_DUR);
    BoolValue:Destroy();

    if u1.Id[u6.UserId] ~= u9 then
        return;
    end;

    EffectsEvent.ToAllInRange(u6, "VenomFangs_effs", u6.Character, "Slash");
    local valuesfolder2 = Utility.getvaluesfolder(Character);
    local CFrame_lookAlong_ret = CFrame.lookAlong(v11, unit);
    local ModelInRegion = Utility.GetModelInRegion(CFrame_lookAlong_ret * Config.SLASH_HITBOX_OFFSET, Config.SLASH_HITBOX_SIZE, nil, nil);
    local v14 = nil;
    local v15 = false;

    for _, v in pairs(ModelInRegion) do
        if u1.Id[u6.UserId] ~= u9 then
            return;
        end;

        if v ~= Character and v:FindFirstChild("Humanoid") ~= nil then
            local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
            v:FindFirstChild("Humanoid");
            local v16, _ = Checker.check_victim(script, Character, v);
            local valuesfolder3 = Utility.getvaluesfolder(v);

            if u2.Both(valuesfolder3, {
                name = "Choosing_1",
                pv = valuesfolder2
            }) ~= true then
                if v16 == "Perfect" then
                    Combat_Util.Perfect(script, Character, v);
                elseif v16 == true or v16 == "Blocking" then
                    if v16 == "Blocking" then
                        Combat_Util.Block(script, Character, v, Config.SLASH_BLOCK_BREAK);
                    else
                        Combat_Util.Damage(script, Character, v, {
                            Base = Config.SLASH_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.AddStun(script, Character, valuesfolder3, Config.SLASH_STUN);
                        Combat_Util.Add_air_combo_bp(HumanoidRootPart2, HumanoidRootPart, nil, HumanoidRootPart.Position);
                        v14 = v14 or v;
                        v15 = true;
                    end;
                end;
            end;
        end;
    end;

    if v14 ~= nil then
        ImpactSounds.Play(Character, script.Parent.Name, v14);
    end;

    if v15 then
        EffectsEvent.ToAllInRange(u6, "VenomFangs_effs", u6.Character, "Success");
        script.Parent.Name:gsub(" ", "");
        Combat_Util.Add_air_combo_bp(HumanoidRootPart, nil, nil, HumanoidRootPart.Position);
        local BoolValue2 = Instance.new("BoolValue");
        BoolValue2.Name = "iframe";
        BoolValue2.Parent = valuesfolder2;
        DebrisModule:AddItem(BoolValue2, Config.IFRAME_DUR);
        u10:Destroy();
        u10 = Utility.AddValue(valuesfolder2, "pause_gameplay", Config.FOLLOWUP_LOCK_DUR);
        task.delay(Config.FOLLOWUP_AT, function() -- Line: 128
            -- upvalues: u1 (ref), u6 (copy), u9 (copy), Character (copy), Humanoid (copy), Config (ref), HumanoidRootPart (copy), ModelInRegion (ref), Checker (ref), Utility (ref), u2 (ref), valuesfolder2 (copy), Combat_Util (ref), Value (ref), ImpactSounds (ref), u13 (copy)
            if u1.Id[u6.UserId] ~= u9 or (Character == nil or not Character:IsDescendantOf(workspace)) then
                return;
            end;

            Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(script.VenomFangsAttacker):Play();
            task.wait(Config.FOLLOWUP_HIT_AT);

            if u1.Id[u6.UserId] ~= u9 then
                return;
            end;

            local LookVector = HumanoidRootPart.CFrame.LookVector;
            local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

            if Vector3_new_ret.Magnitude > 0.001 then
                LookVector = Vector3_new_ret.Unit;
            end;

            local v17 = LookVector * Config.FOLLOWUP_KNOCKBACK;
            local v18 = nil;

            for _, v in pairs(ModelInRegion) do
                if u1.Id[u6.UserId] ~= u9 then
                    return;
                end;

                if v ~= Character and v:FindFirstChild("Humanoid") ~= nil then
                    local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
                    local v19, _ = Checker.check_victim(script, Character, v);
                    local valuesfolder3 = Utility.getvaluesfolder(v);

                    if u2.Both(valuesfolder3, {
                        name = "Choosing_1",
                        pv = valuesfolder2
                    }) ~= true then
                        if v19 == "Perfect" then
                            Combat_Util.Perfect(script, Character, v);
                        elseif v19 == true or v19 == "Blocking" then
                            if v19 == "Blocking" then
                                Combat_Util.Block(script, Character, v, Config.FOLLOWUP_BLOCK_BREAK);
                            else
                                Combat_Util.Damage(script, Character, v, {
                                    Base = Config.FOLLOWUP_DAMAGE,
                                    Skill = script.Parent.Name
                                });
                                Combat_Util.AddStun(script, Character, valuesfolder3, Config.FOLLOWUP_STUN);
                                Combat_Util.Knockback(script, Character, HumanoidRootPart2, v17, Config.FOLLOWUP_KNOCKBACK_DUR);
                                Combat_Util.RagDoll(script, Character, valuesfolder3, Config.FOLLOWUP_RAGDOLL);
                                local v20 = Utility.AddValue(valuesfolder3, Value, Config.VENOM_DURATION, "ObjectValue", Character);
                                v20:SetAttribute("Skill", script.Parent.Name);
                                v20:SetAttribute("PercentHealth", Config.VENOM_MAX_HEALTH_RATIO);
                                v18 = v18 or v;
                            end;
                        end;
                    end;
                end;
            end;

            if v18 ~= nil then
                ImpactSounds.Play(Character, script.Parent.Name, v18);
            end;

            u13();
        end);
    end;
end;

function u1.Cancel(p21) -- Line: 187
    -- upvalues: EffectsEvent (copy)
    if p21.Character == nil then
        return;
    end;

    p21.Character:SetAttribute("OriginalPositionForSkill", nil);
    EffectsEvent.ToAllInRange(p21, "VenomFangs_effs", p21.Character, "Cancel");
end;

return u1;